import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class ProjectMilestonesMA extends StatefulWidget {
  const ProjectMilestonesMA({
    Key? key,
    
    this.selectedProject,
  }) : super(key: key);

  
  final ProjectModel? selectedProject;

  @override
  State<ProjectMilestonesMA> createState() => _ProjectMilestonesMAState();
}

class _ProjectMilestonesMAState extends State<ProjectMilestonesMA> {
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
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1.0),
      child: FutureBuilder<ProjectModel>(
        future: readProjectData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  ProjectDetailHeaderMA(
                       headerTitle: 'MILESTONES'),
                  readJsonFileContent.milestones == null
                      ? Container()
                      : SizedBox(
                          height: (readJsonFileContent.milestones!.length *
                                  230) +
                              ((readJsonFileContent.milestones!.length - 1) *
                                  20),
                          child: ListView.builder(
                              itemCount: readJsonFileContent.milestones!.length,
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
                                            Text(
                                              "MILESTONE ${index + 1}",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                //letterSpacing: 8,
                                                fontFamily: 'Electrolize',
                                                fontSize:
                                                     MediaQuery.of(context).size.width *
                                                        0.045,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueGrey,
                                              ),
                                            ),
                                            const SizedBox(height: 5.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "MILESTONE",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    //letterSpacing: 8,
                                                    fontFamily: 'Electrolize',
                                                    fontSize:
                                                         MediaQuery.of(context).size.width *
                                                            0.035,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  readJsonFileContent
                                                              .milestones![index]
                                                              .milestones ==
                                                          null
                                                      ? ""
                                                      : readJsonFileContent
                                                          .milestones![index]
                                                          .milestones!,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    //letterSpacing: 8,
                                                    fontFamily: 'Electrolize',
                                                    fontSize:
                                                         MediaQuery.of(context).size.width *
                                                            0.035,
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
                                                  "% WEIGHT GIVEN",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    //letterSpacing: 8,
                                                    fontFamily: 'Electrolize',
                                                    fontSize:
                                                         MediaQuery.of(context).size.width *
                                                            0.035,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  readJsonFileContent
                                                              .milestones![index]
                                                              .weightGiven ==
                                                          null
                                                      ? ""
                                                      : "${readJsonFileContent.milestones![index].weightGiven!}%",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    //letterSpacing: 8,
                                                    fontFamily: 'Electrolize',
                                                    fontSize:
                                                         MediaQuery.of(context).size.width *
                                                            0.035,
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
                                                  "IMPACT",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    //letterSpacing: 8,
                                                    fontFamily: 'Electrolize',
                                                    fontSize:
                                                         MediaQuery.of(context).size.width *
                                                            0.035,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  readJsonFileContent
                                                              .milestones![index]
                                                              .impact ==
                                                          null
                                                      ? ""
                                                      : readJsonFileContent
                                                          .milestones![index]
                                                          .impact!,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    color: readJsonFileContent
                                                                .milestones![
                                                                    index]
                                                                .impact ==
                                                            "High"
                                                        ? Colors.red
                                                        : readJsonFileContent
                                                                    .milestones![
                                                                        index]
                                                                    .impact ==
                                                                "Medium"
                                                            ? Colors.yellow
                                                            : Colors.blue,
                                                    fontFamily: 'Electrolize',
                                                    fontSize:
                                                         MediaQuery.of(context).size.width *
                                                            0.035,
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
                                                  "START DATE",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    //letterSpacing: 8,
                                                    fontFamily: 'Electrolize',
                                                    fontSize:
                                                         MediaQuery.of(context).size.width *
                                                            0.035,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "END DATE",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    //letterSpacing: 8,
                                                    fontFamily: 'Electrolize',
                                                    fontSize:
                                                         MediaQuery.of(context).size.width *
                                                            0.035,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "DURATION",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    //letterSpacing: 8,
                                                    fontFamily: 'Electrolize',
                                                    fontSize:
                                                         MediaQuery.of(context).size.width *
                                                            0.035,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  readJsonFileContent
                                                              .milestones![index]
                                                              .startDate ==
                                                          null
                                                      ? ""
                                                      : DateFormat(
                                                              "EEE, MMM d, yyyy")
                                                          .format(
                                                          DateTime.parse(
                                                            readJsonFileContent
                                                                .milestones![
                                                                    index]
                                                                .startDate!,
                                                          ),
                                                        ),
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    //letterSpacing: 8,
                                                    fontFamily: 'Electrolize',
                                                    fontSize:
                                                         MediaQuery.of(context).size.width *
                                                            0.03,
                                                  ),
                                                ),
                                                Text(
                                                  readJsonFileContent
                                                              .milestones![index]
                                                              .endDate ==
                                                          null
                                                      ? ""
                                                      : DateFormat(
                                                              "EEE, MMM d, yyyy")
                                                          .format(
                                                          DateTime.parse(
                                                            readJsonFileContent
                                                                .milestones![
                                                                    index]
                                                                .endDate!,
                                                          ),
                                                        ),
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    //letterSpacing: 8,
                                                    fontFamily: 'Electrolize',
                                                    fontSize:
                                                         MediaQuery.of(context).size.width *
                                                            0.03,
                                                  ),
                                                ),
                                                Text(
                                                  readJsonFileContent
                                                              .milestones![index]
                                                              .duration ==
                                                          null
                                                      ? ""
                                                      : "${readJsonFileContent.milestones![index].duration} weeks",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    //letterSpacing: 8,
                                                    fontFamily: 'Electrolize',
                                                    fontSize:
                                                         MediaQuery.of(context).size.width *
                                                            0.03,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10.0),
                                             Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Text(
                                                          "DELIVERABLES",
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            //letterSpacing: 8,
                                                            fontFamily:
                                                                'Electrolize',
                                                            fontSize: MediaQuery.of(context).size
                                                                    .width *
                                                                0.035,
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                              .milestones![index]
                                                              .deliverables!,
                                                          textAlign:
                                                              TextAlign.left,
                                                          maxLines: 250,
                                                          style: TextStyle(
                                                            //letterSpacing: 8,
                                                            fontFamily:
                                                                'Electrolize',
                                                            fontSize: MediaQuery.of(context).size
                                                                    .width *
                                                                0.035,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                            const SizedBox(height: 10.0),
                                             Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "ACTION PLAN",
                                                        textAlign: TextAlign.left,
                                                        style: TextStyle(
                                                          //letterSpacing: 8,
                                                          fontFamily:
                                                              'Electrolize',
                                                          fontSize: MediaQuery.of(context).size
                                                                  .width *
                                                              0.035,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          readJsonFileContent.milestones![index]
                                                              .actionPlan ==
                                                              null
                                                              ? ""
                                                              : readJsonFileContent
                                                              .milestones![index]
                                                              .actionPlan!,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            //letterSpacing: 8,
                                                            fontFamily:
                                                                'Electrolize',
                                                            fontSize: MediaQuery.of(context).size
                                                                    .width *
                                                                0.035,
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
                                             MediaQuery.of(context).size.height * 0.02),
                                  ],
                                );
                              }),
                        ),
                  readJsonFileContent.milestones == null
                      ? Container()
                      : const SizedBox(height: 100),
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
}

