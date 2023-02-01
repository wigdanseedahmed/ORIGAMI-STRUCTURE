import 'dart:ui';

import 'package:nb_utils/nb_utils.dart';
import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class EditProjectResourcesWS extends StatefulWidget {
  const EditProjectResourcesWS({
    Key? key,
    required this.selectedUser,
    this.selectedProject,
    required this.navigationMenu,
  }) : super(key: key);

  final UserModel? selectedUser;
  final ProjectModel? selectedProject;
  final NavigationMenu navigationMenu;

  @override
  State<EditProjectResourcesWS> createState() => _EditProjectResourcesWSState();
}

class _EditProjectResourcesWSState extends State<EditProjectResourcesWS> {
  /// Variables used to add more
  bool addNewItemResource = false;
  var fullResourcesContainer = <Container>[];
  var fullResources = <ResourcesModel>[];

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
    widget.selectedProject!.resources == [] ||
            widget.selectedProject!.resources == null
        ? fullResources = <ResourcesModel>[]
        : fullResources = widget.selectedProject!.resources!;
    print("fullResources ${fullResources.length}");
/*
    fullResources.isEmpty
        ? fullResourcesContainer.add(addNewItemResourceContainer())
        : fullResourcesContainer = <Container>[];*/
    //print("fullResourcesContainer $fullResourcesContainer");
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
          rows.clear();
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (fullResources == null || fullResources.isEmpty) {
                rows;
              } else {
                for (int i = 0; i < fullResources.length; i++) {
                  rows.add(
                    PlutoRow(
                      cells: {
                        'id': PlutoCell(value: '${i + 1}'),
                        'type':
                            PlutoCell(value: fullResources[i].resourcesType),
                        'tool':
                            PlutoCell(value: fullResources[i].resourcesTool),
                        'reference':
                            PlutoCell(value: fullResources[i].reference),
                        'start date':
                            PlutoCell(value: fullResources[i].startDate),
                        'end date': PlutoCell(value: fullResources[i].endDate),
                        'duration': PlutoCell(value: fullResources[i].duration),
                        'cost': PlutoCell(value: fullResources[i].cost),
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
      title: 'Type',
      field: 'type',
      type: PlutoColumnType.select(resourcesTypeList!),
      backgroundColor: kBlueChill,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Tool',
      field: 'tool',
      type: PlutoColumnType.text(),
      backgroundColor: kBlueChill,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Reference',
      field: 'reference',
      type: PlutoColumnType.text(),
      backgroundColor: kBlueChill,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Start Date',
      field: 'start date',
      type: PlutoColumnType.date(),
      backgroundColor: kBlueChill,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'End Date',
      field: 'end date',
      type: PlutoColumnType.date(),
      backgroundColor: kBlueChill,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Duration',
      field: 'duration',
      type: PlutoColumnType.number(),
      backgroundColor: kBlueChill,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Cost',
      field: 'cost',
      type: PlutoColumnType.number(),
      backgroundColor: kBlueChill,
      enableEditingMode: true,
    ),
  ];

  final List<PlutoRow> rows = [];

  /// columnGroups that can group columns can be omitted.
  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(title: 'Id', fields: ['id'], expandedColumn: true),
    PlutoColumnGroup(title: 'Type', fields: ['type'], expandedColumn: true),
    PlutoColumnGroup(title: 'Tool', fields: ['tool'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Reference', fields: ['reference'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Start Date', fields: ['start date'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'End Date', fields: ['end date'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Duration', fields: ['duration'], expandedColumn: true),
    PlutoColumnGroup(title: 'Cost', fields: ['cost'], expandedColumn: true),
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
              'RESOURCES',
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
      fullResources
          .add(ResourcesModel()..resourcesID = "${fullResources.length + 1}");

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

      readJsonFileContent.resources = fullResources;

      _futureProjectInformation = writeProjectData(readJsonFileContent);
    });
  }

  void handleAddGrids() {
    setState(() {
      fullResources
          .add(ResourcesModel()..resourcesID = "${fullResources.length + 1}");

      readJsonFileContent.resources = fullResources;

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
      fullResources.removeAt(stateManager.currentRowIdx!);

      stateManager.removeCurrentRow();

      readJsonFileContent.resources = fullResources;

      _futureProjectInformation = writeProjectData(readJsonFileContent);
    });
  }

  void handleRemoveSelectedRowsButton() {
    setState(() {
      print(stateManager.currentSelectingRows);
      print(stateManager.currentSelectingRows.last.sortIdx!);
      // fullResources.removeRange(stateManager.currentSelectingRows);

      stateManager.removeRows(stateManager.currentSelectingRows);

      readJsonFileContent.resources = fullResources;

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
            "Add New Resource",
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
            "Remove Current Selected Resource",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ), const PopupMenuItem(
          value: 6,
          child: Text(
            "Remove Selected Resources",
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
            "Add New Resource",
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenSize.height / 20),
        const Align(
          alignment: Alignment.centerLeft,
          child: ProjectDetailHeaderWS(headerTitle: 'RESOURCES'),
        ),
        SizedBox(height: screenSize.height / 30),
        SizedBox(
          width: double.infinity,
          height: readJsonFileContent.resources == null || fullResources.isEmpty
              ? (screenSize.height * 0.131)
              : (screenSize.height * 0.131) +
                  (rows.length * screenSize.height * 0.065),
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
                  fullResources[event.rowIdx!].resourcesType = event.value;
                } else if (event.columnIdx == 2) {
                  fullResources[event.rowIdx!].resourcesTool = event.value;
                } else if (event.columnIdx == 3) {
                  fullResources[event.rowIdx!].reference = event.value;
                } else if (event.columnIdx == 4) {
                  fullResources[event.rowIdx!].startDate = event.value;
                } else if (event.columnIdx == 5) {
                  fullResources[event.rowIdx!].endDate = event.value;
                } else if (event.columnIdx == 6) {
                  fullResources[event.rowIdx!].duration = event.value;
                } else if (event.columnIdx == 7) {
                  fullResources[event.rowIdx!].cost = event.value;
                }

                readJsonFileContent.resources = fullResources;

                _futureProjectInformation =
                    writeProjectData(readJsonFileContent);
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
        ),
      ],
    );
  }

  ///----------------------------- BUILD GRID VIEW -----------------------------///
  buildGrid(BuildContext context) {
    return Column(
      children: [
        fullResources.isEmpty
            ? Container()
            : SizedBox(
                height: fullResources.length *
                        MediaQuery.of(context).size.height *
                        0.45 +
                    ((fullResources.length - 1) *
                        MediaQuery.of(context).size.height *
                        0.02),
                child: ListView.builder(
                    itemCount: fullResources.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            color: Colors.black12,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "RESOURCE ${index + 1}",
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
                                              fullResources
                                                  .remove(fullResources[index]);
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
                                        "RESOURCE TOOL",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: TextFormField(
                                          minLines: 1,
                                          maxLines: 250,
                                          autofocus: false,
                                          initialValue: fullResources[index]
                                                      .resourcesTool ==
                                                  null
                                              ? ""
                                              : fullResources[index]
                                                  .resourcesTool!,
                                          cursorColor: DynamicTheme.of(context)
                                                      ?.brightness ==
                                                  Brightness.light
                                              ? Colors.grey[100]
                                              : Colors.grey[600],
                                          onChanged: (newValue) {
                                            fullResources[index].resourcesTool =
                                                newValue;

                                            readJsonFileContent.resources = fullResources;

                                            _futureProjectInformation =
                                                writeProjectData(readJsonFileContent);
                                          },
                                          onFieldSubmitted: (newValue) {
                                            fullResources[index].resourcesTool =
                                                newValue;

                                            readJsonFileContent.resources = fullResources;

                                            _futureProjectInformation =
                                                writeProjectData(readJsonFileContent);
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
                                      height:
                                          MediaQuery.of(context).size.height /
                                              70),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "RESOURCE TYPE",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
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
                                            ),
                                            //mode of dropdown
                                            mode: Mode.MENU,
                                            //to show search box
                                            showSearchBox: true,
                                            //list of dropdown items
                                            items: resourcesTypeList,
                                            onChanged: (String? newValue) {
                                              dropDownState(() {
                                                fullResources[index]
                                                    .resourcesType = newValue;
                                                //print(_allUserNameList!.indexWhere((element) => element == readJsonFileContent.projectSeniorManager!));

                                                readJsonFileContent.resources = fullResources;

                                                _futureProjectInformation =
                                                    writeProjectData(readJsonFileContent);
                                              });
                                            },
                                            //show selected item
                                            selectedItem: fullResources[index]
                                                        .resourcesType ==
                                                    null
                                                ? ""
                                                : fullResources[index]
                                                    .resourcesType!,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              70),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "DURATION (in weeks)",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: TextFormField(
                                          minLines: 1,
                                          maxLines: 250,
                                          autofocus: false,
                                          initialValue:
                                              fullResources[index].duration ==
                                                      null
                                                  ? ""
                                                  : fullResources[index]
                                                      .duration!
                                                      .toString(),
                                          cursorColor: DynamicTheme.of(context)
                                                      ?.brightness ==
                                                  Brightness.light
                                              ? Colors.grey[100]
                                              : Colors.grey[600],
                                          onChanged: (newValue) {
                                            fullResources[index].duration =
                                                double.parse(newValue);

                                            readJsonFileContent.resources = fullResources;

                                            _futureProjectInformation =
                                                writeProjectData(readJsonFileContent);
                                          },
                                          onFieldSubmitted: (newValue) {
                                            fullResources[index].duration =
                                                double.parse(newValue);

                                            readJsonFileContent.resources = fullResources;

                                            _futureProjectInformation =
                                                writeProjectData(readJsonFileContent);
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
                                      height:
                                          MediaQuery.of(context).size.height /
                                              70),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height:
                                        MediaQuery.of(context).size.height *
                                            0.05,
                                        width:
                                        MediaQuery.of(context).size.width *
                                            0.2,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: const [
                                            Icon(
                                              Icons.access_time_outlined,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "START DATE",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                //letterSpacing: 8,
                                                fontFamily: 'Electrolize',
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 110),
                                      SizedBox(
                                        height:
                                        MediaQuery.of(context).size.height *
                                            0.05,
                                        width:
                                        MediaQuery.of(context).size.width *
                                            0.2,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: const [
                                            Icon(
                                              Icons.access_time_outlined,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              "END DATE",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                //letterSpacing: 8,
                                                fontFamily: 'Electrolize',
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
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
                                                0.05,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: CupertinoDateTextBox(
                                          initialValue: fullResources[index]
                                                      .startDate ==
                                                  null
                                              ? DateTime.now()
                                              : DateFormat("yyyy-MM-dd").parse(
                                                  fullResources[index]
                                                      .startDate!),
                                          onDateChange: (DateTime? newDate) {
                                            //print(newDate);
                                            setState(() {
                                              fullResources[index].startDate =
                                                  newDate!.toIso8601String();

                                              readJsonFileContent.resources = fullResources;

                                              _futureProjectInformation =
                                                  writeProjectData(readJsonFileContent);
                                            });
                                          },
                                          hintText: fullResources[index]
                                                      .startDate ==
                                                  null
                                              ? DateFormat()
                                                  .format(DateTime.now())
                                              : fullResources[index].startDate!,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: CupertinoDateTextBox(
                                          initialValue: fullResources[index]
                                                      .endDate ==
                                                  null
                                              ? DateTime.now()
                                              : DateFormat('yyyy-MM-dd').parse(
                                                  fullResources[index]
                                                      .endDate!),
                                          onDateChange: (DateTime? newDate) {
                                            // print(newDate);
                                            setState(() {
                                              fullResources[index].endDate =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(newDate!);

                                              readJsonFileContent.resources = fullResources;

                                              _futureProjectInformation =
                                                  writeProjectData(readJsonFileContent);
                                            });
                                          },
                                          hintText: fullResources[index]
                                                      .endDate ==
                                                  null
                                              ? DateFormat()
                                                  .format(DateTime.now())
                                              : fullResources[index].endDate!,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              70),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "COST",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: TextFormField(
                                          minLines: 1,
                                          maxLines: 250,
                                          autofocus: false,
                                          initialValue: fullResources[index]
                                                      .cost ==
                                                  null
                                              ? ""
                                              : "${fullResources[index].cost!}",
                                          cursorColor: DynamicTheme.of(context)
                                                      ?.brightness ==
                                                  Brightness.light
                                              ? Colors.grey[100]
                                              : Colors.grey[600],
                                          onChanged: (newValue) {
                                            fullResources[index].cost =
                                                newValue.toDouble();

                                            readJsonFileContent.resources = fullResources;

                                            _futureProjectInformation =
                                                writeProjectData(readJsonFileContent);
                                          },
                                          onFieldSubmitted: (newValue) {
                                            fullResources[index].cost =
                                                newValue.toDouble();

                                            readJsonFileContent.resources = fullResources;

                                            _futureProjectInformation =
                                                writeProjectData(readJsonFileContent);
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
                                      height:
                                          MediaQuery.of(context).size.height /
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
        fullResources.isEmpty
            ? Container()
            : SizedBox(height: MediaQuery.of(context).size.height * 0.02),
      ],
    );
  }
}
