import 'package:daily_task_app/models/task_model.dart';
import 'package:daily_task_app/providers/task_provider.dart';
import 'package:daily_task_app/services/notification_service.dart';
import 'package:daily_task_app/static_data.dart';
import 'package:device_installed_apps/device_installed_apps.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

void openApp(String packageName, context) async {
  bool? isOpened = await DeviceInstalledApps.launchApp(packageName);
  if (!isOpened!) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Unable to open app $packageName')),
    );
  }
}

bool isValidURL(String url) {
  // Basic regex for URL validation
  final regex = RegExp(
    r'^(http|https):\/\/[^\s/$.?#].[^\s]*$',
    caseSensitive: false,
  );
  return regex.hasMatch(url);
}

class TaskTileWidget extends StatefulWidget {
  const TaskTileWidget({
    super.key,
    required this.ontap,
    required this.task,
    required this.idx,
    this.isAnalyseTask = false,
    this.isDefault = false,
    this.isNotificationPopUp = false,
  });
  final Function() ontap;
  final TaskModel task;
  final int idx;
  final bool isAnalyseTask;
  final bool isDefault;
  final bool isNotificationPopUp;

  @override
  State<TaskTileWidget> createState() => _TaskTileWidgetState();
}

class _TaskTileWidgetState extends State<TaskTileWidget> {
  bool view = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Theme.of(context).primaryColor, width: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (widget.isNotificationPopUp == false)
                    Text(
                      'Task: ${widget.idx}',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  if (widget.isNotificationPopUp == false)
                    const SizedBox(
                      width: 20,
                    ),
                  if (widget.task.category != 'Sleep')
                    Icon(
                        size: 30,
                        getIcon(widget.task.category!),
                        color: Theme.of(context).primaryColor),
                  if (widget.task.category == 'Sleep')
                    Image.asset("assets/images/sleeping_icon.png",
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                        color: Theme.of(context).primaryColor),
                  const Spacer(),
                  if (!widget.isAnalyseTask)
                    IconButton(
                      onPressed: () {
                        if (widget.isDefault) {
                          Provider.of<TaskProvider>(context, listen: false)
                              .deleteDefaultTask(widget.task.id!);
                        } else {
                          Provider.of<TaskProvider>(context, listen: false)
                              .deleteTask(id: widget.task.id!);
                        }
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    )
                ],
              ),
              const Divider(),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: Text(
                      'Activity: ${widget.task.task}',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Icon(
                              Icons.access_time_rounded,
                              color: Theme.of(context).primaryColor,
                              size: 15,
                            ),
                          ),
                          Text(
                            '${formatTimeOfDay(widget.task.startTime!)} - ${formatTimeOfDay(widget.task.endTime!)}',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      if (widget.isNotificationPopUp == true)
                        Text(
                          'Duration: ${calculateDuration(widget.task.startTime!, widget.task.endTime!)}',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      if (widget.isAnalyseTask)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 4),
                                child: Icon(
                                  Icons.calendar_month_outlined,
                                  color: Theme.of(context).primaryColor,
                                  size: 15,
                                ),
                              ),
                              Text(
                                DateFormat("dd MMM yyyy")
                                    .format(widget.task.date!),
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Spacer(),
                  if (widget.isNotificationPopUp == false)
                    Row(
                      children: [
                        Icon(
                          Icons.timer,
                          size: 18,
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          ' ${calculateDuration(widget.task.startTime!, widget.task.endTime!)}',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  IconButton(
                      onPressed: () {
                        view = !view;
                        setState(() {});
                      },
                      icon: RotatedBox(
                          quarterTurns: view ? 3 : 1,
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 20,
                          )))
                ],
              ),
              const Divider(),
              if (view)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Task Representation: ',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        children: [
                          if (widget.task.icon != 'sleeping')
                            Icon(
                                size: 25,
                                getIcon(widget.task.icon!),
                                color: Theme.of(context).primaryColor),
                          if (widget.task.icon == 'sleeping')
                            Image.asset("assets/images/sleeping_icon.png",
                                width: 25,
                                height: 25,
                                fit: BoxFit.cover,
                                color: Theme.of(context).primaryColor),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            widget.task.icon!,
                          ),
                        ],
                      ),
                    ),
                    if (widget.task.description != '')
                      Column(
                        children: [
                          const Text(
                            'Description: ',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                          Text(widget.task.description!),
                        ],
                      ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      'Link you provided: ',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    InkWell(
                        onTap: () {
                          if (isValidURL(widget.task.link!)) {
                            launchUrl(Uri.parse(widget.task.link!));
                          } else {
                            launchUrl(Uri.parse(
                                'https://www.google.co.in/search?q=${widget.task.link!}'));
                          }
                        },
                        child: Text(
                          "${widget.task.link!}(click to launch url)",
                          style: const TextStyle(color: Colors.purple),
                        )),
                    const SizedBox(
                      height: 3,
                    ),
                    if (widget.task.app != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Open app: ',
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                          ListTile(
                            onTap: () {
                              openApp(widget.task.app!.bundleId!, context);
                            },
                            leading: Image.memory(
                                height: 45, widget.task.app!.icon!),
                            title: Text(widget.task.app!.name!),
                          ),
                        ],
                      ),
                  ],
                ),
              Row(
                children: [
                  const Text(
                    'Status:  ',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    widget.task.status == 'incomplete'
                        ? "Not Yet Started"
                        : widget.task.status == 'pending'
                            ? "In Progress"
                            : "Completed",
                    style: TextStyle(
                        color: widget.task.status == 'incomplete'
                            ? Colors.red
                            : widget.task.status == 'pending'
                                ? Colors.yellow
                                : Colors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  if (!widget.isAnalyseTask)
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: SizedBox(
                        height: 34,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            onPressed: widget.ontap,
                            child: const Text(
                              'Update',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )),
                      ),
                    )
                ],
              ),
              if (widget.isNotificationPopUp)
                Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          final TaskModel taskTobeUpdated = TaskModel(
                              date: widget.task.date,
                              id: widget.task.id,
                              task: widget.task.task,
                              link: widget.task.link,
                              startTime: widget.task.startTime,
                              endTime: widget.task.endTime,
                              category: widget.task.category,
                              description: widget.task.description,
                              icon: widget.task.icon,
                              status: widget.task.status == 'incomplete'
                                  ? 'pending'
                                  : 'completed',
                              app: widget.task.app);
                          //just small space
                          Provider.of<TaskProvider>(context, listen: false)
                              .editTask(task: taskTobeUpdated);
                          if (taskTobeUpdated.status != 'completed') {
                            await NotificationService.scheduleNotification(
                                id: DateTime.parse(taskTobeUpdated.id!)
                                    .microsecond,
                                payload: taskTobeUpdated.id!,
                                scheduledTime: DateTime(
                                  taskTobeUpdated.date!.year,
                                  taskTobeUpdated.date!.month,
                                  taskTobeUpdated.date!.day,
                                  taskTobeUpdated.endTime!.hour,
                                  taskTobeUpdated.endTime!.minute,
                                ),
                                title: taskTobeUpdated.task!);
                          }
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                        },
                        child: Text(widget.task.status == 'incomplete'
                            ? 'Start Task'
                            : 'Complete task')))
            ],
          ),
        ),
      ),
    );
  }

  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour > 12 ? time.hour - 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';

    return '${hour == 0 ? 12 : hour}:$minute $period';
  }

  String calculateDuration(TimeOfDay startTime, TimeOfDay endTime) {
    final start = Duration(hours: startTime.hour, minutes: startTime.minute);
    final end = Duration(hours: endTime.hour, minutes: endTime.minute);

    // Calculate duration
    Duration duration;
    if (end < start) {
      // If end time is less than start time, it means it goes to the next day
      duration = (const Duration(hours: 24) + end) - start;
    } else {
      duration = end - start;
    }

    // Format duration to hh:min
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '$hours:${minutes.toString().padLeft(2, '0')}';
  }
}
