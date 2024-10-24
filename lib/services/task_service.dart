import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:daily_task_app/models/task_model.dart';
import 'package:daily_task_app/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TaskService {
  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;

  static Database? _database;

  TaskService._internal();

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          '''
        CREATE TABLE tasks (
          id TEXT PRIMARY KEY,
          task_name TEXT,          -- Task name
          description TEXT,        -- Task description
          icon TEXT,               -- Task icon as string
          date TEXT,               -- Task date in ISO 8601 string format
          startTime TEXT,          -- Start time in ISO 8601 string format
          endTime TEXT,            -- End time in ISO 8601 string format
          category TEXT,           -- Task category
          link TEXT,               -- Link associated with the task
          status TEXT,             -- Status of the task (e.g., complete, incomplete)
          app TEXT                 -- Store AppModel as a JSON string
        )
        ''',
        );
      },
    );
  }

  // Store a task in the database
  static Future<void> addTask(TaskModel task) async {
    final db = await database;
    await db.insert(
      'tasks',
      {
        'id': task.id,
        'task_name': task.task,
        'description': task.description,
        'icon': task.icon,
        'date': task.date?.toIso8601String(),
        'startTime': task.startTime != null
            ? DateTime(2000, 1, 1, task.startTime!.hour, task.startTime!.minute)
                .toIso8601String()
            : null,
        'endTime': task.endTime != null
            ? DateTime(2000, 1, 1, task.endTime!.hour, task.endTime!.minute)
                .toIso8601String()
            : null,
        'category': task.category,
        'link': task.link,
        'status': task.status,
        'app': task.app != null
            ? jsonEncode(task.app!.toJson())
            : null, // Store AppModel as JSON string
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    DateTime sheduleTime = DateTime(
      task.date!.year,
      task.date!.month,
      task.date!.day,
      task.startTime!.hour,
      task.startTime!.minute,
    );
    if (sheduleTime.isBefore(DateTime.now())) {
      return;
    }
    NotificationService.scheduleNotification(
        title: task.task!,
        payload: task.id!,
        scheduledTime: sheduleTime,
        id: DateTime.parse(task.id!).microsecond);
  }

  // Retrieve all tasks from the database
  static Future<List<TaskModel>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks');

    return List.generate(maps.length, (i) {
      return TaskModel.fromJson(maps[i]);
    });
  }

  // Edit a specific task
  static Future<void> editTask(TaskModel updatedTask) async {
    final db = await database;
    await db.update(
      'tasks',
      updatedTask.toJson(),
      where: 'id = ?',
      whereArgs: [updatedTask.id],
    );
    if (updatedTask.status == 'completed') {
      NotificationService.cancelNotification(
          DateTime.parse(updatedTask.id!).microsecond);
      return;
    }

    DateTime sheduleTime = DateTime(
      updatedTask.date!.year,
      updatedTask.date!.month,
      updatedTask.date!.day,
      updatedTask.status == 'pending'
          ? updatedTask.endTime!.hour
          : updatedTask.startTime!.hour,
      updatedTask.status == 'pending'
          ? updatedTask.endTime!.minute
          : updatedTask.startTime!.minute,
    );
    NotificationService.cancelNotification(
        DateTime.parse(updatedTask.id!).microsecond);
    if (sheduleTime.isBefore(DateTime.now())) {
      return;
    }
    NotificationService.scheduleNotification(
        title: updatedTask.task!,
        payload: updatedTask.id!,
        scheduledTime: sheduleTime,
        id: DateTime.parse(updatedTask.id!).microsecond);
  }

  // Delete a specific task
  static Future<void> deleteTask(String taskId) async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [taskId],
    );
    NotificationService.cancelNotification(DateTime.parse(taskId).microsecond);
  }

  static Future<TaskModel?> getTaskById(String id) async {
    final Database db = await _initDatabase(); // Initialize the database

    // Query the database for the task with the given id
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'id = ?', // Filter by the task id
      whereArgs: [id], // Pass the id as an argument
    );

    // If the task is found, return a TaskModel instance
    if (maps.isNotEmpty) {
      return TaskModel.fromJson(
          maps.first); // Create a TaskModel from the first result
    } else {
      return null; // Return null if no task is found
    }
  }

  static Future<List<TaskModel>> getPendingTasks() async {
    final db = await database;
    DateTime currentTime = DateTime.now();

    // Query to get tasks with start time after the current time
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'date >= ? AND startTime >= ?',
      whereArgs: [
        currentTime.toIso8601String().split('T')[0], // Date condition
        currentTime.toIso8601String() // Time condition
      ],
    );

    // Return the list of future tasks
    return List.generate(maps.length, (i) {
      return TaskModel.fromJson(maps[i]);
    });
  }

  static Future saveDefaultTask(
      {required List<TaskModel> tasks, required String type}) async {
    final pref = await SharedPreferences.getInstance();
    List data = [];
    for (TaskModel task in tasks) {
      data.add(task.toJson());
    }
    await pref.setString(type, jsonEncode(data));
  }

  static Future<List<TaskModel>> getDefalutTasks({required String type}) async {
    final pref = await SharedPreferences.getInstance();
    String? data = pref.getString(type);

    if (data == null) {
      return [];
    }
    final List maps = jsonDecode(data);

    return List.generate(maps.length, (i) {
      log(maps[i].toString());
      return TaskModel.fromJson(maps[i]);
    });
  }

  static setDayType({required String date, required String type}) async {
    final pref = await SharedPreferences.getInstance();
    print(date + type);
    await pref.setString(date, type);
  }

  static getDayType({required String date}) async {
    final pref = await SharedPreferences.getInstance();
    print(date);
    print(pref.getString(date).toString() + "----------------->");
    return pref.getString(date);
  }

  static clearType({required String date}) async {
    final pref = await SharedPreferences.getInstance();
    pref.remove(date);
  }
}
