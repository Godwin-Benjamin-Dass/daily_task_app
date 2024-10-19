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
  String category = 'Particular Date';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Analyzer',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 0.2, color: Colors.white54),
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  child: DropdownButton<String>(
                    value: category,
                    items: <String>["Particular Date", "Particular Range"]
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      category = value!;
                      setState(() {});
                    },
                    underline: SizedBox(),
                    dropdownColor: Theme.of(context).primaryColor,
                    iconEnabledColor: Colors.white54,
                  ),
                )),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
            Text(
              category == "Particular Date"
                  ? 'Select Particular Date '
                  : 'Select Particular Range ',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            const SizedBox(
              height: 40,
            ),
            CircleAvatar(
              minRadius: 92,
              child: GestureDetector(
                  onTap: () async {
                    if (category == "Particular Date") {
                      DateTime? date = await showDatePicker(
                          context: context,
                          firstDate: DateTime(1991),
                          lastDate: DateTime(2100));
                      if (date != null) {
                        particularDate = date;
                        setState(() {});
                      }
                    } else {
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
                    }
                  },
                  child: Icon(
                    category == "Particular Date"
                        ? Icons.date_range_outlined
                        : Icons.calendar_month_outlined,
                    size: 140,
                    color: Theme.of(context).primaryColor,
                  )),
            ),
            SizedBox(
                height: particularDate != null ||
                        (startDate != null && endDate != null)
                    ? 30
                    : 0),
            Text(
              particularDate != null && category == "Particular Date"
                  ? DateFormat("dd MMM yy").format(particularDate!)
                  : startDate != null &&
                          endDate != null &&
                          category != "Particular Date"
                      ? '${DateFormat("dd MMM yy").format(startDate!)} - ${DateFormat("dd MMM yy").format(endDate!)}'
                      : ' ',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 15),
            Center(
              child: SizedBox(
                height: 35,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        backgroundColor: Theme.of(context).primaryColor),
                    onPressed: () {
                      if (category == "Particular Date") {
                        if (particularDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please Select a Date'),
                              backgroundColor: Colors.red,
                            ),
                          );
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
                      } else {
                        if (startDate == null || endDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please Select a Date Range')));
                          return;
                        }

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AnalyzerScreen(
                                      startDate: startDate!,
                                      endDate: endDate!,
                                    )));
                      }
                    },
                    child: const Text(
                      'Analyze',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
