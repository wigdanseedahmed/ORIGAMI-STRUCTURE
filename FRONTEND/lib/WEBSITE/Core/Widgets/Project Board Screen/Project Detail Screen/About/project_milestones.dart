import 'dart:ui';

import 'package:origami_structure/imports.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

class ProjectMilestonesWS extends StatefulWidget {
  const ProjectMilestonesWS({
    Key? key,
    required this.selectedUser,
    this.selectedProject,
    required this.navigationMenu,
  }) : super(key: key);

  final UserModel? selectedUser;
  final ProjectModel? selectedProject;
  final NavigationMenu navigationMenu;

  @override
  State<ProjectMilestonesWS> createState() => _ProjectMilestonesWSState();
}

class _ProjectMilestonesWSState extends State<ProjectMilestonesWS> {
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
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1.0),
      child: FutureBuilder<ProjectModel>(
        future: readProjectData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (readJsonFileContent.milestones == null ||
                  readJsonFileContent.milestones!.isEmpty) {
                rows;
              } else {
                for (int i = 0;
                    i < readJsonFileContent.milestones!.length;
                    i++) {
                  rows.add(
                    PlutoRow(
                      cells: {
                        'id': PlutoCell(value: '${i + 1}'),
                        'milestone': PlutoCell(
                            value:
                                readJsonFileContent.milestones![i].milestones),
                        'start date': PlutoCell(
                            value:
                                readJsonFileContent.milestones![i].startDate),
                        'end date': PlutoCell(
                            value: readJsonFileContent.milestones![i].endDate),
                        'duration': PlutoCell(
                            value: readJsonFileContent.milestones![i].duration),
                        'impact': PlutoCell(
                            value: readJsonFileContent.milestones![i].impact),
                        'weight given': PlutoCell(
                            value:
                                readJsonFileContent.milestones![i].weightGiven),
                        'deliverables': PlutoCell(
                            value: readJsonFileContent
                                .milestones![i].deliverables),
                        'action plan': PlutoCell(
                            value:
                                readJsonFileContent.milestones![i].actionPlan),
                        'risks': PlutoCell(
                            value: readJsonFileContent.milestones![i].risks),
                        'comments': PlutoCell(
                            value: readJsonFileContent.milestones![i].comments),
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

  late String bodyViewSelected = "Table";

  buildBody(BuildContext context, Size screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenSize.height / 20),
        Align(
          alignment: Alignment.centerLeft,
          child: ProjectDetailHeaderWS(
            headerTitle: 'MILESTONES',
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
            : readJsonFileContent.milestones == null || readJsonFileContent.milestones!.isEmpty
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
      title: 'Milestone',
      field: 'milestone',
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
      title: 'Impact',
      field: 'impact',
      type: PlutoColumnType.text(),
      backgroundColor: kDeepSapphire,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else if (rendererContext.cell.value == "High") {
          textColor = Colors.red;
        } else if (rendererContext.cell.value == "Medium") {
          textColor = Colors.yellow;
        } else if (rendererContext.cell.value == "Low") {
          textColor = Colors.blue;
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
      title: 'Weight Given',
      field: 'weight given',
      type: PlutoColumnType.number(),
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
      title: 'Deliverables',
      field: 'deliverables',
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
      title: 'Action Plan',
      field: 'action plan',
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
      title: 'Risks',
      field: 'risks',
      type: PlutoColumnType.text(),
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
    PlutoColumn(
      title: 'Comments',
      field: 'comments',
      type: PlutoColumnType.text(),
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
    PlutoColumnGroup(
        title: 'Milestone', fields: ['milestone'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Start Date', fields: ['start date'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'End Date', fields: ['end date'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Duration', fields: ['duration'], expandedColumn: true),
    PlutoColumnGroup(title: 'Impact', fields: ['impact'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Weight Given', fields: ['weight given'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Deliverables', fields: ['deliverables'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Action Plan', fields: ['action plan'], expandedColumn: true),
    PlutoColumnGroup(title: 'Risks', fields: ['risks'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Comments', fields: ['comments'], expandedColumn: true),
  ];

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late final PlutoGridStateManager stateManager;

  buildTableView(Size screenSize) {
    return SizedBox(
      width: double.infinity,
      height: readJsonFileContent.milestones == null ||
              readJsonFileContent.milestones!.isEmpty
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
          itemCount: readJsonFileContent.milestones!.length,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "MILESTONE ${index + 1}",
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "MILESTONE",
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
                                readJsonFileContent
                                            .milestones![index].milestones ==
                                        null
                                    ? ""
                                    : readJsonFileContent
                                        .milestones![index].milestones!,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "% WEIGHT GIVEN",
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
                                readJsonFileContent
                                            .milestones![index].weightGiven ==
                                        null
                                    ? ""
                                    : "${readJsonFileContent.milestones![index].weightGiven!}%",
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "IMPACT",
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
                                readJsonFileContent.milestones![index].impact ==
                                        null
                                    ? ""
                                    : readJsonFileContent
                                        .milestones![index].impact!,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: readJsonFileContent
                                              .milestones![index].impact ==
                                          "High"
                                      ? Colors.red
                                      : readJsonFileContent
                                                  .milestones![index].impact ==
                                              "Medium"
                                          ? Colors.yellow
                                          : Colors.blue,
                                  fontFamily: 'Electrolize',
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.01,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.07,
                                child: Text(
                                  readJsonFileContent
                                              .milestones![index].startDate ==
                                          null
                                      ? ""
                                      : DateFormat("EEE, MMM d, yyyy").format(
                                          DateTime.parse(
                                            readJsonFileContent
                                                .milestones![index].startDate!,
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
                                  readJsonFileContent
                                              .milestones![index].endDate ==
                                          null
                                      ? ""
                                      : DateFormat("EEE, MMM d, yyyy").format(
                                          DateTime.parse(
                                            readJsonFileContent
                                                .milestones![index].endDate!,
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
                                  readJsonFileContent
                                              .milestones![index].duration ==
                                          null
                                      ? ""
                                      : "${readJsonFileContent.milestones![index].duration} weeks",
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "DELIVERABLES",
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
                              Expanded(
                                child: Text(
                                  readJsonFileContent.milestones![index]
                                              .deliverables ==
                                          null
                                      ? ""
                                      : readJsonFileContent
                                          .milestones![index].deliverables!,
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
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "ACTION PLAN",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  //letterSpacing: 8,
                                  fontFamily: 'Electrolize',
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.01,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  readJsonFileContent
                                              .milestones![index].actionPlan ==
                                          null
                                      ? ""
                                      : readJsonFileContent
                                          .milestones![index].actionPlan!,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    //letterSpacing: 8,
                                    fontFamily: 'Electrolize',
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.01,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
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
