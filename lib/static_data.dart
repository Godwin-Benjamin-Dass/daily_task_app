import 'package:daily_task_app/models/task_model.dart';
import 'package:flutter/material.dart';

List<TaskModel> tASKS = [
  //when ever adding the list enusure to add the date of the day that is selected
  //this data is from the excel sheet provided by the client, ask the client or me before changing it
  TaskModel(
      id: DateTime.now().toString(),
      task: 'Wake up',
      category: 'Health',
      description: 'fresh up your self',
      startTime: const TimeOfDay(hour: 6, minute: 0),
      endTime: const TimeOfDay(hour: 6, minute: 5),
      icon: 'sleeping',
      link: '',
      status: 'incomplete'),
  TaskModel(
      id: DateTime.now().toString(),
      task: 'Rest room',
      category: 'Health',
      description: 'fresh up your self',
      startTime: const TimeOfDay(hour: 6, minute: 5),
      endTime: const TimeOfDay(hour: 6, minute: 30),
      icon: 'Health',
      status: 'incomplete',
      link: ''),
  TaskModel(
      id: DateTime.now().toString(),
      task: 'Excercise',
      category: 'Health',
      description: 'Develop your mind and body',
      startTime: const TimeOfDay(hour: 6, minute: 30),
      endTime: const TimeOfDay(hour: 7, minute: 30),
      icon: 'Health',
      status: 'incomplete',
      link: ''),
  TaskModel(
      id: DateTime.now().toString(),
      task: 'Get ready To office/food/dressing',
      category: 'Health',
      description: 'Get ready for a great day',
      startTime: const TimeOfDay(hour: 7, minute: 30),
      endTime: const TimeOfDay(hour: 8, minute: 0),
      icon: 'Health',
      status: 'incomplete',
      link: ''),
  TaskModel(
      id: DateTime.now().toString(),
      task: 'TV News / news paper',
      category: 'knowledge',
      description: 'fresh up your self',
      startTime: const TimeOfDay(hour: 8, minute: 0),
      endTime: const TimeOfDay(hour: 8, minute: 30),
      icon: 'knowledge',
      status: 'incomplete',
      link: ''),
  TaskModel(
      id: DateTime.now().toString(),
      task: 'Travelling time to office',
      category: 'Wealth',
      description: 'Get ready for office',
      startTime: const TimeOfDay(hour: 8, minute: 30),
      endTime: const TimeOfDay(hour: 9, minute: 00),
      icon: 'Wealth',
      status: 'incomplete',
      link: ''),
  TaskModel(
      id: DateTime.now().toString(),
      task: 'Office work Time',
      category: 'Wealth',
      description: 'A loved job never feels like a job',
      startTime: const TimeOfDay(hour: 9, minute: 0),
      endTime: const TimeOfDay(hour: 11, minute: 00),
      icon: 'Wealth',
      status: 'incomplete',
      link: ''),
  TaskModel(
      id: DateTime.now().toString(),
      task: 'Tea Time / water',
      category: 'Health',
      description: 'Fresh up your self',
      startTime: const TimeOfDay(hour: 11, minute: 00),
      endTime: const TimeOfDay(hour: 11, minute: 15),
      icon: 'Health',
      status: 'incomplete',
      link: ''),
  TaskModel(
      id: DateTime.now().toString(),
      task: 'office work Time ',
      category: 'Wealth',
      description: 'Back to work',
      startTime: const TimeOfDay(hour: 11, minute: 15),
      endTime: const TimeOfDay(hour: 13, minute: 00),
      icon: 'Wealth',
      status: 'incomplete',
      link: ''),
  TaskModel(
      id: DateTime.now().toString(),
      task: 'Lunch/ friend & family  call/ Rest Room ',
      category: 'Health',
      description: 'Fresh up your self',
      startTime: const TimeOfDay(hour: 13, minute: 0),
      endTime: const TimeOfDay(hour: 14, minute: 00),
      icon: 'Health',
      status: 'incomplete',
      link: ''),
  TaskModel(
      id: DateTime.now().toString(),
      task: 'office work Time',
      category: 'Wealth',
      description: 'Back to work',
      startTime: const TimeOfDay(hour: 14, minute: 0),
      endTime: const TimeOfDay(hour: 15, minute: 30),
      icon: 'Wealth',
      status: 'incomplete',
      link: ''),
  TaskModel(
      id: DateTime.now().toString(),
      task: 'Tea Time / water',
      category: 'Health',
      description: 'Fresh up your self',
      startTime: const TimeOfDay(hour: 15, minute: 30),
      endTime: const TimeOfDay(hour: 15, minute: 45),
      icon: 'Health',
      status: 'incomplete',
      link: ''),
  TaskModel(
      id: DateTime.now().toString(),
      task: 'office work Time',
      category: 'Wealth',
      description: 'Back to work',
      startTime: const TimeOfDay(hour: 15, minute: 45),
      endTime: const TimeOfDay(hour: 17, minute: 30),
      icon: 'Wealth',
      status: 'incomplete',
      link: ''),
  TaskModel(
      id: DateTime.now().toString(),
      task: 'Getting Ready To house ',
      category: 'Wealth',
      description: 'Pack your stuff',
      startTime: const TimeOfDay(hour: 17, minute: 30),
      endTime: const TimeOfDay(hour: 18, minute: 00),
      icon: 'Wealth',
      status: 'incomplete',
      link: ''),
  TaskModel(
      id: DateTime.now().toString(),
      task: 'Evening Refresh Time',
      category: 'Health',
      description: 'Free your self',
      startTime: const TimeOfDay(hour: 18, minute: 0),
      endTime: const TimeOfDay(hour: 18, minute: 30),
      icon: 'Health',
      status: 'incomplete',
      link: ''),
  TaskModel(
      id: DateTime.now().toString(),
      task: 'Evening sports/gym',
      category: 'Health',
      description: 'A healthy body is a healthy mind',
      startTime: const TimeOfDay(hour: 18, minute: 30),
      endTime: const TimeOfDay(hour: 19, minute: 30),
      icon: 'Health',
      status: 'incomplete',
      link: ''),
  TaskModel(
      id: DateTime.now().toString(),
      task: 'TV News / socla media ',
      category: 'Health',
      description: 'Learn what is going on',
      startTime: const TimeOfDay(hour: 19, minute: 30),
      endTime: const TimeOfDay(hour: 20, minute: 00),
      icon: 'Health',
      status: 'incomplete',
      link: ''),
  TaskModel(
      id: DateTime.now().toString(),
      task: 'dinner/ with family',
      category: 'Health',
      description: 'Spend your quality time with your family',
      startTime: const TimeOfDay(hour: 20, minute: 0),
      endTime: const TimeOfDay(hour: 20, minute: 30),
      icon: 'Health',
      status: 'incomplete',
      link: ''),
  TaskModel(
      id: DateTime.now().toString(),
      task: 'Discussion with the family',
      category: 'Health',
      description: 'Guide your family',
      startTime: const TimeOfDay(hour: 20, minute: 30),
      endTime: const TimeOfDay(hour: 20, minute: 45),
      icon: 'Health',
      status: 'incomplete',
      link: ''),
  TaskModel(
      id: DateTime.now().toString(),
      task: 'Today work completion / Tomorrow work plan',
      category: 'Health',
      description: 'Plan for tomorrow',
      startTime: const TimeOfDay(hour: 20, minute: 45),
      endTime: const TimeOfDay(hour: 21, minute: 30),
      icon: 'Health',
      status: 'incomplete',
      link: ''),
  TaskModel(
      id: DateTime.now().toString(),
      task: 'helping the family',
      category: 'Health',
      description: 'Help your fammily',
      startTime: const TimeOfDay(hour: 21, minute: 30),
      endTime: const TimeOfDay(hour: 21, minute: 45),
      icon: 'Health',
      status: 'incomplete',
      link: ''),
  TaskModel(
      id: DateTime.now().toString(),
      task: 'song / meditation',
      category: 'Health',
      description: 'Free your self',
      startTime: const TimeOfDay(hour: 21, minute: 45),
      endTime: const TimeOfDay(hour: 22, minute: 00),
      icon: 'Health',
      status: 'incomplete',
      link: ''),
  TaskModel(
      id: DateTime.now().toString(),
      task: 'Sleeping time ',
      category: 'Health',
      description: 'Give rest to your body and soul',
      startTime: const TimeOfDay(hour: 22, minute: 0),
      endTime: const TimeOfDay(hour: 6, minute: 00),
      icon: 'Health',
      status: 'incomplete',
      link: ''),
];

