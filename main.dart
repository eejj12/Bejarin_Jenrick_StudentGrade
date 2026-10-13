import 'dart:io';

class Student {
  String fullName;
  int idNumber;
  double grade1;
  double grade2;
  double grade3;

  Student(
    this.fullName,
    this.idNumber,
    this.grade1,
    this.grade2,
    this.grade3,
  );

  double computeGrade() {
    return (grade1 + grade2 + grade3) / 3;
  }
}

String getStatus(double average) {
  if (average >= 75) {
    return 'Passed';
  } else if (average >= 70) {
    return 'Conditional';
  } else {
    return 'Failed';
  }
}

void main() {
  print('==================================== STUDENT GRADE CALCULATOR  ====================================');

  stdout.write('Enter full name: ');
  String fullName = stdin.readLineSync() ?? '';

  stdout.write('Enter student ID number: ');
  int idNumber = int.parse(stdin.readLineSync()!);

  List<double> grades = [];

  for (int i = 1; i <= 3; i++) {
    while (true) {
      stdout.write('Enter grade for Subject $i (0-100): ');
      double? grade = double.tryParse(stdin.readLineSync() ?? '');

      if (grade != null && grade >= 0 && grade <= 100) {
        grades.add(grade);
        break;
      } else {
        print('Invalid grade. Please enter a number from 0 to 100.');
      }
    }
  }

  Student student = Student(
    fullName,
    idNumber,
    grades[0],
    grades[1],
    grades[2],
  );

  print('==================================== STUDENT REPORT ====================================');
  print('Full Name : ${student.fullName}');
  print('Student ID: ${student.idNumber}');

  print('\nSubject Grades:');
  for (int i = 0; i < grades.length; i++) {
    print('Subject ${i + 1}: ${grades[i].toStringAsFixed(2)}');
  }

  double average = student.computeGrade();
  String status = getStatus(average);

  print('\nAverage Grade: ${average.toStringAsFixed(2)}');
  print('Status       : $status');
  print('====================================');
}