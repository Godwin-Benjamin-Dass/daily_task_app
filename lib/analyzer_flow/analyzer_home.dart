import 'package:daily_task_app/analyzer_flow/analyzer_screen.dart';
import 'package:flutter/material.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
import 'package:intl/intl.dart';

class AnalyzerHome extends StatefulWidget {
  const AnalyzerHome({super.key});

  @override
  State<AnalyzerHome> createState() => _AnalyzerHomeState();
}

class _AnalyzerHomeState extends State<AnalyzerHome> {
  DateTime? startDate;
  DateTime? endDate;
  DateTime? particularDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Analyzer',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  'Select date: ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      DateTime? date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1991),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        particularDate = date;
                        setState(() {});
                      }
                    },
                    child: const Text("Select date")),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            const SizedBox(height: 20),
            Text(
              particularDate != null
                  ? DateFormat("dd, MMM").format(particularDate!)
                  : '-',
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    if (particularDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please select a date')));
                      return;
                    }

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AnalyzerScreen(
                                  isParticularDay: true,
                                  startDate: particularDate!
                                      .subtract(const Duration(days: 1)),
                                  endDate: particularDate!
                                      .add(const Duration(days: 1)),
                                )));
                  },
                  child: const Text('Analyse particullar day')),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  'Select range: ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      showCustomDateRangePicker(
                        context,
                        dismissible: true,
                        minimumDate:
                            DateTime.now().subtract(const Duration(days: 30)),
                        maximumDate:
                            DateTime.now().add(const Duration(days: 60)),
                        endDate: endDate,
                        startDate: startDate,
                        backgroundColor: Colors.white,
                        primaryColor: Theme.of(context).primaryColor,
                        onApplyClick: (start, end) {
                          setState(() {
                            endDate = end;
                            startDate = start;
                            if (end.isBefore(start)) {
                              var temp = end;
                              end = start;
                              start = temp;
                            }
                          });
                        },
                        onCancelClick: () {
                          setState(() {
                            endDate = null;
                            startDate = null;
                          });
                        },
                      );
                    },
                    child: const Text("Select range")),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              '${startDate != null ? DateFormat("dd, MMM").format(startDate!) : '-'} / ${endDate != null ? DateFormat("dd, MMM").format(endDate!) : '-'}',
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    if (startDate == null || endDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please select a date range')));
                      return;
                    }

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AnalyzerScreen(
                                  startDate: startDate!,
                                  endDate: endDate!,
                                )));
                  },
                  child: const Text('Analyse Range')),
            )
          ],
        ),
      ),
    );
  }
}
