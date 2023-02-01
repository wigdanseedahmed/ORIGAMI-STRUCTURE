import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class EditProjectGeneralInformationMA extends StatefulWidget {
  const EditProjectGeneralInformationMA({
    Key? key,
    required this.selectedProject,
  }) : super(key: key);

  final ProjectModel? selectedProject;

  @override
  State<EditProjectGeneralInformationMA> createState() =>
      _EditProjectGeneralInformationMAState();
}

class _EditProjectGeneralInformationMAState
    extends State<EditProjectGeneralInformationMA>
    with TickerProviderStateMixin {
  /// VARIABLES FOR USERS
  List<UserModel>? _allUserData = <UserModel>[];

  List<String>? _allUserNameList = <String>[];
  List<String>? _allUserFullNameList = <String>[];

  Future<List<UserModel>?> readAllUsersJsonData() async {
    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(AppUrl.users);

    /// Create Request to get data and response to read data
    final response = await http.get(
      uri,
      headers: {
        "Access-Control-Allow-Origin": "*",
        // Required for CORS support to work
        "Access-Control-Allow-Headers":
            "Content-Type, Access-Control-Allow-Origin, Accept",
        //'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Methods": "POST, DELETE, GET, PUT"
      },
    );
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    _allUserData = <UserModel>[];
    _allUserNameList = <String>[];

    if (response.statusCode == 200) {
      _allUserData = userModelListFromJson(response.body);
      // print("User Model Info : ${readJsonFileContent}");

      for (int i = 0; i < _allUserData!.length; i++) {
        _allUserNameList!.add(_allUserData![i].username!);
        _allUserFullNameList!
            .add("${_allUserData![i].firstName} ${_allUserData![i].lastName}");
      }

      // print("User Model Name : ${_allUserFullNameList}");

      return _allUserData;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// VARIABLES FOR PROJECT
  ProjectModel readJsonFileContent = ProjectModel();
  Future<ProjectModel>? _futureProjectInformation;

  Future<ProjectModel> readProjectData() async {
    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(
        "${AppUrl.getProjectByProjectName}${widget.selectedProject!.projectName}");

    /// Create Request to get data and response to read data
    final response = await http.get(
      uri,
      headers: {
        "Access-Control-Allow-Origin": "*",
        // Required for CORS support to work
        "Access-Control-Allow-Headers":
            "Content-Type, Access-Control-Allow-Origin, Accept",
        //'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Methods": "POST, DELETE, GET, PUT"
      },
    );
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      readJsonFileContent = projectModelFromJson(response.body)[0];
      print("Project Info : ${readJsonFileContent}");

      return readJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  Future<ProjectModel> writeGeneralInformationJsonData(
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

  @override
  void initState() {
    super.initState();

    readAllUsersJsonData();

    _futureProjectInformation = readProjectData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1.0),
      child: FutureBuilder<ProjectModel>(
        future: _futureProjectInformation,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "GENERAL INFORMATION",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            letterSpacing: 4,
                            fontFamily: 'Electrolize',
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.save_outlined),
                        color: primaryColour,
                        onPressed: () {
                          setState(() {
                            _futureProjectInformation =
                                writeGeneralInformationJsonData(
                                    readJsonFileContent);
                          });
                        },
                      )
                    ],
                  ),
                  const ProjectDetailHeaderMA(headerTitle: 'DESCRIPTION'),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 250,
                      autofocus: false,
                      initialValue:
                          readJsonFileContent.projectDescription == null
                              ? "Project Description"
                              : readJsonFileContent.projectDescription!,
                      cursorColor: DynamicTheme.of(context)?.brightness ==
                              Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                      onChanged: (newValue) {
                        readJsonFileContent.projectDescription = newValue;
                      },
                      onFieldSubmitted: (newValue) {
                        readJsonFileContent.projectDescription = newValue;
                      },
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
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 25),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 25,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time_outlined,
                              color: Colors.grey,
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width / 50),
                            Text(
                              "START DATE",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                //letterSpacing: 8,
                                fontFamily: 'Electrolize',
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.045,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 80),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 25,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.access_time_outlined,
                              color: Colors.grey,
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width / 50),
                            Text(
                              "END DATE",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                //letterSpacing: 8,
                                fontFamily: 'Electrolize',
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.045,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: CupertinoDateTextBox(
                          initialValue: readJsonFileContent.startDate == null
                              ? DateTime.now()
                              : DateFormat("yyyy-MM-dd")
                                  .parse(readJsonFileContent.startDate!),
                          onDateChange: (DateTime newdate) {
                            //print(newdate);
                            setState(() {
                              readJsonFileContent.startDate =
                                  newdate.toIso8601String();
                            });
                          },
                          hintText: readJsonFileContent.startDate == null
                              ? DateFormat("EEE, MMM d, yyyy")
                                  .format(DateTime.now())
                              : readJsonFileContent.startDate!,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 3,
                        child: CupertinoDateTextBox(
                          initialValue: readJsonFileContent.dueDate == null
                              ? DateTime.now()
                              : DateFormat("yyyy-MM-dd")
                                  .parse(readJsonFileContent.dueDate!),
                          onDateChange: (DateTime newdate) {
                            //print(newdate);
                            setState(() {
                              readJsonFileContent.dueDate =
                                  newdate.toIso8601String();
                            });
                          },
                          hintText: readJsonFileContent.dueDate == null
                              ? DateFormat("EEE, MMM d, yyyy")
                                  .format(DateTime.now())
                              : readJsonFileContent.dueDate!,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 25),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 25,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.grey,
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width / 50),
                            Text(
                              "DURATION (in Weeks)",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                //letterSpacing: 8,
                                fontFamily: 'Electrolize',
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 65),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 20,
                        width: MediaQuery.of(context).size.width * 0.1,
                        child: TextFormField(
                          minLines: 1,
                          maxLines: 1,
                          autofocus: false,
                          initialValue: readJsonFileContent.duration == null
                              ? "0"
                              : readJsonFileContent.duration.toString(),
                          cursorColor: DynamicTheme.of(context)?.brightness ==
                                  Brightness.light
                              ? Colors.grey[100]
                              : Colors.grey[600],
                          onChanged: (newValue) {
                            readJsonFileContent.duration =
                                double.parse(newValue);
                          },
                          onFieldSubmitted: (newValue) {
                            readJsonFileContent.duration =
                                double.parse(newValue);
                          },
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
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 25),
                  const ProjectDetailHeaderMA(headerTitle: 'LEADING MEMBERS'),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 16.0),
                    child: FutureBuilder(
                      future: readAllUsersJsonData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      child: Text(
                                        "MANAGER",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      child: StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter dropDownState) {
                                        return DropdownSearch<String>(
                                          popupElevation: 0.0,
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                            labelStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  120,
                                              fontFamily: 'Montserrat',
                                              letterSpacing: 3,
                                            ),
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
                                          //mode of dropdown
                                          mode: Mode.MENU,
                                          //to show search box
                                          showSearchBox: true,
                                          //list of dropdown items
                                          items: _allUserFullNameList,
                                          onChanged: (String? newValue) {
                                            dropDownState(() {
                                              readJsonFileContent
                                                      .projectManager =
                                                  _allUserNameList![
                                                      _allUserFullNameList!
                                                          .indexWhere(
                                                              (element) =>
                                                                  element ==
                                                                  newValue)];

                                              //print(_allUserNameList.indexWhere((element) => element == readJsonFileContent.projectSeniorManager));
                                            });
                                          },
                                          //show selected item
                                          selectedItem: readJsonFileContent
                                                      .projectManager ==
                                                  null
                                              ? "Project Manager"
                                              : _allUserFullNameList![
                                                  _allUserNameList!.indexWhere(
                                                      (element) =>
                                                          element ==
                                                          readJsonFileContent
                                                              .projectManager)],
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      child: Text(
                                        "LEADER",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      child: StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter dropDownState) {
                                        return DropdownSearch<String>(
                                          popupElevation: 0.0,
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                            labelStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  120,
                                              fontFamily: 'Montserrat',
                                              letterSpacing: 3,
                                            ),
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
                                          //mode of dropdown
                                          mode: Mode.MENU,
                                          //to show search box
                                          showSearchBox: true,
                                          //list of dropdown items
                                          items: _allUserFullNameList,
                                          onChanged: (String? newValue) {
                                            dropDownState(() {
                                              readJsonFileContent
                                                      .projectLeader =
                                                  _allUserNameList![
                                                      _allUserFullNameList!
                                                          .indexWhere(
                                                              (element) =>
                                                                  element ==
                                                                  newValue)];
                                            });
                                          },
                                          //show selected item
                                          selectedItem: readJsonFileContent
                                                      .projectLeader ==
                                                  null
                                              ? "Project Leader"
                                              : _allUserFullNameList![
                                                  _allUserNameList!.indexWhere(
                                                      (element) =>
                                                          element ==
                                                          readJsonFileContent
                                                              .projectLeader)],
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      child: Text(
                                        "ASSISTANT",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.06,
                                      child: StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter dropDownState) {
                                        return DropdownSearch<String>(
                                          popupElevation: 0.0,
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                            labelStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  120,
                                              fontFamily: 'Montserrat',
                                              letterSpacing: 3,
                                            ),
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
                                          //mode of dropdown
                                          mode: Mode.MENU,
                                          //to show search box
                                          showSearchBox: true,
                                          //list of dropdown items
                                          items: _allUserFullNameList,
                                          onChanged: (String? newValue) {
                                            dropDownState(() {
                                              readJsonFileContent
                                                      .projectAssistantOrCoordinator =
                                                  _allUserNameList![
                                                      _allUserFullNameList!
                                                          .indexWhere(
                                                              (element) =>
                                                                  element ==
                                                                  newValue)];

                                              //print(_allUserNameList.indexWhere((element) => element == readJsonFileContent.projectSeniorManager));
                                            });
                                          },
                                          //show selected item
                                          selectedItem: readJsonFileContent
                                                      .projectAssistantOrCoordinator ==
                                                  null
                                              ? "Project Assistant/Coordinator"
                                              : _allUserFullNameList![
                                                  _allUserNameList!.indexWhere(
                                                      (element) =>
                                                          element ==
                                                          readJsonFileContent
                                                              .projectAssistantOrCoordinator)],
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                        }

                        return const CircularProgressIndicator();
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 25),
                  const ProjectDetailHeaderMA(headerTitle: 'GENERAL AIMS'),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 250,
                      autofocus: false,
                      initialValue: readJsonFileContent.aims == null
                          ? ""
                          : readJsonFileContent.aims,
                      cursorColor: DynamicTheme.of(context)?.brightness ==
                              Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                      onChanged: (newValue) {
                        readJsonFileContent.aims = newValue;
                      },
                      onFieldSubmitted: (newValue) {
                        readJsonFileContent.aims = newValue;
                      },
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
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 25),
                  const ProjectDetailHeaderMA(headerTitle: 'OBJECTIVES'),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 250,
                      autofocus: false,
                      initialValue: readJsonFileContent.objective == null
                          ? ""
                          : readJsonFileContent.objective,
                      cursorColor: DynamicTheme.of(context)?.brightness ==
                              Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                      onChanged: (newValue) {
                        readJsonFileContent.objective = newValue;
                      },
                      onFieldSubmitted: (newValue) {
                        readJsonFileContent.objective = newValue;
                      },
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
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 25),
                  const ProjectDetailHeaderMA(headerTitle: 'BENEFITS (KIP)'),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 250,
                      autofocus: false,
                      initialValue: readJsonFileContent.benefits == null
                          ? ""
                          : readJsonFileContent.benefits,
                      cursorColor: DynamicTheme.of(context)?.brightness ==
                              Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                      onChanged: (newValue) {
                        readJsonFileContent.benefits = newValue;
                      },
                      onFieldSubmitted: (newValue) {
                        readJsonFileContent.benefits = newValue;
                      },
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
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 25),
                  const ProjectDetailHeaderMA(headerTitle: 'DELIVERABLES'),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 250,
                      autofocus: false,
                      initialValue: readJsonFileContent.deliverables == null
                          ? ""
                          : readJsonFileContent.deliverables,
                      cursorColor: DynamicTheme.of(context)?.brightness ==
                              Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                      onChanged: (newValue) {
                        readJsonFileContent.deliverables = newValue;
                      },
                      onFieldSubmitted: (newValue) {
                        readJsonFileContent.deliverables = newValue;
                      },
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
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 25),
                  const ProjectDetailHeaderMA(headerTitle: 'INITIAL RISKS'),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 250,
                      autofocus: false,
                      initialValue: readJsonFileContent.initialRisks == null
                          ? ""
                          : readJsonFileContent.initialRisks,
                      cursorColor: DynamicTheme.of(context)?.brightness ==
                              Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                      onChanged: (newValue) {
                        readJsonFileContent.initialRisks = newValue;
                      },
                      onFieldSubmitted: (newValue) {
                        readJsonFileContent.initialRisks = newValue;
                      },
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
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 25),
                  const ProjectDetailHeaderMA(headerTitle: 'EXPECTED OUTCOMES'),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 250,
                      autofocus: false,
                      initialValue: readJsonFileContent.expectedOutcome == null
                          ? ""
                          : readJsonFileContent.expectedOutcome,
                      cursorColor: DynamicTheme.of(context)?.brightness ==
                              Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                      onChanged: (newValue) {
                        readJsonFileContent.expectedOutcome = newValue;
                      },
                      onFieldSubmitted: (newValue) {
                        readJsonFileContent.expectedOutcome = newValue;
                      },
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
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 25),
                  const ProjectDetailHeaderMA(headerTitle: 'Measurable Criteria For Success'),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 250,
                      autofocus: false,
                      initialValue: readJsonFileContent
                                  .measurableCriteriaForSuccess ==
                              null
                          ? ""
                          : readJsonFileContent.measurableCriteriaForSuccess!,
                      cursorColor: DynamicTheme.of(context)?.brightness ==
                              Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                      onChanged: (newValue) {
                        readJsonFileContent.measurableCriteriaForSuccess =
                            newValue;
                      },
                      onFieldSubmitted: (newValue) {
                        readJsonFileContent.measurableCriteriaForSuccess =
                            newValue;
                      },
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
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 25),
                  const ProjectDetailHeaderMA(headerTitle: 'TYPE OF PROJECT'),
                  SizedBox(
                    height: typeOfProjectList!.length *
                        MediaQuery.of(context).size.height *
                        0.065,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: typeOfProjectList!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            if (readJsonFileContent.typeOfProject == null) {
                              setState(() {
                                readJsonFileContent.typeOfProject = [];
                                readJsonFileContent.typeOfProject!
                                    .add(typeOfProjectList![index]);
                              });
                              //print(readJsonFileContent.theme);
                            } else if (readJsonFileContent.typeOfProject!
                                .contains(typeOfProjectList![index])) {
                              setState(() {
                                readJsonFileContent.typeOfProject!
                                    .remove(typeOfProjectList![index]);
                              });
                              //print(readJsonFileContent.theme);
                            } else {
                              setState(() {
                                readJsonFileContent.typeOfProject!
                                    .add(typeOfProjectList![index]);
                              });
                              //print(readJsonFileContent.theme);
                            }
                          },
                          title: Text(
                            typeOfProjectList![index],
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 25,
                              fontFamily: 'Montserrat',
                              //fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: Container(
                            child: readJsonFileContent.typeOfProject == null
                                ? Icon(Icons.check_box_outline_blank,
                                    size:
                                        MediaQuery.of(context).size.width / 20)
                                : !readJsonFileContent.typeOfProject!
                                        .contains(typeOfProjectList![index])
                                    ? Icon(Icons.check_box_outline_blank,
                                        size:
                                            MediaQuery.of(context).size.width /
                                                20)
                                    : Icon(Icons.check,
                                        size:
                                            MediaQuery.of(context).size.width /
                                                20),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 25),
                  const ProjectDetailHeaderMA(headerTitle: 'PORTFOLIO AFFILIATION'),
                  SizedBox(
                    height: portfolioAffiliationList!.length *
                        MediaQuery.of(context).size.height *
                        0.065,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: portfolioAffiliationList!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            if (readJsonFileContent.theme == null) {
                              setState(() {
                                readJsonFileContent.theme = [];
                                readJsonFileContent.theme!
                                    .add(portfolioAffiliationList![index]);
                              });
                              //print(readJsonFileContent.theme);
                            } else if (readJsonFileContent.theme!
                                .contains(portfolioAffiliationList![index])) {
                              setState(() {
                                readJsonFileContent.theme!
                                    .remove(portfolioAffiliationList![index]);
                              });
                              //print(readJsonFileContent.theme);
                            } else {
                              setState(() {
                                readJsonFileContent.theme!
                                    .add(portfolioAffiliationList![index]);
                              });
                              //print(readJsonFileContent.theme);
                            }
                          },
                          title: Text(portfolioAffiliationList![index],
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width / 25,
                                fontFamily: 'Montserrat',
                                //fontWeight: FontWeight.bold,
                              )),
                          leading: Container(
                            child: readJsonFileContent.theme == null
                                ? Icon(Icons.check_box_outline_blank,
                                    size:
                                        MediaQuery.of(context).size.width / 20)
                                : !readJsonFileContent.theme!.contains(
                                        portfolioAffiliationList![index])
                                    ? Icon(Icons.check_box_outline_blank,
                                        size:
                                            MediaQuery.of(context).size.width /
                                                20)
                                    : Icon(Icons.check,
                                        size:
                                            MediaQuery.of(context).size.width /
                                                20),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 25),
                  const ProjectDetailHeaderMA(headerTitle: 'SDGs TARGETED'),
                  SizedBox(
                    height: sdgGoalsList!.length *
                        MediaQuery.of(context).size.height *
                        0.068,
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: sdgGoalsList!.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              if (readJsonFileContent.sdgs == null) {
                                setState(() {
                                  readJsonFileContent.sdgs = [];
                                  readJsonFileContent.sdgs!
                                      .add(sdgGoalsList![index]);
                                });
                                //print(readJsonFileContent.theme);
                              } else if (readJsonFileContent.sdgs!
                                  .contains(sdgGoalsList![index])) {
                                setState(() {
                                  readJsonFileContent.sdgs!
                                      .remove(sdgGoalsList![index]);
                                });
                                //print(readJsonFileContent.sdgs);
                              } else {
                                setState(() {
                                  readJsonFileContent.sdgs!
                                      .add(sdgGoalsList![index]);
                                });
                                //print(readJsonFileContent.sdgs);
                              }
                            },
                            title: Text(sdgGoalsList![index],
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 25,
                                  fontFamily: 'Montserrat',
                                  //fontWeight: FontWeight.bold,
                                )),
                            leading: Container(
                              child: readJsonFileContent.sdgs == null
                                  ? Icon(Icons.check_box_outline_blank,
                                      size: MediaQuery.of(context).size.width /
                                          20)
                                  : !readJsonFileContent.sdgs!
                                          .contains(sdgGoalsList![index])
                                      ? Icon(Icons.check_box_outline_blank,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              20)
                                      : Icon(Icons.check,
                                          size: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              20),
                            ),
                          );
                        }),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 25),
                ],
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
}
