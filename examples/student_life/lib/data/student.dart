/// The signed-in student (mock data).
class Student {
  const Student({
    required this.firstName,
    required this.lastName,
    required this.pid,
    required this.program,
  });

  final String firstName;
  final String lastName;

  /// Student ID number. A placeholder in this demo.
  final String pid;
  final String program;

  String get fullName => '$firstName $lastName';
}

const currentStudent = Student(
  firstName: 'Alex',
  lastName: 'Rivera',
  pid: 'A00000000',
  program: 'Undergraduate · Computer Science',
);
