import 'dart:ui';

import 'package:origami_structure/imports.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

class ProjectSkillsRequiredWS extends StatefulWidget {
  const ProjectSkillsRequiredWS({
    Key? key,
    required this.selectedUser,
    this.selectedProject,
    required this.navigationMenu,
  }) : super(key: key);

  final UserModel? selectedUser;
  final ProjectModel? selectedProject;
  final NavigationMenu navigationMenu;

  @override
  State<ProjectSkillsRequiredWS> createState() =>
      _ProjectSkillsRequiredWSState();
}

class _ProjectSkillsRequiredWSState extends State<ProjectSkillsRequiredWS> {
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
              /// CALCULATE TOTAL NUMBER OF SKILLS ADDED TO USE FOR THE HEIGHT
              int totalSkills = 0;
              // print("readJsonFileContent.skillsRequired!: ${readJsonFileContent.skillsRequired!}");

              if (readJsonFileContent.skillsRequired == null ||
                  readJsonFileContent.skillsRequired!.isEmpty) {
                totalSkills = totalSkills + 0;
                rows;
              } else {
                for (var i = 0;
                    i < readJsonFileContent.skillsRequired!.length;
                    i++) {
                  if (readJsonFileContent.skillsRequired![i].hardSkills ==
                          null ||
                      readJsonFileContent
                          .skillsRequired![i].hardSkills!.isEmpty) {
                    totalSkills = totalSkills + 0;

                    rows.add(
                      PlutoRow(
                        cells: {
                          'id': PlutoCell(value: '${i + 1}'),
                          'skill': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].skillName),
                          'job field': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].jobField),
                          'job sub field': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].jobSubField),
                          'job specialization': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].jobSpecialization),
                          'job title': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].jobTitle),
                          'contract type': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].contractType),
                          'type of specialization': PlutoCell(value: ''),
                          'hard skill category': PlutoCell(value: ''),
                          'hard skill': PlutoCell(value: ''),
                          'level': PlutoCell(value: ''),
                          'start date': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].startDate),
                          'end date': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].endDate),
                          'duration': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].duration),
                          'assigned to': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].assignedTo),
                        },
                      ),
                    );
                  } else {
                    rows.add(
                      PlutoRow(
                        cells: {
                          'id': PlutoCell(value: '${i + 1}'),
                          'skill': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].skillName),
                          'job field': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].jobField),
                          'job sub field': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].jobSubField),
                          'job specialization': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].jobSpecialization),
                          'job title': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].jobTitle),
                          'contract type': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].contractType),
                          'type of specialization': PlutoCell(
                              value: readJsonFileContent.skillsRequired![i]
                                  .hardSkills![0].typeOfSpecialization),
                          'hard skill category': PlutoCell(
                              value: readJsonFileContent.skillsRequired![i]
                                  .hardSkills![0].skillCategory),
                          'hard skill': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].hardSkills![0].skill),
                          'level': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].hardSkills![0].level),
                          'start date': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].startDate),
                          'end date': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].endDate),
                          'duration': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].duration),
                          'assigned to': PlutoCell(
                              value: readJsonFileContent
                                  .skillsRequired![i].assignedTo),
                        },
                      ),
                    );
                    for (var j = 0;
                        j <
                            readJsonFileContent
                                    .skillsRequired![i].hardSkills!.length -
                                1;
                        j++) {
                      totalSkills = totalSkills + 1;

                      rows.add(
                        PlutoRow(
                          cells: {
                            'id': PlutoCell(value: ''),
                            'skill': PlutoCell(value: ''),
                            'job field': PlutoCell(value: ''),
                            'job sub field': PlutoCell(value: ''),
                            'job specialization': PlutoCell(value: ''),
                            'job title': PlutoCell(value: ''),
                            'contract type': PlutoCell(value: ''),
                            'type of specialization': PlutoCell(
                                value: readJsonFileContent.skillsRequired![i]
                                    .hardSkills![j + 1].typeOfSpecialization),
                            'hard skill category': PlutoCell(
                                value: readJsonFileContent.skillsRequired![i]
                                    .hardSkills![j + 1].skillCategory),
                            'hard skill': PlutoCell(
                                value: readJsonFileContent.skillsRequired![i]
                                    .hardSkills![j + 1].skill),
                            'level': PlutoCell(
                                value: readJsonFileContent.skillsRequired![i]
                                    .hardSkills![j + 1].level),
                            'start date': PlutoCell(value: ''),
                            'end date': PlutoCell(value: ''),
                            'duration': PlutoCell(value: ''),
                            'assigned to': PlutoCell(value: ''),
                          },
                        ),
                      );
                    }
                  }
                }
              }
              // print(rows);

              return Column(
                children: [
                  SizedBox(height: screenSize.height / 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ProjectDetailHeaderWS(
                      headerTitle: 'SKILLS REQUIRED',
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
                      ? buildTableView(context, screenSize, totalSkills)
                      :  readJsonFileContent.skillsRequired == null || readJsonFileContent.skillsRequired!.isEmpty
                          ? Container()
                          : buildGridView(
                              screenSize: screenSize,
                              crossAxisCount: 4,
                              crossAxisCellCount:
                                  ResponsiveWidget.isLargeScreen(context)
                                      ? 2
                                      : 1,
                            ),
                  SizedBox(height: screenSize.height / 10),
                ],
              );
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
      title: 'Skill',
      field: 'skill',
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
      title: 'Job Field',
      field: 'job field',
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
      title: 'Job Sub Field',
      field: 'job sub field',
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
      title: 'Job Specialization',
      field: 'job specialization',
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
      title: 'Job Title',
      field: 'job title',
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
      title: 'Contract Type',
      field: 'contract type',
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
      title: 'Type of Specialization',
      field: 'type of specialization',
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
      title: 'Hard Skill Category',
      field: 'hard skill category',
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
      title: 'Hard Skill',
      field: 'hard skill',
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
      title: 'Level',
      field: 'level',
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
      title: 'Start Date',
      field: 'start date',
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
      title: 'End Date',
      field: 'end date',
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
      title: 'Duration',
      field: 'duration',
      type: PlutoColumnType.number(),
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
      title: 'Assigned To',
      field: 'assigned to',
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
    PlutoColumnGroup(title: 'Skill', fields: ['skill'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Job Field', fields: ['job field'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Job Sub Field',
        fields: ['job sub field'],
        expandedColumn: true),
    PlutoColumnGroup(
        title: 'Job Specialization',
        fields: ['job specialization'],
        expandedColumn: true),
    PlutoColumnGroup(
        title: 'Job Title', fields: ['job title'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Contract Type',
        fields: ['contract type'],
        expandedColumn: true),
    PlutoColumnGroup(
        title: 'Type of Specialization',
        fields: ['type of specialization'],
        expandedColumn: true),
    PlutoColumnGroup(
        title: 'Hard Skill Category',
        fields: ['hard skill category'],
        expandedColumn: true),
    PlutoColumnGroup(
        title: 'Hard Skill', fields: ['hard skill'], expandedColumn: true),
    PlutoColumnGroup(title: 'Level', fields: ['level'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Start Date', fields: ['start date'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'End Date', fields: ['end date'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Duration', fields: ['duration'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Assigned To', fields: ['assigned to'], expandedColumn: true),
  ];

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late final PlutoGridStateManager stateManager;

  late String bodyViewSelected = "Table";

  buildTableView(BuildContext context, Size screenSize, int totalSkills) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          height: readJsonFileContent.skillsRequired == null ||
                  readJsonFileContent.skillsRequired!.isEmpty
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
        ),
        SizedBox(height: screenSize.height / 10),
      ],
    );
  }

  Widget buildGridView({
    required Size screenSize,
    required int crossAxisCount,
    required int crossAxisCellCount,
    Axis headerAxis = Axis.horizontal,
  }) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: crossAxisCount,
      itemCount: readJsonFileContent.skillsRequired!.length,
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
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "SKILL REQUIRED ${index + 1}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          //letterSpacing: 8,
                          fontFamily: 'Electrolize',
                          fontSize: screenSize.width * 0.012,
                          fontWeight: FontWeight.bold,
                          color: primaryColour,
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "JOB FIELD",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            //letterSpacing: 8,
                            fontFamily: 'Electrolize',
                            fontSize: screenSize.width * 0.01,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          readJsonFileContent.skillsRequired![index].jobField ==
                                  null
                              ? ""
                              : readJsonFileContent
                                  .skillsRequired![index].jobField!,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            //letterSpacing: 8,
                            fontFamily: 'Electrolize',
                            fontSize: screenSize.width * 0.01,
                          ),
                        ),
                      ),
                      SizedBox(height: screenSize.height / 70),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "JOB SUB-FIELD",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            //letterSpacing: 8,
                            fontFamily: 'Electrolize',
                            fontSize: screenSize.width * 0.01,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          readJsonFileContent
                                      .skillsRequired![index].jobSubField ==
                                  null
                              ? ""
                              : readJsonFileContent
                                  .skillsRequired![index].jobSubField!,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            //letterSpacing: 8,
                            fontFamily: 'Electrolize',
                            fontSize: screenSize.width * 0.01,
                          ),
                        ),
                      ),
                      SizedBox(height: screenSize.height / 70),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "JOB SPECIALIZATION",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            //letterSpacing: 8,
                            fontFamily: 'Electrolize',
                            fontSize: screenSize.width * 0.01,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          readJsonFileContent.skillsRequired![index]
                                      .jobSpecialization ==
                                  null
                              ? ""
                              : readJsonFileContent
                                  .skillsRequired![index].jobSpecialization!,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            //letterSpacing: 8,
                            fontFamily: 'Electrolize',
                            fontSize: screenSize.width * 0.01,
                          ),
                        ),
                      ),
                      SizedBox(height: screenSize.height / 70),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "JOB TITLE",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            //letterSpacing: 8,
                            fontFamily: 'Electrolize',
                            fontSize: screenSize.width * 0.01,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          readJsonFileContent.skillsRequired![index].jobTitle ==
                                  null
                              ? ""
                              : readJsonFileContent
                                  .skillsRequired![index].jobTitle!,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            //letterSpacing: 8,
                            fontFamily: 'Electrolize',
                            fontSize: screenSize.width * 0.01,
                          ),
                        ),
                      ),
                      SizedBox(height: screenSize.height / 70),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "SKILLS",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            //letterSpacing: 8,
                            fontFamily: 'Electrolize',
                            fontSize: screenSize.width * 0.01,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      readJsonFileContent.skillsRequired![index].hardSkills ==
                              null
                          ? Container()
                          : SizedBox(
                              height: readJsonFileContent.skillsRequired![index]
                                      .hardSkills!.length *
                                  260,
                              child: ListView.builder(
                                itemCount: readJsonFileContent
                                    .skillsRequired![index].hardSkills!.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, skillsRequiredIndex) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        top:
                                            MediaQuery.of(context).size.height *
                                                0.001),
                                    child: Column(
                                      children: [
                                        Container(
                                          color: Colors.black12,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Column(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        "SKILLS ${skillsRequiredIndex + 1}",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            letterSpacing: 2,
                                                            fontFamily:
                                                                'Electrolize',
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                primaryColour),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        height: 10.0),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        "TYPE OF SPECIALIZATION",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          //letterSpacing: 8,
                                                          fontFamily:
                                                              'Electrolize',
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.01,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5.0),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        readJsonFileContent
                                                                    .skillsRequired![
                                                                        index]
                                                                    .hardSkills![
                                                                        skillsRequiredIndex]
                                                                    .typeOfSpecialization ==
                                                                null
                                                            ? ""
                                                            : readJsonFileContent
                                                                .skillsRequired![
                                                                    index]
                                                                .hardSkills![
                                                                    skillsRequiredIndex]
                                                                .typeOfSpecialization!,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          //letterSpacing: 8,
                                                          fontFamily:
                                                              'Electrolize',
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.01,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            70),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        "HARD SKILL CATEGORY",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          //letterSpacing: 8,
                                                          fontFamily:
                                                              'Electrolize',
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.01,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5.0),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        readJsonFileContent
                                                                    .skillsRequired![
                                                                        index]
                                                                    .hardSkills![
                                                                        skillsRequiredIndex]
                                                                    .skillCategory ==
                                                                null
                                                            ? ""
                                                            : readJsonFileContent
                                                                .skillsRequired![
                                                                    index]
                                                                .hardSkills![
                                                                    skillsRequiredIndex]
                                                                .skillCategory!,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          //letterSpacing: 8,
                                                          fontFamily:
                                                              'Electrolize',
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.01,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            70),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        "HARD SKILL",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          //letterSpacing: 8,
                                                          fontFamily:
                                                              'Electrolize',
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.01,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5.0),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        readJsonFileContent
                                                                    .skillsRequired![
                                                                        index]
                                                                    .hardSkills![
                                                                        skillsRequiredIndex]
                                                                    .skill ==
                                                                null
                                                            ? ""
                                                            : readJsonFileContent
                                                                .skillsRequired![
                                                                    index]
                                                                .hardSkills![
                                                                    skillsRequiredIndex]
                                                                .skill!,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          //letterSpacing: 8,
                                                          fontFamily:
                                                              'Electrolize',
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.01,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            70),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        "LEVEL",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          //letterSpacing: 8,
                                                          fontFamily:
                                                              'Electrolize',
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.01,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        readJsonFileContent
                                                                    .skillsRequired![
                                                                        index]
                                                                    .hardSkills![
                                                                        skillsRequiredIndex]
                                                                    .level ==
                                                                null
                                                            ? ""
                                                            : readJsonFileContent
                                                                .skillsRequired![
                                                                    index]
                                                                .hardSkills![
                                                                    skillsRequiredIndex]
                                                                .level!,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          //letterSpacing: 8,
                                                          fontFamily:
                                                              'Electrolize',
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.01,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 20),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                      SizedBox(height: screenSize.height / 70),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "CONTRACT TYPE",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              //letterSpacing: 8,
                              fontFamily: 'Electrolize',
                              fontSize: screenSize.width * 0.01,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            readJsonFileContent
                                        .skillsRequired![index].contractType ==
                                    null
                                ? ""
                                : readJsonFileContent
                                    .skillsRequired![index].contractType!,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              //letterSpacing: 8,
                              fontFamily: 'Electrolize',
                              fontSize: screenSize.width * 0.01,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenSize.height / 70),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "START DATE",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              //letterSpacing: 8,
                              fontFamily: 'Electrolize',
                              fontSize: screenSize.width * 0.01,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "END DATE",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              //letterSpacing: 8,
                              fontFamily: 'Electrolize',
                              fontSize: screenSize.width * 0.01,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "DURATION",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              //letterSpacing: 8,
                              fontFamily: 'Electrolize',
                              fontSize: screenSize.width * 0.01,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            readJsonFileContent
                                        .skillsRequired![index].startDate ==
                                    null
                                ? ""
                                : DateFormat("EEE, MMM d, yyyy").format(
                                    DateTime.parse(
                                      readJsonFileContent
                                          .skillsRequired![index].startDate!,
                                    ),
                                  ),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              //letterSpacing: 8,
                              fontFamily: 'Electrolize',
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            readJsonFileContent
                                        .skillsRequired![index].endDate ==
                                    null
                                ? ""
                                : DateFormat("EEE, MMM d, yyyy").format(
                                    DateTime.parse(
                                      readJsonFileContent
                                          .skillsRequired![index].endDate!,
                                    ),
                                  ),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              //letterSpacing: 8,
                              fontFamily: 'Electrolize',
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            readJsonFileContent
                                        .skillsRequired![index].duration ==
                                    null
                                ? ""
                                : "${readJsonFileContent.skillsRequired![index].duration}",
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              //letterSpacing: 8,
                              fontFamily: 'Electrolize',
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenSize.height / 70),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "ASSIGNED TO",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              //letterSpacing: 8,
                              fontFamily: 'Electrolize',
                              fontSize: screenSize.width * 0.01,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            readJsonFileContent
                                        .skillsRequired![index].assignedTo ==
                                    null
                                ? ""
                                : readJsonFileContent
                                    .skillsRequired![index].assignedTo!,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              //letterSpacing: 8,
                              fontFamily: 'Electrolize',
                              fontSize: screenSize.width * 0.01,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenSize.height / 70),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10)
            ],
          ),
        );
      },
      staggeredTileBuilder: (int index) =>
          StaggeredTile.fit(crossAxisCellCount),
    );
  }
}
