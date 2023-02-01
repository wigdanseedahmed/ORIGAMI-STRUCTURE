import 'package:origami_structure/imports.dart';

class ProjectCardWS extends StatelessWidget {
  final String? projectTitle;
  final String? projectDescription;
  final String? projectStartDateTime;
  final String? projectDueDateTime;
  final String? projectManager;
  final String? projectLeader;
  final String? projectCoordinator;

  final UserModel? projectManagerInfo;
  final UserModel? projectLeaderInfo;
  final UserModel? projectCoordinatorInfo;

  final int? projectTaskNumber;
  final int? projectTaskDone;
  final int? projectTaskUnDone;
  final double? projectProgressPercentage;
  final double? totalProjectMembers;

  final Color? colour;

  const ProjectCardWS({
    Key? key,
    this.projectTitle,
    this.projectDescription,
    this.projectDueDateTime,
    this.projectTaskNumber,
    this.projectProgressPercentage,
    this.colour,
    this.projectManager,
    this.projectLeader,
    this.projectCoordinator,
    this.totalProjectMembers,
    this.projectManagerInfo,
    this.projectLeaderInfo,
    this.projectCoordinatorInfo,
    this.projectTaskDone,
    this.projectTaskUnDone,
    this.projectStartDateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 650),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.only(top: 18.0, bottom: 18.0, left: 18.0, right: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 8,
                    backgroundColor: colour,
                  ),
                  const SizedBox(width: 8),
                  AutoSizeText(
                    projectTitle!,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      fontFamily: "SF",
                    ),
                    maxLines: 3,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    projectStartDateTime == null
                        ? "Unknown"
                        : DateFormat("EEE, MMM d, yyyy").format(
                        DateTime.parse(projectStartDateTime!)),
                    style: TextStyle(
                      fontSize: 12,
                      color: colour,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    " ~ ",
                    style: TextStyle(
                      fontSize: 12,
                      color: colour,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    projectDueDateTime == null
                        ? "Unknown"
                        : DateFormat("EEE, MMM d, yyyy")
                        .format(DateTime.parse(projectDueDateTime!)),
                    style: TextStyle(
                      fontSize: 12,
                      color: colour,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(
                      width: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 18,
                          ),
                          Text(
                            "Members",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[500],
                            ),
                          ),
                          SizedBox(
                            width:
                            MediaQuery.of(context).size.width * 0.6,
                            child: Row(
                              children: <Widget>[
                                projectManager == null
                                    ? Container()
                                    : projectManagerInfo!.userPhotoFile ==
                                    null
                                    ? Padding(
                                  padding:
                                  const EdgeInsets.all(3.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(
                                          20.0),
                                      color:
                                      const Color.fromRGBO(
                                          202, 202, 202, 1),
                                    ),
                                    width: 40.0,
                                    height: 40.0,
                                    child: Center(
                                      child: Text(
                                        "${projectManagerInfo!.firstName![0]}${projectManagerInfo!.lastName![0]}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight:
                                          FontWeight.bold,
                                          color: Color.fromRGBO(
                                              76, 75, 75, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                    : Padding(
                                  padding:
                                  const EdgeInsets.all(3.0),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                    MemoryImage(
                                        base64Decode(
                                          projectManagerInfo!
                                              .userPhotoFile!,
                                        )),
                                  ),
                                ),
                                projectLeader == null
                                    ? Container()
                                    : projectLeaderInfo!.userPhotoFile ==
                                    null
                                    ? Padding(
                                  padding:
                                  const EdgeInsets.all(3.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(
                                          20.0),
                                      color:
                                      const Color.fromRGBO(
                                          202, 202, 202, 1),
                                    ),
                                    width: 40.0,
                                    height: 40.0,
                                    child: Center(
                                      child: Text(
                                        "${projectLeaderInfo!.firstName![0]}${projectLeaderInfo!.lastName![0]}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight:
                                          FontWeight.bold,
                                          color: Color.fromRGBO(
                                              76, 75, 75, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                    : Padding(
                                  padding:
                                  const EdgeInsets.all(3.0),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage:
                                    MemoryImage(
                                        base64Decode(
                                          projectLeaderInfo!
                                              .userPhotoFile!,
                                        )),
                                  ),
                                ),
                                projectCoordinator == null
                                    ? Container()
                                    : projectCoordinatorInfo!
                                    .userPhotoFile ==
                                    null
                                    ? Padding(
                                  padding:
                                  const EdgeInsets.all(3.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(
                                          20.0),
                                      color:
                                      const Color.fromRGBO(
                                          202, 202, 202, 1),
                                    ),
                                    width: 40.0,
                                    height: 40.0,
                                    child: Center(
                                      child: Text(
                                        "${projectCoordinatorInfo!.firstName![0]}${projectCoordinatorInfo!.lastName![0]}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight:
                                          FontWeight.bold,
                                          color: Color.fromRGBO(
                                              76, 75, 75, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                    : Padding(
                                  padding:
                                  const EdgeInsets.all(3.0),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: MemoryImage(
                                        base64Decode(
                                            projectCoordinatorInfo!
                                                .userPhotoFile!)),
                                  ),
                                ),
                                totalProjectMembers == null
                                    ? Container()
                                    : Padding(
                                  padding:
                                  const EdgeInsets.all(3.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(
                                          20.0),
                                      color: const Color.fromRGBO(
                                          202, 202, 202, 1),
                                    ),
                                    width: 40.0,
                                    height: 40.0,
                                    child: Center(
                                      child: Text(
                                        "+${totalProjectMembers!.toInt()}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight:
                                          FontWeight.bold,
                                          color: Color.fromRGBO(
                                              76, 75, 75, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 14,
                          ),
                          Text(
                            "Task",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 15),
                          _RichText(
                              value1: "$projectTaskNumber ",
                              value2: "Task"),
                          const SizedBox(height: 3),
                          _RichText(
                              value1: "$projectTaskDone ",
                              value2: "Done Task"),
                          const SizedBox(height: 3),
                          _RichText(
                              value1: "$projectTaskUnDone ",
                              value2: "Undone Task"),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: CircularPercentIndicator(
                      radius: 90,
                      lineWidth: 15,
                      percent: projectProgressPercentage! / 100,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${(projectProgressPercentage!.toStringAsFixed(2))}%",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            "Completed",
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 15),
                          ),
                        ],
                      ),
                      progressColor: colour,
                      backgroundColor:
                      DynamicTheme.of(context)?.brightness ==
                          Brightness.light
                          ? Colors.grey.shade100
                          : Colors.grey.shade900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* -----------------------------> COMPONENTS <------------------------------ */
class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({
    required this.percent,
    required this.center,
    Key? key,
  }) : super(key: key);

  final double percent;
  final Widget center;

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 55,
      lineWidth: 2.0,
      percent: percent,
      center: center,
      circularStrokeCap: CircularStrokeCap.round,
      backgroundColor: Colors.blueGrey,
      progressColor: Theme.of(Get.context!).primaryColor,
    );
  }
}

class _ProfileImage extends StatelessWidget {
  const _ProfileImage(
      {required this.image,
      Key? key,
      required this.firstName,
      required this.lastName})
      : super(key: key);

  final String? firstName;
  final String? lastName;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return image == null
        ? Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(202, 202, 202, 1),
              borderRadius: BorderRadius.all(
                  Radius.circular(MediaQuery.of(context).size.width * 0.2)),
            ),
            child: Center(
              child: Text(
                "${firstName![0]}${lastName![0]}",
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.1,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromRGBO(76, 75, 75, 1),
                ),
              ),
            ),
          )
        : CircleAvatar(
            backgroundImage: MemoryImage(
              base64Decode(image!),
            ),
            radius: 20,
            backgroundColor: Colors.white,
          );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText(this.data, {Key? key}) : super(key: key);

  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(
      data.capitalize!,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color.fromRGBO(255, 255, 255, 1),
        letterSpacing: 0.8,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _SubtitleText extends StatelessWidget {
  const _SubtitleText(this.data, {Key? key}) : super(key: key);

  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      style: const TextStyle(
          fontSize: 11, color: Color.fromRGBO(170, 170, 170, 1)),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _ReleaseTimeText extends StatelessWidget {
  const _ReleaseTimeText(this.date, {Key? key}) : super(key: key);

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(74, 177, 120, 1),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
      child: Text(
        DateFormat.yMMMd().format(date),
        style: const TextStyle(fontSize: 9, color: Colors.white),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _RichText extends StatelessWidget {
  const _RichText({
    required this.value1,
    required this.value2,
    Key? key,
  }) : super(key: key);

  final String value1;
  final String value2;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: DynamicTheme.of(context)?.brightness == Brightness.light
              ? Colors.black
              : Colors.white,
        ),
        children: [
          TextSpan(
            text: value1,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: DynamicTheme.of(context)?.brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
          ),
          TextSpan(
            text: value2,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: DynamicTheme.of(context)?.brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
