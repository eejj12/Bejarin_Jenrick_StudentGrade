import 'dart:io';

final String line = '=' * 36;

abstract class TaskItem {
  final int id;
  final String title;
  bool done = false;

  TaskItem(this.id, this.title);

  String describe();
}

mixin Logger {
  void log(String msg) => print('  >> $msg');
}

class Task extends TaskItem {
  final String deadline;

  Task(int id, String title, this.deadline) : super(id, title);

  @override
  String describe() =>
      '[${done ? "x" : " "}] #$id  $title  (Due: $deadline)';
}

class UrgentTask extends Task {
  UrgentTask(int id, String title, String deadline)
      : super(id, title, deadline);

  @override
  String describe() => '${super.describe()}  <-- URGENT!';
}

class TaskPlanner with Logger {
  final List<TaskItem> tasks = [];
  int _nextId = 1;

  Future<void> add(String title, String deadline, bool urgent) async {
    print('\n  Saving task...');
    await Future.delayed(Duration(seconds: 2));
    tasks.add(urgent
        ? UrgentTask(_nextId, title, deadline)
        : Task(_nextId, title, deadline));
    log('Added "$title" (ID $_nextId)');
    _nextId++;
  }

  TaskItem _find(int id) => tasks.firstWhere((t) => t.id == id);

  Future<void> complete(int id) async {
    final task = _find(id);
    print('\n  Updating task...');
    await Future.delayed(Duration(seconds: 1));
    task.done = true;
    log('Completed "${task.title}"');
  }

  void delete(int id) {
    final task = _find(id);
    tasks.remove(task);
    log('Deleted "${task.title}"');
  }

  void show() {
    print('\n$line\n  YOUR TASKS (${tasks.length})\n$line');
    if (tasks.isEmpty) {
      print('  No tasks yet.');
    } else {
      for (final t in tasks) {
        print('  ${t.describe()}');
      }
    }
    print(line);
  }
}

String ask(String question) {
  stdout.write('  $question: ');
  return stdin.readLineSync() ?? '';
}

int askNumber(String question, int min, int max) {
  while (true) {
    final n = int.tryParse(ask(question));
    if (n != null && n >= min && n <= max) return n;
    print('  [!] Numbers only, from $min to $max.');
  }
}

Future<void> main() async {
  final planner = TaskPlanner();

  print('$line\n        DART TASK PLANNER\n$line');

  while (true) {
    print('\n+-------------- MENU --------------+');
    print('|  1. Add Task     2. View Tasks   |');
    print('|  3. Complete     4. Delete       |');
    print('|  5. Exit                         |');
    print('+----------------------------------+');
    try {
      switch (ask('Choice')) {
        case '1':
          final title = ask('Title');
          if (title.trim().isEmpty) throw FormatException('empty title');
          print('\n  Deadline');
          final month = askNumber('Month (1-12)', 1, 12);
          final maxDay = DateTime(DateTime.now().year, month + 1, 0).day;
          final day = askNumber('Day (1-$maxDay)', 1, maxDay);
          final deadline = '${month.toString().padLeft(2, '0')}/'
              '${day.toString().padLeft(2, '0')}';
          final urgent = ask('Urgent? (Yes/No)').toLowerCase() == 'y';
          await planner.add(title, deadline, urgent);
          break;
        case '2':
          planner.show();
          break;
        case '3':
          await planner.complete(int.parse(ask('Task ID')));
          break;
        case '4':
          planner.delete(int.parse(ask('Task ID')));
          break;
        case '5':
          print('\n Stay productive.\n');
          return;
        default:
          print('  Invalid choice.');
      }
    } on StateError {
      print('  [!] Error: Task ID not found.');
    } on FormatException {
      print('  [!] Error: Invalid input.');
    } catch (e) {
      print('  [!] Unexpected error: $e');
    }
  }
}
