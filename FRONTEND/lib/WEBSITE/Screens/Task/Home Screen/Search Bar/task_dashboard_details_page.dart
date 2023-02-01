import 'package:origami_structure/imports.dart';

class TaskDashboardDetailScreen extends StatelessWidget {
  final TaskModel task;

  const TaskDashboardDetailScreen({
    Key? key,
    required this.task,
  }) : super(key: key);

  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      if (kDebugMode) {
        print('Error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.projectName!),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 16.0,
            ),
            const SizedBox(
              height: 22.0,
            ),
            Text(
              task.taskName!,
              style: const TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: 12.0,
            ),
            Row(
              children: [
                Icon(
                  Icons.access_time_sharp,
                  size: 15,
                  color: Colors.blueGrey[300],
                ),
                const SizedBox(width: 3),
                Text(
                  'Start: ${task.startDate}',
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey[300],
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.circle,
                  size: 5,
                  color: Colors.blueGrey[300],
                ),
                const SizedBox(width: 8),
                Text(
                  'Start: ${task.startDate}',
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey[300],
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            const SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'email',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.left,
                ),
                IconButton(
                  onPressed: () {
                    //customLaunch('mailto:${user.email}?subject=Contact%20Information&body=Type%20your%20mail%20here');
                  },
                  icon: const Icon(
                    Icons.email,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12.0,
            ),
            const Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding:  EdgeInsets.only(
                      left: 12.0, right: 12.0, bottom: 20.0),
                  child: Text(
                    "user.profile",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
