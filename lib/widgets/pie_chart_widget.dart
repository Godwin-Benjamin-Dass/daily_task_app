import 'package:easy_pie_chart/easy_pie_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatelessWidget {
  const PieChartWidget({
    super.key,
    required this.pending,
    required this.inProgress,
    required this.completed,
    required this.type,
    required this.ontap,
  });
  final String type;
  final int pending;
  final int inProgress;
  final int completed;
  final Function() ontap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$type: ',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              if (pending == 0 && inProgress == 0 && completed == 0)
                EasyPieChart(
                  showValue: false,
                  children: [
                    PieData(value: 1, color: Colors.grey),
                  ],
                  borderEdge: StrokeCap.butt,
                  pieType: PieType.fill,
                  onTap: (index) {},
                  gap: 0.02,
                  start: 0,
                  size: 130,
                ),
              if (pending != 0 || inProgress != 0 || completed != 0)
                EasyPieChart(
                  children: [
                    PieData(value: pending.toDouble(), color: Colors.red),
                    PieData(value: inProgress.toDouble(), color: Colors.yellow),
                    PieData(value: completed.toDouble(), color: Colors.green),
                  ],
                  borderEdge: StrokeCap.butt,
                  pieType: PieType.fill,
                  onTap: (index) {},
                  gap: 0.02,
                  start: 0,
                  size: 130,
                ),
              const SizedBox(
                width: 15,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Pending: ',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                      Text(
                        pending.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text(
                        'In progress: ',
                        style: TextStyle(fontSize: 16, color: Colors.yellow),
                      ),
                      Text(
                        inProgress.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Completed: ',
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                      Text(
                        completed.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Center(
            child: ElevatedButton(
                onPressed: ontap, child: const Text('View Tasks')))
      ],
    );
  }
}
