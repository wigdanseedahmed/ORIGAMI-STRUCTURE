import 'package:origami_structure/imports.dart';

class TaskCardWS extends StatelessWidget {
  const TaskCardWS({
    Key? key,
    required this.taskData,
    required this.allUserData,
    required this.onTap,
    required this.onPressedMore,
    required this.onPressedTask,
    required this.onPressedContributors,
    required this.onPressedComments,
  }) : super(key: key);

  final TaskModel taskData;
  final List<UserModel> allUserData;

  final Function() onTap;

  final Function() onPressedMore;
  final Function() onPressedTask;
  final Function() onPressedContributors;
  final Function() onPressedComments;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: _Tile(
                  dotColor: taskData.criticalityColour == null
                      ? Colors.transparent
                      : labelColours![taskData.criticalityColour!],
                  title: taskData.taskName!,
                  subtitle: taskData.deadlineDate == null
                      ? ""
                      : (DateTime.parse(taskData.deadlineDate!)
                                  .difference(DateTime.now())
                                  .inDays <
                              0)
                          ? "Late ${(DateTime.parse(taskData.deadlineDate!).difference(DateTime.now()).inDays) * -1} days"
                          : "Due ${DateTime.parse(taskData.deadlineDate!).difference(DateTime.now()).inDays > 0 ? "in ${(DateTime.parse(taskData.deadlineDate!).difference(DateTime.now()).inDays)} days" : "today"}",
                  onPressedMore: onPressedMore,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: taskData.status == null
                            ? Colors.transparent
                            : statusColours![taskData.status! == "Todo"
                                ? 0
                                : taskData.status! == "On Hold"
                                    ? 1
                                    : taskData.status! == "In Progress"
                                        ? 2
                                        : taskData.status! == "Done"
                                            ? 3
                                            : 4],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: onPressedTask,
                      child: Text(
                        taskData.status!,
                      ),
                    ),
                    taskData.assignedTo == null
                        ? Container()
                        : ListProfileImageWS(
                      allUserData: allUserData,
                            assignedTo: taskData.assignedTo == null
                                ? []
                                : taskData.assignedTo!,
                            onPressed: onPressedContributors,
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxWidth: 300),
                      child: LinearPercentIndicator(
                        //leaner progress bar
                        animation: true,
                        animationDuration: 1000,
                        lineHeight: 16.0,
                        percent: taskData.percentageDone == null
                            ? 0
                            : taskData.percentageDone! / 100,
                        backgroundColor: statusColours![taskData.status! == "Todo"
                            ? 0
                            : taskData.status! == "On Hold"
                            ? 1
                            : taskData.status! == "In Progress"
                            ? 2
                            : taskData.status! == "Done"
                            ? 3
                            : 4].withOpacity(0.1),
                        progressColor: statusColours![taskData.status! == "Todo"
                            ? 0
                            : taskData.status! == "On Hold"
                                ? 1
                                : taskData.status! == "In Progress"
                                    ? 2
                                    : taskData.status! == "Done"
                                        ? 3
                                        : 4],
                        barRadius: const Radius.circular(16),
                        center: Text(
                          taskData.percentageDone == null
                              ? "0.0%"
                              : "${taskData.percentageDone}%",
                          style: const TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    /*const SizedBox(width:10),
                          _IconButton(
                            iconData: EvaIcons.peopleOutline,
                            onPressed:(){},
                            totalContributors: taskAssignedTo!.length,
                          ),*/
                  ],
                ),
              ),
              const SizedBox(height: 10),
              /*Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    _IconButton(
                      iconData: EvaIcons.messageCircleOutline,
                      onPressed: onPressedComments,
                      totalContributors: taskData.comments == null
                          ? 0
                          : taskData.comments!.length,
                    ),
                    const SizedBox(width: 10),
                    _IconButton(
                      iconData: EvaIcons.peopleOutline,
                      onPressed: onPressedContributors,
                      totalContributors: taskData.assignedTo!.length,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),*/
            ],
          ),
        ),
      ),
    );
  }
}

/* -----------------------------> COMPONENTS <------------------------------ */
class _Tile extends StatelessWidget {
  const _Tile({
    required this.dotColor,
    required this.title,
    required this.subtitle,
    required this.onPressedMore,
    Key? key,
  }) : super(key: key);

  final Color dotColor;
  final String title;
  final String subtitle;
  final Function() onPressedMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _dot(dotColor),
              const SizedBox(width: 8),
              Expanded(child: _title(title)),
              _moreButton(onPressed: onPressedMore),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _subtitle(subtitle),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _dot(Color color) {
    return CircleAvatar(
      radius: 4,
      backgroundColor: color,
    );
  }

  Widget _title(String data) {
    return Text(
      data,
      textAlign: TextAlign.left,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _subtitle(String data) {
    return Text(
      data,
      // style: Theme.of(Get.context!).textTheme.caption,
      textAlign: TextAlign.left,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _moreButton({required Function() onPressed}) {
    return IconButton(
      iconSize: 20,
      onPressed: onPressed,
      icon: const Icon(Icons.more_vert_rounded),
      splashRadius: 20,
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.iconData,
    required this.totalContributors,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final IconData iconData;
  final int totalContributors;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: onPressed,
      icon: _icon(iconData),
      label: _label("$totalContributors"),
    );
  }

  Widget _label(String data) {
    return Text(
      data,
      style: const TextStyle(
        color: Colors.white54,
        fontSize: 10,
      ),
    );
  }

  Widget _icon(IconData iconData) {
    return Icon(
      iconData,
      color: Colors.white54,
      size: 14,
    );
  }
}
