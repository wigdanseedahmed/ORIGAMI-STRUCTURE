import 'dart:ui';

import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class EditProjectExecutingAgencyWS extends StatefulWidget {
  const EditProjectExecutingAgencyWS({
    Key? key,
    required this.selectedUser,
    this.selectedProject,
    required this.navigationMenu,
  }) : super(key: key);

  final UserModel? selectedUser;
  final ProjectModel? selectedProject;
  final NavigationMenu navigationMenu;

  @override
  State<EditProjectExecutingAgencyWS> createState() =>
      _EditProjectExecutingAgencyWSState();
}

class _EditProjectExecutingAgencyWSState
    extends State<EditProjectExecutingAgencyWS> {
  /// Variables used to add more
  bool addNewItemExecutingAgency = false;
  var fullExecutingAgencyContainer = <Container>[];
  var fullExecutingAgency = <ExecutingAgencyModel>[];

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

  Future<ProjectModel> writeProjectData(
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
    _futureProjectInformation = readProjectData();

    /// VARIABLES USED TO EDIT PROJECT DETAILS
    widget.selectedProject!.executingAgency == [] || widget.selectedProject!.executingAgency == null
        ? fullExecutingAgency = <ExecutingAgencyModel>[]
        : fullExecutingAgency = widget.selectedProject!.executingAgency!;

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
              if (fullExecutingAgency == null || fullExecutingAgency.isEmpty) {
                rows;
              } else {
                for (int i = 0;
                    i < readJsonFileContent.executingAgency!.length;
                    i++) {
                  rows.add(
                    PlutoRow(
                      cells: {
                        'id': PlutoCell(value: 'Agency ${i + 1}'),
                        'name': PlutoCell(
                            value: fullExecutingAgency[i].executingAgencyName),
                        'department': PlutoCell(
                            value: fullExecutingAgency[i]
                                .executingAgencyDepartment),
                        'team': PlutoCell(
                            value: fullExecutingAgency[i].executingAgencyTeam),
                        'email': PlutoCell(
                            value: fullExecutingAgency[i].executingAgencyEmail),
                        'website': PlutoCell(
                            value:
                                fullExecutingAgency[i].executingAgencyWebsite),
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
      backgroundColor: kBlueChill,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Name',
      field: 'name',
      type: PlutoColumnType.text(),
      backgroundColor: kBlueChill,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Department',
      field: 'department',
      type: PlutoColumnType.text(),
      backgroundColor: kBlueChill,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Team',
      field: 'team',
      type: PlutoColumnType.text(),
      backgroundColor: kBlueChill,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Email',
      field: 'email',
      type: PlutoColumnType.text(),
      backgroundColor: kBlueChill,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Website',
      field: 'website',
      type: PlutoColumnType.text(),
      backgroundColor: kBlueChill,
      enableEditingMode: true,
    ),
  ];

  final List<PlutoRow> rows = [];

  /// columnGroups that can group columns can be omitted.
  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(title: 'Id', fields: ['id'], expandedColumn: true),
    PlutoColumnGroup(title: 'Name', fields: ['name'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Department', fields: ['department'], expandedColumn: true),
    PlutoColumnGroup(title: 'Team', fields: ['team'], expandedColumn: true),
    PlutoColumnGroup(title: 'Email', fields: ['email'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Website', fields: ['website'], expandedColumn: true),
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
              'EXECUTING AGENCY',
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
      fullExecutingAgency.add(ExecutingAgencyModel()
        ..executingAgencyName =
            "Executing Agency ${fullExecutingAgency.length}");

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

      readJsonFileContent.executingAgency = fullExecutingAgency;

      _futureProjectInformation = writeProjectData(readJsonFileContent);
    });
  }

  void handleAddGrids() {
    setState(() {
      fullExecutingAgency.add(ExecutingAgencyModel()
        ..executingAgencyName =
            "Executing Agency ${fullExecutingAgency.length + 1}");

      readJsonFileContent.executingAgency = fullExecutingAgency;

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
      fullExecutingAgency.removeAt(stateManager.currentRowIdx!);

      stateManager.removeCurrentRow();

      readJsonFileContent.executingAgency = fullExecutingAgency;

      _futureProjectInformation = writeProjectData(readJsonFileContent);
    });
  }

  void handleRemoveSelectedRowsButton() {
    setState(() {
      print(stateManager.currentSelectingRows);
      print(stateManager.currentSelectingRows.last.sortIdx!);
      // fullExecutingAgency.removeRange(stateManager.currentSelectingRows);

      stateManager.removeRows(stateManager.currentSelectingRows);

      readJsonFileContent.executingAgency = fullExecutingAgency;

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
            "Add New Executing Agency",
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
            "Remove Current Selected Executing Agency",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ), const PopupMenuItem(
          value: 6,
          child: Text(
            "Remove Selected Executing Agencies",
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
            "Add New Executing Agency",
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
      height: fullExecutingAgency == null || fullExecutingAgency.isEmpty
          ? (screenSize.height * 0.131)
          : (screenSize.height * 0.131) +
              (rows.length * screenSize.height * 0.065),
      child: PlutoGrid(
        key: UniqueKey(),
        columns: columns,
        rows: rows,
        columnGroups: columnGroups,
        onLoaded: (PlutoGridOnLoadedEvent event) {
          stateManager = event.stateManager;
        },
        onChanged: (PlutoGridOnChangedEvent event) {
          setState(() {
            if (event.columnIdx == 1) {
              fullExecutingAgency[event.rowIdx!].executingAgencyName =
                  event.value;
            } else if (event.columnIdx == 2) {
              fullExecutingAgency[event.rowIdx!].executingAgencyDepartment =
                  event.value;
            } else if (event.columnIdx == 3) {
              fullExecutingAgency[event.rowIdx!].executingAgencyTeam =
                  event.value;
            } else if (event.columnIdx == 4) {
              fullExecutingAgency[event.rowIdx!].executingAgencyEmail =
                  event.value;
            } else if (event.columnIdx == 5) {
              fullExecutingAgency[event.rowIdx!].executingAgencyWebsite =
                  event.value;
            }

            readJsonFileContent.executingAgency = fullExecutingAgency;

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
        fullExecutingAgency.isEmpty
            ? Container()
            : SizedBox(
                height: fullExecutingAgency.length *
                        MediaQuery.of(context).size.height *
                        0.385 +
                    ((fullExecutingAgency.length - 1) *
                        MediaQuery.of(context).size.height *
                        0.02),
                child: ListView.builder(
                    itemCount: fullExecutingAgency.length,
                    physics: const NeverScrollableScrollPhysics(),
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
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "EXECUTING AGENCY ${index + 1}",
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize: 20,
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
                                              fullExecutingAgency.remove(
                                                  fullExecutingAgency[index]);

                                              readJsonFileContent
                                                      .executingAgency =
                                                  fullExecutingAgency;

                                              _futureProjectInformation =
                                                  writeProjectData(
                                                      readJsonFileContent);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "EXECUTING AGENCY",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width *
                                            0.3,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: TextFormField(
                                          minLines: 1,
                                          maxLines: 250,
                                          autofocus: false,
                                          initialValue: fullExecutingAgency[index]
                                                      .executingAgencyName ==
                                                  null
                                              ? ""
                                              : fullExecutingAgency[index]
                                                  .executingAgencyName!,
                                          cursorColor: DynamicTheme.of(context)
                                                      ?.brightness ==
                                                  Brightness.light
                                              ? Colors.grey[100]
                                              : Colors.grey[600],
                                          onChanged: (newValue) {
                                            fullExecutingAgency[index]
                                                .executingAgencyName = newValue;

                                            readJsonFileContent.executingAgency =
                                                fullExecutingAgency;

                                            _futureProjectInformation =
                                                writeProjectData(
                                                    readJsonFileContent);
                                          },
                                          onFieldSubmitted: (newValue) {
                                            fullExecutingAgency[index]
                                                .executingAgencyName = newValue;

                                            readJsonFileContent.executingAgency =
                                                fullExecutingAgency;

                                            _futureProjectInformation =
                                                writeProjectData(
                                                    readJsonFileContent);
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
                                  SizedBox(
                                      height: MediaQuery.of(context).size.height /
                                          70),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "DEPARTMENT",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.3,
                                        child: TextFormField(
                                          minLines: 1,
                                          maxLines: 250,
                                          autofocus: false,
                                          initialValue: fullExecutingAgency[index]
                                                      .executingAgencyDepartment ==
                                                  null
                                              ? ""
                                              : fullExecutingAgency[index]
                                                  .executingAgencyDepartment!,
                                          cursorColor: DynamicTheme.of(context)
                                                      ?.brightness ==
                                                  Brightness.light
                                              ? Colors.grey[100]
                                              : Colors.grey[600],
                                          onChanged: (newValue) {
                                            fullExecutingAgency[index]
                                                    .executingAgencyDepartment =
                                                newValue;

                                            readJsonFileContent.executingAgency =
                                                fullExecutingAgency;

                                            _futureProjectInformation =
                                                writeProjectData(
                                                    readJsonFileContent);
                                          },
                                          onFieldSubmitted: (newValue) {
                                            fullExecutingAgency[index]
                                                    .executingAgencyDepartment =
                                                newValue;

                                            readJsonFileContent.executingAgency =
                                                fullExecutingAgency;

                                            _futureProjectInformation =
                                                writeProjectData(
                                                    readJsonFileContent);
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
                                  SizedBox(
                                      height: MediaQuery.of(context).size.height /
                                          70),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "TEAM",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.3,
                                        child: TextFormField(
                                          minLines: 1,
                                          maxLines: 250,
                                          autofocus: false,
                                          initialValue: fullExecutingAgency[index]
                                                      .executingAgencyTeam ==
                                                  null
                                              ? ""
                                              : fullExecutingAgency[index]
                                                  .executingAgencyTeam!,
                                          cursorColor: DynamicTheme.of(context)
                                                      ?.brightness ==
                                                  Brightness.light
                                              ? Colors.grey[100]
                                              : Colors.grey[600],
                                          onChanged: (newValue) {
                                            fullExecutingAgency[index]
                                                .executingAgencyTeam = newValue;

                                            readJsonFileContent.executingAgency =
                                                fullExecutingAgency;

                                            _futureProjectInformation =
                                                writeProjectData(
                                                    readJsonFileContent);
                                          },
                                          onFieldSubmitted: (newValue) {
                                            fullExecutingAgency[index]
                                                .executingAgencyTeam = newValue;

                                            readJsonFileContent.executingAgency =
                                                fullExecutingAgency;

                                            _futureProjectInformation =
                                                writeProjectData(
                                                    readJsonFileContent);
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
                                  SizedBox(
                                      height: MediaQuery.of(context).size.height /
                                          70),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "WEBSITE",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.3,
                                        child: TextFormField(
                                          minLines: 1,
                                          maxLines: 250,
                                          autofocus: false,
                                          initialValue: fullExecutingAgency[index]
                                                      .executingAgencyWebsite ==
                                                  null
                                              ? ""
                                              : fullExecutingAgency[index]
                                                  .executingAgencyWebsite!,
                                          cursorColor: DynamicTheme.of(context)
                                                      ?.brightness ==
                                                  Brightness.light
                                              ? Colors.grey[100]
                                              : Colors.grey[600],
                                          onChanged: (newValue) {
                                            fullExecutingAgency[index]
                                                    .executingAgencyWebsite =
                                                newValue;

                                            readJsonFileContent.executingAgency =
                                                fullExecutingAgency;

                                            _futureProjectInformation =
                                                writeProjectData(
                                                    readJsonFileContent);
                                          },
                                          onFieldSubmitted: (newValue) {
                                            fullExecutingAgency[index]
                                                    .executingAgencyWebsite =
                                                newValue;

                                            readJsonFileContent.executingAgency =
                                                fullExecutingAgency;

                                            _futureProjectInformation =
                                                writeProjectData(
                                                    readJsonFileContent);
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
                                  SizedBox(
                                      height: MediaQuery.of(context).size.height /
                                          70),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "EMAIL",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.3,
                                        child: TextFormField(
                                          minLines: 1,
                                          maxLines: 250,
                                          autofocus: false,
                                          initialValue: fullExecutingAgency[index]
                                                      .executingAgencyEmail ==
                                                  null
                                              ? ""
                                              : fullExecutingAgency[index]
                                                  .executingAgencyEmail!,
                                          cursorColor: DynamicTheme.of(context)
                                                      ?.brightness ==
                                                  Brightness.light
                                              ? Colors.grey[100]
                                              : Colors.grey[600],
                                          onChanged: (newValue) {
                                            fullExecutingAgency[index]
                                                .executingAgencyEmail = newValue;

                                            readJsonFileContent.executingAgency =
                                                fullExecutingAgency;

                                            _futureProjectInformation =
                                                writeProjectData(
                                                    readJsonFileContent);
                                          },
                                          onFieldSubmitted: (newValue) {
                                            fullExecutingAgency[index]
                                                .executingAgencyEmail = newValue;

                                            readJsonFileContent.executingAgency =
                                                fullExecutingAgency;

                                            _futureProjectInformation =
                                                writeProjectData(
                                                    readJsonFileContent);
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
                                  SizedBox(
                                      height: MediaQuery.of(context).size.height /
                                          70),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02)
                        ],
                      );
                    }),
              ),
        fullExecutingAgency.isEmpty
            ? Container()
            : SizedBox(height: MediaQuery.of(context).size.height * 0.02),
      ],
    );
  }
}
