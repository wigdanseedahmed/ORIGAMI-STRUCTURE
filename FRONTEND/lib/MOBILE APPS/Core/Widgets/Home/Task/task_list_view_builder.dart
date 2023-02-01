import 'package:origami_structure/imports.dart';

class TaskListViewBuilder extends StatelessWidget {

  final String taskTitle;
  final String taskDescription;
  final String taskDueDateTime;
  final String taskStatus;
  final double taskProgressPercentage;
  final List<String> taskAssignedTo;
  final Color taskColour;

  final int itemCount;

  final NavigationMenu navigationMenu;

  const TaskListViewBuilder({
    Key? key,
    required this.taskTitle,
    required this.taskDescription,
    required this.taskDueDateTime,
    required this.taskStatus,
    required this.itemCount,
    required this.taskColour,
    required this.navigationMenu,
    required this.taskAssignedTo, required this.taskProgressPercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0.5, vertical: 0.5),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) {
          return TaskCardMA(
            taskTitle: taskTitle,
            taskProjectName: taskDescription,
            taskDueDateTime: taskDueDateTime,
            colour: taskColour,
            taskStatus: taskStatus, navigationMenu: navigationMenu,
            taskAssignedTo: taskAssignedTo,
            taskProgressPercentage: taskProgressPercentage,

          );
        },
      ),
    );
  }
}