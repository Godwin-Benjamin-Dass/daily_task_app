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
          '$type :',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              decoration: TextDecoration.underline),
        ),
        SizedBox(
          height: 8,
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
                width: 25,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Pending - ',
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
                      Text(
                        pending.toString(),
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text(
                        'In Progress - ',
                        style: TextStyle(fontSize: 16, color: Colors.amber),
                      ),
                      Text(
                        inProgress.toString(),
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Completed - ',
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                      Text(
                        completed.toString(),
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        pending > 0 || inProgress > 0 || completed > 0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: ontap,
                      child: Text(
                        'View Tasks >>',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w700),
                      )),
                ],
              )
            : SizedBox()
      ],
    );
  }
}
