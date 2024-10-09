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
        title: Text(
          '${widget.sheduleType} Schedule',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, task, child) => ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: task.deafultTask.length,
            itemBuilder: (ctx, i) {
              return TaskTileWidget(
                  idx: i + 1,
                  task: task.dailyTask[i],
                  ontap: () {
                    addTaskDialog(context,
                        date: DateTime.now(),
                        isEdit: true,
                        task: task.deafultTask[i]);
                  });
            }),
      ),
    );
  }
}
