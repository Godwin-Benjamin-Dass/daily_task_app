import 'package:daily_task_app/models/task_model.dart';
import 'package:daily_task_app/providers/task_provider.dart';
import 'package:daily_task_app/static_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskTileWidget extends StatefulWidget {
  const TaskTileWidget({
    super.key,
    required this.ontap,
    required this.task,
    required this.idx,
    this.isAnalyseTask = false,
    this.isDefault = false,
  });
  final Function() ontap;
  final TaskModel task;
  final int idx;
  final bool isAnalyseTask;
  final bool isDefault;

  @override
  State<TaskTileWidget> createState() => _TaskTileWidgetState();
}

class _TaskTileWidgetState extends State<TaskTileWidget> {
  bool view = false;
  bool isValidURL(String url) {
    // Basic regex for URL validation
    final regex = RegExp(
      r'^(http|https):\/\/[^\s/$.?#].[^\s]*$',
      caseSensitive: false,
    );
    return regex.hasMatch(url);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'SI No: ${widget.idx}',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Icon(
                    size: 40,
                    getIcon(widget.task.category),
                    color: Theme.of(context).primaryColor,
                  ),
                  const Spacer(),
                  if (!widget.isAnalyseTask)
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.red, shape: BoxShape.circle),
                      child: IconButton(
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
                            Icons.close,
                            color: Colors.white,
                          )),
                    )
                ],
              ),
              const Divider(),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: Text(
                      'Task: ${widget.task.task}',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  if (widget.task.icon != 'sleeping')
                    Icon(
                      size: 30,
                      getIcon(widget.task.icon),
                      color: Colors.black,
                    ),
                  if (widget.task.icon == 'sleeping')
                    Image.asset(
                      "assets/images/sleeping_icon.png",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                ],
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start time: ${formatTimeOfDay(widget.task.startTime!)}',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'End time: ${formatTimeOfDay(widget.task.endTime!)}',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      if (widget.isAnalyseTask)
                        Text(
                          'Date: ${DateFormat("dd, MMM, yy").format(widget.task.date!)}',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                    ],
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    ' Duration: ${calculateDuration(widget.task.startTime!, widget.task.endTime!)}',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
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
                      'Description: ',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                    Text(widget.task.description!),
                    const Text(
                      'Link you provided: ',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
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
                    if (widget.task.category == 'Wealth')
                      Column(
                        children: [
                          const Divider(),
                          InkWell(
                              onTap: () {
                                launchUrl(Uri.parse(
                                    'https://play.google.com/store/apps/details?id=com.google.android.apps.nbu.paisa.user&hl=en_IN'));
                              },
                              child: const Text(
                                "Open Google Pay",
                                style: TextStyle(color: Colors.purple),
                              )),
                        ],
                      )
                  ],
                ),
              Row(
                children: [
                  const Text(
                    'Status',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.task.status == 'incomplete'
                            ? Colors.red
                            : widget.task.status == 'pending'
                                ? Colors.yellow
                                : Colors.green,
                        border: Border.all()),
                  ),
                  const Spacer(),
                  if (!widget.isAnalyseTask)
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor),
                        onPressed: widget.ontap,
                        child: const Text(
                          'Update',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ))
                ],
              ),
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
