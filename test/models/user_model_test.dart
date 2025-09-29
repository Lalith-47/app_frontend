import 'package:flutter_test/flutter_test.dart';
import 'package:praniti_mobile_app/shared/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('should create UserModel from JSON correctly', () {
      final json = {
        'id': '123',
        'name': 'John Doe',
        'email': 'john@example.com',
        'role': 'student',
        'profileImage': 'https://example.com/image.jpg',
        'createdAt': '2023-01-01T00:00:00.000Z',
        'lastLogin': '2023-01-02T00:00:00.000Z',
        'isActive': true,
        'analytics': {'score': 85},
        'mentorId': '456',
        'assignedStudents': ['789', '101'],
      };

      final user = UserModel.fromJson(json);

      expect(user.id, equals('123'));
      expect(user.name, equals('John Doe'));
      expect(user.email, equals('john@example.com'));
      expect(user.role, equals('student'));
      expect(user.profileImage, equals('https://example.com/image.jpg'));
      expect(user.isActive, isTrue);
      expect(user.analytics, equals({'score': 85}));
      expect(user.mentorId, equals('456'));
      expect(user.assignedStudents, equals(['789', '101']));
    });

    test('should convert UserModel to JSON correctly', () {
      final user = UserModel(
        id: '123',
        name: 'John Doe',
        email: 'john@example.com',
        role: 'student',
        profileImage: 'https://example.com/image.jpg',
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
        lastLogin: DateTime.parse('2023-01-02T00:00:00.000Z'),
        isActive: true,
        analytics: {'score': 85},
        mentorId: '456',
        assignedStudents: ['789', '101'],
      );

      final json = user.toJson();

      expect(json['id'], equals('123'));
      expect(json['name'], equals('John Doe'));
      expect(json['email'], equals('john@example.com'));
      expect(json['role'], equals('student'));
      expect(json['profileImage'], equals('https://example.com/image.jpg'));
      expect(json['isActive'], isTrue);
      expect(json['analytics'], equals({'score': 85}));
      expect(json['mentorId'], equals('456'));
      expect(json['assignedStudents'], equals(['789', '101']));
    });

    test('should handle copyWith correctly', () {
      final user = UserModel(
        id: '123',
        name: 'John Doe',
        email: 'john@example.com',
        role: 'student',
        createdAt: DateTime.now(),
      );

      final updatedUser = user.copyWith(
        name: 'Jane Doe',
        email: 'jane@example.com',
      );

      expect(updatedUser.id, equals('123'));
      expect(updatedUser.name, equals('Jane Doe'));
      expect(updatedUser.email, equals('jane@example.com'));
      expect(updatedUser.role, equals('student'));
    });

    test('should identify role correctly', () {
      final student = UserModel(
        id: '1',
        name: 'Student',
        email: 'student@example.com',
        role: 'student',
        createdAt: DateTime.now(),
      );

      final mentor = UserModel(
        id: '2',
        name: 'Mentor',
        email: 'mentor@example.com',
        role: 'mentor',
        createdAt: DateTime.now(),
      );

      expect(student.isStudent, isTrue);
      expect(student.isMentor, isFalse);
      expect(mentor.isStudent, isFalse);
      expect(mentor.isMentor, isTrue);
    });

    test('should generate display name correctly', () {
      final userWithName = UserModel(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        role: 'student',
        createdAt: DateTime.now(),
      );

      final userWithoutName = UserModel(
        id: '2',
        name: '',
        email: 'jane@example.com',
        role: 'student',
        createdAt: DateTime.now(),
      );

      expect(userWithName.displayName, equals('John Doe'));
      expect(userWithoutName.displayName, equals('jane'));
    });

    test('should generate initials correctly', () {
      final userWithFullName = UserModel(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        role: 'student',
        createdAt: DateTime.now(),
      );

      final userWithSingleName = UserModel(
        id: '2',
        name: 'John',
        email: 'john@example.com',
        role: 'student',
        createdAt: DateTime.now(),
      );

      final userWithoutName = UserModel(
        id: '3',
        name: '',
        email: 'jane@example.com',
        role: 'student',
        createdAt: DateTime.now(),
      );

      expect(userWithFullName.initials, equals('JD'));
      expect(userWithSingleName.initials, equals('J'));
      expect(userWithoutName.initials, equals('J'));
    });

    test('should handle null values in JSON', () {
      final json = {
        'id': '123',
        'name': 'John Doe',
        'email': 'john@example.com',
        'role': 'student',
        'createdAt': '2023-01-01T00:00:00.000Z',
      };

      final user = UserModel.fromJson(json);

      expect(user.id, equals('123'));
      expect(user.name, equals('John Doe'));
      expect(user.email, equals('john@example.com'));
      expect(user.role, equals('student'));
      expect(user.profileImage, isNull);
      expect(user.lastLogin, isNull);
      expect(user.isActive, isTrue);
      expect(user.analytics, isNull);
      expect(user.mentorId, isNull);
      expect(user.assignedStudents, isNull);
    });
  });
}
