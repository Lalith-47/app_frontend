class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final bool isActive;
  final Map<String, dynamic>? analytics;
  final String? mentorId;
  final List<String>? assignedStudents;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profileImage,
    required this.createdAt,
    this.lastLogin,
    this.isActive = true,
    this.analytics,
    this.mentorId,
    this.assignedStudents,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      profileImage: json['profileImage'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      lastLogin: json['lastLogin'] != null ? DateTime.parse(json['lastLogin']) : null,
      isActive: json['isActive'] ?? true,
      analytics: json['analytics'],
      mentorId: json['mentorId'],
      assignedStudents: json['assignedStudents'] != null 
          ? List<String>.from(json['assignedStudents']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'profileImage': profileImage,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
      'isActive': isActive,
      'analytics': analytics,
      'mentorId': mentorId,
      'assignedStudents': assignedStudents,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? profileImage,
    DateTime? createdAt,
    DateTime? lastLogin,
    bool? isActive,
    Map<String, dynamic>? analytics,
    String? mentorId,
    List<String>? assignedStudents,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      isActive: isActive ?? this.isActive,
      analytics: analytics ?? this.analytics,
      mentorId: mentorId ?? this.mentorId,
      assignedStudents: assignedStudents ?? this.assignedStudents,
    );
  }

  bool get isMentor => role == 'mentor';
  bool get isStudent => role == 'student';

  String get displayName => name.isNotEmpty ? name : email.split('@').first;
  String get initials {
    final names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : email[0].toUpperCase();
  }
}




