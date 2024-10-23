import 'package:daily_task_app/home_flow/add_task_popup.dart';
import 'package:daily_task_app/setting_flow/settings_page.dart';
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
    // ignore: use_build_context_synchronously
    // NotificationService().initNotification(context);
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
                // ignore: use_build_context_synchronously
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
            preferredSize: const Size(double.infinity, 70),
            child: Expanded(
              child: Container(
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
                                      .where((ele) => ele.category == 'Health')
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
                                  title: 'Studies',
                                  count: Provider.of<TaskProvider>(context,
                                          listen: false)
                                      .dailyTask
                                      .where((ele) => ele.category == 'Studies')
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
                                      .where((ele) => ele.category == 'Money')
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
                                  title: 'Enjoyment',
                                  count: Provider.of<TaskProvider>(context,
                                          listen: false)
                                      .dailyTask
                                      .where(
                                          (ele) => ele.category == 'Enjoyment')
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
                                      .where((ele) => ele.category == 'Sleep')
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
            )),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, task, child) => task.dailyTask.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text(
                                      "Select type",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.55,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8))),
                                              onPressed: () {
                                                task
                                                    .copyDefalutTask(
                                                        date: date,
                                                        type: 'Week-day')
                                                    .then((val) {
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: const Text(
                                                'Week Day',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.55,
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8))),
                                              onPressed: () {
                                                task
                                                    .copyDefalutTask(
                                                        date: date,
                                                        type: 'Week-end')
                                                    .then((val) {
                                                  Navigator.pop(context);
                                                });
                                              },
                                              child: const Text(
                                                'Week End',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              )),
                                        )
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            'Close',
                                            style: TextStyle(color: Colors.red),
                                          ))
                                    ],
                                  ));
                        },
                        child: Container(
                          height: 120,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(
                                    'assets/images/animationBG.png')),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Copy Default Schedule',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Icon(
                                Icons.copy,
                                color: Theme.of(context).primaryColor,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: InkWell(
                          onTap: () {
                            addTaskDialog(date: date, context, isEdit: false);
                          },
                          child: Container(
                            height: 120,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                      'assets/images/animationBG.png')),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Create Your Own Schedule',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Icon(
                                  Icons.add_alert_outlined,
                                  color: Theme.of(context).primaryColor,
                                )
                              ],
                            ),
                          )),
                    ),
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
                  ListView.builder(
                      physics: const BouncingScrollPhysics(),
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
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        title,
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 18),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Row(
                          children: [
                            Text(
                              "No of task: ",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                            Text(
                              count.toString(),
                              style: TextStyle(
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
