import 'package:daily_task_app/models/task_model.dart';
import 'package:daily_task_app/models/time_slot.dart';
import 'package:daily_task_app/services/task_service.dart';
import 'package:daily_task_app/static_data.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TaskProvider extends ChangeNotifier {
  List<TaskModel> _allTask = [];
  List<TaskModel> get allTask => _allTask;

  List<TaskModel> _dailyTask = [];
  List<TaskModel> get dailyTask => _dailyTask;

  getAllTask() async {
    _allTask = await TaskService.getAllTasks();
    notifyListeners();
  }

  List<TaskModel> _analyseTask = [];
  List<TaskModel> get analyseTask => _analyseTask;

  copyDefalutTask({required DateTime date}) {
    _dailyTask.clear();
    for (var task in tASKS) {
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
          status: task.status);
      _dailyTask.add(taskToBeAdded);

      addOrEditAllTask(taskToBeAdded);
    }

    notifyListeners();
  }

  Future addTask({required TaskModel task}) async {
    final possible = isSlotAvailable(task.startTime!, task.endTime!);
    if (!possible) {
      Fluttertoast.showToast(
          msg: 'the slot is not available',
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
              msg: 'the slot is not available',
              backgroundColor: Colors.red,
              textColor: Colors.white);

          return false;
        }
      }
      _dailyTask[idx] = task;
    }

    notifyListeners();
    addOrEditAllTask(task);
    return true;
  }

  deleteTask({required String id}) {
    int idx = _dailyTask.indexWhere((ele) => ele.id == id);
    if (idx != -1) {
      _dailyTask.removeAt(idx);
    }
    deleteTaskInAllTask(id);
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
    notifyListeners();
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

  bool isSlotAvailable(TimeOfDay startTime, TimeOfDay endTime, {int? idx}) {
    List<TimeSlot> existingSlots = [];
    for (int i = 0; i < _dailyTask.length; i++) {
      if (i != idx) {
        existingSlots
            .add(TimeSlot(_dailyTask[i].startTime!, _dailyTask[i].endTime!));
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