/*
SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: DataTable(
                        columnSpacing: 40,
                        headingRowHeight: screenSize.width * 0.05,
                        //defaultColumnWidth: const FixedColumnWidth(150.0),
                        border: TableBorder.all(
                          color: Colors.grey,
                          style: BorderStyle.solid,
                          width: 1,
                        ),
                        columns: [
                          DataColumn(
                            label: Text(
                              "MILESTONE",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                //letterSpacing: 8,
                                fontFamily: 'Electrolize',
                                fontSize: screenSize.width * 0.035,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "% WEIGHT GIVEN",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                //letterSpacing: 8,
                                fontFamily: 'Electrolize',
                                fontSize: screenSize.width * 0.035,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "IMPACT",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                //letterSpacing: 8,
                                fontFamily: 'Electrolize',
                                fontSize: screenSize.width * 0.035,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "DELIVERABLES",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                //letterSpacing: 8,
                                fontFamily: 'Electrolize',
                                fontSize: screenSize.width * 0.035,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "START DATE",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                //letterSpacing: 8,
                                fontFamily: 'Electrolize',
                                fontSize: screenSize.width * 0.035,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "END DATE",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                //letterSpacing: 8,
                                fontFamily: 'Electrolize',
                                fontSize: screenSize.width * 0.035,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "DURATION (weeks)",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                //letterSpacing: 8,
                                fontFamily: 'Electrolize',
                                fontSize: screenSize.width * 0.035,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "ACTION PLAN",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                //letterSpacing: 8,
                                fontFamily: 'Electrolize',
                                fontSize: screenSize.width * 0.035,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                        rows: selectedProject!.milestones!
                            .map(
                              (milestone) => DataRow(
                                cells: [
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        milestone.milestones == null
                                            ? ""
                                            : milestone.milestones!,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize: screenSize.width * 0.03,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        milestone.weightGiven == null
                                            ? ""
                                            : "${milestone.weightGiven}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize: screenSize.width * 0.03,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        milestone.impact == null
                                            ? ""
                                            : milestone.impact!,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize: screenSize.width * 0.03,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        milestone.deliverables == null
                                            ? ""
                                            : milestone.deliverables!,
                                        textAlign: TextAlign.left,
                                        maxLines: 250,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize: screenSize.width * 0.03,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        milestone.startDate == null
                                            ? ""
                                            : milestone.startDate!,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize: screenSize.width * 0.03,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        milestone.endDate == null
                                            ? ""
                                            : milestone.endDate!,
                                        // DateFormat("EEE, MMM d, yyyy").format(DateTime.parse(milestone.endDate!)),
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize: screenSize.width * 0.03,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        milestone.duration == null
                                            ? ""
                                            : "${milestone.duration}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize: screenSize.width * 0.03,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Center(
                                      child: Text(
                                        milestone.actionPlan == null
                                            ? ""
                                            : milestone.actionPlan!,
                                        textAlign: TextAlign.left,
                                        maxLines: 250,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize: screenSize.width * 0.03,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              )
 */
