import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/user_model.dart';
import '../services/auth_service.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final UserModel? user;
  final String? error;
  final String? token;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.user,
    this.error,
    this.token,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    UserModel? user,
    String? error,
    String? token,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      error: error,
      token: token ?? this.token,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthState()) {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    state = state.copyWith(isLoading: true);
    
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      if (isLoggedIn) {
        final token = await _authService.getToken();
        final user = await _authService.getCurrentUser();
        
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          user: user,
          token: token,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> login({
    required String email,
    required String password,
    String? role,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final result = await _authService.login(
        email: email,
        password: password,
        role: role,
      );
      
      if (result['success']) {
        state = state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          user: result['user'],
          token: result['token'],
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String role,
    String? mentorId,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final result = await _authService.register(
        name: name,
        email: email,
        password: password,
        role: role,
        mentorId: mentorId,
      );
      
      if (result['success']) {
        state = state.copyWith(
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: result['message'] ?? 'Registration failed',
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    
    try {
      await _authService.logout();
      state = const AuthState();
    } catch (e) {
      // Even if logout fails, clear local state
      state = const AuthState();
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? profileImage,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _authService.updateProfile(
        name: name,
        email: email,
        profileImage: profileImage,
      );
      
      // Refresh user data
      final user = await _authService.getCurrentUser();
      
      state = state.copyWith(
        isLoading: false,
        user: user,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      
      state = state.copyWith(
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _authService.forgotPassword(email);
      
      state = state.copyWith(
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _authService.resetPassword(
        token: token,
        newPassword: newPassword,
      );
      
      state = state.copyWith(
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  bool get isMentor => state.user?.isMentor ?? false;
  bool get isStudent => state.user?.isStudent ?? false;
}

// Providers
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

// Convenience providers
final currentUserProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});

final authErrorProvider = Provider<String?>((ref) {
  return ref.watch(authProvider).error;
});


