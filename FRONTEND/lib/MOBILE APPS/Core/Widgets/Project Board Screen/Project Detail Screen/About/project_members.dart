import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class ProjectMembersMA extends StatefulWidget {
  const ProjectMembersMA({
    Key? key,
    
    this.selectedProject,
  }) : super(key: key);

  
  final ProjectModel? selectedProject;

  @override
  State<ProjectMembersMA> createState() => _ProjectMembersMAState();
}

class _ProjectMembersMAState extends State<ProjectMembersMA> {
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
                       headerTitle: 'MEMBERS'),
                  readJsonFileContent.members == null
                      ? Container()
                      : SizedBox(
                    height: readJsonFileContent.members!.length * 350 + ((readJsonFileContent.members!.length - 1) * 20),
                    child: ListView.builder(
                        itemCount: readJsonFileContent.members!.length,
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
                                        "MEMBER ${index + 1}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize:  MediaQuery.of(context).size.width * 0.045,
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
                                            "MEMBER NAME",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            readJsonFileContent
                                                .members![index].memberName ==
                                                null
                                                ? ""
                                                : readJsonFileContent
                                                .members![index].memberName!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
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
                                            "JOB TITLE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
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
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
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
                                            "ROLE IN PROJECT",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            readJsonFileContent.members![index]
                                                .projectJobPosition ==
                                                null
                                                ? ""
                                                : readJsonFileContent.members![index]
                                                .projectJobPosition!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: readJsonFileContent.members![index]
                                                  .projectJobPosition ==
                                                  "Project Manager"
                                                  ? Colors.red
                                                  : readJsonFileContent.members![index]
                                                  .projectJobPosition ==
                                                  "Project Leader"
                                                  ? Colors.yellow
                                                  : Colors.blue,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
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
                                            "WORK EMAIL",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                               MediaQuery.of(context).size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            readJsonFileContent.members![index].workEmail ==
                                                null
                                                ? ""
                                                : readJsonFileContent
                                                .members![index].workEmail!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                               MediaQuery.of(context).size.width * 0.035,
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
                                            "PERSONAL EMAIL",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                               MediaQuery.of(context).size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            readJsonFileContent.members![index].personalEmail ==
                                                null
                                                ? ""
                                                : readJsonFileContent
                                                .members![index].personalEmail!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                               MediaQuery.of(context).size.width * 0.035,
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
                                            "PHONE NUMBER",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                               MediaQuery.of(context).size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            readJsonFileContent.members![index].phoneNumber ==
                                                null
                                                ? ""
                                                : readJsonFileContent
                                                .members![index].phoneNumber!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                               MediaQuery.of(context).size.width * 0.035,
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
                                            "PHONE NUMBER 2 (OP)",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                               MediaQuery.of(context).size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            readJsonFileContent.members![index].optionalPhoneNumber ==
                                                null
                                                ? ""
                                                : readJsonFileContent.members![index]
                                                .optionalPhoneNumber!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                               MediaQuery.of(context).size.width * 0.035,
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
                                            "CONTRACT TYPE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                               MediaQuery.of(context).size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            readJsonFileContent.members![index].contractType ==
                                                null
                                                ? ""
                                                : readJsonFileContent
                                                .members![index].contractType!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                               MediaQuery.of(context).size.width * 0.035,
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
                                            "EXTENSION NUMBER",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                               MediaQuery.of(context).size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            readJsonFileContent.members![index].extension ==
                                                null
                                                ? ""
                                                : readJsonFileContent
                                                .members![index].extension!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                               MediaQuery.of(context).size.width * 0.035,
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
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "DURATION",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
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
                                                .members![index].startDate ==
                                                null
                                                ? ""
                                                : DateFormat("EEE, MMM d, yyyy")
                                                .format(
                                              DateTime.parse(
                                                readJsonFileContent
                                                    .members![index].startDate!,
                                              ),
                                            ),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.03,
                                            ),
                                          ),
                                          Text(
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
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.03,
                                            ),
                                          ),
                                          Text(
                                            readJsonFileContent
                                                .members![index].duration ==
                                                null
                                                ? ""
                                                : "${readJsonFileContent.members![index].duration} weeks",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.03,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10.0),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height:  MediaQuery.of(context).size.height * 0.04),
                            ],
                          );
                        }),
                  ),
                  readJsonFileContent.members == null
                      ? Container()
                      : SizedBox(height: 100),
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
                        // defaultColumnWidth: const FixedColumnWidth(150.0),
                        border: TableBorder.all(
                          color: Colors.grey,
                          style: BorderStyle.solid,
                          width: 1,
                        ),
                        columns: [
                          DataColumn(
                            label: Text(
                              "MEMBER NAME",
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
                              "JOB TITLE",
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
                              "ROLE IN PROJECT",
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
                              "WORK EMAIL",
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
                              "PERSONAL EMAIL",
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
                              "PHONE NUMBER",
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
                              "PN (Optional)",
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
                              "CONTRACT TYPE",
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
                              "DURATION",
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
                              "EXTENSION NUMBER",
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
                        rows: selectedProject!.members!
                            .map(
                              (member) => DataRow(
                                cells: [
                                  DataCell(
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        member.memberName == null
                                            ? ""
                                            : member.memberName!,
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
                                        member.jobTitle == null
                                            ? ""
                                            : "${member.jobTitle}",
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
                                        member.projectJobPosition == null
                                            ? ""
                                            : member.projectJobPosition!,
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
                                        member.workEmail == null
                                            ? ""
                                            : member.workEmail!,
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
                                        member.personalEmail == null
                                            ? ""
                                            : member.personalEmail!,
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
                                        member.phoneNumber == null
                                            ? ""
                                            : member.phoneNumber!,
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
                                        member.optionalPhoneNumber == null
                                            ? ""
                                            : member.optionalPhoneNumber!,
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
                                        member.contractType == null
                                            ? ""
                                            : member.contractType!,
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
                                        member.startDate == null
                                            ? ""
                                            : member.startDate!,
                                        //DateFormat("EEE, MMM d, yyyy").format(DateTime.parse(phase.startDate!)),
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
                                        member.endDate == null
                                            ? ""
                                            : member.endDate!,
                                        //DateFormat("EEE, MMM d, yyyy").format(DateTime.parse(phase.endDate!)),
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
                                        member.duration == null
                                            ? ""
                                            : "${member.duration}",
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
                                        member.extension == null
                                            ? ""
                                            : member.extension!,
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
