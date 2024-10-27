import 'package:daily_task_app/models/task_model.dart';
import 'package:daily_task_app/models/time_slot.dart';
import 'package:daily_task_app/services/task_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> _allTask = [];
  List<TaskModel> get allTask => _allTask;

  List<TaskModel> _dailyTask = [];
  List<TaskModel> get dailyTask => _dailyTask;

  final List<TaskModel> _deafultTask = [];
  List<TaskModel> get deafultTask => _deafultTask;
  String? _taskType;
  String? get taskType => _taskType;
  bool _isTaskOngoing = false;
  bool get isTaskOngoing => _isTaskOngoing;
  TaskModel? _ongoingTask;
  TaskModel? get ongoingTask => _ongoingTask;

  getAllTask() async {
    _allTask = await TaskService.getAllTasks();
    notifyListeners();
  }

  List<TaskModel> _analyseTask = [];
  List<TaskModel> get analyseTask => _analyseTask;

  Future copyDefalutTask({required DateTime date, required String type}) async {
    _dailyTask.clear();
    List<TaskModel> tasks = await TaskService.getDefalutTasks(type: type);
    if (tasks.isEmpty) {
      Fluttertoast.showToast(msg: '$type Task is Empty!');
      return;
    }
    for (var task in tasks) {
      TaskModel taskToBeAdded = TaskModel(
          id: DateTime.now().toString(),
          task: task.task,
          date: date,
          category: task.category,
          description: task.description,
          endTime: task.endTime,
          startTime: task.startTime,
          icon: task.icon,
          link: task.link,
          status: task.status,
          app: task.app);
      _dailyTask.add(taskToBeAdded);

      addOrEditAllTask(taskToBeAdded);
    }
    TaskService.setDayType(
        date: DateTime(date.year, date.month, date.day).toString(), type: type);
    _taskType = type;
    notifyListeners();
  }

  Future addTask({required TaskModel task}) async {
    final possible = isSlotAvailable(task.startTime!, task.endTime!);
    if (!possible) {
      Fluttertoast.showToast(
          msg: 'The Slot is not Available',
          backgroundColor: Colors.red,
          textColor: Colors.white);

      return false;
    }
    _dailyTask.add(task);
    addOrEditAllTask(task);

    notifyListeners();

    return true;
  }

  Future editTask({required TaskModel task}) async {
    int idx = _dailyTask.indexWhere((ele) => ele.id == task.id);
    if (idx != -1) {
      if (_dailyTask[idx].startTime != task.startTime ||
          _dailyTask[idx].endTime != task.endTime) {
        final possible =
            isSlotAvailable(task.startTime!, task.endTime!, idx: idx);
        if (!possible) {
          Fluttertoast.showToast(
              msg: 'The Slot is not Available',
              backgroundColor: Colors.red,
              textColor: Colors.white);

          return false;
        }
      }
      _dailyTask[idx] = task;
    }

    notifyListeners();
    addOrEditAllTask(task);
    checkOngoingTask();

    return true;
  }

  deleteTask({required String id}) {
    DateTime? date;
    int idx = _dailyTask.indexWhere((ele) => ele.id == id);
    if (idx != -1) {
      date = _dailyTask[idx].date;
      _dailyTask.removeAt(idx);
    }
    deleteTaskInAllTask(id);

    if (_dailyTask.isEmpty && date != null) {
      TaskService.clearType(
          date: DateTime(date.year, date.month, date.day).toString());
      _taskType = null;
    }
    notifyListeners();
  }

  getTaskForParticularDay({required DateTime date}) async {
    getAllTask();
    _dailyTask.clear();
    _dailyTask = _allTask
        .where((ele) => (ele.date!.day == date.day &&
            ele.date!.month == date.month &&
            ele.date!.year == date.year))
        .toList();

    _dailyTask.sort((a, b) {
      int dateComparison = a.date!.compareTo(b.date!);
      if (dateComparison != 0) {
        return dateComparison; // If the dates are different, return the comparison
      }
      // If the dates are the same, compare the startTime
      return a.startTime!.hour.compareTo(b.startTime!.hour) != 0
          ? a.startTime!.hour.compareTo(b.startTime!.hour)
          : a.startTime!.minute.compareTo(b.startTime!.minute);
    });
    _taskType = await TaskService.getDayType(
        date: DateTime(date.year, date.month, date.day).toString().toString());
    notifyListeners();
    checkOngoingTask();
  }

  addOrEditAllTask(TaskModel task) async {
    int idx = _allTask.indexWhere((ele) => ele.id == task.id);
    if (idx != -1) {
      _allTask[idx] = task;
      TaskService.editTask(task);
    } else {
      _allTask.add(task);
      TaskService.addTask(task);
    }
    notifyListeners();
  }

  deleteTaskInAllTask(String id) async {
    int idx = _allTask.indexWhere((ele) => ele.id == id);
    if (idx != -1) {
      _allTask.removeAt(idx);
    }
    await TaskService.deleteTask(id);
    notifyListeners();
  }

  addOrEditDefaultTask(TaskModel task) async {
    int idx = _deafultTask.indexWhere((ele) => ele.id == task.id);
    if (idx != -1) {
      final possible = isSlotAvailable(task.startTime!, task.endTime!,
          isDeafult: true, idx: idx);
      if (!possible) {
        Fluttertoast.showToast(
            msg: 'The Slot is not Available',
            backgroundColor: Colors.red,
            textColor: Colors.white);

        return false;
      }
      _deafultTask[idx] = task;
    } else {
      _deafultTask.add(task);
    }
    notifyListeners();
    return true;
  }

  deleteDefaultTask(String id) async {
    int idx = _deafultTask.indexWhere((ele) => ele.id == id);
    if (idx != -1) {
      _deafultTask.removeAt(idx);
    }
    notifyListeners();
  }

  copyDefalutTasksToDefaultTask({required String type}) async {
    _deafultTask.clear();
    List<TaskModel> tasks = await TaskService.getDefalutTasks(type: type);
    for (var task in tasks) {
      TaskModel taskToBeAdded = TaskModel(
          id: DateTime.now().toString(),
          task: task.task,
          category: task.category,
          description: task.description,
          endTime: task.endTime,
          startTime: task.startTime,
          icon: task.icon,
          link: task.link,
          status: task.status,
          app: task.app);
      _deafultTask.add(taskToBeAdded);
    }
    _deafultTask.sort((a, b) {
      int dateComparison = a.date!.compareTo(b.date!);
      if (dateComparison != 0) {
        return dateComparison; // If the dates are different, return the comparison
      }
      // If the dates are the same, compare the startTime
      return a.startTime!.hour.compareTo(b.startTime!.hour) != 0
          ? a.startTime!.hour.compareTo(b.startTime!.hour)
          : a.startTime!.minute.compareTo(b.startTime!.minute);
    });

    notifyListeners();
  }

  Future saveDefaultTask({required String type}) async {
    if (_deafultTask.isEmpty) {
      Fluttertoast.showToast(msg: 'Please add some task');
      return false;
    }
    TaskService.saveDefaultTask(tasks: _deafultTask, type: type);
    Fluttertoast.showToast(msg: 'Saved');
    return true;
  }

  checkOngoingTask() {
    int idx = _dailyTask.indexWhere((ele) => ele.status == 'pending');
    if (idx != -1) {
      _ongoingTask = _dailyTask[idx];
      _isTaskOngoing = true;
    } else {
      _isTaskOngoing = false;
      _ongoingTask = null;
    }
    notifyListeners();
  }

  getTasksForToAnalyse(
      {required DateTime startDate, required DateTime endDate}) {
    getAllTask();
    _analyseTask.clear();
    _analyseTask = _allTask
        .where((ele) =>
            (ele.date!.isAfter(startDate) && ele.date!.isBefore(endDate)))
        .toList();
    _analyseTask.sort((a, b) {
      int dateComparison = a.date!.compareTo(b.date!);
      if (dateComparison != 0) {
        return dateComparison; // If the dates are different, return the comparison
      }
      // If the dates are the same, compare the startTime
      return a.startTime!.hour.compareTo(b.startTime!.hour) != 0
          ? a.startTime!.hour.compareTo(b.startTime!.hour)
          : a.startTime!.minute.compareTo(b.startTime!.minute);
    });
    notifyListeners();
    return _analyseTask;
  }

  bool isSlotAvailable(TimeOfDay startTime, TimeOfDay endTime,
      {int? idx, bool isDeafult = false}) {
    List<TaskModel> tasksToBeChecked = isDeafult ? _deafultTask : _dailyTask;
    List<TimeSlot> existingSlots = [];
    for (int i = 0; i < tasksToBeChecked.length; i++) {
      if (i != idx) {
        existingSlots.add(TimeSlot(
            tasksToBeChecked[i].startTime!, tasksToBeChecked[i].endTime!));
      }
    }

    final TimeSlot newSlot = TimeSlot(startTime, endTime);

    for (TimeSlot slot in existingSlots) {
      if (slot.overlaps(newSlot)) {
        return false; // Conflict detected
      }
    }
    return true; // No conflicts
  }
}
