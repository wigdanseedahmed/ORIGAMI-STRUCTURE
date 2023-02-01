import 'dart:ui';

import 'package:origami_structure/imports.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

class ProjectResourcesWS extends StatefulWidget {
  const ProjectResourcesWS({
    Key? key,
    required this.selectedUser,
    this.selectedProject,
    required this.navigationMenu,
  }) : super(key: key);

  final UserModel? selectedUser;
  final ProjectModel? selectedProject;
  final NavigationMenu navigationMenu;

  @override
  State<ProjectResourcesWS> createState() => _ProjectResourcesWSState();
}

class _ProjectResourcesWSState extends State<ProjectResourcesWS> {
  /// VARIABLES FOR PROJECT
  ProjectModel readProjectContent = ProjectModel();

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
      readProjectContent = projectModelFromJson(response.body)[0];
      //print("Project Info : ${readJsonFileContent}");

      return readProjectContent;
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
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1.0),
      child: FutureBuilder<ProjectModel>(
        future: readProjectData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (readProjectContent.resources == null ||
                  readProjectContent.resources!.isEmpty) {
                rows;
              } else {
                for (int i = 0; i < readProjectContent.resources!.length; i++) {
                  rows.add(
                    PlutoRow(
                      cells: {
                        'id': PlutoCell(value: '${i + 1}'),
                        'type': PlutoCell(
                            value:
                                readProjectContent.resources![i].resourcesType),
                        'tool': PlutoCell(
                            value:
                                readProjectContent.resources![i].resourcesTool),
                        'reference': PlutoCell(
                            value: readProjectContent.resources![i].reference),
                        'start date': PlutoCell(
                            value: readProjectContent.resources![i].startDate),
                        'end date': PlutoCell(
                            value: readProjectContent.resources![i].endDate),
                        'duration': PlutoCell(
                            value: readProjectContent.resources![i].duration),
                        'cost': PlutoCell(
                            value: readProjectContent.resources![i].cost),
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

  buildBody(BuildContext context, Size screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenSize.height / 20),
        Align(
          alignment: Alignment.centerLeft,
          child: ProjectDetailHeaderWS(
            headerTitle: 'RESOURCES',
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
            : readProjectContent.resources == null ||
                    readProjectContent.resources!.isEmpty
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
      title: 'Tool',
      field: 'tool',
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
      title: 'Reference',
      field: 'reference',
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
      title: 'Start Date',
      field: 'start date',
      type: PlutoColumnType.date(),
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
      title: 'End Date',
      field: 'end date',
      type: PlutoColumnType.date(),
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
      title: 'Duration',
      field: 'duration',
      type: PlutoColumnType.number(),
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
      title: 'Cost',
      field: 'cost',
      type: PlutoColumnType.number(),
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

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late final PlutoGridStateManager stateManager;

  late String bodyViewSelected = "Table";

  buildTableView(Size screenSize) {
    return SizedBox(
      width: double.infinity,
      height: readProjectContent.resources == null ||
              readProjectContent.resources!.isEmpty
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
          itemCount: readProjectContent.resources!.length,
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
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      // border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text(
                            "RESOURCE ${index + 1}",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              //letterSpacing: 8,
                              fontFamily: 'Electrolize',
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.013,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "RESOURCE TYPE",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  //letterSpacing: 8,
                                  fontFamily: 'Electrolize',
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.01,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                readProjectContent
                                            .resources![index].resourcesType ==
                                        null
                                    ? ""
                                    : readProjectContent
                                        .resources![index].resourcesType!,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  //letterSpacing: 8,
                                  fontFamily: 'Electrolize',
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.01,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "RESOURCE TOOL",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  //letterSpacing: 8,
                                  fontFamily: 'Electrolize',
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.01,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                readProjectContent
                                            .resources![index].resourcesTool ==
                                        null
                                    ? ""
                                    : readProjectContent
                                        .resources![index].resourcesTool!,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  //letterSpacing: 8,
                                  fontFamily: 'Electrolize',
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.01,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          readProjectContent.resources![index].reference == null
                              ? Container()
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "REFERENCE",
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
                                      readProjectContent
                                          .resources![index].reference!,
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
                          readProjectContent.resources![index].reference == null
                              ? Container()
                              : const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.07,
                                child: Text(
                                  "START DATE",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    //letterSpacing: 8,
                                    fontFamily: 'Electrolize',
                                    fontSize: MediaQuery.of(context)
                                        .size
                                        .width *
                                        0.01,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.07,
                                child: Text(
                                  "END DATE",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    //letterSpacing: 8,
                                    fontFamily: 'Electrolize',
                                    fontSize: MediaQuery.of(context)
                                        .size
                                        .width *
                                        0.01,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.06,
                                child: Text(
                                  "DURATION",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    //letterSpacing: 8,
                                    fontFamily: 'Electrolize',
                                    fontSize: MediaQuery.of(context)
                                        .size
                                        .width *
                                        0.01,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.07,
                                child: Text(
                                  readProjectContent
                                              .resources![index].startDate ==
                                          null
                                      ? ""
                                      : DateFormat("EEE, MMM d, yyyy").format(
                                          DateTime.parse(
                                            readProjectContent
                                                .resources![index].startDate!,
                                          ),
                                        ),
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    //letterSpacing: 8,
                                    fontFamily: 'Electrolize',
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.07,
                                child: Text(
                                  readProjectContent.resources![index].endDate ==
                                          null
                                      ? ""
                                      : DateFormat("EEE, MMM d, yyyy").format(
                                          DateTime.parse(
                                            readProjectContent
                                                .resources![index].endDate!,
                                          ),
                                        ),
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    //letterSpacing: 8,
                                    fontFamily: 'Electrolize',
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.06,
                                child: Text(
                                  readProjectContent.resources![index].duration ==
                                          null
                                      ? ""
                                      : "${readProjectContent.resources![index].duration} weeks",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    //letterSpacing: 8,
                                    fontFamily: 'Electrolize',
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          readProjectContent.resources![index].cost == null
                              ? Container()
                              : Row(
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
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.01,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 50.0),
                                    Text(
                                      "\$${readProjectContent.resources![index].cost!}",
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
                          readProjectContent.resources![index].cost == null
                              ? Container()
                              : const SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
