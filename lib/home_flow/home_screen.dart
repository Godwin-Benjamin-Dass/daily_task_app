// ignore_for_file: use_build_context_synchronously

import 'package:daily_task_app/home_flow/add_task_popup.dart';
import 'package:daily_task_app/services/notification_service.dart';
import 'package:daily_task_app/setting_flow/settings_page.dart';
import 'package:daily_task_app/providers/task_provider.dart';
import 'package:daily_task_app/widgets/home_tile.dart';
import 'package:daily_task_app/widgets/task_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    setData();
  }

  setData() async {
    await Provider.of<TaskProvider>(context, listen: false).getAllTask();
    await Provider.of<TaskProvider>(context, listen: false)
        .getTaskForParticularDay(date: date);
  }

  final f = DateFormat('yyyy-MM-dd');
  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Daily Activities',
          style: TextStyle(
              fontWeight: FontWeight.w700, fontSize: 20, color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()));
              },
              icon: const Icon(
                Icons.calendar_month_outlined,
                color: Colors.white70,
              )),
          InkWell(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                  currentDate: date,
                  context: context,
                  firstDate: DateTime(1999),
                  lastDate: DateTime(2100));
              if (picked != null) {
                date = picked;
                setState(() {});
                Provider.of<TaskProvider>(context, listen: false)
                    .getTaskForParticularDay(date: date);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 0.2, color: Colors.white54),
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                child: Row(
                  children: [
                    Text(
                      date.year == DateTime.now().year &&
                              date.month == DateTime.now().month &&
                              date.day == DateTime.now().day
                          ? 'Today'
                          : f.format(date),
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    const Icon(
                      Icons.arrow_drop_down_rounded,
                      color: Colors.white54,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
        bottom: PreferredSize(
            preferredSize: Size(
                double.infinity,
                Provider.of<TaskProvider>(context, listen: true).taskType ==
                        null
                    ? 70
                    : 120),
            child: Consumer<TaskProvider>(
              builder: (context, task, child) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).primaryColor),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () {
                                  showCountPopup(context,
                                      title: 'Health',
                                      count: Provider.of<TaskProvider>(context,
                                              listen: false)
                                          .dailyTask
                                          .where(
                                              (ele) => ele.category == 'Health')
                                          .toList()
                                          .length);
                                },
                                icon: const Icon(
                                  size: 30,
                                  Icons.health_and_safety,
                                  color: Colors.white,
                                )),
                            IconButton(
                                onPressed: () {
                                  showCountPopup(context,
                                      title: 'Knowledge',
                                      count: Provider.of<TaskProvider>(context,
                                              listen: false)
                                          .dailyTask
                                          .where((ele) =>
                                              ele.category == 'Knowledge')
                                          .toList()
                                          .length);
                                },
                                icon: const Icon(
                                  size: 30,
                                  Icons.school,
                                  color: Colors.white,
                                )),
                            IconButton(
                                onPressed: () {
                                  showCountPopup(context,
                                      title: 'Money',
                                      count: Provider.of<TaskProvider>(context,
                                              listen: false)
                                          .dailyTask
                                          .where(
                                              (ele) => ele.category == 'Money')
                                          .toList()
                                          .length);
                                },
                                icon: const Icon(
                                  size: 30,
                                  Icons.currency_rupee,
                                  color: Colors.white,
                                )),
                            IconButton(
                                onPressed: () {
                                  showCountPopup(context,
                                      title: 'Happiness',
                                      count: Provider.of<TaskProvider>(context,
                                              listen: false)
                                          .dailyTask
                                          .where((ele) =>
                                              ele.category == 'Happiness')
                                          .toList()
                                          .length);
                                },
                                icon: const Icon(
                                  size: 30,
                                  Icons.mood,
                                  color: Colors.white,
                                )),
                            IconButton(
                                onPressed: () {
                                  showCountPopup(context,
                                      title: 'Sleep',
                                      count: Provider.of<TaskProvider>(context,
                                              listen: false)
                                          .dailyTask
                                          .where(
                                              (ele) => ele.category == 'Sleep')
                                          .toList()
                                          .length);
                                },
                                icon: Image.asset(
                                  "assets/images/sleeping_icon.png",
                                  width: 32,
                                  height: 32,
                                  fit: BoxFit.cover,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (task.taskType != null)
                    Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Row(
                        children: [
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all()),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Task type: ${task.taskType}"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                ],
              ),
            )),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, task, child) => task.dailyTask.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HomeTile(
                        title: 'Copy Week-Day Schedule',
                        iconData: Icons.copy,
                        ontap: () {
                          task
                              .copyDefalutTask(date: date, type: 'Week-day')
                              .then((val) {
                            setData();
                          });
                        }),
                    HomeTile(
                      iconData: Icons.copy,
                      title: 'Copy Week-End Schedule',
                      ontap: () {
                        task
                            .copyDefalutTask(date: date, type: 'Week-end')
                            .then((val) {
                          setData();
                        });
                      },
                    ),
                    HomeTile(
                        title: 'Create Your Own Schedule',
                        iconData: Icons.add_alert_outlined,
                        ontap: () {
                          addTaskDialog(date: date, context, isEdit: false);
                        }),
                  ],
                ),
              )
            : Stack(
                children: [
                  Center(
                      child: Image.asset(
                    "assets/images/logo.png",
                    height: 80,
                    width: 80,
                    color: Colors.white
                        .withOpacity(0.8), // Apply a semi-transparent color
                    colorBlendMode: BlendMode.lighten,
                  )),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        if (task.isTaskOngoing)
                          IconButton(
                            onPressed: () async {
                              await NotificationService.showDialogs(
                                  task.ongoingTask!);
                            },
                            icon: TextScroll(
                              'Task: ${task.ongoingTask!.task}, Started at: ${task.ongoingTask!.startTime!.hour}:${task.ongoingTask!.startTime!.minute}, Ends at: ${task.ongoingTask!.endTime!.hour}:${task.ongoingTask!.endTime!.minute}, Click here to view more about this task.',
                              mode: TextScrollMode.endless,
                              velocity: const Velocity(
                                  pixelsPerSecond: Offset(75, 0)),
                              delayBefore: const Duration(milliseconds: 500),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red),
                              textAlign: TextAlign.right,
                              selectable: true,
                            ),
                          ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: task.dailyTask.length,
                            itemBuilder: (ctx, i) {
                              return TaskTileWidget(
                                  idx: i + 1,
                                  task: task.dailyTask[i],
                                  ontap: () {
                                    addTaskDialog(context,
                                        date: date,
                                        isEdit: true,
                                        task: task.dailyTask[i]);
                                  });
                            }),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            addTaskDialog(context, isEdit: false, date: date);
          }),
    );
  }

  showCountPopup(context, {required String title, required int count}) {
    return showDialog(
        context: context,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                  height: 90,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 18),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Row(
                          children: [
                            const Text(
                              "No of task: ",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              count.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ));
  }
}
