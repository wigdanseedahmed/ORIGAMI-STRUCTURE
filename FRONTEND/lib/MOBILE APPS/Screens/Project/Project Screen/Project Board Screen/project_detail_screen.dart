import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

// ignore: import_of_legacy_library_into_null_safe
import 'package:unicorndial/unicorndial.dart';

class ProjectDetailScreenMA extends StatefulWidget {
  static const String id = 'project_board_detail_screen';

  final ProjectModel? selectedProject;
  final NavigationMenu navigationMenu;

  const ProjectDetailScreenMA({
    Key? key,
    this.selectedProject,
    required this.navigationMenu,
  }) : super(key: key);

  @override
  _ProjectDetailScreenMAState createState() => _ProjectDetailScreenMAState();
}

class _ProjectDetailScreenMAState extends State<ProjectDetailScreenMA>
    with TickerProviderStateMixin {
  ///VARIABLES USED TO RETRIEVE AND FILTER THROUGH DATA FROM BACKEND

  late String? typeOfIntervention = "";

  TextEditingController taskSearchBarTextEditingController =
      TextEditingController();

  /// VARIABLES USED TO DETERMINE SCREEN SIZE
  late ScrollController _scrollController;

  /// VARIABLES USED TO RETRIEVE AND FILTER THROUGH PROJECT MAP LOCATION FROM BACKEND
  late AnimationController _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 750));
  late CurvedAnimation _animation =
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
  late MapZoomPanBehavior _zoomPanBehavior =
      MapZoomPanBehavior(minZoomLevel: 6.0);

  /// VARIABLES USED FOR FLOATING APP BAR
  late String? selectedMenuItem = "General Information";

  /// VARIABLES FOR PROJECT
  ProjectModel readJsonFileContent = ProjectModel();

  Future<ProjectModel> readProjectInformationJsonData() async {
    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(
        "${AppUrl.getProjectByProjectName}${widget.selectedProject!.projectName}");

    /// Create Request to get data and response to read data
    final response = await http.get(
      uri,
      headers: {
        //"Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        // Required for CORS support to work
        //"Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Content-Type, Access-Control-Allow-Origin, Accept",
        "Access-Control-Allow-Methods": "POST, DELETE, GET, PUT"
      },
    );
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      readJsonFileContent = projectModelFromJson(response.body)
          .where((element) =>
              element.projectName == widget.selectedProject!.projectName)
          .toList()[0];
      // print("ALL  tasks: ${readProjectsJsonFileContent}");

      return readJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  @override
  void initState() {
    readProjectInformationJsonData();

    /// VARIABLES USED FORT MAP LOCATION
    _zoomPanBehavior = MapZoomPanBehavior(minZoomLevel: 6.0);
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 750));
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.repeat(min: 0.15, max: 1.0, reverse: true);

    super.initState();
  }

  @override
  dispose() {
    _controller.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    /// VARIABLES USED FOR FLOATING APP BAR
    var childButtons = <UnicornButton>[];

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelBackgroundColor: Colors.transparent,
        labelHasShadow: false,
        labelText: "General Information",
        currentButton: FloatingActionButton(
          elevation: 0.0,
          heroTag: "General Information",
          backgroundColor: primaryColour,
          mini: true,
          child: const Icon(Icons.library_books_outlined),
          onPressed: () {
            setState(() {
              selectedMenuItem = "General Information";
            });
          },
        ),
      ),
    );

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelBackgroundColor: Colors.transparent,
        labelHasShadow: false,
        labelText: "Location",
        currentButton: FloatingActionButton(
          elevation: 0.0,
          heroTag: "Location",
          backgroundColor: primaryColour,
          mini: true,
          child: const Icon(Icons.location_on_outlined),
          onPressed: () {
            setState(() {
              selectedMenuItem = "Location";
            });
          },
        ),
      ),
    );

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelBackgroundColor: Colors.transparent,
        labelHasShadow: false,
        labelText: "Skills Required",
        currentButton: FloatingActionButton(
          elevation: 0.0,
          heroTag: "Skills Required",
          backgroundColor: primaryColour,
          mini: true,
          onPressed: () {
            setState(() {
              selectedMenuItem = "Skills Required";
            });
          },
          child: Image.asset("assets/icons/skills_required.png",
              color: Colors.white, width: 30.0),
        ),
      ),
    );

    if (widget.selectedProject!.status != "Suggested") {
      childButtons.add(
        UnicornButton(
          hasLabel: true,
          labelBackgroundColor: Colors.transparent,
          labelHasShadow: false,
          labelText: "Members",
          currentButton: FloatingActionButton(
            elevation: 0.0,
            heroTag: "Members",
            backgroundColor: primaryColour,
            mini: true,
            onPressed: () {
              setState(() {
                selectedMenuItem = "Members";
              });
            },
            child: Image.asset("assets/icons/members.png",
                color: Colors.white, width: 20.0),
          ),
        ),
      );
    } else {
      childButtons.add(
        UnicornButton(
          hasLabel: true,
          labelBackgroundColor: Colors.transparent,
          labelHasShadow: false,
          labelText: "People Allowed to View Project",
          currentButton: FloatingActionButton(
            elevation: 0.0,
            heroTag: "People Allowed to View Project",
            backgroundColor: primaryColour,
            mini: true,
            onPressed: () {
              setState(() {
                selectedMenuItem = "People Allowed to View Project";
              });
            },
            child: const Icon(Icons.perm_identity_outlined),
          ),
        ),
      );
    }

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelBackgroundColor: Colors.transparent,
        labelHasShadow: false,
        labelText: "Milestones",
        currentButton: FloatingActionButton(
          elevation: 0.0,
          heroTag: "Milestones",
          backgroundColor: primaryColour,
          mini: true,
          child: const Icon(Icons.emoji_flags_outlined),
          onPressed: () {
            setState(() {
              selectedMenuItem = "Milestones";
            });
          },
        ),
      ),
    );

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelBackgroundColor: Colors.transparent,
        labelHasShadow: false,
        labelText: "Phases",
        currentButton: FloatingActionButton(
          elevation: 0.0,
          heroTag: "Phases",
          backgroundColor: primaryColour,
          mini: true,
          onPressed: () {
            setState(() {
              selectedMenuItem = "Phases";
            });
          },
          child: Image.asset("assets/icons/phases.png",
              color: Colors.white, width: 20.0),
        ),
      ),
    );

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelBackgroundColor: Colors.transparent,
        labelHasShadow: false,
        labelText: "Resources",
        currentButton: FloatingActionButton(
          elevation: 0.0,
          heroTag: "Resources",
          backgroundColor: primaryColour,
          mini: true,
          child: const Icon(Icons.bubble_chart_outlined),
          onPressed: () {
            setState(() {
              selectedMenuItem = "Resources";
            });
          },
        ),
      ),
    );

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelBackgroundColor: Colors.transparent,
        labelHasShadow: false,
        labelText: "Budget",
        currentButton: FloatingActionButton(
          elevation: 0.0,
          heroTag: "Budget",
          backgroundColor: primaryColour,
          mini: true,
          onPressed: () {
            setState(() {
              selectedMenuItem = "Budget";
            });
          },
          child: const Icon(Icons.monetization_on_outlined),
        ),
      ),
    );

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelBackgroundColor: Colors.transparent,
        labelHasShadow: false,
        labelText: "Donors",
        currentButton: FloatingActionButton(
          elevation: 0.0,
          heroTag: "Donors",
          backgroundColor: primaryColour,
          mini: true,
          onPressed: () {
            setState(() {
              selectedMenuItem = "Donors";
            });
          },
          child: Image.asset("assets/icons/donor.png",
              color: Colors.white, width: 20.0),
        ),
      ),
    );

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelBackgroundColor: Colors.transparent,
        labelHasShadow: false,
        labelText: "Executing Agency",
        currentButton: FloatingActionButton(
          elevation: 0.0,
          heroTag: "Executing Agency",
          backgroundColor: primaryColour,
          mini: true,
          onPressed: () {
            setState(() {
              selectedMenuItem = "Executing Agency";
            });
          },
          child: Image.asset("assets/icons/agency.png",
              color: Colors.white, width: 20.0),
        ),
      ),
    );

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1.0),
      child: FutureBuilder<ProjectModel>(
        future: readProjectInformationJsonData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Scaffold(
                appBar: buildAppBar(context),
                body: bodyBody(context),
                floatingActionButton: buildFloatingActionButton(childButtons),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }

  buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: primaryColour,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ProjectBoardScreenMA(
                  selectedProject: readJsonFileContent,
                  navigationMenu: widget.navigationMenu,
                );
              },
            ),
          );
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return EditProjectDetailScreenMA(
                    selectedProject: readJsonFileContent,
                    navigationMenu: widget.navigationMenu,
                  );
                },
              ),
            );
          },
          icon: Icon(
            Icons.edit_outlined,
            color: primaryColour,
          ),
        ),
      ],
    );
  }

  bodyBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        const SizedBox(height: 10.0),
        FutureBuilder<ProjectModel>(
          future: readProjectInformationJsonData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return readJsonFileContent.projectPhotoFile == null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            height: 250.0,
                            width: MediaQuery.of(context).size.width - 40.0,
                            color: const Color.fromRGBO(202, 202, 202, 1),
                            child: Center(
                              child: Text(
                                readJsonFileContent.projectName!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  letterSpacing: 8,
                                  fontFamily: 'Electrolize',
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromRGBO(76, 75, 75, 1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.memory(
                            base64Decode(readJsonFileContent.projectPhotoFile!),
                            height: 250.0,
                            width: MediaQuery.of(context).size.width - 40.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
            }
            return const CircularProgressIndicator();
          },
        ),
        const SizedBox(height: 20),
        ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                readJsonFileContent.projectName!,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
                maxLines: 2,
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 3),
            Row(
              children: <Widget>[
                Icon(
                  Icons.access_time_sharp,
                  size: 15,
                  color: primaryColour,
                ),
                const SizedBox(width: 3),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${readJsonFileContent.duration == null ? 0 : readJsonFileContent.duration!} Weeks",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: primaryColour,
                    ),
                    maxLines: 250,
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.circle,
                  size: 5,
                  color: primaryColour,
                ),
                const SizedBox(width: 8),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Priority: ${impactLabel![readJsonFileContent.criticalityColour == null ? 0 : readJsonFileContent.criticalityColour!]}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: primaryColour,
                    ),
                    maxLines: 250,
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.circle,
                  size: 5,
                  color: primaryColour,
                ),
                const SizedBox(width: 8),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Status: ${readJsonFileContent.status == null ? "Unknown" : readJsonFileContent.status!}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: primaryColour,
                    ),
                    maxLines: 250,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            selectedMenuItem == "General Information"
                ? ProjectGeneralInformationMA(
                    selectedProject: readJsonFileContent,
                  )
                : selectedMenuItem == "Location"
                    ? ProjectLocationsMA(
                        selectedProject: readJsonFileContent,
                        zoomPanBehavior: _zoomPanBehavior,
                        animation: _animation,
                      )
                    : selectedMenuItem == "Skills Required"
                        ? ProjectSkillsRequiredMA(
                            selectedProject: readJsonFileContent,
                          )
                        : selectedMenuItem == "Members"
                            ? ProjectMembersMA(
                                selectedProject: readJsonFileContent,
                              )
                            : selectedMenuItem == "Milestones"
                                ? ProjectMilestonesMA(
                                    selectedProject: readJsonFileContent,
                                  )
                                : selectedMenuItem == "Phases"
                                    ? ProjectPhasesMA(
                                        selectedProject: readJsonFileContent,
                                      )
                                    : selectedMenuItem == "Resources"
                                        ? ProjectResourcesMA(
                                            selectedProject:
                                                readJsonFileContent,
                                          )
                                        : selectedMenuItem == "Budget"
                                            ? ProjectBudgetMA(
                                                selectedProject:
                                                    readJsonFileContent,
                                              )
                                            : selectedMenuItem == "Donors"
                                                ? ProjectDonorMA(
                                                    selectedProject:
                                                        readJsonFileContent,
                                                  )
                                                : selectedMenuItem ==
                                                        "Executing Agency"
                                                    ? ProjectExecutingAgencyMA(
                                                        selectedProject:
                                                            readJsonFileContent,
                                                      )
                                                    : selectedMenuItem ==
                                                            "People Allowed to View Project"
                                                        ? PeopleWhoAreAllowedToViewProjectMA(
                                                            selectedProject:
                                                                readJsonFileContent,
                                                          )
                                                        : Container(),
          ],
        ),
      ],
    );
  }

  buildFloatingActionButton(List<UnicornButton> childButtons) {
    return UnicornDialer(
      childPadding: 0.0,
      backgroundColor: DynamicTheme.of(context)?.brightness == Brightness.light
          ? const Color.fromRGBO(255, 255, 255, 0.6)
          : const Color(0XFF323232),
      parentButtonBackground: primaryColour,
      orientation: UnicornOrientation.VERTICAL,
      parentButton: const Icon(Icons.filter_list_sharp),
      childButtons: childButtons,
    );
  }
}
