import 'package:daily_task_app/home_flow/add_task_popup.dart';
import 'package:daily_task_app/providers/task_provider.dart';
import 'package:daily_task_app/widgets/task_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEditDefaultShedule extends StatefulWidget {
  const AddEditDefaultShedule({super.key, required this.sheduleType});
  final String sheduleType;

  @override
  State<AddEditDefaultShedule> createState() => _AddEditDefaultSheduleState();
}

class _AddEditDefaultSheduleState extends State<AddEditDefaultShedule> {
  @override
  void initState() {
    super.initState();
    getDefalutTask();
  }

  getDefalutTask() {
    Future.delayed(Duration.zero, () {
      Provider.of<TaskProvider>(context, listen: false)
          .copyDefalutTasksToDefaultTask(type: widget.sheduleType);
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text(
                    'Do you want to save the tasks ?',
                    style: TextStyle(fontSize: 18),
                  ),
                  actions: [
                    SizedBox(
                        height: 34,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('No'))),
                    SizedBox(
                        height: 34,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                backgroundColor:
                                    Theme.of(context).primaryColor),
                            onPressed: () {
                              Provider.of<TaskProvider>(context, listen: false)
                                  .saveDefaultTask(type: widget.sheduleType);

                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Yes',
                              style: TextStyle(color: Colors.white),
                            ))),
                  ],
                ));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text(
                            'Do you want to save the tasks ?',
                            style: TextStyle(fontSize: 18),
                          ),
                          actions: [
                            SizedBox(
                                height: 34,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8))),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('No'))),
                            SizedBox(
                                height: 34,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        backgroundColor:
                                            Theme.of(context).primaryColor),
                                    onPressed: () {
                                      Provider.of<TaskProvider>(context,
                                              listen: false)
                                          .saveDefaultTask(
                                              type: widget.sheduleType);

                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Yes',
                                      style: TextStyle(color: Colors.white),
                                    ))),
                          ],
                        ));
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            '${widget.sheduleType} Schedule',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        body: Consumer<TaskProvider>(
          builder: (context, task, child) => SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: task.deafultTask.length,
                    itemBuilder: (ctx, i) {
                      return TaskTileWidget(
                          isDefault: true,
                          idx: i + 1,
                          task: task.deafultTask[i],
                          ontap: () {
                            addTaskDialog(context,
                                date: DateTime.now(),
                                isEdit: true,
                                task: task.deafultTask[i],
                                defaultType: widget.sheduleType);
                          });
                    }),
                task.deafultTask.length > 0
                    ? Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: SizedBox(
                          height: 34,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () {
                                Provider.of<TaskProvider>(context,
                                        listen: false)
                                    .saveDefaultTask(type: widget.sheduleType)
                                    .then((val) {
                                  if (val) {
                                    Navigator.pop(context);
                                  }
                                });
                              },
                              child: const Text(
                                'Save',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              )),
                        ),
                      )
                    : SizedBox(
                        child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.42,
                          ),
                          Text("No Default Schedule Available"),
                        ],
                      ))
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              addTaskDialog(
                  defaultType: widget.sheduleType,
                  context,
                  isEdit: false,
                  date: DateTime.now());
            }),
      ),
    );
  }
}
