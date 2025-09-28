import '../../../core/network/api_client.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/api_exception.dart';
import '../../../shared/models/user_model.dart';

class AuthService {
  final ApiClient _apiClient = ApiClient();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    String? role,
  }) async {
    try {
      final response = await _apiClient.post(
        AppConstants.loginEndpoint,
        data: {
          'email': email,
          'password': password,
          if (role != null) 'role': role,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final token = data['token'];
        final user = UserModel.fromJson(data['user']);

        // Store token
        await _apiClient.setToken(token);

        return {
          'success': true,
          'token': token,
          'user': user,
          'message': data['message'] ?? 'Login successful',
        };
      } else {
        throw ApiException('Login failed: ${response.data['message']}');
      }
    } catch (e) {
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
      final response = await _apiClient.post(
        AppConstants.registerEndpoint,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'role': role,
          if (mentorId != null) 'mentorId': mentorId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        return {
          'success': true,
          'message': data['message'] ?? 'Registration successful',
          'user': data['user'] != null ? UserModel.fromJson(data['user']) : null,
        };
      } else {
        throw ApiException('Registration failed: ${response.data['message']}');
      }
    } catch (e) {
      throw ApiException('Registration failed: ${e.toString()}');
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.get(AppConstants.profileEndpoint);
      
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw ApiException('Failed to get user profile');
      }
    } catch (e) {
      throw ApiException('Failed to get user profile: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.post(AppConstants.logoutEndpoint);
    } catch (e) {
      // Even if logout fails on server, clear local token
      // Logout error: $e
    } finally {
      await _apiClient.clearToken();
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


