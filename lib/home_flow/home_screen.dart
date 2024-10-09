import 'package:daily_task_app/home_flow/add_task_popup.dart';
import 'package:daily_task_app/home_flow/settings_page.dart';
import 'package:daily_task_app/providers/task_provider.dart';
import 'package:daily_task_app/widgets/task_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
    // ignore: use_build_context_synchronously
    await Provider.of<TaskProvider>(context, listen: false)
        .getTaskForParticularDay(date: DateTime.now());
  }

  final f = DateFormat('yyyy-MM-dd');
  DateTime date = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 135),
          child: Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      children: [
                        const Text(
                          'Daily Activities',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SettingsPage()));
                            },
                            icon: const Icon(
                              Icons.settings,
                              color: Colors.white,
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
                              // ignore: use_build_context_synchronously
                              Provider.of<TaskProvider>(context, listen: false)
                                  .getTaskForParticularDay(date: date);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.2, color: Colors.white54),
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 3),
                              child: Row(
                                children: [
                                  Text(
                                    date.year == DateTime.now().year &&
                                            date.month ==
                                                DateTime.now().month &&
                                            date.day == DateTime.now().day
                                        ? 'Today'
                                        : f.format(date),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: Colors.white54,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            size: 40,
                            Icons.health_and_safety,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            size: 40,
                            Icons.school,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            size: 40,
                            Icons.currency_rupee,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            size: 40,
                            Icons.mood,
                            color: Colors.white,
                          )),
                      IconButton(
                          onPressed: () {},
                          icon: Image.asset(
                            "assets/images/sleeping_icon.png",
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            color: Colors.white,
                          ))
                    ],
                  )
                ],
              ),
            ),
          )),
      body: Consumer<TaskProvider>(
        builder: (context, task, child) => task.dailyTask.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          task.copyDefalutTask(date: date);
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Copy Default Shedule'),
                            SizedBox(
                              width: 20,
                            ),
                            Icon(Icons.copy)
                          ],
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          addTaskDialog(date: date, context, isEdit: false);
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Create Your Own Shedule'),
                            SizedBox(
                              width: 20,
                            ),
                            Icon(Icons.add)
                          ],
                        )),
                  ],
                ),
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: task.dailyTask.length,
                itemBuilder: (ctx, i) {
                  return TaskTileWidget(
                      idx: i + 1,
                      task: task.dailyTask[i],
                      ontap: () {
                        addTaskDialog(context,
                            date: date, isEdit: true, task: task.dailyTask[i]);
                      });
                }),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            addTaskDialog(context, isEdit: false, date: date);
          }),
    );
  }
}
