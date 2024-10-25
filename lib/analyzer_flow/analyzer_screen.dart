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
  bool taskBreakUp = false;

  getTaskAnalysis() {
    Future.delayed(Duration.zero, () {
      // ignore: use_build_context_synchronously
      analyzerTask = Provider.of<TaskProvider>(context, listen: false)
          .getTasksForToAnalyse(
              startDate: widget.isParticularDay
                  ? widget.startDate.add(const Duration(days: 1))
                  : widget.startDate,
              endDate: widget.endDate);
      health = analyzerTask.where((ele) => ele.category == 'Health').toList();
      studies =
          analyzerTask.where((ele) => ele.category == 'Knowledge').toList();
      money = analyzerTask.where((ele) => ele.category == 'Money').toList();
      enjoyment =
          analyzerTask.where((ele) => ele.category == 'Happiness').toList();
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
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, task, child) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        DateFormat("dd MMM yy").format(widget.isParticularDay
                            ? widget.startDate.add(const Duration(days: 1))
                            : widget.startDate),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      if (!widget.isParticularDay)
                        Text(
                          " - ${DateFormat("dd MMM yy").format(widget.endDate)}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Total number of task: ',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        task.analyseTask.length.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 18),
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
                    height: 15,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.45,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                      'assets/images/animationBG.png')),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          size: 50,
                                          Icons.health_and_safety,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        Text(
                                          'Health',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.hourglass_bottom_rounded,
                                            size: 20,
                                          ),
                                          Text(
                                            " ${health.length.toString()} tasks",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.timer_outlined,
                                            size: 20,
                                          ),
                                          Text(
                                            " ${calculateTotalHours(health).toStringAsFixed(0)} hours",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.46,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                      'assets/images/animationBG.png')),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          size: 50,
                                          Icons.school,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        Text(
                                          'Knowledge',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.hourglass_bottom_rounded,
                                            size: 20,
                                          ),
                                          Text(
                                            " ${studies.length.toString()} tasks",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.timer_outlined,
                                            size: 20,
                                          ),
                                          Text(
                                            " ${calculateTotalHours(studies).toStringAsFixed(0)} hours",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.45,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                      'assets/images/animationBG.png')),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          size: 50,
                                          Icons.currency_rupee,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        Text(
                                          'Money',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.hourglass_bottom_rounded,
                                            size: 20,
                                          ),
                                          Text(
                                            " ${money.length.toString()} tasks",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.timer_outlined,
                                            size: 20,
                                          ),
                                          Text(
                                            " ${calculateTotalHours(money).toStringAsFixed(0)} hours",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.46,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                      'assets/images/animationBG.png')),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          size: 50,
                                          Icons.mood,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        Text(
                                          'Happiness',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.hourglass_bottom_rounded,
                                            size: 20,
                                          ),
                                          Text(
                                            " ${enjoyment.length.toString()} tasks",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.timer_outlined,
                                            size: 20,
                                          ),
                                          Text(
                                            " ${calculateTotalHours(enjoyment).toStringAsFixed(0)} hours",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.45,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                      'assets/images/animationBG.png')),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, right: 4),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/images/sleeping_icon.png",
                                          width: 30,
                                          height: 30,
                                          fit: BoxFit.cover,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        Text(
                                          'Sleep',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.hourglass_bottom_rounded,
                                            size: 20,
                                          ),
                                          Text(
                                            " ${sleep.length.toString()} tasks",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.timer_outlined,
                                            size: 20,
                                          ),
                                          Text(
                                            " ${calculateTotalHours(sleep).toStringAsFixed(0)} hours",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        taskBreakUp = !taskBreakUp;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          'Task breakup',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        Icon(!taskBreakUp
                            ? Icons.keyboard_arrow_down_rounded
                            : Icons.keyboard_arrow_up_rounded),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  taskBreakUp
                      ? Column(
                          children: [
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
                        )
                      : const SizedBox(),
                ],
              ),
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
