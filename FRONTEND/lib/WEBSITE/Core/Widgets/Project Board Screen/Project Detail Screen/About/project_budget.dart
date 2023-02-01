import 'dart:ui';

import 'package:origami_structure/imports.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

class ProjectBudgetWS extends StatefulWidget {
  const ProjectBudgetWS({
    Key? key,
    required this.selectedUser,
    this.selectedProject,
    required this.navigationMenu,
  }) : super(key: key);

  final UserModel? selectedUser;
  final ProjectModel? selectedProject;
  final NavigationMenu navigationMenu;

  @override
  State<ProjectBudgetWS> createState() => _ProjectBudgetWSState();
}

class _ProjectBudgetWSState extends State<ProjectBudgetWS> {
  /// VARIABLES FOR PROJECT
  /*
  ProjectModel readJsonFileContent = ProjectModel();

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
      //print("Project Info : ${readJsonFileContent}");

      return readJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }
*/
  @override
  void initState() {
    widget.selectedProject;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    if (widget.selectedProject!.budget == null ||
        widget.selectedProject!.budget!.isEmpty) {
      rows;
    } else {
      for (int i = 0; i < widget.selectedProject!.budget!.length; i++) {
        rows.add(
          PlutoRow(
            cells: {
              'id': PlutoCell(value: '${i + 1}'),
              'name': PlutoCell(value: widget.selectedProject!.budget![i].item),
              'type':
                  PlutoCell(value: widget.selectedProject!.budget![i].itemType),
              'purchase from': PlutoCell(
                  value: widget.selectedProject!.budget![i].purchaseFrom),
              'purchase date': PlutoCell(
                  value: widget.selectedProject!.budget![i].purchaseDate),
              'cost': PlutoCell(value: widget.selectedProject!.budget![i].cost),
            },
          ),
        );
      }
    }

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1.0),
      child: buildBody(context, screenSize),
    );
  }

  late String bodyViewSelected = "Table";

  buildBody(BuildContext context, Size screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenSize.height / 20),
        Align(
          alignment: Alignment.centerLeft,
          child: ProjectDetailHeaderWS(
            headerTitle: 'BUDGET',
            icon: Icon(
              bodyViewSelected == "Table"
                  ? Icons.grid_view_rounded
                  : Icons.table_view_rounded,
            ),
            onPressed: () {
              setState(() {
                if (bodyViewSelected == "Table") {
                  bodyViewSelected = "Grid";
                } else if (bodyViewSelected == "Grid") {
                  bodyViewSelected = "Table";
                }
              });
            },
          ),
        ),
        SizedBox(height: screenSize.height / 30),
        bodyViewSelected == "Table"
            ? buildTableView(screenSize)
            : widget.selectedProject!.budget == null || widget.selectedProject!.budget!.isEmpty

                ? Container()
                : buildGridView(
                    screenSize: screenSize,
                    crossAxisCount: 4,
                    crossAxisCellCount:
                        ResponsiveWidget.isLargeScreen(context) ? 2 : 1,
                  ),
        SizedBox(height: screenSize.height / 10),
      ],
    );
  }

  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      title: 'Id',
      field: 'id',
      type: PlutoColumnType.text(),
      backgroundColor: kShamrock,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Name',
      field: 'name',
      type: PlutoColumnType.text(),
      backgroundColor: kBlueChill,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Type',
      field: 'type',
      type: PlutoColumnType.text(),
      backgroundColor: kDeepSapphire,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Purchase From',
      field: 'purchase from',
      type: PlutoColumnType.text(),
      backgroundColor: kTolopea,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Purchase Date',
      field: 'purchase date',
      type: PlutoColumnType.date(),
      backgroundColor: kTolopea,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Cost',
      field: 'cost',
      type: PlutoColumnType.number(),
      backgroundColor: kViolet,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
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

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late final PlutoGridStateManager stateManager;

  buildTableView(Size screenSize) {
    return SizedBox(
      width: double.infinity,
      height: widget.selectedProject!.budget == null ||
              widget.selectedProject!.budget!.isEmpty
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
          print(event);
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

  Widget buildGridView({
    required Size screenSize,
    required int crossAxisCount,
    required int crossAxisCellCount,
    Axis headerAxis = Axis.horizontal,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StaggeredGridView.countBuilder(
          crossAxisCount: crossAxisCount,
          itemCount: widget.selectedProject!.budget!.length,
          addAutomaticKeepAlives: false,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          // border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ITEM ${index + 1}",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  //letterSpacing: 8,
                                  fontFamily: 'Electrolize',
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.012,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "ITEM NAME",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      //letterSpacing: 8,
                                      fontFamily: 'Electrolize',
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.01,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.selectedProject!.budget![index]
                                                .item ==
                                            null
                                        ? ""
                                        : widget.selectedProject!.budget![index]
                                            .item!,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      //letterSpacing: 8,
                                      fontFamily: 'Electrolize',
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.01,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "ITEM TYPE",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      //letterSpacing: 8,
                                      fontFamily: 'Electrolize',
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.01,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.selectedProject!.budget![index]
                                                .itemType ==
                                            null
                                        ? ""
                                        : widget.selectedProject!.budget![index]
                                            .itemType!,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      //letterSpacing: 8,
                                      fontFamily: 'Electrolize',
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.01,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "PURCHASE FROM",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      //letterSpacing: 8,
                                      fontFamily: 'Electrolize',
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.01,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.selectedProject!.budget![index]
                                                .purchaseFrom ==
                                            null
                                        ? ""
                                        : widget.selectedProject!.budget![index]
                                            .purchaseFrom!,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: 'Electrolize',
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.01,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "PURCHASE DATE",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      //letterSpacing: 8,
                                      fontFamily: 'Electrolize',
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.01,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.selectedProject!.budget![index]
                                                .purchaseDate ==
                                            null
                                        ? ""
                                        : DateFormat("EEE, MMM d, yyyy").format(
                                            DateTime.parse(
                                              widget.selectedProject!
                                                  .budget![index].purchaseDate!,
                                            ),
                                          ),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: 'Electrolize',
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.01,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "COST",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        //letterSpacing: 8,
                                        fontFamily: 'Electrolize',
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 50.0),
                                  Text(
                                    widget.selectedProject!.budget![index]
                                                .cost ==
                                            null
                                        ? "\$0"
                                        : "\$${widget.selectedProject!.budget![index].cost!}",
                                    textAlign: TextAlign.left,
                                    maxLines: 250,
                                    style: TextStyle(
                                      //letterSpacing: 8,
                                      fontFamily: 'Electrolize',
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.01,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          staggeredTileBuilder: (int index) =>
              StaggeredTile.fit(crossAxisCellCount),
        ),
      ],
    );
  }
}
