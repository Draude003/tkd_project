class MockUser {
  final String email;
  final String password;
  final String role; 
  final String name;

  const MockUser({
    required this.email,
    required this.password,
    required this.role,
    required this.name,
  });
}

final List<MockUser> mockUsers = [
  MockUser(
    email: 'student@gmail.com',
    password: '1234',
    role: 'student',
    name: 'Juan dela Cruz',
  ),
  MockUser(
    email: 'parent@gmail.com',
    password: '1234',
    role: 'parent',
    name: 'Maria Dela Cruz',
  ),
  MockUser(
    email: 'instructor@gmail.com',
    password: '1234',
    role: 'instructor',
    name: 'Sensei oleg',
  ),
];

MockUser? authenticate(String email, String password) {
  try {
    return mockUsers.firstWhere(
      (u) => u.email == email && u.password == password,
    );
  } catch (_) {
    return null;
  }
}