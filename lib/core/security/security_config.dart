import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

class SecurityConfig {
  static const String _salt = 'praniti_salt_2024';
  static const int _minPasswordLength = 6;
  static const int _maxPasswordLength = 128;
  static const int _maxLoginAttempts = 5;
  static const Duration _lockoutDuration = Duration(minutes: 15);
  static const Duration _sessionTimeout = Duration(hours: 24);
  static const Duration _tokenRefreshThreshold = Duration(minutes: 30);

  // Password hashing
  static String hashPassword(String password) {
    final bytes = utf8.encode(password + _salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Verify password
  static bool verifyPassword(String password, String hashedPassword) {
    return hashPassword(password) == hashedPassword;
  }

  // Generate secure token
  static String generateSecureToken() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecondsSinceEpoch;
    final data = '${_salt}_$timestamp\_$random';
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Validate password strength
  static PasswordStrength validatePasswordStrength(String password) {
    if (password.length < _minPasswordLength) {
      return PasswordStrength.weak;
    }
    
    if (password.length > _maxPasswordLength) {
      return PasswordStrength.weak;
    }

    int score = 0;
    
    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    
    // Character variety
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;
    
    // Common patterns check
    if (RegExp(r'(.)\1{2,}').hasMatch(password)) score--; // Repeated characters
    if (RegExp(r'(012|123|234|345|456|567|678|789|890)').hasMatch(password)) score--; // Sequential numbers
    if (RegExp(r'(abc|bcd|cde|def|efg|fgh|ghi|hij|ijk|jkl|klm|lmn|mno|nop|opq|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz)').hasMatch(password.toLowerCase())) score--; // Sequential letters
    
    if (score >= 6) return PasswordStrength.strong;
    if (score >= 4) return PasswordStrength.medium;
    return PasswordStrength.weak;
  }

  // Sanitize input
  static String sanitizeInput(String input) {
    return input
        .replaceAll(RegExp(r'<script[^>]*>.*?</script>', caseSensitive: false), '')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'[<>"\']'), '')
        .trim();
  }

  // Validate email format
  static bool isValidEmailFormat(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  // Check for suspicious patterns
  static bool isSuspiciousInput(String input) {
    final suspiciousPatterns = [
      RegExp(r'<script', caseSensitive: false),
      RegExp(r'javascript:', caseSensitive: false),
      RegExp(r'vbscript:', caseSensitive: false),
      RegExp(r'onload=', caseSensitive: false),
      RegExp(r'onerror=', caseSensitive: false),
      RegExp(r'<iframe', caseSensitive: false),
      RegExp(r'<object', caseSensitive: false),
      RegExp(r'<embed', caseSensitive: false),
    ];

    return suspiciousPatterns.any((pattern) => pattern.hasMatch(input));
  }

  // Rate limiting
  static bool isRateLimited(String identifier, Map<String, List<DateTime>> rateLimitMap) {
    final now = DateTime.now();
    final attempts = rateLimitMap[identifier] ?? [];
    
    // Remove old attempts
    attempts.removeWhere((attempt) => now.difference(attempt) > _lockoutDuration);
    
    if (attempts.length >= _maxLoginAttempts) {
      return true;
    }
    
    attempts.add(now);
    rateLimitMap[identifier] = attempts;
    return false;
  }

  // Session validation
  static bool isSessionValid(DateTime lastActivity) {
    return DateTime.now().difference(lastActivity) < _sessionTimeout;
  }

  // Token refresh check
  static bool shouldRefreshToken(DateTime tokenCreated) {
    return DateTime.now().difference(tokenCreated) > _tokenRefreshThreshold;
  }

  // Generate CSRF token
  static String generateCSRFToken() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecondsSinceEpoch;
    final data = 'csrf_${_salt}_$timestamp\_$random';
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Validate CSRF token
  static bool validateCSRFToken(String token) {
    // In a real app, you would store and validate against server-side tokens
    return token.isNotEmpty && token.length > 20;
  }

  // Encrypt sensitive data
  static String encryptSensitiveData(String data) {
    // In a real app, use proper encryption like AES
    final bytes = utf8.encode(data + _salt);
    final digest = sha256.convert(bytes);
    return base64Encode(digest.bytes);
  }

  // Decrypt sensitive data
  static String decryptSensitiveData(String encryptedData) {
    // In a real app, use proper decryption
    try {
      final bytes = base64Decode(encryptedData);
      return utf8.decode(bytes);
    } catch (e) {
      return '';
    }
  }

  // Security headers for API requests
  static Map<String, String> getSecurityHeaders() {
    return {
      'X-Content-Type-Options': 'nosniff',
      'X-Frame-Options': 'DENY',
      'X-XSS-Protection': '1; mode=block',
      'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
      'Referrer-Policy': 'strict-origin-when-cross-origin',
    };
  }

  // Log security events
  static void logSecurityEvent(String event, {Map<String, dynamic>? details}) {
    if (kDebugMode) {
      print('SECURITY EVENT: $event');
      if (details != null) {
        print('Details: $details');
      }
    }
  }
}

enum PasswordStrength {
  weak,
  medium,
  strong,
}

class SecurityViolation {
  final String type;
  final String message;
  final DateTime timestamp;
  final Map<String, dynamic>? details;

  SecurityViolation({
    required this.type,
    required this.message,
    required this.timestamp,
    this.details,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'details': details,
    };
  }
}
