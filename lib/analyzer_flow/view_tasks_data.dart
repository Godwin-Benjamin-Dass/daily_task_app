import 'package:daily_task_app/models/task_model.dart';
import 'package:daily_task_app/widgets/task_tile_widget.dart';
import 'package:flutter/material.dart';

class ViewTasksData extends StatefulWidget {
  const ViewTasksData({super.key, required this.tasks});
  final List<TaskModel> tasks;

  @override
  State<ViewTasksData> createState() => _ViewTasksDataState();
}

class _ViewTasksDataState extends State<ViewTasksData> {
  @override
  void initState() {
    super.initState();
    setData();
  }

  setData() {
    inComplete =
        widget.tasks.where((ele) => ele.status == 'incomplete').toList();
    inProgress = widget.tasks.where((ele) => ele.status == 'pending').toList();
    completed = widget.tasks.where((ele) => ele.status == 'completed').toList();
    setState(() {});
  }

  List<TaskModel> inComplete = [];
  List<TaskModel> inProgress = [];
  List<TaskModel> completed = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
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
            'Status',
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: <Widget>[
              Tab(
                text: 'Incompleted',
              ),
              Tab(
                text: 'Pending',
              ),
              Tab(
                text: 'Completed',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            inComplete.isEmpty
                ? const Center(
                    child: Text('No Incompleted Tasks'),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: inComplete.length,
                    itemBuilder: (ctx, i) {
                      return TaskTileWidget(
                          isAnalyseTask: true,
                          idx: i + 1,
                          task: inComplete[i],
                          ontap: () {});
                    }),
            inProgress.isEmpty
                ? const Center(
                    child: Text('No Task Inprogress'),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: inProgress.length,
                    itemBuilder: (ctx, i) {
                      return TaskTileWidget(
                          isAnalyseTask: true,
                          idx: i + 1,
                          task: inProgress[i],
                          ontap: () {});
                    }),
            completed.isEmpty
                ? const Center(
                    child: Text('No Completed Tasks'),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: completed.length,
                    itemBuilder: (ctx, i) {
                      return TaskTileWidget(
                          isAnalyseTask: true,
                          idx: i + 1,
                          task: completed[i],
                          ontap: () {});
                    }),
          ],
        ),
      ),
    );
  }
}
