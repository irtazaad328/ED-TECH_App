class UserProfile {
  final String name;
  final String email;
  final bool isTeacher;
  final int courseCount;

  const UserProfile({
    required this.name,
    required this.email,
    required this.isTeacher,
    required this.courseCount,
  });

  String get roleLabel => isTeacher ? 'Teacher' : 'Learner';
  String get courseCountLabel =>
      isTeacher ? 'Published Courses' : 'Enrolled Courses';

  static const UserProfile learnerDemo = UserProfile(
    name: 'Student User',
    email: 'student@edtech.com',
    isTeacher: false,
    courseCount: 3,
  );

  static const UserProfile teacherDemo = UserProfile(
    name: 'Instructor',
    email: 'teacher@edtech.com',
    isTeacher: true,
    courseCount: 4,
  );
}
