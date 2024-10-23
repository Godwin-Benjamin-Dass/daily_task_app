import 'package:daily_task_app/setting_flow/add_edit_default_shedule.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
        title: const Text(
          'Schedules',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                '1. Week-day Schedule:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const Spacer(),
              SizedBox(
                  height: 36,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AddEditDefaultShedule(
                                      sheduleType: 'Week-day',
                                    )));
                      },
                      child: const Text(
                        'Add/Edit Schedule',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      )))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const Text(
                '2. Week-end Schedule:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const Spacer(),
              SizedBox(
                height: 36,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddEditDefaultShedule(
                                    sheduleType: 'Week-end',
                                  )));
                    },
                    child: const Text(
                      'Add/Edit Schedule',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    )),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
