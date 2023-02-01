import 'package:origami_structure/imports.dart';

class ProjectDetailCardMA extends StatelessWidget {
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

  const ProjectDetailCardMA({
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
    this.projectCoordinatorInfo, this.projectTaskDone, this.projectTaskUnDone, this.projectStartDateTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(left: 8.0, right: 8.0, top: 12.0, bottom: 12.0),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Card(
            elevation: 0.0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8),
              child: ListTile(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 8,
                          backgroundColor: colour,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          projectTitle!,
                          style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              fontFamily: "SF"),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
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
                              : DateFormat("EEE, MMM d, yyyy").format(
                              DateTime.parse(projectDueDateTime!)),
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
                          padding: const EdgeInsets.all(10.0),
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
                                  width: MediaQuery.of(context).size.width * 0.7,
                                  child: Row(
                                    children: <Widget>[
                                      projectManager == null
                                          ? Container()
                                          : projectManagerInfo!.userPhotoFile == null
                                              ? Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(20.0),
                                                      color: const Color.fromRGBO(
                                                          202, 202, 202, 1),
                                                    ),
                                                    width: 40.0,
                                                    height: 40.0,
                                                    child: Center(
                                                      child: Text(
                                                        "${projectManagerInfo!.firstName![0]}${projectManagerInfo!.lastName![0]}",
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color.fromRGBO(
                                                              76, 75, 75, 1),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              )
                                              : Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: MemoryImage(
                                                      base64Decode(projectManagerInfo!.userPhotoFile!,)
                                                  ),
                                                ),
                                              ),
                                      projectLeader == null
                                          ? Container()
                                          : projectLeaderInfo!.userPhotoFile == null
                                              ? Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(20.0),
                                                      color: const Color.fromRGBO(
                                                          202, 202, 202, 1),
                                                    ),
                                                    width: 40.0,
                                                    height: 40.0,
                                                    child: Center(
                                                      child: Text(
                                                        "${projectLeaderInfo!.firstName![0]}${projectLeaderInfo!.lastName![0]}",
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color.fromRGBO(
                                                              76, 75, 75, 1),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              )
                                              : Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: CircleAvatar(
                                          radius: 20,
                                          backgroundImage: MemoryImage(
                                              base64Decode(projectLeaderInfo!.userPhotoFile!,)
                                          ),
                                        ),
                                      ),
                                      projectCoordinator == null
                                          ? Container()
                                          : projectCoordinatorInfo!.userPhotoFile == null
                                              ? Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(20.0),
                                                      color: const Color.fromRGBO(
                                                          202, 202, 202, 1),
                                                    ),
                                                    width: 40.0,
                                                    height: 40.0,
                                                    child: Center(
                                                      child: Text(
                                                        "${projectCoordinatorInfo!.firstName![0]}${projectCoordinatorInfo!.lastName![0]}",
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,
                                                          color: Color.fromRGBO(
                                                              76, 75, 75, 1),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              )
                                              : Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundImage: MemoryImage(
                                                      base64Decode(projectCoordinatorInfo!.userPhotoFile!)
                                                  ),
                                                  ),
                                              ),
                                      totalProjectMembers == null
                                          ? Container()
                                          : Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20.0),
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
                                                      fontWeight: FontWeight.bold,
                                                      color:
                                                          Color.fromRGBO(76, 75, 75, 1),
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
                                _RichText(value1: "$projectTaskNumber ", value2: "Task"),
                                const SizedBox(height: 3),
                                _RichText(value1: "$projectTaskDone ", value2: "Done Task"),
                                const SizedBox(height: 3),
                                _RichText(value1: "$projectTaskUnDone ", value2: "Undone Task"),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          child: CircularPercentIndicator(
                            radius: 85,
                            lineWidth: 15,
                            percent: projectProgressPercentage! / 100,
                            circularStrokeCap: CircularStrokeCap.round,
                            center: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${(projectProgressPercentage!.toStringAsFixed(2))}%",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  "Completed",
                                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 15),
                                ),
                              ],
                            ),
                            progressColor: colour,
                            backgroundColor: DynamicTheme.of(context)?.brightness ==
                                Brightness.light
                                ? Colors.grey.shade100 : Colors.grey.shade900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
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
              ? Colors.black: Colors.white,
        ),
        children: [
          TextSpan(text: value1,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: DynamicTheme.of(context)?.brightness == Brightness.light
                    ? Colors.black: Colors.white,
              ),
          ),
          TextSpan(
            text: value2,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: DynamicTheme.of(context)?.brightness == Brightness.light
                  ? Colors.black: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
