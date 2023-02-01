import 'package:nb_utils/nb_utils.dart';
import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class EditPeopleWhoAreAllowedToViewProjectMA extends StatefulWidget {
  const EditPeopleWhoAreAllowedToViewProjectMA({
    Key? key,
    this.selectedProject,
  }) : super(key: key);

  final ProjectModel? selectedProject;

  @override
  State<EditPeopleWhoAreAllowedToViewProjectMA> createState() =>
      _EditPeopleWhoAreAllowedToViewProjectMAState();
}

class _EditPeopleWhoAreAllowedToViewProjectMAState
    extends State<EditPeopleWhoAreAllowedToViewProjectMA> {
  /// Variables used to add more
  bool addNewItemMember = false;
  var fullPeopleAllowedToViewProjectContainer = <Container>[];
  var fullPeopleAllowedToViewProject = <MembersModel>[];

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

    _allUserNameList = <String>[];
    _allUserFullNameList = <String>[];

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

  Future<ProjectModel>
      readPeopleAllowedToViewProjectInformationJsonData() async {
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

  Future<ProjectModel> writePeopleAllowedToViewProjectInformationJsonData(
      ProjectModel selectedProjectInformation) async {
    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(
        "${AppUrl.updateProjectByProjectName}${widget.selectedProject!.projectName}");

    //print(selectedProjectInformation);

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
    _futureProjectInformation =
        readPeopleAllowedToViewProjectInformationJsonData();
    readAllUsersJsonData();

    /// VARIABLES USED TO EDIT PROJECT DETAILS
    widget.selectedProject!.members == [] ||
            widget.selectedProject!.members == null
        ? fullPeopleAllowedToViewProject = <MembersModel>[]
        : fullPeopleAllowedToViewProject = widget.selectedProject!.members!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print("fullPeopleAllowedToViewProject ${fullPeopleAllowedToViewProject.length}");
    // print("fullPeopleAllowedToViewProjectContainer $fullPeopleAllowedToViewProjectContainer");
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1.0),
      child: FutureBuilder<ProjectModel>(
        future: _futureProjectInformation,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return buildBody(context);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }

  buildBody(BuildContext context) {
    return Column(
      children: [
        buildTitle(context),
        buildAddNewViewer(context),
        fullPeopleAllowedToViewProject == null ||
                fullPeopleAllowedToViewProject.isEmpty
            ? Container()
            : Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 16.0),
                child: FutureBuilder(
                  future: readAllUsersJsonData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        UserModel _selectedMemberData = UserModel();
                        return buildViewer(context, _selectedMemberData);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                    }

                    return const CircularProgressIndicator();
                  },
                ),
              ),
        fullPeopleAllowedToViewProject == null ||
                fullPeopleAllowedToViewProject.isEmpty
            ? Container()
            : SizedBox(height: MediaQuery.of(context).size.height * 0.02),
      ],
    );
  }

  buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "PEOPLE WHO ARE\nALLOWED TO VIEW THE\nPROJECT",
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
              readJsonFileContent.members = fullPeopleAllowedToViewProject;
              _futureProjectInformation =
                  writePeopleAllowedToViewProjectInformationJsonData(
                      readJsonFileContent);
            });
          },
        )
      ],
    );
  }

  buildAddNewViewer(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "VIEWERS OF PROJECT",
            textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 1,
              fontFamily: 'Electrolize',
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              fullPeopleAllowedToViewProject.add(MembersModel());
            });
          },
        )
      ],
    );
  }

  buildViewer(BuildContext context, UserModel _selectedMemberData) {
    return SizedBox(
      height: fullPeopleAllowedToViewProject.length *
              MediaQuery.of(context).size.height *
              0.55 +
          ((fullPeopleAllowedToViewProject.length - 1) *
              MediaQuery.of(context).size.height *
              0.02),
      child: ListView.builder(
          itemCount: fullPeopleAllowedToViewProject.length,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  color: Colors.black12,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "PERSON ${index + 1}",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              //letterSpacing: 8,
                              fontFamily: 'Electrolize',
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.045,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  fullPeopleAllowedToViewProject.remove(
                                      fullPeopleAllowedToViewProject[index]);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "NAME",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              //letterSpacing: 8,
                              fontFamily: 'Electrolize',
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height * 0.06,
                            child: StatefulBuilder(builder:
                                (BuildContext context,
                                    StateSetter dropDownState) {
                              return DropdownSearch<String>(
                                popupElevation: 0.0,
                                dropdownSearchDecoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize:
                                        MediaQuery.of(context).size.width / 120,
                                    fontFamily: 'Montserrat',
                                    letterSpacing: 3,
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
                                    setState(() {
                                      fullPeopleAllowedToViewProject[index]
                                              .memberUsername =
                                          _allUserNameList![
                                              _allUserFullNameList!.indexWhere(
                                                  (element) =>
                                                      element == newValue!)];

                                      _selectedMemberData = _allUserData!
                                          .where((element) =>
                                              element.username ==
                                              fullPeopleAllowedToViewProject[
                                                      index]
                                                  .memberUsername)
                                          .toList()[0];
                                      fullPeopleAllowedToViewProject[index]
                                              .memberUsername =
                                          _selectedMemberData.username;
                                      fullPeopleAllowedToViewProject[index]
                                              .memberUsername =
                                          "${_selectedMemberData.firstName} ${_selectedMemberData.lastName}";
                                      fullPeopleAllowedToViewProject[index]
                                              .jobTitle =
                                          _selectedMemberData.jobTitle;
                                      fullPeopleAllowedToViewProject[index]
                                              .contractType =
                                          _selectedMemberData.jobContractType;
                                      fullPeopleAllowedToViewProject[index]
                                              .extension =
                                          _selectedMemberData.extension;
                                      fullPeopleAllowedToViewProject[index]
                                              .skills =
                                          _selectedMemberData.hardSkills;
                                      fullPeopleAllowedToViewProject[index]
                                              .phoneNumber =
                                          _selectedMemberData.phoneNumber;
                                      fullPeopleAllowedToViewProject[index]
                                              .optionalPhoneNumber =
                                          _selectedMemberData
                                              .optionalPhoneNumber;
                                      fullPeopleAllowedToViewProject[index]
                                              .personalEmail =
                                          _selectedMemberData.personalEmail;
                                      fullPeopleAllowedToViewProject[index]
                                              .workEmail =
                                          _selectedMemberData.workEmail;
                                      //print(_allUserNameList!.indexWhere((element) => element == readJsonFileContent.projectSeniorManager!));
                                    });
                                  });
                                },
                                //show selected item
                                selectedItem: fullPeopleAllowedToViewProject[
                                                index]
                                            .memberUsername ==
                                        null
                                    ? "Person Name"
                                    : _allUserFullNameList![_allUserNameList!
                                        .indexWhere((element) =>
                                            element ==
                                            fullPeopleAllowedToViewProject[
                                                    index]
                                                .memberUsername!)],
                              );
                            }),
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 70),
                      SizedBox(height: MediaQuery.of(context).size.height / 70),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "WORK EMAIL",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              //letterSpacing: 8,
                              fontFamily: 'Electrolize',
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: TextFormField(
                              minLines: 1,
                              maxLines: 250,
                              autofocus: false,
                              initialValue:
                                  fullPeopleAllowedToViewProject[index]
                                              .workEmail ==
                                          null
                                      ? ""
                                      : fullPeopleAllowedToViewProject[index]
                                          .workEmail!
                                          .toString(),
                              cursorColor:
                                  DynamicTheme.of(context)?.brightness ==
                                          Brightness.light
                                      ? Colors.grey[100]
                                      : Colors.grey[600],
                              onChanged: (newValue) {
                                fullPeopleAllowedToViewProject[index]
                                    .workEmail = newValue;
                              },
                              onFieldSubmitted: (newValue) {
                                fullPeopleAllowedToViewProject[index]
                                    .workEmail = newValue;
                              },
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 0.3,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 0.3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 70),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "PERSONAL EMAIL",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              //letterSpacing: 8,
                              fontFamily: 'Electrolize',
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: TextFormField(
                              minLines: 1,
                              maxLines: 250,
                              autofocus: false,
                              initialValue:
                                  fullPeopleAllowedToViewProject[index]
                                              .personalEmail ==
                                          null
                                      ? ""
                                      : fullPeopleAllowedToViewProject[index]
                                          .personalEmail!
                                          .toString(),
                              cursorColor:
                                  DynamicTheme.of(context)?.brightness ==
                                          Brightness.light
                                      ? Colors.grey[100]
                                      : Colors.grey[600],
                              onChanged: (newValue) {
                                fullPeopleAllowedToViewProject[index]
                                    .personalEmail = newValue;
                              },
                              onFieldSubmitted: (newValue) {
                                fullPeopleAllowedToViewProject[index]
                                    .personalEmail = newValue;
                              },
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 0.3,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 0.3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 70),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "PHONE NUMBER",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              //letterSpacing: 8,
                              fontFamily: 'Electrolize',
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: TextFormField(
                              minLines: 1,
                              maxLines: 250,
                              autofocus: false,
                              initialValue:
                                  fullPeopleAllowedToViewProject[index]
                                              .phoneNumber ==
                                          null
                                      ? ""
                                      : fullPeopleAllowedToViewProject[index]
                                          .phoneNumber!
                                          .toString(),
                              cursorColor:
                                  DynamicTheme.of(context)?.brightness ==
                                          Brightness.light
                                      ? Colors.grey[100]
                                      : Colors.grey[600],
                              onChanged: (newValue) {
                                fullPeopleAllowedToViewProject[index]
                                    .phoneNumber = newValue;
                              },
                              onFieldSubmitted: (newValue) {
                                fullPeopleAllowedToViewProject[index]
                                    .phoneNumber = newValue;
                              },
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 0.3,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 0.3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 70),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "PN OPTIONAL",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              //letterSpacing: 8,
                              fontFamily: 'Electrolize',
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: TextFormField(
                              minLines: 1,
                              maxLines: 250,
                              autofocus: false,
                              initialValue:
                                  fullPeopleAllowedToViewProject[index]
                                              .optionalPhoneNumber ==
                                          null
                                      ? ""
                                      : fullPeopleAllowedToViewProject[index]
                                          .optionalPhoneNumber!
                                          .toString(),
                              cursorColor:
                                  DynamicTheme.of(context)?.brightness ==
                                          Brightness.light
                                      ? Colors.grey[100]
                                      : Colors.grey[600],
                              onChanged: (newValue) {
                                fullPeopleAllowedToViewProject[index]
                                    .optionalPhoneNumber = newValue;
                              },
                              onFieldSubmitted: (newValue) {
                                fullPeopleAllowedToViewProject[index]
                                    .optionalPhoneNumber = newValue;
                              },
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 0.3,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 0.3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 70),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "DURATION (in weeks)",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              //letterSpacing: 8,
                              fontFamily: 'Electrolize',
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            //
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: TextFormField(
                              minLines: 1,
                              maxLines: 250,
                              autofocus: false,
                              initialValue:
                                  fullPeopleAllowedToViewProject[index]
                                              .duration ==
                                          null
                                      ? ""
                                      : fullPeopleAllowedToViewProject[index]
                                          .duration!
                                          .toString(),
                              cursorColor:
                                  DynamicTheme.of(context)?.brightness ==
                                          Brightness.light
                                      ? Colors.grey[100]
                                      : Colors.grey[600],
                              onChanged: (newValue) {
                                fullPeopleAllowedToViewProject[index].duration =
                                    double.parse(newValue);
                              },
                              onFieldSubmitted: (newValue) {
                                fullPeopleAllowedToViewProject[index].duration =
                                    double.parse(newValue);
                              },
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                              decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 0.3,
                                  ),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 0.3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height / 70),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02)
              ],
            );
          }),
    );
  }
}
