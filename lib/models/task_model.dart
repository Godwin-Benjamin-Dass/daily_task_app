import 'dart:convert';

import 'package:daily_task_app/models/app_model.dart';
import 'package:flutter/material.dart'; // for TimeOfDay

class TaskModel {
  String? id;
  String? task;
  String? description;
  String? icon;
  DateTime? date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? category;
  String? link;
  String? status;
  AppModel? app;

  TaskModel({
    this.id,
    this.task,
    this.description,
    this.icon,
    this.date,
    this.startTime,
    this.endTime,
    this.category,
    this.link,
    this.status,
    this.app,
  });

  // Convert TaskModel to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'task_name': task, // Ensure the key matches your JSON structure
        'description': description,
        'icon': icon,
        'date': date?.toIso8601String(), // Use ISO 8601 format
        'startTime': startTime != null
            ? DateTime(2000, 1, 1, startTime!.hour, startTime!.minute)
                .toIso8601String()
            : null,
        'endTime': endTime != null
            ? DateTime(2000, 1, 1, endTime!.hour, endTime!.minute)
                .toIso8601String()
            : null,
        'category': category,
        'link': link,
        'status': status,
        'app': app == null ? null : jsonEncode(app!.toJson())
      };

  // Create TaskModel from JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
      id: json['id'] as String?,
      task: json['task_name'] as String?,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      startTime: json['startTime'] != null
          ? TimeOfDay.fromDateTime(
              DateTime.tryParse(json['startTime']) ?? DateTime.now())
          : null,
      endTime: json['endTime'] != null
          ? TimeOfDay.fromDateTime(
              DateTime.tryParse(json['endTime']) ?? DateTime.now())
          : null,
      category: json['category'] as String?,
      link: json['link'] as String?,
      status: json['status'] as String?,
      app: jsonDecode(json['app'] ?? 'null') == null
          ? null
          : AppModel.fromJson(jsonDecode(json['app'])));
}
