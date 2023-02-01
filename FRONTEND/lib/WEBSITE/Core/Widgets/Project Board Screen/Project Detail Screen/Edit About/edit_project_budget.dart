import 'dart:ui';

import 'package:nb_utils/nb_utils.dart';
import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class EditProjectBudgetWS extends StatefulWidget {
  const EditProjectBudgetWS({
    Key? key,
    required this.selectedUser,
    this.selectedProject,
    required this.navigationMenu,
  }) : super(key: key);

  final UserModel? selectedUser;
  final ProjectModel? selectedProject;
  final NavigationMenu navigationMenu;

  @override
  State<EditProjectBudgetWS> createState() => _EditProjectBudgetWSState();
}

class _EditProjectBudgetWSState extends State<EditProjectBudgetWS>
    with TickerProviderStateMixin {
  /// Variables used to add more
  bool addNewItemBudget = false;
  var fullBudgetsContainer = <Container>[];
  List<BudgetModel> fullBudgets = <BudgetModel>[];

  double totalDonatedAmount = 0.0;

  /// VARIABLES FOR PROJECT
  ProjectModel readJsonFileContent = ProjectModel();
  Future<ProjectModel>? _futureProjectInformation;

  Future<ProjectModel> readBudgetInformationJsonData() async {
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
      // print("Project Info : ${readJsonFileContent.budget}");

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
    _futureProjectInformation = readBudgetInformationJsonData();

    /// VARIABLES USED TO EDIT PROJECT DETAILS
    widget.selectedProject!.budget == [] || widget.selectedProject!.budget == null
        ? fullBudgets = <BudgetModel>[]
        : fullBudgets = widget.selectedProject!.budget!;

    // print("fullBudgets ${fullBudgets.length}");
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
              for (int i = 0; i < readJsonFileContent.budget!.length; i++) {
                rows.add(
                  PlutoRow(
                    cells: {
                      'id': PlutoCell(value: 'Item ${i + 1}'),
                      'name': PlutoCell(value: fullBudgets[i].item),
                      'type': PlutoCell(value: fullBudgets[i].itemType),
                      'purchase from':
                          PlutoCell(value: fullBudgets[i].purchaseFrom),
                      'purchase date':
                          PlutoCell(value: fullBudgets[i]..purchaseDate),
                      'cost': PlutoCell(value: fullBudgets[i].cost),
                    },
                  ),
                );
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
      readOnly: true,
    ),
    PlutoColumn(
      title: 'Name',
      field: 'name',
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
      titlePadding: const EdgeInsets.symmetric(horizontal: 4.0),
      title: 'Purchase From',
      field: 'purchase from',
      type: PlutoColumnType.text(),
      backgroundColor: kBlueChill,
      enableEditingMode: true,
    ),
    PlutoColumn(
      titlePadding: const EdgeInsets.symmetric(horizontal: 4.0),
      title: 'Purchase Date',
      field: 'purchase date',
      type: PlutoColumnType.date(),
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
    PlutoColumnGroup(title: 'Name', fields: ['name'], expandedColumn: true),
    PlutoColumnGroup(title: 'Type', fields: ['type'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Purchase From',
        fields: ['purchase from'],
        expandedColumn: true),
    PlutoColumnGroup(
        title: 'Purchase Date',
        fields: ['purchase date'],
        expandedColumn: true),
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
              'BUDGET',
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
      fullBudgets.add(BudgetModel()..item = "Budget ${fullBudgets.length + 1}");

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

      readJsonFileContent.budget = fullBudgets;


      _futureProjectInformation = writeProjectData(readJsonFileContent);
    });
  }

  void handleAddGrids() {
    setState(() {
      fullBudgets.add(BudgetModel()..item = "Budget ${fullBudgets.length}");

      readJsonFileContent.budget = fullBudgets;

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
      fullBudgets.removeAt(stateManager.currentRowIdx!);

      stateManager.removeCurrentRow();

      readJsonFileContent.budget = fullBudgets;

      _futureProjectInformation = writeProjectData(readJsonFileContent);
    });
  }

  void handleRemoveSelectedRowsButton() {
    setState(() {
      print(stateManager.currentSelectingRows);
      print(stateManager.currentSelectingRows.last.sortIdx!);
      // fullBudgets.removeRange(stateManager.currentSelectingRows);

      stateManager.removeRows(stateManager.currentSelectingRows);

      readJsonFileContent.budget = fullBudgets;

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
            "Add New Budget Item",
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
            "Remove Current Selected Budget Item",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ), const PopupMenuItem(
          value: 6,
          child: Text(
            "Remove Selected Budget Items",
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
            "Add New Budget Item",
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
      height: (screenSize.height * 0.131) +
          (fullBudgets.length * screenSize.height * 0.065),
      child: PlutoGrid(
        key: UniqueKey(),
        columns: columns,
        rows: rows,
        columnGroups: columnGroups,
        onLoaded: (PlutoGridOnLoadedEvent event) {
          stateManager = event.stateManager;
        },
        onChanged: (PlutoGridOnChangedEvent event) {
          // print(event.value);
          setState(() {
            if (event.columnIdx == 1) {
              fullBudgets[event.rowIdx!].item = event.value;
            } else if (event.columnIdx == 2) {
              fullBudgets[event.rowIdx!].itemType = event.value;
            } else if (event.columnIdx == 3) {
              fullBudgets[event.rowIdx!].purchaseFrom = event.value;
            } else if (event.columnIdx == 4) {
              fullBudgets[event.rowIdx!].purchaseDate = event.value;
            } else if (event.columnIdx == 5) {
              fullBudgets[event.rowIdx!].cost = event.value;
            }

            readJsonFileContent.budget = fullBudgets;
            readJsonFileContent.totalBudget = 0;

            for (var i = 0; i < fullBudgets.length; i++) {
              if (fullBudgets[i].cost != null) {
                readJsonFileContent.totalBudget =
                    readJsonFileContent.totalBudget! + fullBudgets[i].cost!;
              } else {
                readJsonFileContent.totalBudget =
                    readJsonFileContent.totalBudget! + 0;
              }
            }

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
        fullBudgets.isEmpty
            ? Container()
            : SizedBox(
                height: fullBudgets.length *
                        MediaQuery.of(context).size.height *
                        0.55 +
                    ((fullBudgets.length - 1) *
                        MediaQuery.of(context).size.height *
                        0.02),
                child: ListView.builder(
                  itemCount: fullBudgets.length,
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
                                      "ITEM ${index + 1}",
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
                                            fullBudgets
                                                .remove(fullBudgets[index]);
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
                                      "ITEM",
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
                                        initialValue:
                                            fullBudgets[index].item == null
                                                ? ""
                                                : fullBudgets[index].item!,
                                        cursorColor: DynamicTheme.of(context)
                                                    ?.brightness ==
                                                Brightness.light
                                            ? Colors.grey[100]
                                            : Colors.grey[600],
                                        onChanged: (newValue) {
                                          fullBudgets[index].item = newValue;

                                          readJsonFileContent.budget =
                                              fullBudgets;
                                          readJsonFileContent.totalBudget = 0;

                                          for (var i = 0;
                                              i < fullBudgets.length;
                                              i++) {
                                            if (fullBudgets[i].cost != null) {
                                              readJsonFileContent.totalBudget =
                                                  readJsonFileContent
                                                          .totalBudget! +
                                                      fullBudgets[i].cost!;
                                            } else {
                                              readJsonFileContent.totalBudget =
                                                  readJsonFileContent
                                                          .totalBudget! +
                                                      0;
                                            }
                                          }

                                          _futureProjectInformation =
                                              writeProjectData(
                                                  readJsonFileContent);
                                        },
                                        onFieldSubmitted: (newValue) {
                                          fullBudgets[index].item = newValue;

                                          readJsonFileContent.budget =
                                              fullBudgets;
                                          readJsonFileContent.totalBudget = 0;

                                          for (var i = 0;
                                              i < fullBudgets.length;
                                              i++) {
                                            if (fullBudgets[i].cost != null) {
                                              readJsonFileContent.totalBudget =
                                                  readJsonFileContent
                                                          .totalBudget! +
                                                      fullBudgets[i].cost!;
                                            } else {
                                              readJsonFileContent.totalBudget =
                                                  readJsonFileContent
                                                          .totalBudget! +
                                                      0;
                                            }
                                          }

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
                                    height:
                                        MediaQuery.of(context).size.height / 70),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "ITEM TYPE",
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
                                              fullBudgets[index].itemType =
                                                  newValue;
                                              //print(_allUserNameList!.indexWhere((element) => element == readJsonFileContent.projectSeniorManager!));

                                              readJsonFileContent.budget =
                                                  fullBudgets;
                                              readJsonFileContent.totalBudget = 0;

                                              for (var i = 0;
                                                  i < fullBudgets.length;
                                                  i++) {
                                                if (fullBudgets[i].cost != null) {
                                                  readJsonFileContent
                                                          .totalBudget =
                                                      readJsonFileContent
                                                              .totalBudget! +
                                                          fullBudgets[i].cost!;
                                                } else {
                                                  readJsonFileContent
                                                          .totalBudget =
                                                      readJsonFileContent
                                                              .totalBudget! +
                                                          0;
                                                }
                                              }

                                              _futureProjectInformation =
                                                  writeProjectData(
                                                      readJsonFileContent);
                                            });
                                          },
                                          //show selected item
                                          selectedItem:
                                              fullBudgets[index].itemType == null
                                                  ? ""
                                                  : fullBudgets[index].itemType!,
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 70),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "PURCHASE FROM",
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
                                        initialValue: fullBudgets[index]
                                                    .purchaseFrom ==
                                                null
                                            ? ""
                                            : fullBudgets[index].purchaseFrom!,
                                        cursorColor: DynamicTheme.of(context)
                                                    ?.brightness ==
                                                Brightness.light
                                            ? Colors.grey[100]
                                            : Colors.grey[600],
                                        onChanged: (newValue) {
                                          fullBudgets[index].purchaseFrom =
                                              newValue;

                                          readJsonFileContent.budget =
                                              fullBudgets;
                                          readJsonFileContent.totalBudget = 0;

                                          for (var i = 0;
                                              i < fullBudgets.length;
                                              i++) {
                                            if (fullBudgets[i].cost != null) {
                                              readJsonFileContent.totalBudget =
                                                  readJsonFileContent
                                                          .totalBudget! +
                                                      fullBudgets[i].cost!;
                                            } else {
                                              readJsonFileContent.totalBudget =
                                                  readJsonFileContent
                                                          .totalBudget! +
                                                      0;
                                            }
                                          }

                                          _futureProjectInformation =
                                              writeProjectData(
                                                  readJsonFileContent);
                                        },
                                        onFieldSubmitted: (newValue) {
                                          fullBudgets[index].purchaseFrom =
                                              newValue;

                                          readJsonFileContent.budget =
                                              fullBudgets;
                                          readJsonFileContent.totalBudget = 0;

                                          for (var i = 0;
                                              i < fullBudgets.length;
                                              i++) {
                                            if (fullBudgets[i].cost != null) {
                                              readJsonFileContent.totalBudget =
                                                  readJsonFileContent
                                                          .totalBudget! +
                                                      fullBudgets[i].cost!;
                                            } else {
                                              readJsonFileContent.totalBudget =
                                                  readJsonFileContent
                                                          .totalBudget! +
                                                      0;
                                            }
                                          }

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
                                    height:
                                        MediaQuery.of(context).size.height / 70),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.calendar_today_outlined,
                                          ),
                                          SizedBox(
                                              width: 10),
                                          Text(
                                            "PURCHASE DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      child: CupertinoDateTextBox(
                                        initialValue: fullBudgets[index]
                                                    .purchaseDate ==
                                                null
                                            ? DateTime.now()
                                            : DateFormat("yyyy-MM-dd").parse(
                                                fullBudgets[index].purchaseDate!),
                                        onDateChange: (DateTime? newDate) {
                                          //print(newDate);
                                          setState(() {
                                            fullBudgets[index].purchaseDate =
                                                newDate!.toIso8601String();

                                            readJsonFileContent.budget =
                                                fullBudgets;
                                            readJsonFileContent.totalBudget = 0;

                                            for (var i = 0;
                                                i < fullBudgets.length;
                                                i++) {
                                              if (fullBudgets[i].cost != null) {
                                                readJsonFileContent.totalBudget =
                                                    readJsonFileContent
                                                            .totalBudget! +
                                                        fullBudgets[i].cost!;
                                              } else {
                                                readJsonFileContent.totalBudget =
                                                    readJsonFileContent
                                                            .totalBudget! +
                                                        0;
                                              }
                                            }

                                            _futureProjectInformation =
                                                writeProjectData(
                                                    readJsonFileContent);
                                          });
                                        },
                                        hintText: fullBudgets[index]
                                                    .purchaseDate ==
                                                null
                                            ? DateFormat().format(DateTime.now())
                                            : fullBudgets[index].purchaseDate!,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 70),
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
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      child: TextFormField(
                                        minLines: 1,
                                        maxLines: 250,
                                        autofocus: false,
                                        initialValue:
                                            fullBudgets[index].duration == null
                                                ? ""
                                                : fullBudgets[index]
                                                    .duration!
                                                    .toString(),
                                        cursorColor: DynamicTheme.of(context)
                                                    ?.brightness ==
                                                Brightness.light
                                            ? Colors.grey[100]
                                            : Colors.grey[600],
                                        onChanged: (newValue) {
                                          fullBudgets[index].duration =
                                              double.parse(newValue);

                                          readJsonFileContent.budget =
                                              fullBudgets;
                                          readJsonFileContent.totalBudget = 0;

                                          for (var i = 0;
                                              i < fullBudgets.length;
                                              i++) {
                                            if (fullBudgets[i].cost != null) {
                                              readJsonFileContent.totalBudget =
                                                  readJsonFileContent
                                                          .totalBudget! +
                                                      fullBudgets[i].cost!;
                                            } else {
                                              readJsonFileContent.totalBudget =
                                                  readJsonFileContent
                                                          .totalBudget! +
                                                      0;
                                            }
                                          }

                                          _futureProjectInformation =
                                              writeProjectData(
                                                  readJsonFileContent);
                                        },
                                        onFieldSubmitted: (newValue) {
                                          fullBudgets[index].duration =
                                              double.parse(newValue);

                                          readJsonFileContent.budget =
                                              fullBudgets;
                                          readJsonFileContent.totalBudget = 0;

                                          for (var i = 0;
                                              i < fullBudgets.length;
                                              i++) {
                                            if (fullBudgets[i].cost != null) {
                                              readJsonFileContent.totalBudget =
                                                  readJsonFileContent
                                                          .totalBudget! +
                                                      fullBudgets[i].cost!;
                                            } else {
                                              readJsonFileContent.totalBudget =
                                                  readJsonFileContent
                                                          .totalBudget! +
                                                      0;
                                            }
                                          }

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
                                    height:
                                        MediaQuery.of(context).size.height / 70),
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
                                      width: MediaQuery.of(context).size.width * 0.3,
                                      child: TextFormField(
                                        minLines: 1,
                                        maxLines: 250,
                                        autofocus: false,
                                        initialValue: fullBudgets[index].cost ==
                                                null
                                            ? ""
                                            : fullBudgets[index].cost!.toString(),
                                        cursorColor: DynamicTheme.of(context)
                                                    ?.brightness ==
                                                Brightness.light
                                            ? Colors.grey[100]
                                            : Colors.grey[600],
                                        onChanged: (newValue) {
                                          fullBudgets[index].cost =
                                              double.parse(newValue);

                                          readJsonFileContent.budget =
                                              fullBudgets;
                                          readJsonFileContent.totalBudget = 0;

                                          for (var i = 0;
                                              i < fullBudgets.length;
                                              i++) {
                                            if (fullBudgets[i].cost != null) {
                                              readJsonFileContent.totalBudget =
                                                  readJsonFileContent
                                                          .totalBudget! +
                                                      fullBudgets[i].cost!;
                                            } else {
                                              readJsonFileContent.totalBudget =
                                                  readJsonFileContent
                                                          .totalBudget! +
                                                      0;
                                            }
                                          }

                                          _futureProjectInformation =
                                              writeProjectData(
                                                  readJsonFileContent);
                                        },
                                        onFieldSubmitted: (newValue) {
                                          fullBudgets[index].cost =
                                              double.parse(newValue);

                                          readJsonFileContent.budget =
                                              fullBudgets;
                                          readJsonFileContent.totalBudget = 0;

                                          for (var i = 0;
                                              i < fullBudgets.length;
                                              i++) {
                                            if (fullBudgets[i].cost != null) {
                                              readJsonFileContent.totalBudget =
                                                  readJsonFileContent
                                                          .totalBudget! +
                                                      fullBudgets[i].cost!;
                                            } else {
                                              readJsonFileContent.totalBudget =
                                                  readJsonFileContent
                                                          .totalBudget! +
                                                      0;
                                            }
                                          }

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
                                    height:
                                        MediaQuery.of(context).size.height / 70),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02)
                      ],
                    );
                  },
                ),
              ),
        fullBudgets.isEmpty
            ? Container()
            : SizedBox(height: MediaQuery.of(context).size.height * 0.02),
      ],
    );
  }

}