final List<Map<String, IconData>> taskIcons = [
  {'Wealth': Icons.currency_rupee},
  {'Health': Icons.health_and_safety},
  {'Grocery Shopping': Icons.shopping_cart},
  {'Laundry': Icons.local_laundry_service},
  {'Exercise': Icons.fitness_center},
  {'Cooking': Icons.kitchen},
  {'Work': Icons.work},
  {'Cleaning': Icons.cleaning_services},
  {'Reading': Icons.book},
  {'Meeting': Icons.meeting_room},
  {'Sleeping': Icons.hotel},
  {'Business': Icons.business},
  {'Self Care': Icons.self_improvement},
  {'Travel': Icons.travel_explore},
  {'Medicine': Icons.medication},
  {'Study Time': Icons.school},
  {'Playing': Icons.sports_soccer},
  {'Entertainment': Icons.movie},
];

getIcon(String icon) {
  switch (icon) {
    case 'Wealth' || 'Money':
      return Icons.currency_rupee;
    case 'Health':
      return Icons.health_and_safety;
    case 'Grocery Shopping':
      return Icons.shopping_cart;
    case 'Laundry':
      return Icons.local_laundry_service;
    case 'Exercise':
      return Icons.fitness_center;
    case 'Cooking':
      return Icons.kitchen;
    case 'Work':
      return Icons.work;
    case 'Cleaning':
      return Icons.cleaning_services;
    case 'Reading':
      return Icons.book;
    case 'Meeting':
      return Icons.meeting_room;
    case 'Sleeping':
      return Icons.hotel;
    case 'Business':
      return Icons.business;
    case 'Self Care':
      return Icons.self_improvement;
    case 'Travel':
      return Icons.travel_explore;
    case 'Medicine':
      return Icons.medication;
    case 'Study Time' || 'Knowledge':
      return Icons.school;
    case 'Playing':
      return Icons.sports_soccer;
    case 'Entertainment' || 'Happiness':
      return Icons.emoji_emotions;
    default:
      return Icons.help; // Fallback icon in case no match is found
  }
}
