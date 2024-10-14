import 'package:daily_task_app/home_flow/device_app_screen.dart';
import 'package:daily_task_app/models/app_model.dart';
import 'package:daily_task_app/models/task_model.dart';
import 'package:daily_task_app/providers/task_provider.dart';
import 'package:daily_task_app/static_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

addTaskDialog(BuildContext context,
    {required bool isEdit,
    String? type,
    TaskModel? task,
    String? defaultType,
    required DateTime date}) async {
  String? inComplete;
  String? inProgress;
  String? complete;
  if (isEdit) {
    if (task!.status == 'pending') {
      inProgress = 'pending';
      inComplete = null;
      complete = null;
    } else if (task.status == 'completed') {
      inProgress = null;
      inComplete = null;
      complete = 'completed';
    } else {
      inProgress = null;
      inComplete = 'incomplete';
      complete = null;
    }
  }

  TimeOfDay? startTime = isEdit ? task!.startTime : null;
  TimeOfDay? endTime = isEdit ? task!.endTime : null;
  String category = isEdit ? task!.category! : 'Health';
  String selectedTaskIconName = isEdit ? task!.icon! : 'Work';
  TextEditingController taskController =
      TextEditingController(text: isEdit ? task!.task : null);
  TextEditingController linkController =
      TextEditingController(text: isEdit ? task!.link : null);
  TextEditingController desController =
      TextEditingController(text: isEdit ? task!.description : null);
  AppModel? app = isEdit ? task!.app : null;

  // set up the button

  Widget closeButton = ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('Close'));

  Widget addButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor),
      onPressed: () {
        if (taskController.text.trim() == '') {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please enter a task')));
          return;
        }
        if (startTime == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select start time')));
          return;
        }
        if (endTime == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select end time')));
          return;
        }
        if (defaultType != null) {
          Provider.of<TaskProvider>(context, listen: false)
              .addOrEditDefaultTask(TaskModel(
                  id: isEdit ? task!.id : DateTime.now().toString(),
                  task: taskController.text.trim(),
                  link: linkController.text.trim(),
                  startTime: startTime,
                  endTime: endTime,
                  category: category,
                  description: desController.text.trim(),
                  icon: selectedTaskIconName,
                  status: 'incomplete',
                  app: app));
          Navigator.pop(context);

          return;
        }
        if (isEdit) {
          Provider.of<TaskProvider>(context, listen: false)
              .editTask(
                  task: TaskModel(
                      id: task!.id,
                      task: taskController.text.trim(),
                      link: linkController.text.trim(),
                      startTime: startTime,
                      endTime: endTime,
                      category: category,
                      date: date,
                      description: desController.text.trim(),
                      icon: selectedTaskIconName,
                      status: inComplete ?? inProgress ?? complete,
                      app: app))
              .then((val) {
            if (val) {
              Navigator.pop(context);
            }
          });
        } else {
          Provider.of<TaskProvider>(context, listen: false)
              .addTask(
                  task: TaskModel(
                      id: DateTime.now().toString(),
                      task: taskController.text.trim(),
                      link: linkController.text.trim(),
                      startTime: startTime,
                      endTime: endTime,
                      category: category,
                      date: date,
                      description: desController.text.trim(),
                      icon: selectedTaskIconName,
                      status: 'incomplete',
                      app: app))
              .then((val) {
            if (val) {
              Navigator.pop(context);
            }
          });
        }
      },
      child: Text(
        isEdit ? 'Edit' : 'Add',
        style: const TextStyle(color: Colors.white),
      ));
  // set up the AlertDialog

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isEdit ? 'Edit Task' : "Add Task"),
          content: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: taskController,
                  decoration: const InputDecoration(
                      labelText: "Task", border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  maxLines: 2,
                  controller: desController,
                  decoration: const InputDecoration(
                      labelText: "Short description",
                      border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: linkController,
                  decoration: const InputDecoration(
                      labelText: "Link realted to task",
                      border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    TextButton(
                        onPressed: () async {
                          final val = await Navigator.of(context).push(
                            showPicker(
                              showSecondSelector: true,
                              context: context,
                              value: Time(
                                  hour: startTime == null
                                      ? TimeOfDay.now().hour
                                      : startTime!.hour,
                                  minute: startTime == null
                                      ? TimeOfDay.now().minute
                                      : startTime!.minute),
                              onChange: ((val) {}),

                              // Optional onChange to receive value as DateTime
                              onChangeDateTime: (DateTime dateTime) {
                                // print(dateTime);
                                debugPrint("[debug datetime]:  $dateTime");
                              },
                            ),
                          );
                          if (val != null) {
                            //   // TimeOfDay? time = await showTimePicker(
                            //   //     context: context,
                            //   //     initialTime: endTime ?? TimeOfDay.now());
                            //   // if (time != null) {
                            startTime = TimeOfDay(
                                hour: (val as TimeOfDay).hour,
                                minute: (val).minute);
                          }
                          setState(() {});
                        },
                        child: startTime == null
                            ? const Text('Start Time')
                            : Text(DateFormat('HH:mm:ss').format(DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                startTime!.hour,
                                startTime!.minute)))),
                    const Spacer(),
                    TextButton(
                        onPressed: () async {
                          final val = await Navigator.of(context).push(
                            showPicker(
                              showSecondSelector: true,
                              context: context,
                              value: Time(
                                  hour: endTime == null
                                      ? TimeOfDay.now().hour
                                      : endTime!.hour,
                                  minute: endTime == null
                                      ? TimeOfDay.now().minute
                                      : endTime!.minute),
                              onChange: ((val) {}),
                              // Optional onChange to receive value as DateTime
                              onChangeDateTime: (DateTime dateTime) {
                                // print(dateTime);
                                debugPrint("[debug datetime]:  $dateTime");
                              },
                            ),
                          );
                          if (val != null) {
                            //   // TimeOfDay? time = await showTimePicker(
                            //   //     context: context,
                            //   //     initialTime: endTime ?? TimeOfDay.now());
                            //   // if (time != null) {
                            endTime = TimeOfDay(
                                hour: (val as TimeOfDay).hour,
                                minute: val.minute);
                          }
                          setState(() {});
                          // }
                        },
                        child: endTime == null
                            ? const Text('End Time')
                            : Text(DateFormat('HH:mm:ss').format(DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                endTime!.hour,
                                endTime!.minute)))),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text('Category:'),
                    DropdownButton<String>(
                      value: category,
                      items: <String>[
                        'Health',
                        'Studies',
                        'Money',
                        'Enjoyment',
                        'Sleep'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        category = value!;
                        setState(() {});
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                DropdownButton<String>(
                  hint: const Text('Select a Task Icon'),
                  value: selectedTaskIconName,
                  items: taskIcons.map((taskIcon) {
                    final iconName = taskIcon.keys.first;
                    return DropdownMenuItem<String>(
                      value: iconName,
                      child: Row(
                        children: [
                          Icon(taskIcon[iconName], size: 24),
                          const SizedBox(width: 8),
                          Text(iconName),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTaskIconName = newValue!;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () async {
                      AppModel? appData = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DeviceAppScreen()));
                      if (appData != null) {
                        app = appData;
                        setState(() {});
                      }
                    },
                    child: Text(app == null ? 'Add app' : 'Edit app')),
                if (app != null)
                  Column(
                    children: [
                      const Divider(),
                      ListTile(
                        leading: Image.memory(height: 45, app!.icon!),
                        title: Text(app!.name!),
                        trailing: IconButton(
                            onPressed: () {
                              app = null;
                              setState(() {});
                            },
                            icon: const Icon(Icons.close)),
                      ),
                      const Divider()
                    ],
                  ),
                if (isEdit)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          inComplete = 'incomplete';
                          inProgress = null;
                          complete = null;
                          setState(() {});
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red,
                              border: inComplete != null ? Border.all() : null),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          inComplete = null;
                          inProgress = 'pending';
                          complete = null;
                          setState(() {});
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow,
                              border: inProgress != null ? Border.all() : null),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          inComplete = null;
                          inProgress = null;
                          complete = 'completed';
                          setState(() {});
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                              border: complete != null ? Border.all() : null),
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
          actions: [
            closeButton,
            addButton,
          ],
        ),
      );
    },
  );
}
