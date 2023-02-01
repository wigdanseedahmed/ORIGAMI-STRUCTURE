import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

// ignore: import_of_legacy_library_into_null_safe
import 'package:unicorndial/unicorndial.dart';

class EditProjectDetailScreenMA extends StatefulWidget {
  static const String id = 'project_board_edit_detail_screen';

  final ProjectModel? selectedProject;
  final NavigationMenu navigationMenu;

  const EditProjectDetailScreenMA({
    Key? key,
    this.selectedProject,
    required this.navigationMenu,
  }) : super(key: key);

  @override
  _EditProjectDetailScreenMAState createState() =>
      _EditProjectDetailScreenMAState();
}

class _EditProjectDetailScreenMAState extends State<EditProjectDetailScreenMA>
    with TickerProviderStateMixin {
  ///VARIABLES USED TO DETERMINE SCREEN SIZE
  late ScrollController _scrollController;
  double _scrollPosition = 0;
  double _opacity = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  /// VARIABLES FOR PROJECT
  ProjectModel readJsonFileContent = ProjectModel();

  Future<ProjectModel>? _futureProjectInformation;

  Future<ProjectModel> readProjectGeneralInformationJsonData() async {
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

  Future<ProjectModel> writeProjectGeneralInformationJsonData(
      ProjectModel selectedProjectInformation) async {
    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(
        "${AppUrl.updateProjectByProjectName}${widget.selectedProject!.projectName!}");

    print(selectedProjectInformation);

    /// Create Request to get data and response to read data
    final response = await http.put(
      uri,
      headers: {
        "Access-Control-Allow-Origin": "*",
        // Required for CORS support to work
        "Access-Control-Allow-Headers":
            "Content-Type, Access-Control-Allow-Origin, Accept",
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Methods": "POST, DELETE, GET, PUT"
      },
      body: json.encode(selectedProjectInformation.toJson()),
    );
    //print(response.body);

    if (response.statusCode == 200) {
      readJsonFileContent = projectFromJson(response.body);
      //print(readJsonFileContent);
      return readJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// VARIABLES USED FOR FLOATING APP BAR
  late String? selectedMenuItem = "General Information";

  @override
  void initState() {
    /// VARIABLES USED TO SCROLL THROUGH SCREEN
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    _futureProjectInformation = readProjectGeneralInformationJsonData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _opacity = _scrollPosition < MediaQuery.of(context).size.height * 0.40
        ? _scrollPosition / (MediaQuery.of(context).size.height * 0.40)
        : 1;

    /// VARIABLES USED FOR FLOATING APP BAR
    var childButtons = <UnicornButton>[];

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelBackgroundColor: Colors.transparent,
        labelHasShadow: false,
        labelText: "General Information",
        currentButton: FloatingActionButton(
          heroTag: "General Information",
          elevation: 0.0,
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

    if (widget.selectedProject!.status == "Suggested") {
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
    } else {
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
    }

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelBackgroundColor: Colors.transparent,
        labelHasShadow: false,
        labelText: "Milestones",
        currentButton: FloatingActionButton(
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
        future: _futureProjectInformation,
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
          //Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProjectDetailScreenMA(
                selectedProject: readJsonFileContent,
                navigationMenu: widget.navigationMenu,
              ),
            ),
          );
          //finish(context);
        },
      ),
      /*actions: [
        IconButton(
          onPressed: () {
            toast('Coming Soon');
            //TODO: NotificationComponents().launch(context);
          },
          icon: Icon(
            Icons.save_outlined,
            color: primaryColour,
          ),
        ),
      ],*/
    );
  }

  bodyBody(BuildContext context) {
    //print(readJsonFileContent);
    return ListView(
      children: <Widget>[
        const SizedBox(height: 10.0),
        EditProjectProfileAvatarWidgetMA(
          onClicked: () {},
          projectName: readJsonFileContent.projectName!,
          imagePath: readJsonFileContent.projectPhotoName == null
              ? null
              : readJsonFileContent.projectPhotoName!,
        ),
        const SizedBox(height: 20),
        selectedMenuItem == "General Information"
            ? Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "NAME",
                          style: TextStyle(
                            //letterSpacing: 8,
                            fontFamily: 'Electrolize',
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 38),
                        SizedBox(
                          width: 250,
                          child: TextFormField(
                            minLines: 1,
                            maxLines: 250,
                            autofocus: false,
                            cursorColor: DynamicTheme.of(context)?.brightness ==
                                    Brightness.light
                                ? Colors.grey[100]
                                : Colors.grey[600],
                            initialValue:
                                readJsonFileContent.projectName == null
                                    ? ""
                                    : readJsonFileContent.projectName!,
                            style: subTitleTextStyleMA,
                            decoration: InputDecoration(
                              //hintText: "Description",
                              //hintStyle: subTitleTextStyle,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: primaryColour,
                                  width: 0.5,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: primaryColour,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            onChanged: (newName) {
                              setState(() {
                                readJsonFileContent.projectName = newName;
                                _futureProjectInformation =
                                    writeProjectGeneralInformationJsonData(
                                        readJsonFileContent);
                              });
                            },
                            onFieldSubmitted: (newName) {
                              setState(() {
                                readJsonFileContent.projectName = newName;
                                _futureProjectInformation =
                                    writeProjectGeneralInformationJsonData(
                                        readJsonFileContent);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          "STATUS",
                          style: TextStyle(
                            //letterSpacing: 8,
                            fontFamily: 'Electrolize',
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: Align(
                            alignment: Alignment.center,
                            child: StatefulBuilder(builder:
                                (BuildContext context,
                                    StateSetter dropDownState) {
                              return DropdownSearch<String>(
                                popupElevation: 0.0,
                                showClearButton: true,
                                dropdownSearchDecoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: primaryColour,
                                      width: 0.5,
                                    ),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: primaryColour,
                                      width: 0.5,
                                    ),
                                  ),
                                  labelStyle: subTitleTextStyleMA,
                                ),
                                ////dropdownButtonSplashRadius: 1.0,
                                //mode of dropdown
                                mode: Mode.MENU,
                                //to show search box
                                showSearchBox: true,
                                //list of dropdown items
                                items: projectStatusLabel,
                                onChanged: (String? newValue) {
                                  dropDownState(() {
                                    setState(() {
                                      readJsonFileContent.status = newValue;
                                      _futureProjectInformation =
                                          writeProjectGeneralInformationJsonData(
                                              readJsonFileContent);
                                    });
                                  });
                                },
                                //show selected item
                                selectedItem: readJsonFileContent.status == null
                                    ? ""
                                    : readJsonFileContent.status!,
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Container(),
        ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            const SizedBox(height: 20),
            selectedMenuItem == "General Information"
                ? EditProjectGeneralInformationMA(
                    selectedProject: readJsonFileContent,
                  )
                : selectedMenuItem == "Location"
                    ? EditProjectLocationsMA(
                        selectedProject: readJsonFileContent,
                      )
                    : selectedMenuItem == "Skills Required"
                        ? EditProjectSkillsRequiredMA(
                            selectedProject: readJsonFileContent,
                            navigationMenu: widget.navigationMenu,
                          )
                        : selectedMenuItem == "Members"
                            ? EditProjectMembersMA(
                                selectedProject: readJsonFileContent,
                              )
                            : selectedMenuItem == "Milestones"
                                ? EditProjectMilestonesMA(
                                    selectedProject: readJsonFileContent,
                                  )
                                : selectedMenuItem == "Phases"
                                    ? EditProjectPhasesMA(
                                        selectedProject: readJsonFileContent,
                                      )
                                    : selectedMenuItem == "Resources"
                                        ? EditProjectResourcesMA(
                                            selectedProject:
                                                readJsonFileContent,
                                          )
                                        : selectedMenuItem == "Budget"
                                            ? EditProjectBudgetMA(
                                                selectedProject:
                                                    readJsonFileContent,
                                              )
                                            : selectedMenuItem == "Donors"
                                                ? EditProjectDonorsMA(
                                                    selectedProject:
                                                        readJsonFileContent,
                                                  )
                                                : selectedMenuItem ==
                                                        "Executing Agency"
                                                    ? EditProjectExecutingAgencyMA(
                                                        selectedProject:
                                                            readJsonFileContent,
                                                      )
                                                    : EditPeopleWhoAreAllowedToViewProjectMA(
                                                        selectedProject:
                                                            readJsonFileContent,
                                                      ),
          ],
        ),
      ],
    );
  }

  buildFloatingActionButton(List<UnicornButton> childButtons) {
    return UnicornDialer(
      backgroundColor: DynamicTheme.of(context)?.brightness == Brightness.light
          ? const Color.fromRGBO(255, 255, 255, 0.6)
          : const Color(0XFF323232),
      childPadding: 0.0,
      parentButtonBackground: primaryColour,
      orientation: UnicornOrientation.VERTICAL,
      parentButton: const Icon(Icons.filter_list_sharp),
      childButtons: childButtons,
    );
  }
}
