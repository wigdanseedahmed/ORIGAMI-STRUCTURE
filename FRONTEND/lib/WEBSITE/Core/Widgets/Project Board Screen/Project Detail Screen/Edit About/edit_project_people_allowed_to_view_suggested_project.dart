import 'dart:ui';

import 'package:nb_utils/nb_utils.dart';
import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class EditPeopleWhoAreAllowedToViewProjectWS extends StatefulWidget {
  const EditPeopleWhoAreAllowedToViewProjectWS({
    Key? key,
    required this.selectedUser,
    this.selectedProject,
    required this.navigationMenu,
  }) : super(key: key);

  final UserModel? selectedUser;
  final ProjectModel? selectedProject;
  final NavigationMenu navigationMenu;

  @override
  State<EditPeopleWhoAreAllowedToViewProjectWS> createState() =>
      _EditPeopleWhoAreAllowedToViewProjectWSState();
}

class _EditPeopleWhoAreAllowedToViewProjectWSState
    extends State<EditPeopleWhoAreAllowedToViewProjectWS> {
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

  Future<ProjectModel> writeProjectData(ProjectModel selectedProjectInformation) async {
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
        readProjectData();
    readAllUsersJsonData();

    /// VARIABLES USED TO EDIT PROJECT DETAILS
    widget.selectedProject!.members == [] ||
            widget.selectedProject!.members == null
        ? fullPeopleAllowedToViewProject = <MembersModel>[]
        : fullPeopleAllowedToViewProject =
            widget.selectedProject!.members!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1.0),
      child: FutureBuilder<ProjectModel>(
        future: _futureProjectInformation,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              rows.clear();
              if (fullPeopleAllowedToViewProject == null || fullPeopleAllowedToViewProject.isEmpty) {
                rows;
              } else {
                for (int i = 0;
                i < fullPeopleAllowedToViewProject.length;
                i++) {
                  rows.add(
                    PlutoRow(
                      cells: {
                        'id': PlutoCell(value: '${i + 1}'),
                        'name': PlutoCell(
                            value: fullPeopleAllowedToViewProject[i]
                                .memberName),
                        'job title': PlutoCell(
                            value: fullPeopleAllowedToViewProject[i].jobTitle),
                        'phone number': PlutoCell(
                            value: fullPeopleAllowedToViewProject[i].phoneNumber),
                        'optional phone number': PlutoCell(
                            value: fullPeopleAllowedToViewProject[i].optionalPhoneNumber),
                        'work email': PlutoCell(
                            value: fullPeopleAllowedToViewProject[i].workEmail),
                        'contract type': PlutoCell(
                            value: fullPeopleAllowedToViewProject[i].contractType),
                        'start date': PlutoCell(
                            value: fullPeopleAllowedToViewProject[i].startDate),
                        'end date': PlutoCell(
                            value: fullPeopleAllowedToViewProject[i].endDate),
                        'duration': PlutoCell(
                            value: fullPeopleAllowedToViewProject[i].duration),
                      },
                    ),
                  );
                }
              }
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

  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      title: 'Id',
      field: 'id',
      type: PlutoColumnType.text(),
      backgroundColor: kShamrock,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Name',
      field: 'name',
      type: PlutoColumnType.text(),
      backgroundColor: kShamrock,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Job Title',
      field: 'job title',
      type: PlutoColumnType.text(),
      backgroundColor: kBlueChill,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Phone Number',
      field: 'phone number',
      type: PlutoColumnType.text(),
      backgroundColor: kDeepSapphire,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Optional Phone Number',
      field: 'optional phone number',
      type: PlutoColumnType.text(),
      backgroundColor: kDeepSapphire,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Work Email',
      field: 'work email',
      type: PlutoColumnType.text(),
      backgroundColor: kDeepSapphire,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Contract Type',
      field: 'contract type',
      type: PlutoColumnType.text(),
      backgroundColor: kTolopea,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Start Date',
      field: 'start date',
      type: PlutoColumnType.date(),
      backgroundColor: kViolet,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'End Date',
      field: 'end date',
      type: PlutoColumnType.date(),
      backgroundColor: kViolet,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Duration',
      field: 'duration',
      type: PlutoColumnType.number(),
      backgroundColor: kViolet,
      enableEditingMode: true,
    ),
  ];

  final List<PlutoRow> rows = [];

  /// columnGroups that can group columns can be omitted.
  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(title: 'Id', fields: ['id'], expandedColumn: true),
    PlutoColumnGroup(title: 'Name', fields: ['name'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Job Title', fields: ['job title'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Phone Number', fields: ['phone number'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Optional Phone Number',
        fields: ['optional phone number'],
        expandedColumn: true),
    PlutoColumnGroup(
        title: 'Work Email', fields: ['work email'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Contract Type',
        fields: ['contract type'],
        expandedColumn: true),
    PlutoColumnGroup(
        title: 'Start Date', fields: ['start date'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'End Date', fields: ['end date'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Duration', fields: ['duration'], expandedColumn: true),
  ];



  buildBody(BuildContext context, Size screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "PEOPLE WHO ARE ALLOWED TO VIEW THE PROJECT",
              textAlign: TextAlign.left,
              style: TextStyle(
                letterSpacing: 1,
                fontFamily: 'Electrolize',
                fontSize: MediaQuery.of(context).size.width / 75,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: (() {
                    setState(() {
                      if (bodyViewSelected == "Table") {
                        bodyViewSelected = "Grid";
                      } else if (bodyViewSelected == "Grid") {
                        bodyViewSelected = "Table";
                      }
                    });
                  }),
                  icon: Icon(
                    bodyViewSelected == "Table"
                        ? Icons.grid_view_rounded
                        : Icons.table_view_rounded,
                  ),
                ),
                bodyViewSelected == "Table"
                    ? tableOptionsPopup(): gridOptionsPopup(),
              ],
            ),
          ],
        ),
        SizedBox(height: screenSize.height / 20),
        // buildMap(context, screenSize),

        bodyViewSelected == "Table"
            ? buildTable(context, screenSize)
            : buildGrid(context),
      ],
    );
  }

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late PlutoGridStateManager stateManager;

  late String bodyViewSelected = "Table";

  int addCount = 1;

  int addedCount = 0;

  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  void handleAddColumns() {
    final List<PlutoColumn> addedColumns = [];

    for (var i = 0; i < addCount; i += 1) {
      addedColumns.add(
        PlutoColumn(
          title: "column${++addedCount}",
          field: 'column${++addedCount}',
          type: PlutoColumnType.text(),
        ),
      );
    }

    stateManager.insertColumns(
      stateManager.bodyColumns.length,
      addedColumns,
    );
  }

  void handleAddRows() {
    setState(() {
      fullPeopleAllowedToViewProject
          .add(MembersModel()..memberID = "${fullPeopleAllowedToViewProject.length + 1}");

      final newRows = stateManager.getNewRows(count: addCount);

      stateManager.appendRows(newRows);

      stateManager.setCurrentCell(
        newRows.first.cells.entries.first.value,
        stateManager.refRows.length - 1,
      );

      stateManager.moveScrollByRow(
        PlutoMoveDirection.down,
        stateManager.refRows.length - 2,
      );

      stateManager.setKeepFocus(true);

      readJsonFileContent.members = fullPeopleAllowedToViewProject;

      fullPeopleAllowedToViewProject == []
          ? readJsonFileContent.locationsNumber = 0
          : readJsonFileContent.locationsNumber = fullPeopleAllowedToViewProject.length;

      _futureProjectInformation = writeProjectData(readJsonFileContent);
    });
  }

  void handleAddGrids() {
    setState(() {
      fullPeopleAllowedToViewProject
          .add(MembersModel()..memberID = "${fullPeopleAllowedToViewProject.length + 1}");

      readJsonFileContent.members = fullPeopleAllowedToViewProject;

      fullPeopleAllowedToViewProject == []
          ? readJsonFileContent.locationsNumber = 0
          : readJsonFileContent.locationsNumber = fullPeopleAllowedToViewProject.length;

      _futureProjectInformation = writeProjectData(readJsonFileContent);
    });
  }

  void handleSaveAll() {
    stateManager.setShowLoading(true);

    Future.delayed(const Duration(milliseconds: 500), () {
      for (var row in stateManager.refRows) {
        if (row.cells['id']!.value == '') {
          row.cells['id']!.value = 'guest';
        }

        if (row.cells['name']!.value == '') {
          row.cells['name']!.value = 'anonymous';
        }
      }

      stateManager.setShowLoading(false);
    });
  }

  void handleRemoveCurrentColumnButton() {
    final currentColumn = stateManager.currentColumn;

    if (currentColumn == null) {
      return;
    }

    stateManager.removeColumns([currentColumn]);
  }

  void handleRemoveCurrentRowButton() {
    setState(() {
      fullPeopleAllowedToViewProject.removeAt(stateManager.currentRowIdx!);

      stateManager.removeCurrentRow();

      readJsonFileContent.members = fullPeopleAllowedToViewProject;

      _futureProjectInformation = writeProjectData(readJsonFileContent);
    });
  }

  void handleRemoveSelectedRowsButton() {
    setState(() {
      print(stateManager.currentSelectingRows);
      print(stateManager.currentSelectingRows.last.sortIdx!);
      // fullPeopleAllowedToViewProject.removeRange(stateManager.currentSelectingRows);

      stateManager.removeRows(stateManager.currentSelectingRows);

      readJsonFileContent.members = fullPeopleAllowedToViewProject;

      _futureProjectInformation = writeProjectData(readJsonFileContent);
    });
  }

  void handleFiltering() {
    stateManager.setShowColumnFilter(!stateManager.showColumnFilter);
  }

  void setGridSelectingMode(PlutoGridSelectingMode? mode) {
    if (mode == null || gridSelectingMode == mode) {
      return;
    }

    setState(() {
      gridSelectingMode = mode;
      stateManager.setSelectingMode(mode);
    });
  }

  Widget tableOptionsPopup() => PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert_sharp),
      offset: const Offset(0, 0),
      itemBuilder: (context) => [
        /*const PopupMenuItem(
        value: 1,
        child: Text(
          "Add Columns",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),*/
        const PopupMenuItem(
          value: 2,
          child: Text(
            "Add New Person",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        /* const PopupMenuItem(
        value: 3,
        child: Text(
          "Save All",
          style: TextStyle(
              fontWeight: FontWeight.w700),
        ),
      ),*/
        /*const PopupMenuItem(
        value: 4,
        child: Text(
          "Remove Current Column",
          style: TextStyle(
              fontWeight: FontWeight.w700),
        ),
      ),*/
        const PopupMenuItem(
          value: 5,
          child: Text(
            "Remove Current Selected Person",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ), const PopupMenuItem(
          value: 6,
          child: Text(
            "Remove Selected People",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        /* const PopupMenuItem(
        value: 7,
        child: Text(
          "Toggle Filtering",
          style: TextStyle(
              fontWeight: FontWeight.w700),
        ),
      ),*/
        /* const PopupMenuItem(
        value: 8,
        child: Text(
          "Cells",
          style: TextStyle(
              fontWeight: FontWeight.w700),
        ),
      ),*/
      ],
      onSelected: (int) {
        setState(() {
          int == 1
              ? handleAddColumns()
              : int == 2
              ? bodyViewSelected == "Table"
              ? handleAddRows()
              : handleAddGrids()
              : int == 3
              ? handleSaveAll()
              : int == 4
              ? handleRemoveCurrentColumnButton()
              : int == 5
              ? handleRemoveCurrentRowButton()
              : int == 6
              ? handleRemoveSelectedRowsButton()
              : int == 7
              ? handleFiltering()
              : Container();
        });
      });

  Widget gridOptionsPopup() => PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert_sharp),
      offset: const Offset(0, 0),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 2,
          child: Text(
            "Add New People",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
      onSelected: (int) {
        setState(() {
          int == 1
              ? handleAddColumns()
              : int == 2
              ? bodyViewSelected == "Table"
              ? handleAddRows()
              : handleAddGrids()
              : int == 3
              ? handleSaveAll()
              : int == 4
              ? handleRemoveCurrentColumnButton()
              : int == 5
              ? handleRemoveCurrentRowButton()
              : int == 6
              ? handleRemoveSelectedRowsButton()
              : int == 7
              ? handleFiltering()
              : Container();
        });
      });

  ///----------------------------- BUILD TABLE VIEW -----------------------------///

  buildTable(BuildContext context, Size screenSize) {
    return SizedBox(
      width: double.infinity,
      height: fullPeopleAllowedToViewProject == null ||
          fullPeopleAllowedToViewProject.isEmpty
          ? (screenSize.height * 0.131)
          : (screenSize.height * 0.131) +
          (rows.length *
              screenSize.height *
              0.065),
      child: PlutoGrid(
        columns: columns,
        rows: rows,
        columnGroups: columnGroups,
        onLoaded: (PlutoGridOnLoadedEvent event) {
          stateManager = event.stateManager;
        },
        onChanged: (PlutoGridOnChangedEvent event) {
          setState(() {
            if (event.columnIdx == 1) {
              fullPeopleAllowedToViewProject[event.rowIdx!].memberName = event.value;
            } else if (event.columnIdx == 2)  {
              fullPeopleAllowedToViewProject[event.rowIdx!].jobTitle = event.value;
            } else if (event.columnIdx == 3) {
              fullPeopleAllowedToViewProject[event.rowIdx!].phoneNumber = event.value;
            } else if (event.columnIdx == 4) {
              fullPeopleAllowedToViewProject[event.rowIdx!].optionalPhoneNumber = event.value;
            } else if (event.columnIdx == 5) {
              fullPeopleAllowedToViewProject[event.rowIdx!].workEmail = event.value;
            } else if (event.columnIdx == 6) {
              fullPeopleAllowedToViewProject[event.rowIdx!].contractType = event.value;
            } else if (event.columnIdx == 7) {
              fullPeopleAllowedToViewProject[event.rowIdx!].startDate = event.value;
            } else if (event.columnIdx == 8) {
              fullPeopleAllowedToViewProject[event.rowIdx!].endDate = event.value;
            } else if (event.columnIdx == 9) {
              fullPeopleAllowedToViewProject[event.rowIdx!].duration = event.value;
            }

            readJsonFileContent.members = fullPeopleAllowedToViewProject;
            _futureProjectInformation = writeProjectData(readJsonFileContent);
          });
        },
        configuration: const PlutoGridConfiguration(
          columnSize: PlutoGridColumnSizeConfig(
            autoSizeMode: PlutoAutoSizeMode.none,
          ),
          style: PlutoGridStyleConfig(
            gridBorderColor: Colors.transparent,
            gridBackgroundColor: Colors.transparent,
            borderColor: Colors.transparent,
            iconColor: kPlatinum,
            columnTextStyle: TextStyle(
              color: kPlatinum,
              decoration: TextDecoration.none,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  ///----------------------------- BUILD GRID VIEW -----------------------------///
   buildGrid(BuildContext context) {
    return Column(
              children: [
                fullPeopleAllowedToViewProject.isEmpty
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
                                return SizedBox(
                                  height:
                                      fullPeopleAllowedToViewProject.length *
                                               MediaQuery.of(context).size.height *
                                              0.83 +
                                          ((fullPeopleAllowedToViewProject
                                                      .length -
                                                  1) *
                                               MediaQuery.of(context).size.height *
                                              0.02),
                                  child: ListView.builder(
                                      itemCount:
                                          fullPeopleAllowedToViewProject
                                              .length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            Container(
                                              color: Colors.black12,
                                              child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "PERSON ${index + 1}",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: const TextStyle(
                                                            //letterSpacing: 8,
                                                            fontFamily:
                                                                'Electrolize',
                                                            fontSize: 20,
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
                                                                fullPeopleAllowedToViewProject.remove(
                                                                    fullPeopleAllowedToViewProject[
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
                                                        const Text(
                                                          "NAME",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            //letterSpacing: 8,
                                                            fontFamily:
                                                                'Electrolize',
                                                            fontSize:
                                                                    15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                                  MediaQuery.of(context).size.width * 0.3,

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
                                                                    fullPeopleAllowedToViewProject[index]
                                                                            .memberUsername =
                                                                        _allUserNameList![_allUserFullNameList!.indexWhere((element) =>
                                                                            element ==
                                                                            newValue!)];

                                                                    _selectedMemberData = _allUserData!
                                                                        .where((element) =>
                                                                            element.username ==
                                                                            fullPeopleAllowedToViewProject[index].memberUsername)
                                                                        .toList()[0];
                                                                    fullPeopleAllowedToViewProject[index]
                                                                            .memberUsername =
                                                                        _selectedMemberData
                                                                            .username;
                                                                    fullPeopleAllowedToViewProject[index]
                                                                            .memberName =
                                                                        "${_selectedMemberData.firstName} ${_selectedMemberData.lastName}";
                                                                    fullPeopleAllowedToViewProject[index]
                                                                            .jobTitle =
                                                                        _selectedMemberData
                                                                            .jobTitle;
                                                                    fullPeopleAllowedToViewProject[index]
                                                                            .contractType =
                                                                        _selectedMemberData
                                                                            .jobContractType;
                                                                    fullPeopleAllowedToViewProject[index]
                                                                            .extension =
                                                                        _selectedMemberData
                                                                            .extension;
                                                                    fullPeopleAllowedToViewProject[index]
                                                                            .skills =
                                                                        _selectedMemberData
                                                                            .hardSkills;
                                                                    fullPeopleAllowedToViewProject[index]
                                                                            .phoneNumber =
                                                                        _selectedMemberData
                                                                            .phoneNumber;
                                                                    fullPeopleAllowedToViewProject[index]
                                                                            .optionalPhoneNumber =
                                                                        _selectedMemberData
                                                                            .optionalPhoneNumber;
                                                                    fullPeopleAllowedToViewProject[index]
                                                                            .personalEmail =
                                                                        _selectedMemberData
                                                                            .personalEmail;
                                                                    fullPeopleAllowedToViewProject[index]
                                                                            .workEmail =
                                                                        _selectedMemberData
                                                                            .workEmail;
                                                                    //print(_allUserNameList!.indexWhere((element) => element == readJsonFileContent.projectSeniorManager!));


                                                                    readJsonFileContent.members = fullPeopleAllowedToViewProject;

                                                                    _futureProjectInformation = writeProjectData(readJsonFileContent);
                                                                  });
                                                                });
                                                              },
                                                              //show selected item
                                                              selectedItem: fullPeopleAllowedToViewProject[
                                                                              index]
                                                                          .memberName ==
                                                                      null
                                                                  ? "Person Name"
                                                                  : _allUserFullNameList![_allUserNameList!.indexWhere((element) =>
                                                                      element ==
                                                                      fullPeopleAllowedToViewProject[
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
                                                        const Text(
                                                          "WORK EMAIL",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            //letterSpacing: 8,
                                                            fontFamily:
                                                                'Electrolize',
                                                            fontSize:
                                                                    15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                                  MediaQuery.of(context).size.width * 0.3,

                                                          child: TextFormField(
                                                            minLines: 1,
                                                            maxLines: 250,
                                                            autofocus: false,
                                                            initialValue: fullPeopleAllowedToViewProject[
                                                                            index]
                                                                        .workEmail ==
                                                                    null
                                                                ? ""
                                                                : fullPeopleAllowedToViewProject[
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
                                                              fullPeopleAllowedToViewProject[
                                                                          index]
                                                                      .workEmail =
                                                                  newValue;

                                                              readJsonFileContent.members = fullPeopleAllowedToViewProject;

                                                              _futureProjectInformation = writeProjectData(readJsonFileContent);
                                                            },
                                                            onFieldSubmitted:
                                                                (newValue) {
                                                              fullPeopleAllowedToViewProject[
                                                                          index]
                                                                      .workEmail =
                                                                  newValue;

                                                              readJsonFileContent.members = fullPeopleAllowedToViewProject;

                                                              _futureProjectInformation = writeProjectData(readJsonFileContent);
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
                                                        const Text(
                                                          "PERSONAL EMAIL",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            //letterSpacing: 8,
                                                            fontFamily:
                                                                'Electrolize',
                                                            fontSize:
                                                                    15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                                  MediaQuery.of(context).size.width * 0.3,

                                                          child: TextFormField(
                                                            minLines: 1,
                                                            maxLines: 250,
                                                            autofocus: false,
                                                            initialValue: fullPeopleAllowedToViewProject[
                                                                            index]
                                                                        .personalEmail ==
                                                                    null
                                                                ? ""
                                                                : fullPeopleAllowedToViewProject[
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
                                                              fullPeopleAllowedToViewProject[
                                                                          index]
                                                                      .personalEmail =
                                                                  newValue;

                                                              readJsonFileContent.members = fullPeopleAllowedToViewProject;

                                                              _futureProjectInformation = writeProjectData(readJsonFileContent);
                                                            },
                                                            onFieldSubmitted:
                                                                (newValue) {
                                                              fullPeopleAllowedToViewProject[
                                                                          index]
                                                                      .personalEmail =
                                                                  newValue;

                                                              readJsonFileContent.members = fullPeopleAllowedToViewProject;

                                                              _futureProjectInformation = writeProjectData(readJsonFileContent);
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
                                                        const Text(
                                                          "PHONE NUMBER",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            //letterSpacing: 8,
                                                            fontFamily:
                                                                'Electrolize',
                                                            fontSize:
                                                                    15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                                  MediaQuery.of(context).size.width * 0.3,

                                                          child: TextFormField(
                                                            minLines: 1,
                                                            maxLines: 250,
                                                            autofocus: false,
                                                            initialValue: fullPeopleAllowedToViewProject[
                                                                            index]
                                                                        .phoneNumber ==
                                                                    null
                                                                ? ""
                                                                : fullPeopleAllowedToViewProject[
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
                                                              fullPeopleAllowedToViewProject[
                                                                          index]
                                                                      .phoneNumber =
                                                                  newValue;

                                                              readJsonFileContent.members = fullPeopleAllowedToViewProject;

                                                              _futureProjectInformation = writeProjectData(readJsonFileContent);
                                                            },
                                                            onFieldSubmitted:
                                                                (newValue) {
                                                              fullPeopleAllowedToViewProject[
                                                                          index]
                                                                      .phoneNumber =
                                                                  newValue;

                                                              readJsonFileContent.members = fullPeopleAllowedToViewProject;

                                                              _futureProjectInformation = writeProjectData(readJsonFileContent);
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
                                                        const Text(
                                                          "PN OPTIONAL",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            //letterSpacing: 8,
                                                            fontFamily:
                                                                'Electrolize',
                                                            fontSize:
                                                                    15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                                  MediaQuery.of(context).size.width * 0.3,

                                                          child: TextFormField(
                                                            minLines: 1,
                                                            maxLines: 250,
                                                            autofocus: false,
                                                            initialValue: fullPeopleAllowedToViewProject[
                                                                            index]
                                                                        .optionalPhoneNumber ==
                                                                    null
                                                                ? ""
                                                                : fullPeopleAllowedToViewProject[
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
                                                              fullPeopleAllowedToViewProject[
                                                                          index]
                                                                      .optionalPhoneNumber =
                                                                  newValue;

                                                              readJsonFileContent.members = fullPeopleAllowedToViewProject;

                                                              _futureProjectInformation = writeProjectData(readJsonFileContent);
                                                            },
                                                            onFieldSubmitted:
                                                                (newValue) {
                                                              fullPeopleAllowedToViewProject[
                                                                          index]
                                                                      .optionalPhoneNumber =
                                                                  newValue;

                                                              readJsonFileContent.members = fullPeopleAllowedToViewProject;

                                                              _futureProjectInformation = writeProjectData(readJsonFileContent);
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
                                                        const Text(
                                                          "DURATION (in weeks)",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            //letterSpacing: 8,
                                                            fontFamily:
                                                                'Electrolize',
                                                            fontSize:
                                                                    15,
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

                                                          child: TextFormField(
                                                            minLines: 1,
                                                            maxLines: 250,
                                                            autofocus: false,
                                                            initialValue: fullPeopleAllowedToViewProject[
                                                                            index]
                                                                        .duration ==
                                                                    null
                                                                ? ""
                                                                : fullPeopleAllowedToViewProject[
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
                                                              fullPeopleAllowedToViewProject[
                                                                          index]
                                                                      .duration =
                                                                  double.parse(
                                                                      newValue);

                                                              readJsonFileContent.members = fullPeopleAllowedToViewProject;

                                                              _futureProjectInformation = writeProjectData(readJsonFileContent);
                                                            },
                                                            onFieldSubmitted:
                                                                (newValue) {
                                                              fullPeopleAllowedToViewProject[
                                                                          index]
                                                                      .duration =
                                                                  double.parse(
                                                                      newValue);

                                                              readJsonFileContent.members = fullPeopleAllowedToViewProject;

                                                              _futureProjectInformation = writeProjectData(readJsonFileContent);
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
                                                  ],
                                                ),
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
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }
                            }

                            return const CircularProgressIndicator();
                          },
                        ),
                      ),
                fullPeopleAllowedToViewProject.isEmpty
                    ? Container()
                    : SizedBox(height:  MediaQuery.of(context).size.height * 0.02),
              ],
            );
  }

}
