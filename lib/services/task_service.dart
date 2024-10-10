import 'dart:async';
import 'dart:convert';
import 'package:daily_task_app/models/task_model.dart';
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
          task_name TEXT,
          description TEXT,
          icon TEXT,
          date TEXT,
          startTime TEXT,
          endTime TEXT,
          category TEXT,
          link TEXT,
          status TEXT,
          app_name TEXT,
          app_icon BLOB,
          bundle_id TEXT
        )
        ''',
        );
      },
    );
  }

  // Store a task in the database
  static Future<void> addTask(TaskModel newTask) async {
    final db = await database;
    await db.insert(
      'tasks',
      newTask.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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
  }

  // Delete a specific task
  static Future<void> deleteTask(String taskId) async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [taskId],
    );
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
      return TaskModel.fromJson(maps[i]);
    });
  }
}
