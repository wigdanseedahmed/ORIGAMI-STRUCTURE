import 'package:origami_structure/imports.dart';

class HomeProjectCard extends StatefulWidget {
  const HomeProjectCard({
    Key? key,
    this.projectTitle,
    this.projectProgressPercentage,
    this.projectTaskNumber,
    this.colour,
    this.selectedProject,
    this.projectManager,
    this.projectLeader,
    this.projectCoordinator,
    this.totalProjectMembers,
    this.projectManagerInfo,
    this.projectLeaderInfo,
    this.projectCoordinatorInfo,
  }) : super(key: key);

  final String? projectTitle;
  final String? projectManager;
  final String? projectLeader;
  final String? projectCoordinator;
  final UserModel? projectManagerInfo;
  final UserModel? projectLeaderInfo;
  final UserModel? projectCoordinatorInfo;
  final double? projectProgressPercentage;
  final double? totalProjectMembers;
  final int? projectTaskNumber;
  final Color? colour;
  final ProjectModel? selectedProject;

  @override
  State<HomeProjectCard> createState() => _HomeProjectCardState();
}

class _HomeProjectCardState extends State<HomeProjectCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectBoardScreenMA(
                selectedProject: widget.selectedProject,
                  navigationMenu: NavigationMenu.dashboardScreen,
              ),
            ),
          );
        },
        child: Card(
          color: DynamicTheme.of(context)?.brightness == Brightness.light
              ? Colors.white
              : Colors.grey.shade800,
          shadowColor: widget.colour,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0.5,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            height: MediaQuery.of(context).size.height * 0.25,
            width: MediaQuery.of(context).size.width * 0.4,
            // width: 260,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    color: widget.colour,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "${widget.projectTaskNumber} tasks",
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 5,
                ),
                Expanded(
                  child: Text(
                    widget.projectTitle!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Row(
                    children: <Widget>[
                      widget.projectManager == null
                          ? Container()
                          : widget.projectManagerInfo!.userPhotoURL == null
                              ? Padding(
                                padding: const EdgeInsets.all(0.5),
                                child: Container(
                                    height: 30.0,
                                    width: 30.0,
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(202, 202, 202, 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20.0)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "${widget.projectManagerInfo!.firstName![0]}${widget.projectManagerInfo!.lastName![0]}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(76, 75, 75, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                              )
                              : Padding(
                                padding: const EdgeInsets.all(0.5),
                                child: CircleAvatar(
                                    radius: 15,
                                    backgroundImage: NetworkImage(
                                      widget.projectManagerInfo!.userPhotoURL!,
                                    ),
                                  ),
                              ),
                      widget.projectLeader == null
                          ? Container()
                          : widget.projectLeaderInfo!.userPhotoURL == null
                              ? Padding(
                                padding: const EdgeInsets.all(0.5),
                                child: Container(
                                    height: 30.0,
                                    width: 30.0,
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(202, 202, 202, 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20.0)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "${widget.projectLeaderInfo!.firstName![0]}${widget.projectLeaderInfo!.lastName![0]}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(76, 75, 75, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                              )
                              : Padding(
                                padding: const EdgeInsets.all(0.5),
                                child: CircleAvatar(
                                    radius: 15,
                                    backgroundImage: NetworkImage(
                                      widget.projectLeaderInfo!.userPhotoURL!,
                                    ),
                                  ),
                              ),
                      widget.projectCoordinator == null
                          ? Container()
                          : widget.projectCoordinatorInfo!.userPhotoURL == null
                              ? Padding(
                                padding: const EdgeInsets.all(0.5),
                                child: Container(
                                    height: 30.0,
                                    width: 30.0,
                                    decoration: const BoxDecoration(
                                      color: Color.fromRGBO(202, 202, 202, 1),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20.0)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "${widget.projectCoordinatorInfo!.firstName![0]}${widget.projectCoordinatorInfo!.lastName![0]}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(76, 75, 75, 1),
                                        ),
                                      ),
                                    ),
                                  ),
                              )
                              : Padding(
                                padding: const EdgeInsets.all(0.5),
                                child: CircleAvatar(
                                    radius: 15,
                                    backgroundImage: NetworkImage(
                                      widget
                                          .projectCoordinatorInfo!.userPhotoURL!,
                                    ),
                                  ),
                              ),
                      widget.totalProjectMembers == null
                          ? Container()
                          : Padding(
                            padding: const EdgeInsets.all(0.5),
                            child: Container(
                                height: 30.0,
                                width: 30.0,
                                decoration: const BoxDecoration(
                                  color: Color.fromRGBO(202, 202, 202, 1),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                child: Center(
                                  child: Text(
                                    "+${widget.totalProjectMembers!.toInt()}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(76, 75, 75, 1),
                                    ),
                                  ),
                                ),
                              ),
                          ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                getPercentageIndicator(
                    context, widget.projectProgressPercentage),
                const SizedBox(
                  height: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
