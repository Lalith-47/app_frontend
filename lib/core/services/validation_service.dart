class ValidationService {
  static final ValidationService _instance = ValidationService._internal();
  factory ValidationService() => _instance;
  ValidationService._internal();

  // Email validation
  bool isValidEmail(String email) {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  // Password validation
  ValidationResult validatePassword(String password) {
    if (password.isEmpty) {
      return ValidationResult(false, 'Password is required');
    }
    
    if (password.length < 6) {
      return ValidationResult(false, 'Password must be at least 6 characters');
    }
    
    if (password.length > 128) {
      return ValidationResult(false, 'Password must be less than 128 characters');
    }
    
    // Check for at least one letter and one number
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(password)) {
      return ValidationResult(false, 'Password must contain at least one letter and one number');
    }
    
    return ValidationResult(true, '');
  }

  // Name validation
  ValidationResult validateName(String name) {
    if (name.isEmpty) {
      return ValidationResult(false, 'Name is required');
    }
    
    // Check for only whitespace
    if (name.trim().isEmpty) {
      return ValidationResult(false, 'Name cannot be only whitespace');
    }
    
    if (name.trim().length < 2) {
      return ValidationResult(false, 'Name must be at least 2 characters');
    }
    
    if (name.length > 50) {
      return ValidationResult(false, 'Name must be less than 50 characters');
    }
    
    // Check for valid characters (letters, spaces, hyphens, apostrophes, accented characters)
    if (!RegExp(r"^[a-zA-ZÀ-ÿ\s\-']+$").hasMatch(name)) {
      return ValidationResult(false, 'Name can only contain letters, spaces, hyphens, and apostrophes');
    }
    
    return ValidationResult(true, '');
  }

  // Phone number validation
  bool isValidPhoneNumber(String phone) {
    // Check if the phone contains only valid characters (digits, spaces, hyphens, parentheses, plus)
    if (!RegExp(r'^[\d\s\-\(\)\+]+$').hasMatch(phone)) {
      return false;
    }
    
    // Remove all non-digit characters
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    // Check if it's a valid length (7-15 digits) and contains only digits
    return cleaned.length >= 7 && 
           cleaned.length <= 15 && 
           RegExp(r'^\d+$').hasMatch(cleaned);
  }

  // URL validation
  bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && 
             (uri.scheme == 'http' || uri.scheme == 'https') &&
             uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Quiz answer validation
  ValidationResult validateQuizAnswer(String answer) {
    if (answer.isEmpty) {
      return ValidationResult(false, 'Please select an answer');
    }
    
    return ValidationResult(true, '');
  }

  // Message validation
  ValidationResult validateMessage(String message) {
    if (message.isEmpty) {
      return ValidationResult(false, 'Message cannot be empty');
    }
    
    if (message.length > 1000) {
      return ValidationResult(false, 'Message must be less than 1000 characters');
    }
    
    // Check for only whitespace
    if (message.trim().isEmpty) {
      return ValidationResult(false, 'Message cannot be only whitespace');
    }
    
    return ValidationResult(true, '');
  }

  // File validation
  ValidationResult validateFile(String fileName, int fileSizeInBytes) {
    if (fileName.isEmpty) {
      return ValidationResult(false, 'File name is required');
    }
    
    // Check file size (10MB limit)
    const maxSize = 10 * 1024 * 1024; // 10MB
    if (fileSizeInBytes > maxSize) {
      return ValidationResult(false, 'File size must be less than 10MB');
    }
    
    // Check file extension
    final extension = fileName.split('.').last.toLowerCase();
    const allowedExtensions = ['jpg', 'jpeg', 'png', 'gif', 'pdf', 'doc', 'docx', 'txt'];
    
    if (!allowedExtensions.contains(extension)) {
      return ValidationResult(false, 'File type not supported. Allowed types: ${allowedExtensions.join(', ')}');
    }
    
    return ValidationResult(true, '');
  }

  // Form validation
  Map<String, String> validateForm(Map<String, dynamic> formData) {
    final errors = <String, String>{};
    
    // Validate email
    if (formData.containsKey('email')) {
      final email = formData['email'] as String?;
      if (email == null || email.isEmpty) {
        errors['email'] = 'Email is required';
      } else if (!isValidEmail(email)) {
        errors['email'] = 'Please enter a valid email address';
      }
    }
    
    // Validate password
    if (formData.containsKey('password')) {
      final password = formData['password'] as String?;
      final result = validatePassword(password ?? '');
      if (!result.isValid) {
        errors['password'] = result.message;
      }
    }
    
    // Validate name
    if (formData.containsKey('name')) {
      final name = formData['name'] as String?;
      final result = validateName(name ?? '');
      if (!result.isValid) {
        errors['name'] = result.message;
      }
    }
    
    // Validate confirm password
    if (formData.containsKey('confirmPassword') && formData.containsKey('password')) {
      final confirmPassword = formData['confirmPassword'] as String?;
      final password = formData['password'] as String?;
      
      if (confirmPassword != password) {
        errors['confirmPassword'] = 'Passwords do not match';
      }
    }
    
    return errors;
  }
}

class ValidationResult {
  final bool isValid;
  final String message;

  ValidationResult(this.isValid, this.message);
}
