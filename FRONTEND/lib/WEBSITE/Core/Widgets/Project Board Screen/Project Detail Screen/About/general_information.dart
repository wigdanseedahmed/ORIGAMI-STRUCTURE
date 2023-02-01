import 'dart:ui';

import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

// ignore: import_Of_legacy_library_into_null_safe
import 'package:flutter_tags/flutter_tags.dart';

class ProjectGeneralInformationWS extends StatefulWidget {
  const ProjectGeneralInformationWS({
    Key? key,
    required this.selectedUser,
    this.selectedProject,
    required this.navigationMenu,
  }) : super(key: key);

  final UserModel? selectedUser;
  final ProjectModel? selectedProject;
  final NavigationMenu navigationMenu;

  @override
  State<ProjectGeneralInformationWS> createState() =>
      _ProjectGeneralInformationWSState();
}

class _ProjectGeneralInformationWSState
    extends State<ProjectGeneralInformationWS> {
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
      //print("Project Info : ${readJsonFileContent}");

      return readJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1.0),
      child: FutureBuilder<ProjectModel>(
        future: readProjectData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return buildBody(context, screenSize);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }

  buildBody(BuildContext context, Size screenSize) {
    return Column(
      children: [
        SizedBox(height: screenSize.height / 20),
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
                  fontSize: screenSize.width * 0.02,
                  color: Colors.black.withOpacity(0.9),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: screenSize.height / 30),
        const ProjectDetailHeaderWS(headerTitle: 'DESCRIPTION', icon: null),
        readJsonFileContent.projectDescription == null
            ? Container()
            : SizedBox(
                width: screenSize.width,
                child: Text(
                  readJsonFileContent.projectDescription!,
                  style: TextStyle(
                    fontSize: screenSize.width * 0.01,
                    fontFamily: 'Montserrat',
                    //fontWeight: FontWeight.bold,
                  ),
                  maxLines: 250,
                  textAlign: TextAlign.left,
                ),
              ),
        SizedBox(height: screenSize.height / 25),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: screenSize.height / 25,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.access_time_outlined,
                    color: Colors.black.withOpacity(0.9),
                  ),
                  SizedBox(width: screenSize.width / 80),
                  Text(
                    "Started",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      //letterSpacing: 8,
                      fontFamily: 'Electrolize',
                      fontSize: screenSize.width * 0.011,
                      color: Colors.black.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: screenSize.width * 0.3),
            SizedBox(
              height: screenSize.height / 25,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.access_time_outlined,
                    color: Colors.black.withOpacity(0.9),
                  ),
                  SizedBox(width: screenSize.width / 80),
                  Text(
                    "Ended",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      //letterSpacing: 8,
                      fontFamily: 'Electrolize',
                      fontSize: screenSize.width * 0.011,
                      color: Colors.black.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: screenSize.height / 25,
              child: Text(
                readJsonFileContent.startDate == null
                    ? "Unknown"
                    : DateFormat("EEE, MMM d, yyyy").format(
                        DateTime.parse(readJsonFileContent.startDate!),
                      ),
                //DateFormat("EEE, MMM d, yyyy").format(DateTime.parse(widget.selectedProject.startDate)),
                textAlign: TextAlign.left,
                style: TextStyle(
                  //letterSpacing: 8,
                  fontFamily: 'Electrolize',
                  fontSize: screenSize.width * 0.01,
                ),
              ),
            ),
            SizedBox(width: screenSize.width * 0.3),
            SizedBox(
              height: screenSize.height / 25,
              child: Text(
                readJsonFileContent.completionDate == null
                    ? readJsonFileContent.startDate == null
                        ? "Unknown"
                        : "In Progress"
                    : DateFormat("EEE, MMM d, yyyy").format(
                        DateTime.parse(readJsonFileContent.completionDate!),
                      ),
                textAlign: TextAlign.left,
                style: TextStyle(
                  //letterSpacing: 8,
                  fontFamily: 'Electrolize',
                  fontSize: screenSize.width * 0.01,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: screenSize.height / 30),
        const ProjectDetailHeaderWS(headerTitle: 'LEADING MEMBERS', icon: null),
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
                      readJsonFileContent.projectManager == null
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: screenSize.height * 0.06,
                                  child: Text(
                                    "MANAGER",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      //letterSpacing: 8,
                                      fontFamily: 'Electrolize',
                                      fontSize: screenSize.width * 0.011,
                                      color: Colors.black.withOpacity(0.9),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                SizedBox(width: screenSize.width * 0.335),
                                SizedBox(
                                  width: screenSize.width * 0.12,
                                  height: screenSize.height * 0.06,
                                  child: Text(
                                    readJsonFileContent.projectManager == null
                                        ? "Project Manager"
                                        : _allUserFullNameList![
                                            _allUserNameList!.indexWhere(
                                                (element) =>
                                                    element ==
                                                    readJsonFileContent
                                                        .projectManager)],
                                    style: TextStyle(
                                      fontSize: screenSize.width * 0.01,
                                      fontFamily: 'Montserrat',
                                      //fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 250,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                      readJsonFileContent.projectLeader == null
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: screenSize.height * 0.06,
                                  child: Text(
                                    "LEADER",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      //letterSpacing: 8,
                                      fontFamily: 'Electrolize',
                                      fontSize: screenSize.width * 0.011,
                                      color: Colors.black.withOpacity(0.9),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                SizedBox(width: screenSize.width * 0.335),
                                SizedBox(
                                  width: screenSize.width * 0.12,
                                  height: screenSize.height * 0.06,
                                  child: Text(
                                    readJsonFileContent.projectLeader == null
                                        ? "Project Leader"
                                        : _allUserFullNameList![
                                            _allUserNameList!.indexWhere(
                                                (element) =>
                                                    element ==
                                                    readJsonFileContent
                                                        .projectLeader)],
                                    style: TextStyle(
                                      fontSize: screenSize.width * 0.01,
                                      fontFamily: 'Montserrat',
                                      //fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 250,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                      readJsonFileContent.projectAssistantOrCoordinator == null
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: screenSize.height * 0.06,
                                  child: Text(
                                    "ASSISTANT",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      //letterSpacing: 8,
                                      fontFamily: 'Electrolize',
                                      fontSize: screenSize.width * 0.011,
                                      color: Colors.black.withOpacity(0.9),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                SizedBox(width: screenSize.width * 0.335),
                                SizedBox(
                                  width: screenSize.width * 0.12,
                                  height: screenSize.height * 0.06,
                                  child: Text(
                                    readJsonFileContent
                                                .projectAssistantOrCoordinator ==
                                            null
                                        ? "Project Assistant"
                                        : _allUserFullNameList![_allUserNameList!
                                            .indexWhere((element) =>
                                                element ==
                                                readJsonFileContent
                                                    .projectAssistantOrCoordinator)],
                                    style: TextStyle(
                                      fontSize: screenSize.width * 0.01,
                                      fontFamily: 'Montserrat',
                                      //fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 250,
                                    textAlign: TextAlign.left,
                                  ),
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
        SizedBox(height: screenSize.height / 30),
        readJsonFileContent.aims == null
            ? Container()
            : const ProjectDetailHeaderWS(headerTitle: 'GENERAL AIMS', icon: null),
        readJsonFileContent.aims == null
            ? Container()
            : SizedBox(
                width: screenSize.width,
                child: Text(
                  readJsonFileContent.aims!,
                  style: TextStyle(
                    fontSize: screenSize.width * 0.01,
                    fontFamily: 'Montserrat',
                    //fontWeight: FontWeight.bold,
                  ),
                  maxLines: 250,
                  textAlign: TextAlign.left,
                ),
              ),
        readJsonFileContent.aims == null
            ? Container()
            : SizedBox(height: screenSize.height / 30),
        readJsonFileContent.objective == null
            ? Container()
            : const ProjectDetailHeaderWS(headerTitle: 'OBJECTIVES', icon: null),
        readJsonFileContent.objective == null
            ? Container()
            : SizedBox(
                width: screenSize.width,
                child: Text(
                  readJsonFileContent.objective!,
                  style: TextStyle(
                    fontSize: screenSize.width * 0.01,
                    fontFamily: 'Montserrat',
                    //fontWeight: FontWeight.bold,
                  ),
                  maxLines: 250,
                  textAlign: TextAlign.left,
                ),
              ),
        readJsonFileContent.objective == null
            ? Container()
            : SizedBox(height: screenSize.height / 30),
        readJsonFileContent.benefits == null
            ? Container()
            : const ProjectDetailHeaderWS(headerTitle: 'BENEFITS (KIP)', icon: null),
        readJsonFileContent.benefits == null
            ? Container()
            : SizedBox(
                width: screenSize.width,
                child: Text(
                  readJsonFileContent.benefits!,
                  style: TextStyle(
                    fontSize: screenSize.width * 0.01,
                    fontFamily: 'Montserrat',
                    //fontWeight: FontWeight.bold,
                  ),
                  maxLines: 250,
                  textAlign: TextAlign.left,
                ),
              ),
        readJsonFileContent.benefits == null
            ? Container()
            : SizedBox(height: screenSize.height / 30),
        readJsonFileContent.deliverables == null
            ? Container()
            : const ProjectDetailHeaderWS(headerTitle: 'DELIVERABLES', icon: null),
        readJsonFileContent.deliverables == null
            ? Container()
            : SizedBox(
                width: screenSize.width,
                child: Text(
                  readJsonFileContent.deliverables!,
                  style: TextStyle(
                    fontSize: screenSize.width * 0.01,
                    fontFamily: 'Montserrat',
                    //fontWeight: FontWeight.bold,
                  ),
                  maxLines: 250,
                  textAlign: TextAlign.left,
                ),
              ),
        readJsonFileContent.deliverables == null
            ? Container()
            : SizedBox(height: screenSize.height / 30),
        readJsonFileContent.initialRisks == null
            ? Container()
            : const ProjectDetailHeaderWS(headerTitle: 'INITIAL RISKS', icon: null),
        readJsonFileContent.initialRisks == null
            ? Container()
            : SizedBox(
                width: screenSize.width,
                child: Text(
                  readJsonFileContent.initialRisks!,
                  style: TextStyle(
                    fontSize: screenSize.width * 0.01,
                    fontFamily: 'Montserrat',
                    //fontWeight: FontWeight.bold,
                  ),
                  maxLines: 250,
                  textAlign: TextAlign.left,
                ),
              ),
        readJsonFileContent.initialRisks == null
            ? Container()
            : SizedBox(height: screenSize.height / 30),
        readJsonFileContent.expectedOutcome == null
            ? Container()
            : const ProjectDetailHeaderWS(headerTitle: 'EXPECTED OUTCOME', icon: null),
        readJsonFileContent.expectedOutcome == null
            ? Container()
            : SizedBox(
                width: screenSize.width,
                child: Text(
                  readJsonFileContent.expectedOutcome!,
                  style: TextStyle(
                    fontSize: screenSize.width * 0.01,
                    fontFamily: 'Montserrat',
                    //fontWeight: FontWeight.bold,
                  ),
                  maxLines: 250,
                  textAlign: TextAlign.left,
                ),
              ),
        readJsonFileContent.expectedOutcome == null
            ? Container()
            : SizedBox(height: screenSize.height / 30),
        readJsonFileContent.measurableCriteriaForSuccess == null
            ? Container()
            : const ProjectDetailHeaderWS(
                headerTitle: 'MEASURABLE CRITERIA FOR SUCCESS', icon: null),
        readJsonFileContent.measurableCriteriaForSuccess == null
            ? Container()
            : SizedBox(
                width: screenSize.width,
                child: Text(
                  readJsonFileContent.measurableCriteriaForSuccess!,
                  style: TextStyle(
                    fontSize: screenSize.width * 0.01,
                    fontFamily: 'Montserrat',
                    //fontWeight: FontWeight.bold,
                  ),
                  maxLines: 250,
                  textAlign: TextAlign.left,
                ),
              ),
        readJsonFileContent.measurableCriteriaForSuccess == null
            ? Container()
            : SizedBox(height: screenSize.height / 30),
        readJsonFileContent.typeOfProject == null
            ? Container()
            : const ProjectDetailHeaderWS(headerTitle: 'TYPE OF PROJECT', icon: null),
        readJsonFileContent.typeOfProject == null
            ? Container()
            : Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: screenSize.width,
                  child: Tags(
                    spacing: 16,
                    alignment: WrapAlignment.center,
                    itemCount: readJsonFileContent.typeOfProject!.length,
                    itemBuilder: (int index) {
                      return Tooltip(
                        message: readJsonFileContent.typeOfProject![index],
                        child: ItemTags(
                          active: false,
                          title: readJsonFileContent.typeOfProject![index],
                          index: index,
                          textStyle: TextStyle(
                            color: DynamicTheme.of(context)?.brightness ==
                                    Brightness.light
                                ? Colors.black
                                : Colors.white,
                            fontSize: screenSize.width / 90,
                            fontFamily: 'Montserrat',
                            //fontWeight: FontWeight.bold,
                          ),
                          color: readJsonFileContent.typeOfProject ==
                                  "Data Analytics"
                              ? const Color.fromRGBO(255, 215, 0, 1.0)
                              : readJsonFileContent.typeOfProject ==
                                      "Digitization"
                                  ? const Color.fromRGBO(72, 209, 204, 1.0)
                                  : readJsonFileContent.typeOfProject ==
                                          "Product Research And Development"
                                      ? const Color.fromRGBO(171, 56, 224, 0.75)
                                      : readJsonFileContent.typeOfProject ==
                                              "Knowledge Management"
                                          ? const Color.fromRGBO(
                                              171, 56, 224, 0.75)
                                          : kPlatinum,
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
        readJsonFileContent.typeOfProject == null
            ? Container()
            : SizedBox(height: screenSize.height / 30),
        readJsonFileContent.theme == null
            ? Container()
            : const ProjectDetailHeaderWS(headerTitle: 'PORTFOLIO AFFILIATION', icon: null),
        readJsonFileContent.theme == null
            ? Container()
            : Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: screenSize.width,
                  child: Tags(
                    spacing: 16,
                    alignment: WrapAlignment.center,
                    itemCount: readJsonFileContent.theme!.length,
                    itemBuilder: (int index) {
                      return Tooltip(
                        message: readJsonFileContent.theme![index] ==
                                "Rules Of Law And Constitutional Building"
                            ? "Rules Of Law And\nConstitutional Building"
                            : readJsonFileContent.theme![index] ==
                                    "Democratic Transition And Economic Recovery"
                                ? "Democratic Transition\nAnd Economic Recovery"
                                : readJsonFileContent.theme![index] ==
                                        "Energy And Environment"
                                    ? "Energy\nAnd Environment"
                                    : readJsonFileContent.theme![index] ==
                                            "Health And Development"
                                        ? "Health\nAnd Development"
                                        : readJsonFileContent.theme![index] ==
                                                "Peace And Stabilization"
                                            ? "Peace\nAnd Stabilization"
                                            : readJsonFileContent.theme![index],
                        child: ItemTags(
                          active: false,
                          title: readJsonFileContent.theme![index] ==
                                  "Rules Of Law And Constitutional Building"
                              ? "Rules Of Law And\nConstitutional Building"
                              : readJsonFileContent.theme![index] ==
                                      "Democratic Transition And Economic Recovery"
                                  ? "Democratic Transition\nAnd Economic Recovery"
                                  : readJsonFileContent.theme![index] ==
                                          "Energy And Environment"
                                      ? "Energy\nAnd Environment"
                                      : readJsonFileContent.theme![index] ==
                                              "Health And Development"
                                          ? "Health\nAnd Development"
                                          : readJsonFileContent.theme![index] ==
                                                  "Peace And Stabilization"
                                              ? "Peace\nAnd Stabilization"
                                              : readJsonFileContent
                                                  .theme![index],
                          index: index,
                          textStyle: TextStyle(
                            color: DynamicTheme.of(context)?.brightness ==
                                    Brightness.light
                                ? Colors.black
                                : Colors.white,
                            fontSize: screenSize.width / 90,
                            fontFamily: 'Montserrat',
                            //fontWeight: FontWeight.bold,
                          ),
                          color: readJsonFileContent.theme![index] ==
                                  "Rules Of Law And Constitutional Building"
                              ? const Color.fromRGBO(255, 215, 0, 1.0)
                              : readJsonFileContent.theme![index] ==
                                      "Democratic Transition And Economic Recovery"
                                  ? const Color.fromRGBO(72, 209, 204, 1.0)
                                  : readJsonFileContent.theme![index] ==
                                          "Energy And Environment"
                                      ? const Color.fromRGBO(171, 56, 224, 0.75)
                                      : readJsonFileContent.theme![index] ==
                                              "Health And Development"
                                          ? const Color.fromRGBO(
                                              126, 247, 74, 0.75)
                                          : readJsonFileContent.theme![index] ==
                                                  "Peace And Stabilization"
                                              ? const Color.fromRGBO(
                                                  99, 164, 230, 1)
                                              : kPlatinum,
                          border: Border.all(
                            color: Colors.transparent,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
        readJsonFileContent.theme == null
            ? Container()
            : SizedBox(height: screenSize.height / 30),
        readJsonFileContent.sdgs == null
            ? Container()
            : const ProjectDetailHeaderWS(headerTitle: 'SDGs TARGETED', icon: null),
        readJsonFileContent.sdgs == null
            ? Container()
            : SizedBox(
                width: screenSize.width,
                child: Tags(
                  spacing: 16,
                  alignment: WrapAlignment.center,
                  itemCount: readJsonFileContent.sdgs!.length,
                  itemBuilder: (int index) {
                    return Tooltip(
                      message: readJsonFileContent.sdgs![index],
                      child: ItemTags(
                        active: false,
                        title: readJsonFileContent.sdgs![index],
                        index: index,
                        textStyle: TextStyle(
                          color: DynamicTheme.of(context)?.brightness ==
                                  Brightness.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: screenSize.width / 90,
                          fontFamily: 'Montserrat',
                          //fontWeight: FontWeight.bold,
                        ),
                        color: readJsonFileContent.sdgs![index] ==
                                "GOAL 1: No Poverty"
                            ? const Color(0xFFe5243b)
                            : readJsonFileContent.sdgs![index] ==
                                    "GOAL 2: Zero Hunger"
                                ? const Color(0xFFDDA63A)
                                : readJsonFileContent.sdgs![index] ==
                                        "GOAL 3: Good Health And Well-being"
                                    ? const Color(0xFF4C9F38)
                                    : readJsonFileContent.sdgs![index] ==
                                            "GOAL 4: Quality Education"
                                        ? const Color(0xFFC5192D)
                                        : readJsonFileContent.sdgs![index] ==
                                                "GOAL 5: Gender Equality"
                                            ? const Color(0xFFFF3A21)
                                            : readJsonFileContent
                                                        .sdgs![index] ==
                                                    "GOAL 6: Clean Water And Sanitation"
                                                ? const Color(0xFF26BDE2)
                                                : readJsonFileContent
                                                            .sdgs![index] ==
                                                        "GOAL 7: Affordable And Clean Energy"
                                                    ? const Color(0xFFFCC30B)
                                                    : readJsonFileContent
                                                                .sdgs![index] ==
                                                            "GOAL 8: Decent Work And Economic Growth"
                                                        ? const Color(
                                                            0xFFA21942)
                                                        : readJsonFileContent
                                                                        .sdgs![
                                                                    index] ==
                                                                "GOAL 9: Industry, Innovation And Infrastructure"
                                                            ? const Color(
                                                                0xFFFD6925)
                                                            : readJsonFileContent
                                                                            .sdgs![
                                                                        index] ==
                                                                    "GOAL 10: Reduced Inequality"
                                                                ? const Color(
                                                                    0xFFDD1367)
                                                                : readJsonFileContent.sdgs![index] ==
                                                                        "GOAL 11: Sustainable Cities And Communities"
                                                                    ? const Color(
                                                                        0xFFFD9D24)
                                                                    : readJsonFileContent.sdgs![index] ==
                                                                            "GOAL 12: Responsible Consumption And Production"
                                                                        ? const Color(0xFFBF8B2E)
                                                                        : readJsonFileContent.sdgs![index] == "GOAL 13: Climate Action"
                                                                            ? const Color(0xFF3F7E44)
                                                                            : readJsonFileContent.sdgs![index] == "GOAL 14: Life Below Water"
                                                                                ? const Color(0xFF0A97D9)
                                                                                : readJsonFileContent.sdgs![index] == "GOAL 15: Life on LAnd"
                                                                                    ? const Color(0xFF56C02B)
                                                                                    : readJsonFileContent.sdgs![index] == "GOAL 16: Peace And Justice Strong Institutions"
                                                                                        ? const Color(0xFF00689D)
                                                                                        : readJsonFileContent.sdgs![index] == "GOAL 17: Partnerships to achieve the Goal"
                                                                                            ? const Color(0xFF00689D)
                                                                                            : kPlatinum,
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                      ),
                    );
                  },
                ),
              ),
        readJsonFileContent.sdgs == null
            ? Container()
            : SizedBox(height: screenSize.height / 30),
      ],
    );
  }
}
