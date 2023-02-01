import 'package:nb_utils/nb_utils.dart';
import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class EditProjectMembersMA extends StatefulWidget {
  const EditProjectMembersMA({
    Key? key,
    
    this.selectedProject,
  }) : super(key: key);

  
  final ProjectModel? selectedProject;

  @override
  State<EditProjectMembersMA> createState() => _EditProjectMembersMAState();
}

class _EditProjectMembersMAState extends State<EditProjectMembersMA> {
  /// Variables used to add more
  bool addNewItemMember = false;
  var fullMembersContainer = <Container>[];
  var fullMembers = <MembersModel>[];

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

  Future<ProjectModel> readMembersInformationJsonData() async {
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

  Future<ProjectModel> writeMembersInformationJsonData(
      ProjectModel selectedProjectInformation) async {
    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(
        "${AppUrl.updateProjectByProjectName}${widget.selectedProject!.projectName}");

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
    _futureProjectInformation = readMembersInformationJsonData();
    readAllUsersJsonData();

    /// VARIABLES USED TO EDIT PROJECT DETAILS
    widget.selectedProject!.members == [] ||
            widget.selectedProject!.members == null
        ? fullMembers = <MembersModel>[]
        : fullMembers = widget.selectedProject!.members!;
    print("fullMembers ${fullMembers.length}");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print("fullMembers ${fullMembers.length}");
    // print("fullMembersContainer $fullMembersContainer");
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

  Column buildBody(BuildContext context) {
    return Column(
              children: [
                buildTitle(context),
                buildAddNewMember(context),
                fullMembers == null || fullMembers.isEmpty
                    ? Container()
                    : Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 16.0),
                        child: FutureBuilder(
                          future: readAllUsersJsonData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                UserModel _selectedMemberData = UserModel();
                                return buildMember(context, _selectedMemberData);
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }
                            }

                            return const CircularProgressIndicator();
                          },
                        ),
                      ),
                fullMembers.isEmpty
                    ? Container()
                    : SizedBox(height:  MediaQuery.of(context).size.height * 0.02),

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
                      "MEMBERS",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        letterSpacing: 4,
                        fontFamily: 'Electrolize',
                        fontSize:  MediaQuery.of(context).size.width * 0.05,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.save_outlined),
                    color: primaryColour,
                    onPressed: () {
                      setState(() {
                        readJsonFileContent.members = fullMembers;
                        readJsonFileContent.totalProjectMembers = 0;

                        if (fullMembers == []) {
                          readJsonFileContent.totalProjectMembers = 0;
                        } else {
                          for (int i = 0; i < fullMembers.length; i++) {
                            if (fullMembers[i].projectJobPosition ==
                                "Project Member") {
                              readJsonFileContent.totalProjectMembers =
                                  readJsonFileContent.totalProjectMembers! +
                                      1;
                            } else {
                              readJsonFileContent.totalProjectMembers = readJsonFileContent.totalProjectMembers! + 0;
                            }
                          }
                          print(readJsonFileContent.totalProjectMembers);
                        }

                        _futureProjectInformation =
                            writeMembersInformationJsonData(
                                readJsonFileContent);
                      });
                    },
                  )
                ],
              );
  }

  buildAddNewMember(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "MEMBERS OF PROJECT",
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
              fullMembers.add(MembersModel());
            });
          },
        )
      ],
    );
  }

  buildMember(BuildContext context, UserModel _selectedMemberData) {
    return SizedBox(
                                height: fullMembers.length *
                                    MediaQuery.of(context).size.height *
                                        0.83 +
                                    ((fullMembers.length - 1) *
                                         MediaQuery.of(context).size.height *
                                        0.02),
                                child: ListView.builder(
                                    itemCount: fullMembers.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          Container(
                                            color: Colors.black12,
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "MEMBER ${index + 1}",
                                                      textAlign:
                                                          TextAlign.left,
                                                      style: TextStyle(
                                                        //letterSpacing: 8,
                                                        fontFamily:
                                                            'Electrolize',
                                                        fontSize:
                                                                MediaQuery.of(context).size
                                                                .width *
                                                            0.045,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.blueGrey,
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment
                                                          .topRight,
                                                      child: IconButton(
                                                        icon: const Icon(
                                                            Icons.clear),
                                                        onPressed: () {
                                                          setState(() {
                                                            fullMembers.remove(
                                                                fullMembers[
                                                                    index]);
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "NAME",
                                                      textAlign:
                                                          TextAlign.left,
                                                      style: TextStyle(
                                                        //letterSpacing: 8,
                                                        fontFamily:
                                                            'Electrolize',
                                                        fontSize:
                                                                MediaQuery.of(context).size
                                                                .width *
                                                            0.035,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                              MediaQuery.of(context).size
                                                              .width *
                                                          0.5,
                                                      height:
                                                              MediaQuery.of(context).size
                                                              .height *
                                                          0.06,
                                                      child: StatefulBuilder(
                                                          builder: (BuildContext
                                                                  context,
                                                              StateSetter
                                                                  dropDownState) {
                                                        return DropdownSearch<
                                                            String>(
                                                          popupElevation:
                                                              0.0,
                                                          dropdownSearchDecoration:
                                                              InputDecoration(
                                                            labelStyle:
                                                                TextStyle(
                                                              color: Colors
                                                                  .grey,
                                                              fontSize:
                                                                      MediaQuery.of(context).size
                                                                      .width /
                                                                  120,
                                                              fontFamily:
                                                                  'Montserrat',
                                                              letterSpacing:
                                                                  3,
                                                            ),
                                                          ),
                                                          //mode of dropdown
                                                          mode: Mode.MENU,
                                                          //to show search box
                                                          showSearchBox:
                                                              true,
                                                          //list of dropdown items
                                                          items:
                                                              _allUserFullNameList,
                                                          onChanged: (String?
                                                              newValue) {
                                                            dropDownState(
                                                                () {
                                                              setState(() {
                                                                fullMembers[index]
                                                                        .memberUsername =
                                                                    _allUserNameList![_allUserFullNameList!.indexWhere((element) =>
                                                                        element ==
                                                                        newValue!)];
                                                                print(fullMembers[
                                                                        index]
                                                                    .memberUsername);
                                                                _selectedMemberData = _allUserData!
                                                                    .where((element) =>
                                                                        element.username ==
                                                                        fullMembers[index].memberUsername)
                                                                    .toList()[0];
                                                                fullMembers[index]
                                                                        .memberUsername =
                                                                    _selectedMemberData
                                                                        .username;
                                                                fullMembers[index]
                                                                        .memberName =
                                                                    "${_selectedMemberData.firstName} ${_selectedMemberData.lastName}";
                                                                fullMembers[index]
                                                                        .jobTitle =
                                                                    _selectedMemberData
                                                                        .jobTitle;
                                                                fullMembers[index]
                                                                        .contractType =
                                                                    _selectedMemberData
                                                                        .jobContractType;
                                                                fullMembers[index]
                                                                        .extension =
                                                                    _selectedMemberData
                                                                        .extension;
                                                                fullMembers[index]
                                                                        .skills =
                                                                    _selectedMemberData
                                                                        .hardSkills;
                                                                fullMembers[index]
                                                                        .phoneNumber =
                                                                    _selectedMemberData
                                                                        .phoneNumber;
                                                                fullMembers[index]
                                                                        .optionalPhoneNumber =
                                                                    _selectedMemberData
                                                                        .optionalPhoneNumber;
                                                                fullMembers[index]
                                                                        .personalEmail =
                                                                    _selectedMemberData
                                                                        .personalEmail;
                                                                fullMembers[index]
                                                                        .workEmail =
                                                                    _selectedMemberData
                                                                        .workEmail;
                                                                //print(_allUserNameList!.indexWhere((element) => element == readJsonFileContent.projectSeniorManager!));
                                                              });
                                                            });
                                                          },
                                                          //show selected item
                                                          selectedItem: fullMembers[
                                                                          index]
                                                                      .memberName ==
                                                                  null
                                                              ? "Member Name"
                                                              : _allUserFullNameList![_allUserNameList!.indexWhere((element) =>
                                                                  element ==
                                                                  fullMembers[
                                                                          index]
                                                                      .memberUsername!)],
                                                        );
                                                      }),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height:
                                                            MediaQuery.of(context).size
                                                            .height /
                                                        70),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "JOB TITLE",
                                                      textAlign:
                                                          TextAlign.left,
                                                      style: TextStyle(
                                                        //letterSpacing: 8,
                                                        fontFamily:
                                                            'Electrolize',
                                                        fontSize:
                                                                MediaQuery.of(context).size
                                                                .width *
                                                            0.035,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                              MediaQuery.of(context).size
                                                              .width *
                                                          0.5,
                                                      height:
                                                              MediaQuery.of(context).size
                                                              .height *
                                                          0.05,
                                                      child: TextFormField(
                                                        minLines: 1,
                                                        maxLines: 250,
                                                        autofocus: false,
                                                        initialValue: fullMembers[
                                                                        index]
                                                                    .jobTitle ==
                                                                null
                                                            ? ""
                                                            : fullMembers[
                                                                    index]
                                                                .jobTitle!
                                                                .toString(),
                                                        cursorColor: DynamicTheme.of(
                                                                        context)
                                                                    ?.brightness ==
                                                                Brightness
                                                                    .light
                                                            ? Colors
                                                                .grey[100]
                                                            : Colors
                                                                .grey[600],
                                                        onChanged:
                                                            (newValue) {
                                                          fullMembers[index]
                                                                  .jobTitle =
                                                              newValue;
                                                        },
                                                        onFieldSubmitted:
                                                            (newValue) {
                                                          fullMembers[index]
                                                                  .jobTitle =
                                                              newValue;
                                                        },
                                                        style:
                                                            const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                        decoration:
                                                            const InputDecoration(
                                                          focusedBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Colors
                                                                  .black,
                                                              width: 0.3,
                                                            ),
                                                          ),
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Colors
                                                                  .black,
                                                              width: 0.3,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height:
                                                            MediaQuery.of(context).size
                                                            .height /
                                                        70),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "ROLE IN PROJECT",
                                                      textAlign:
                                                          TextAlign.left,
                                                      style: TextStyle(
                                                        //letterSpacing: 8,
                                                        fontFamily:
                                                            'Electrolize',
                                                        fontSize:
                                                                MediaQuery.of(context).size
                                                                .width *
                                                            0.035,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                              MediaQuery.of(context).size
                                                              .width *
                                                          0.5,
                                                      height:
                                                              MediaQuery.of(context).size
                                                              .height *
                                                          0.05,
                                                      child: StatefulBuilder(
                                                          builder: (BuildContext
                                                                  context,
                                                              StateSetter
                                                                  dropDownState) {
                                                        return DropdownSearch<
                                                            String>(
                                                          popupElevation:
                                                              0.0,
                                                          dropdownSearchDecoration:
                                                              InputDecoration(
                                                            labelStyle:
                                                                TextStyle(
                                                              color: Colors
                                                                  .grey,
                                                              fontSize:
                                                                      MediaQuery.of(context).size
                                                                      .width *
                                                                  0.01,
                                                              fontFamily:
                                                                  'Montserrat',
                                                              letterSpacing:
                                                                  3,
                                                            ),
                                                          ),
                                                          //mode of dropdown
                                                          mode: Mode.MENU,
                                                          //to show search box
                                                          showSearchBox:
                                                              true,
                                                          //list of dropdown items
                                                          items:
                                                              roleInProjectLabel,
                                                          onChanged: (String?
                                                              newValue) {
                                                            dropDownState(
                                                                () {
                                                              fullMembers[index]
                                                                      .projectJobPosition =
                                                                  newValue!;
                                                            });
                                                          },
                                                          //show selected item
                                                          selectedItem: fullMembers[
                                                                          index]
                                                                      .projectJobPosition ==
                                                                  null
                                                              ? "Role"
                                                              : fullMembers[
                                                                      index]
                                                                  .projectJobPosition!,
                                                        );
                                                      }),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height:
                                                            MediaQuery.of(context).size
                                                            .height /
                                                        70),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "WORK EMAIL",
                                                      textAlign:
                                                          TextAlign.left,
                                                      style: TextStyle(
                                                        //letterSpacing: 8,
                                                        fontFamily:
                                                            'Electrolize',
                                                        fontSize:
                                                                MediaQuery.of(context).size
                                                                .width *
                                                            0.035,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                              MediaQuery.of(context).size
                                                              .width *
                                                          0.5,
                                                      height:
                                                              MediaQuery.of(context).size
                                                              .height *
                                                          0.05,
                                                      child: TextFormField(
                                                        minLines: 1,
                                                        maxLines: 250,
                                                        autofocus: false,
                                                        initialValue: fullMembers[
                                                                        index]
                                                                    .workEmail ==
                                                                null
                                                            ? ""
                                                            : fullMembers[
                                                                    index]
                                                                .workEmail!
                                                                .toString(),
                                                        cursorColor: DynamicTheme.of(
                                                                        context)
                                                                    ?.brightness ==
                                                                Brightness
                                                                    .light
                                                            ? Colors
                                                                .grey[100]
                                                            : Colors
                                                                .grey[600],
                                                        onChanged:
                                                            (newValue) {
                                                          fullMembers[index]
                                                                  .workEmail =
                                                              newValue;
                                                        },
                                                        onFieldSubmitted:
                                                            (newValue) {
                                                          fullMembers[index]
                                                                  .workEmail =
                                                              newValue;
                                                        },
                                                        style:
                                                            const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                        decoration:
                                                            const InputDecoration(
                                                          focusedBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Colors
                                                                  .black,
                                                              width: 0.3,
                                                            ),
                                                          ),
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Colors
                                                                  .black,
                                                              width: 0.3,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height:
                                                            MediaQuery.of(context).size
                                                            .height /
                                                        70),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "PERSONAL EMAIL",
                                                      textAlign:
                                                          TextAlign.left,
                                                      style: TextStyle(
                                                        //letterSpacing: 8,
                                                        fontFamily:
                                                            'Electrolize',
                                                        fontSize:
                                                                MediaQuery.of(context).size
                                                                .width *
                                                            0.035,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                              MediaQuery.of(context).size
                                                              .width *
                                                          0.5,
                                                      height:
                                                              MediaQuery.of(context).size
                                                              .height *
                                                          0.05,
                                                      child: TextFormField(
                                                        minLines: 1,
                                                        maxLines: 250,
                                                        autofocus: false,
                                                        initialValue: fullMembers[
                                                                        index]
                                                                    .personalEmail ==
                                                                null
                                                            ? ""
                                                            : fullMembers[
                                                                    index]
                                                                .personalEmail!
                                                                .toString(),
                                                        cursorColor: DynamicTheme.of(
                                                                        context)
                                                                    ?.brightness ==
                                                                Brightness
                                                                    .light
                                                            ? Colors
                                                                .grey[100]
                                                            : Colors
                                                                .grey[600],
                                                        onChanged:
                                                            (newValue) {
                                                          fullMembers[index]
                                                                  .personalEmail =
                                                              newValue;
                                                        },
                                                        onFieldSubmitted:
                                                            (newValue) {
                                                          fullMembers[index]
                                                                  .personalEmail =
                                                              newValue;
                                                        },
                                                        style:
                                                            const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                        decoration:
                                                            const InputDecoration(
                                                          focusedBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Colors
                                                                  .black,
                                                              width: 0.3,
                                                            ),
                                                          ),
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Colors
                                                                  .black,
                                                              width: 0.3,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height:
                                                            MediaQuery.of(context).size
                                                            .height /
                                                        70),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "PHONE NUMBER",
                                                      textAlign:
                                                          TextAlign.left,
                                                      style: TextStyle(
                                                        //letterSpacing: 8,
                                                        fontFamily:
                                                            'Electrolize',
                                                        fontSize:
                                                                MediaQuery.of(context).size
                                                                .width *
                                                            0.035,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                              MediaQuery.of(context).size
                                                              .width *
                                                          0.5,
                                                      height:
                                                              MediaQuery.of(context).size
                                                              .height *
                                                          0.05,
                                                      child: TextFormField(
                                                        minLines: 1,
                                                        maxLines: 250,
                                                        autofocus: false,
                                                        initialValue: fullMembers[
                                                                        index]
                                                                    .phoneNumber ==
                                                                null
                                                            ? ""
                                                            : fullMembers[
                                                                    index]
                                                                .phoneNumber!
                                                                .toString(),
                                                        cursorColor: DynamicTheme.of(
                                                                        context)
                                                                    ?.brightness ==
                                                                Brightness
                                                                    .light
                                                            ? Colors
                                                                .grey[100]
                                                            : Colors
                                                                .grey[600],
                                                        onChanged:
                                                            (newValue) {
                                                          fullMembers[index]
                                                                  .phoneNumber =
                                                              newValue;
                                                        },
                                                        onFieldSubmitted:
                                                            (newValue) {
                                                          fullMembers[index]
                                                                  .phoneNumber =
                                                              newValue;
                                                        },
                                                        style:
                                                            const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                        decoration:
                                                            const InputDecoration(
                                                          focusedBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Colors
                                                                  .black,
                                                              width: 0.3,
                                                            ),
                                                          ),
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Colors
                                                                  .black,
                                                              width: 0.3,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height:
                                                            MediaQuery.of(context).size
                                                            .height /
                                                        70),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "PN OPTIONAL",
                                                      textAlign:
                                                          TextAlign.left,
                                                      style: TextStyle(
                                                        //letterSpacing: 8,
                                                        fontFamily:
                                                            'Electrolize',
                                                        fontSize:
                                                                MediaQuery.of(context).size
                                                                .width *
                                                            0.035,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                              MediaQuery.of(context).size
                                                              .width *
                                                          0.5,
                                                      height:
                                                              MediaQuery.of(context).size
                                                              .height *
                                                          0.05,
                                                      child: TextFormField(
                                                        minLines: 1,
                                                        maxLines: 250,
                                                        autofocus: false,
                                                        initialValue: fullMembers[
                                                                        index]
                                                                    .optionalPhoneNumber ==
                                                                null
                                                            ? ""
                                                            : fullMembers[
                                                                    index]
                                                                .optionalPhoneNumber!
                                                                .toString(),
                                                        cursorColor: DynamicTheme.of(
                                                                        context)
                                                                    ?.brightness ==
                                                                Brightness
                                                                    .light
                                                            ? Colors
                                                                .grey[100]
                                                            : Colors
                                                                .grey[600],
                                                        onChanged:
                                                            (newValue) {
                                                          fullMembers[index]
                                                                  .optionalPhoneNumber =
                                                              newValue;
                                                        },
                                                        onFieldSubmitted:
                                                            (newValue) {
                                                          fullMembers[index]
                                                                  .optionalPhoneNumber =
                                                              newValue;
                                                        },
                                                        style:
                                                            const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                        decoration:
                                                            const InputDecoration(
                                                          focusedBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Colors
                                                                  .black,
                                                              width: 0.3,
                                                            ),
                                                          ),
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Colors
                                                                  .black,
                                                              width: 0.3,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height:
                                                            MediaQuery.of(context).size
                                                            .height /
                                                        70),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "CONTRACT TYPE",
                                                      textAlign:
                                                          TextAlign.left,
                                                      style: TextStyle(
                                                        //letterSpacing: 8,
                                                        fontFamily:
                                                            'Electrolize',
                                                        fontSize:
                                                                MediaQuery.of(context).size
                                                                .width *
                                                            0.035,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                              MediaQuery.of(context).size
                                                              .width *
                                                          0.5,
                                                      height:
                                                              MediaQuery.of(context).size
                                                              .height *
                                                          0.06,
                                                      child: StatefulBuilder(
                                                          builder: (BuildContext
                                                                  context,
                                                              StateSetter
                                                                  dropDownState) {
                                                        return DropdownSearch<
                                                            String>(
                                                          popupElevation:
                                                              0.0,
                                                          dropdownSearchDecoration:
                                                              InputDecoration(
                                                            labelStyle:
                                                                TextStyle(
                                                              color: Colors
                                                                  .grey,
                                                              fontSize:
                                                                      MediaQuery.of(context).size
                                                                      .width /
                                                                  120,
                                                              fontFamily:
                                                                  'Montserrat',
                                                              letterSpacing:
                                                                  3,
                                                            ),
                                                          ),
                                                          //mode of dropdown
                                                          mode: Mode.MENU,
                                                          //to show search box
                                                          showSearchBox:
                                                              true,
                                                          //list of dropdown items
                                                          items:
                                                              contractTypeList,
                                                          onChanged: (String?
                                                              newValue) {
                                                            dropDownState(
                                                                () {
                                                              setState(() {
                                                                fullMembers[index]
                                                                        .contractType =
                                                                    newValue!;
                                                              });
                                                            });
                                                          },
                                                          //show selected item
                                                          selectedItem: fullMembers[
                                                                          index]
                                                                      .contractType ==
                                                                  null
                                                              ? "Contract Type"
                                                              : fullMembers[
                                                                      index]
                                                                  .contractType!,
                                                        );
                                                      }),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height:
                                                            MediaQuery.of(context).size
                                                            .height /
                                                        70),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "EXTENSION",
                                                      textAlign:
                                                          TextAlign.left,
                                                      style: TextStyle(
                                                        //letterSpacing: 8,
                                                        fontFamily:
                                                            'Electrolize',
                                                        fontSize:
                                                                MediaQuery.of(context).size
                                                                .width *
                                                            0.035,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                              MediaQuery.of(context).size
                                                              .width *
                                                          0.5,
                                                      height:
                                                              MediaQuery.of(context).size
                                                              .height *
                                                          0.05,
                                                      child: TextFormField(
                                                        minLines: 1,
                                                        maxLines: 250,
                                                        autofocus: false,
                                                        initialValue: fullMembers[
                                                                        index]
                                                                    .extension ==
                                                                null
                                                            ? ""
                                                            : fullMembers[
                                                                    index]
                                                                .extension!
                                                                .toString(),
                                                        cursorColor: DynamicTheme.of(
                                                                        context)
                                                                    ?.brightness ==
                                                                Brightness
                                                                    .light
                                                            ? Colors
                                                                .grey[100]
                                                            : Colors
                                                                .grey[600],
                                                        onChanged:
                                                            (newValue) {
                                                          fullMembers[index]
                                                                  .extension =
                                                              newValue;
                                                        },
                                                        onFieldSubmitted:
                                                            (newValue) {
                                                          fullMembers[index]
                                                                  .extension =
                                                              newValue;
                                                        },
                                                        style:
                                                            const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                        decoration:
                                                            const InputDecoration(
                                                          focusedBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Colors
                                                                  .black,
                                                              width: 0.3,
                                                            ),
                                                          ),
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Colors
                                                                  .black,
                                                              width: 0.3,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height:
                                                            MediaQuery.of(context).size
                                                            .height /
                                                        70),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "DURATION (in weeks)",
                                                      textAlign:
                                                          TextAlign.left,
                                                      style: TextStyle(
                                                        //letterSpacing: 8,
                                                        fontFamily:
                                                            'Electrolize',
                                                        fontSize:
                                                                MediaQuery.of(context).size
                                                                .width *
                                                            0.035,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      //
                                                      width:
                                                              MediaQuery.of(context).size
                                                              .width *
                                                          0.3,
                                                      height:
                                                              MediaQuery.of(context).size
                                                              .height *
                                                          0.05,
                                                      child: TextFormField(
                                                        minLines: 1,
                                                        maxLines: 250,
                                                        autofocus: false,
                                                        initialValue: fullMembers[
                                                                        index]
                                                                    .duration ==
                                                                null
                                                            ? ""
                                                            : fullMembers[
                                                                    index]
                                                                .duration!
                                                                .toString(),
                                                        cursorColor: DynamicTheme.of(
                                                                        context)
                                                                    ?.brightness ==
                                                                Brightness
                                                                    .light
                                                            ? Colors
                                                                .grey[100]
                                                            : Colors
                                                                .grey[600],
                                                        onChanged:
                                                            (newValue) {
                                                          fullMembers[index]
                                                                  .duration =
                                                              double.parse(
                                                                  newValue);
                                                        },
                                                        onFieldSubmitted:
                                                            (newValue) {
                                                          fullMembers[index]
                                                                  .duration =
                                                              double.parse(
                                                                  newValue);
                                                        },
                                                        style:
                                                            const TextStyle(
                                                          fontSize: 16,
                                                        ),
                                                        decoration:
                                                            const InputDecoration(
                                                          focusedBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Colors
                                                                  .black,
                                                              width: 0.3,
                                                            ),
                                                          ),
                                                          enabledBorder:
                                                              UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                              color: Colors
                                                                  .black,
                                                              width: 0.3,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height:
                                                            MediaQuery.of(context).size
                                                            .height /
                                                        70),
                                                Row(
                                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                              MediaQuery.of(context).size
                                                              .height /
                                                          25,
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .access_time_outlined,
                                                          ),
                                                          SizedBox(
                                                              width:
                                                                      MediaQuery.of(context).size
                                                                      .width /
                                                                  50),
                                                          Text(
                                                            "START DATE",
                                                            textAlign:
                                                                TextAlign
                                                                    .left,
                                                            style:
                                                                TextStyle(
                                                              //letterSpacing: 8,
                                                              fontFamily:
                                                                  'Electrolize',
                                                              fontSize:
                                                                      MediaQuery.of(context).size
                                                                      .width *
                                                                  0.035,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        width: 110),
                                                    SizedBox(
                                                      height:
                                                              MediaQuery.of(context).size
                                                              .height /
                                                          25,
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .access_time_outlined,
                                                          ),
                                                          SizedBox(
                                                              width:
                                                                      MediaQuery.of(context).size
                                                                      .width /
                                                                  50),
                                                          Text(
                                                            "END DATE",
                                                            textAlign:
                                                                TextAlign
                                                                    .left,
                                                            style:
                                                                TextStyle(
                                                              //letterSpacing: 8,
                                                              fontFamily:
                                                                  'Electrolize',
                                                              fontSize:
                                                                      MediaQuery.of(context).size
                                                                      .width *
                                                                  0.035,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                              MediaQuery.of(context).size
                                                              .width /
                                                          3,
                                                      child:
                                                          CupertinoDateTextBox(
                                                        initialValue: fullMembers[
                                                                        index]
                                                                    .startDate ==
                                                                null
                                                            ? DateTime.now()
                                                            : DateFormat(
                                                                    "yyyy-MM-dd")
                                                                .parse(fullMembers[
                                                                        index]
                                                                    .startDate!),
                                                        onDateChange:
                                                            (DateTime?
                                                                newDate) {
                                                          //print(newDate);
                                                          setState(() {
                                                            fullMembers[index]
                                                                    .startDate =
                                                                newDate!
                                                                    .toIso8601String();
                                                          });
                                                        },
                                                        hintText: fullMembers[
                                                                        index]
                                                                    .startDate ==
                                                                null
                                                            ? DateFormat()
                                                                .format(
                                                                    DateTime
                                                                        .now())
                                                            : fullMembers[
                                                                    index]
                                                                .startDate!,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                              MediaQuery.of(context).size
                                                              .width /
                                                          3,
                                                      child:
                                                          CupertinoDateTextBox(
                                                        initialValue: fullMembers[
                                                                        index]
                                                                    .endDate ==
                                                                null
                                                            ? DateTime.now()
                                                            : DateFormat(
                                                                    'yyyy-MM-dd')
                                                                .parse(fullMembers[
                                                                        index]
                                                                    .endDate!),
                                                        onDateChange:
                                                            (DateTime?
                                                                newDate) {
                                                          // print(newDate);
                                                          setState(() {
                                                            fullMembers[
                                                                    index]
                                                                .endDate = DateFormat(
                                                                    'yyyy-MM-dd')
                                                                .format(
                                                                    newDate!);
                                                          });
                                                        },
                                                        hintText: fullMembers[
                                                                        index]
                                                                    .endDate ==
                                                                null
                                                            ? DateFormat()
                                                                .format(
                                                                    DateTime
                                                                        .now())
                                                            : fullMembers[
                                                                    index]
                                                                .endDate!,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height:
                                                            MediaQuery.of(context).size
                                                            .height /
                                                        70),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              height:
                                                   MediaQuery.of(context).size.height *
                                                      0.02)
                                        ],
                                      );
                                    }),
                              );
  }
}
