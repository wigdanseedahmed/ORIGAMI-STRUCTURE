import 'dart:ui';

import 'package:origami_structure/imports.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

class ProjectMembersWS extends StatefulWidget {
  const ProjectMembersWS({
    Key? key,
    required this.selectedUser,
    this.selectedProject,
    required this.navigationMenu,
  }) : super(key: key);

  final UserModel? selectedUser;
  final ProjectModel? selectedProject;
  final NavigationMenu navigationMenu;

  @override
  State<ProjectMembersWS> createState() => _ProjectMembersWSState();
}

class _ProjectMembersWSState extends State<ProjectMembersWS> {
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
              if (readJsonFileContent.members == null ||
                  readJsonFileContent.members!.isEmpty) {
                rows;
              } else {
                for (int i = 0; i < readJsonFileContent.members!.length; i++) {
                  rows.add(
                    PlutoRow(
                      cells: {
                        'id': PlutoCell(value: '${i + 1}'),
                        'name': PlutoCell(
                            value: readJsonFileContent.members![i].memberName),
                        'project job position': PlutoCell(
                            value: readJsonFileContent
                                .members![i].projectJobPosition),
                        'job title': PlutoCell(
                            value: readJsonFileContent.members![i].jobTitle),
                        'phone number': PlutoCell(
                            value: readJsonFileContent.members![i].phoneNumber),
                        'optional phone number': PlutoCell(
                            value: readJsonFileContent
                                .members![i].optionalPhoneNumber),
                        'work email': PlutoCell(
                            value: readJsonFileContent.members![i].workEmail),
                        'contract type': PlutoCell(
                            value:
                                readJsonFileContent.members![i].contractType),
                        'start date': PlutoCell(
                            value: readJsonFileContent.members![i].startDate),
                        'end date': PlutoCell(
                            value: readJsonFileContent.members![i].endDate),
                        'duration': PlutoCell(
                            value: readJsonFileContent.members![i].duration),
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
          child: ProjectDetailHeaderWS(headerTitle: 'MEMBERS', icon: Icon(
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
            },),
        ),
        SizedBox(height: screenSize.height / 30),
        bodyViewSelected == "Table"
            ? buildTableView(screenSize)
            :readJsonFileContent.members == null ||  readJsonFileContent.members!.isEmpty
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
      title: 'Project Job Position',
      field: 'project job position',
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
      title: 'Phone Number',
      field: 'phone number',
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
      title: 'Optional Phone Number',
      field: 'optional phone number',
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
      title: 'Work Email',
      field: 'work email',
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
      title: 'Contract Type',
      field: 'contract type',
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
      title: 'Start Date',
      field: 'start date',
      type: PlutoColumnType.date(),
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
      title: 'End Date',
      field: 'end date',
      type: PlutoColumnType.date(),
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
      title: 'Duration',
      field: 'duration',
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
    PlutoColumnGroup(
        title: 'Project Job Position',
        fields: ['project job position'],
        expandedColumn: true),
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

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late final PlutoGridStateManager stateManager;

  buildTableView(Size screenSize) {
    return SizedBox(
        width: double.infinity,
        height: readJsonFileContent.members == null ||
                readJsonFileContent.members!.isEmpty
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
          itemCount: readJsonFileContent.members!.length,
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
                            "MEMBER ${index + 1}",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              //letterSpacing: 8,
                              fontFamily: 'Electrolize',
                              fontSize:
                              MediaQuery.of(context).size.width *
                                  0.013,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "MEMBER NAME",
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
                              Text(
                                readJsonFileContent.members![index]
                                    .memberName ==
                                    null
                                    ? ""
                                    : readJsonFileContent
                                    .members![index].memberName!,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  //letterSpacing: 8,
                                  fontFamily: 'Electrolize',
                                  fontSize: MediaQuery.of(context)
                                      .size
                                      .width *
                                      0.01,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "JOB TITLE",
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
                              Text(
                                readJsonFileContent
                                    .members![index].jobTitle ==
                                    null
                                    ? ""
                                    : readJsonFileContent
                                    .members![index].jobTitle!,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  //letterSpacing: 8,
                                  fontFamily: 'Electrolize',
                                  fontSize: MediaQuery.of(context)
                                      .size
                                      .width *
                                      0.01,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "ROLE IN PROJECT",
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
                              Text(
                                readJsonFileContent.members![index]
                                    .projectJobPosition ==
                                    null
                                    ? ""
                                    : readJsonFileContent
                                    .members![index]
                                    .projectJobPosition!,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: readJsonFileContent
                                      .members![index]
                                      .projectJobPosition ==
                                      "Project Manager"
                                      ? Colors.red
                                      : readJsonFileContent
                                      .members![index]
                                      .projectJobPosition ==
                                      "Project Leader"
                                      ? Colors.yellow
                                      : Colors.blue,
                                  fontFamily: 'Electrolize',
                                  fontSize: MediaQuery.of(context)
                                      .size
                                      .width *
                                      0.01,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "WORK EMAIL",
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
                              Text(
                                readJsonFileContent.members![index]
                                    .workEmail ==
                                    null
                                    ? ""
                                    : readJsonFileContent
                                    .members![index].workEmail!,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'Electrolize',
                                  fontSize: MediaQuery.of(context)
                                      .size
                                      .width *
                                      0.01,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "PERSONAL EMAIL",
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
                              Text(
                                readJsonFileContent.members![index]
                                    .personalEmail ==
                                    null
                                    ? ""
                                    : readJsonFileContent
                                    .members![index].personalEmail!,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'Electrolize',
                                  fontSize: MediaQuery.of(context)
                                      .size
                                      .width *
                                      0.01,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "PHONE NUMBER",
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
                              Text(
                                readJsonFileContent.members![index]
                                    .phoneNumber ==
                                    null
                                    ? ""
                                    : readJsonFileContent
                                    .members![index].phoneNumber!,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'Electrolize',
                                  fontSize: MediaQuery.of(context)
                                      .size
                                      .width *
                                      0.01,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "PHONE NUMBER 2 (OP)",
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
                              Text(
                                readJsonFileContent.members![index]
                                    .optionalPhoneNumber ==
                                    null
                                    ? ""
                                    : readJsonFileContent
                                    .members![index]
                                    .optionalPhoneNumber!,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'Electrolize',
                                  fontSize: MediaQuery.of(context)
                                      .size
                                      .width *
                                      0.01,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "CONTRACT TYPE",
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
                              Text(
                                readJsonFileContent.members![index]
                                    .contractType ==
                                    null
                                    ? ""
                                    : readJsonFileContent
                                    .members![index].contractType!,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'Electrolize',
                                  fontSize: MediaQuery.of(context)
                                      .size
                                      .width *
                                      0.01,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "EXTENSION NUMBER",
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
                              Text(
                                readJsonFileContent.members![index]
                                    .extension ==
                                    null
                                    ? ""
                                    : readJsonFileContent
                                    .members![index].extension!,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'Electrolize',
                                  fontSize: MediaQuery.of(context)
                                      .size
                                      .width *
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
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.07,
                                child: Text(
                                  readJsonFileContent.members![index]
                                      .startDate ==
                                      null
                                      ? ""
                                      : DateFormat("EEE, MMM d, yyyy")
                                      .format(
                                    DateTime.parse(
                                      readJsonFileContent
                                          .members![index]
                                          .startDate!,
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
                                      .members![index].endDate ==
                                      null
                                      ? ""
                                      : DateFormat("EEE, MMM d, yyyy")
                                      .format(
                                    DateTime.parse(
                                      readJsonFileContent
                                          .members![index].endDate!,
                                    ),
                                  ),
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    //letterSpacing: 8,
                                    fontFamily: 'Electrolize',
                                    fontSize:15,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.06,
                                child: Text(
                                  readJsonFileContent
                                      .members![index].duration ==
                                      null
                                      ? ""
                                      : "${readJsonFileContent.members![index].duration} weeks",
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
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                      height:
                      MediaQuery.of(context).size.height * 0.04),
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