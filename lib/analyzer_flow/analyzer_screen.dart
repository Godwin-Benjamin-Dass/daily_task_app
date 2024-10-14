import 'package:daily_task_app/analyzer_flow/view_tasks_data.dart';
import 'package:daily_task_app/models/task_model.dart';
import 'package:daily_task_app/providers/task_provider.dart';
import 'package:daily_task_app/widgets/pie_chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AnalyzerScreen extends StatefulWidget {
  const AnalyzerScreen(
      {super.key,
      required this.startDate,
      required this.endDate,
      this.isParticularDay = false});
  final DateTime startDate;
  final DateTime endDate;
  final bool isParticularDay;

  @override
  State<AnalyzerScreen> createState() => _AnalyzerScreenState();
}

class _AnalyzerScreenState extends State<AnalyzerScreen> {
  @override
  void initState() {
    super.initState();
    getTaskAnalysis();
  }

  List<TaskModel> analyzerTask = [];
  List<TaskModel> health = [];
  List<TaskModel> studies = [];
  List<TaskModel> money = [];
  List<TaskModel> enjoyment = [];
  List<TaskModel> sleep = [];

  getTaskAnalysis() {
    Future.delayed(Duration.zero, () {
      analyzerTask = Provider.of<TaskProvider>(context, listen: false)
          .getTasksForToAnalyse(
              startDate: widget.startDate, endDate: widget.endDate);
      health = analyzerTask.where((ele) => ele.category == 'Health').toList();
      studies =
          analyzerTask.where((ele) => ele.category == 'knowledge').toList();
      money = analyzerTask.where((ele) => ele.category == 'Wealth').toList();
      enjoyment =
          analyzerTask.where((ele) => ele.category == 'Enjoyment').toList();
      sleep = analyzerTask.where((ele) => ele.category == 'Sleep').toList();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Analyzer',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, task, child) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      widget.isParticularDay
                          ? 'Selected Date: '
                          : 'Start Range: ',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      DateFormat("dd, MMM, yy").format(widget.isParticularDay
                          ? widget.startDate.add(const Duration(days: 1))
                          : widget.startDate),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (!widget.isParticularDay)
                  Row(
                    children: [
                      const Text(
                        'End Date: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        DateFormat("dd, MMM, yy").format(widget.endDate),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ],
                  ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    const Text(
                      'Total no of task: ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      task.analyseTask.length.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  'Task breakup: ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Text(
                      '- Health: ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      health.length.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      '- Hrs: ',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      calculateTotalHours(health).toStringAsFixed(0),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Text(
                      '- Studies: ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      studies.length.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      '- Hrs: ',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      calculateTotalHours(studies).toStringAsFixed(0),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Text(
                      '- Money: ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      money.length.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      '- Hrs: ',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      calculateTotalHours(money).toStringAsFixed(0),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Text(
                      '- Enjoymnet: ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      enjoyment.length.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      '- Hrs: ',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      calculateTotalHours(enjoyment).toStringAsFixed(0),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Text(
                      '- Sleep: ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      sleep.length.toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      '- Hrs: ',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      calculateTotalHours(sleep).toStringAsFixed(0),
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                PieChartWidget(
                  type: 'Overall Status',
                  pending: getIncomplete(analyzerTask),
                  inProgress: getPending(analyzerTask),
                  completed: getCompleted(analyzerTask),
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewTasksData(
                                  tasks: analyzerTask,
                                )));
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                PieChartWidget(
                  type: 'Health Status',
                  pending: getIncomplete(health),
                  inProgress: getPending(health),
                  completed: getCompleted(health),
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewTasksData(
                                  tasks: health,
                                )));
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                PieChartWidget(
                  type: 'Studies Status',
                  pending: getIncomplete(studies),
                  inProgress: getPending(studies),
                  completed: getCompleted(studies),
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewTasksData(
                                  tasks: studies,
                                )));
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                PieChartWidget(
                  type: 'Money Status',
                  pending: getIncomplete(money),
                  inProgress: getPending(money),
                  completed: getCompleted(money),
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewTasksData(
                                  tasks: money,
                                )));
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                PieChartWidget(
                  type: 'Enjoyment Status',
                  pending: getIncomplete(enjoyment),
                  inProgress: getPending(enjoyment),
                  completed: getCompleted(enjoyment),
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewTasksData(
                                  tasks: enjoyment,
                                )));
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                PieChartWidget(
                  type: 'Sleep Status',
                  pending: getIncomplete(sleep),
                  inProgress: getPending(sleep),
                  completed: getCompleted(sleep),
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewTasksData(
                                  tasks: sleep,
                                )));
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double calculateTotalHours(List<TaskModel> tasks) {
    double totalHours = 0;

    for (TaskModel task in tasks) {
      final startMinutes = task.startTime!.hour * 60 + task.startTime!.minute;
      final endMinutes = task.endTime!.hour * 60 + task.endTime!.minute;

      int durationMinutes;

      // Check if endTime is before startTime (spanning midnight)
      if (endMinutes < startMinutes) {
        // Add 24 hours (1440 minutes) to the end time
        durationMinutes = (1440 - startMinutes) + endMinutes;
      } else {
        durationMinutes = endMinutes - startMinutes;
      }

      totalHours += durationMinutes / 60; // Convert minutes to hours
    }

    return totalHours;
  }

  int getPending(List<TaskModel> tasks) {
    int pending = 0;
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].status == 'pending') {
        pending++;
      }
    }
    return pending;
  }

  int getIncomplete(List<TaskModel> tasks) {
    int incomplete = 0;
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].status == 'incomplete') {
        incomplete++;
      }
    }
    return incomplete;
  }

  int getCompleted(List<TaskModel> tasks) {
    int completed = 0;
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].status == 'completed') {
        completed++;
      }
    }
    return completed;
  }
}
