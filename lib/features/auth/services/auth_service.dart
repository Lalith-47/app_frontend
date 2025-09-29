import '../../../core/network/api_client.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/api_exception.dart';
import '../../../core/services/mock_data_service.dart';
import '../../../core/services/cache_service.dart';
import '../../../core/services/logging_service.dart';
import '../../../core/services/validation_service.dart';
import '../../../shared/models/user_model.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();
  final MockDataService _mockDataService = MockDataService();
  final CacheService _cacheService = CacheService();
  final ValidationService _validationService = ValidationService();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    String? role,
  }) async {
    try {
      LoggingService().logAuth('Login attempt', extra: {'email': email, 'role': role});
      
      // Validate inputs
      if (!_validationService.isValidEmail(email)) {
        throw ApiException('Please enter a valid email address');
      }
      
      final passwordValidation = _validationService.validatePassword(password);
      if (!passwordValidation.isValid) {
        throw ApiException(passwordValidation.message);
      }
      
      // Use mock data for now
      final result = await _mockDataService.authenticateUser(email, password, role);
      
      if (result['success']) {
        final token = result['token'];
        final user = result['user'] as UserModel;

        // Store token
        await _apiClient.setToken(token);
        
        // Cache user data
        await _cacheService.cacheUser(user.toJson());
        
        LoggingService().logAuth('Login successful', extra: {'userId': user.id});
        
        return {
          'success': true,
          'token': token,
          'user': user,
          'message': 'Login successful',
        };
      } else {
        LoggingService().logAuthError('Login failed', extra: {'email': email, 'message': result['message']});
        throw ApiException('Login failed: ${result['message']}');
      }
    } catch (e) {
      LoggingService().logAuthError('Login error', error: e);
      if (e is ApiException) rethrow;
      throw ApiException('Login failed: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? mentorId,
  }) async {
    try {
      LoggingService().logAuth('Registration attempt', extra: {'email': email, 'role': role});
      
      // Validate inputs
      final nameValidation = _validationService.validateName(name);
      if (!nameValidation.isValid) {
        throw ApiException(nameValidation.message);
      }
      
      if (!_validationService.isValidEmail(email)) {
        throw ApiException('Please enter a valid email address');
      }
      
      final passwordValidation = _validationService.validatePassword(password);
      if (!passwordValidation.isValid) {
        throw ApiException(passwordValidation.message);
      }
      
      if (role.isEmpty) {
        throw ApiException('Please select a role');
      }
      
      // Use mock data for now
      final result = await _mockDataService.registerUser(
        name: name,
        email: email,
        password: password,
        role: role,
        mentorId: mentorId,
      );

      if (result['success']) {
        LoggingService().logAuth('Registration successful', extra: {'email': email, 'role': role});
        return {
          'success': true,
          'message': result['message'] ?? 'Registration successful',
          'user': result['user'],
        };
      } else {
        LoggingService().logAuthError('Registration failed', extra: {'email': email, 'message': result['message']});
        throw ApiException('Registration failed: ${result['message']}');
      }
    } catch (e) {
      LoggingService().logAuthError('Registration error', error: e);
      if (e is ApiException) rethrow;
      throw ApiException('Registration failed: ${e.toString()}');
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      LoggingService().logAuth('Getting current user');
      
      // Try to get from cache first
      final cachedUser = await _cacheService.getCachedUser();
      if (cachedUser != null) {
        LoggingService().logCache('User found in cache');
        return UserModel.fromJson(cachedUser);
      }
      
      // For mock data, return the first user as current user
      // In a real app, this would be stored in local storage
      final token = await getToken();
      if (token != null) {
        // Extract user ID from token (mock implementation)
        final userId = token.split('_')[1]; // mock_token_userId_timestamp
        final user = _mockDataService.getUserById(userId);
        if (user != null) {
          // Cache the user
          await _cacheService.cacheUser(user.toJson());
          LoggingService().logAuth('User retrieved and cached');
          return user;
        }
      }
      throw ApiException('User not found');
    } catch (e) {
      LoggingService().logAuthError('Failed to get current user', error: e);
      if (e is ApiException) rethrow;
      throw ApiException('Failed to get user profile: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      LoggingService().logAuth('Logout attempt');
      
      // Try to logout from server
      try {
        await _apiClient.post(AppConstants.logoutEndpoint);
        LoggingService().logAuth('Server logout successful');
      } catch (e) {
        LoggingService().logAuthError('Server logout failed', error: e);
        // Continue with local logout even if server fails
      }
    } finally {
      // Always clear local data
      await _apiClient.clearToken();
      await _cacheService.clearCache();
      LoggingService().logAuth('Local logout completed');
    }
  }

  Future<bool> isLoggedIn() async {
    await _apiClient.loadToken();
    return _apiClient.token != null;
  }

  Future<String?> getToken() async {
    await _apiClient.loadToken();
    return _apiClient.token;
  }

  Future<void> refreshToken() async {
    try {
      final response = await _apiClient.post('/auth/refresh');
      if (response.statusCode == 200) {
        final token = response.data['token'];
        await _apiClient.setToken(token);
      }
    } catch (e) {
      throw ApiException('Token refresh failed: ${e.toString()}');
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/change-password',
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode != 200) {
        throw ApiException('Password change failed: ${response.data['message']}');
      }
    } catch (e) {
      throw ApiException('Password change failed: ${e.toString()}');
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? profileImage,
  }) async {
    try {
      final response = await _apiClient.put(
        '/auth/profile',
        data: {
          if (name != null) 'name': name,
          if (email != null) 'email': email,
          if (profileImage != null) 'profileImage': profileImage,
        },
      );

      if (response.statusCode != 200) {
        throw ApiException('Profile update failed: ${response.data['message']}');
      }
    } catch (e) {
      throw ApiException('Profile update failed: ${e.toString()}');
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      final response = await _apiClient.post(
        '/auth/forgot-password',
        data: {'email': email},
      );

      if (response.statusCode != 200) {
        throw ApiException('Password reset failed: ${response.data['message']}');
      }
    } catch (e) {
      throw ApiException('Password reset failed: ${e.toString()}');
    }
  }

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await _apiClient.post(
        '/auth/reset-password',
        data: {
          'token': token,
          'newPassword': newPassword,
        },
      );

      if (response.statusCode != 200) {
        throw ApiException('Password reset failed: ${response.data['message']}');
      }
    } catch (e) {
      throw ApiException('Password reset failed: ${e.toString()}');
    }
  }
}




