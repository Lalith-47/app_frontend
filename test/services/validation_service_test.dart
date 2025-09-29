import 'package:flutter_test/flutter_test.dart';
import 'package:praniti_mobile_app/core/services/validation_service.dart';

void main() {
  group('ValidationService', () {
    late ValidationService validationService;

    setUp(() {
      validationService = ValidationService();
    });

    group('Email Validation', () {
      test('should return true for valid email addresses', () {
        final validEmails = [
          'test@example.com',
          'user.name@domain.co.uk',
          'user+tag@example.org',
          'test123@test-domain.com',
        ];

        for (final email in validEmails) {
          expect(validationService.isValidEmail(email), isTrue, reason: 'Email $email should be valid');
        }
      });

      test('should return false for invalid email addresses', () {
        final invalidEmails = [
          'invalid-email',
          '@example.com',
          'test@',
          'test.example.com',
          '',
          'test@.com',
          'test@example.',
        ];

        for (final email in invalidEmails) {
          expect(validationService.isValidEmail(email), isFalse, reason: 'Email $email should be invalid');
        }
      });
    });

    group('Password Validation', () {
      test('should return valid for strong passwords', () {
        final strongPasswords = [
          'password123',
          'MyPassword1',
          'Test123456',
          'SecurePass1',
        ];

        for (final password in strongPasswords) {
          final result = validationService.validatePassword(password);
          expect(result.isValid, isTrue, reason: 'Password $password should be valid');
          expect(result.message, isEmpty);
        }
      });

      test('should return invalid for weak passwords', () {
        final weakPasswords = [
          '',
          '123',
          'password',
          '123456',
          'abcdef',
          'a' * 129, // Too long
        ];

        for (final password in weakPasswords) {
          final result = validationService.validatePassword(password);
          expect(result.isValid, isFalse, reason: 'Password $password should be invalid');
          expect(result.message, isNotEmpty);
        }
      });
    });

    group('Name Validation', () {
      test('should return valid for proper names', () {
        final validNames = [
          'John Doe',
          'Mary-Jane Smith',
          "O'Connor",
          'José García',
          'AB', // Minimum 2 characters
        ];

        for (final name in validNames) {
          final result = validationService.validateName(name);
          expect(result.isValid, isTrue, reason: 'Name $name should be valid');
        }
      });

      test('should return invalid for improper names', () {
        final invalidNames = [
          '',
          'A', // Too short
          'a' * 51, // Too long
          'John123', // Contains numbers
          'John@Doe', // Contains special characters
          '   ', // Only whitespace
        ];

        for (final name in invalidNames) {
          final result = validationService.validateName(name);
          expect(result.isValid, isFalse, reason: 'Name $name should be invalid');
          expect(result.message, isNotEmpty);
        }
      });
    });

    group('Phone Number Validation', () {
      test('should return true for valid phone numbers', () {
        final validPhones = [
          '1234567890',
          '+1234567890',
          '(123) 456-7890',
          '123-456-7890',
          '+1 (123) 456-7890',
        ];

        for (final phone in validPhones) {
          expect(validationService.isValidPhoneNumber(phone), isTrue, reason: 'Phone $phone should be valid');
        }
      });

      test('should return false for invalid phone numbers', () {
        final invalidPhones = [
          '',
          '123',
          '12345678901234567890', // Too long
          'abc-def-ghij',
          '123-abc-7890',
        ];

        for (final phone in invalidPhones) {
          expect(validationService.isValidPhoneNumber(phone), isFalse, reason: 'Phone $phone should be invalid');
        }
      });
    });

    group('URL Validation', () {
      test('should return true for valid URLs', () {
        final validUrls = [
          'https://example.com',
          'http://example.com',
          'https://www.example.com/path',
          'https://subdomain.example.com',
        ];

        for (final url in validUrls) {
          expect(validationService.isValidUrl(url), isTrue, reason: 'URL $url should be valid');
        }
      });

      test('should return false for invalid URLs', () {
        final invalidUrls = [
          '',
          'example.com',
          'ftp://example.com',
          'not-a-url',
          'https://',
        ];

        for (final url in invalidUrls) {
          expect(validationService.isValidUrl(url), isFalse, reason: 'URL $url should be invalid');
        }
      });
    });

    group('Message Validation', () {
      test('should return valid for proper messages', () {
        final validMessages = [
          'Hello world',
          'This is a test message',
          'a' * 1000, // Max length
        ];

        for (final message in validMessages) {
          final result = validationService.validateMessage(message);
          expect(result.isValid, isTrue, reason: 'Message should be valid');
        }
      });

      test('should return invalid for improper messages', () {
        final invalidMessages = [
          '',
          '   ', // Only whitespace
          'a' * 1001, // Too long
        ];

        for (final message in invalidMessages) {
          final result = validationService.validateMessage(message);
          expect(result.isValid, isFalse, reason: 'Message should be invalid');
          expect(result.message, isNotEmpty);
        }
      });
    });

    group('Form Validation', () {
      test('should validate complete form correctly', () {
        final formData = {
          'name': 'John Doe',
          'email': 'john@example.com',
          'password': 'password123',
          'confirmPassword': 'password123',
        };

        final errors = validationService.validateForm(formData);
        expect(errors, isEmpty);
      });

      test('should return errors for invalid form data', () {
        final formData = {
          'name': '',
          'email': 'invalid-email',
          'password': '123',
          'confirmPassword': '456',
        };

        final errors = validationService.validateForm(formData);
        expect(errors, isNotEmpty);
        expect(errors.containsKey('name'), isTrue);
        expect(errors.containsKey('email'), isTrue);
        expect(errors.containsKey('password'), isTrue);
        expect(errors.containsKey('confirmPassword'), isTrue);
      });
    });
  });
}
