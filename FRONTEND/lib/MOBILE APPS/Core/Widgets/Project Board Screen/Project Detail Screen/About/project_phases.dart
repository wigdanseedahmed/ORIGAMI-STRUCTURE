import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class ProjectPhasesMA extends StatefulWidget {
  const ProjectPhasesMA({
    Key? key,
    
    this.selectedProject,
  }) : super(key: key);

  
  final ProjectModel? selectedProject;

  @override
  State<ProjectPhasesMA> createState() => _ProjectPhasesMAState();
}

class _ProjectPhasesMAState extends State<ProjectPhasesMA> {
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
                       headerTitle: 'PHASES'),
                  readJsonFileContent.phases == null
                      ? Container()
                      : SizedBox(
                    height: (readJsonFileContent.phases!.length *
                        230) +
                        ((readJsonFileContent.phases!.length - 1) *
                            20),
                    child: ListView.builder(
                        itemCount: readJsonFileContent.phases!.length,
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
                                        "PHASE ${index + 1}",
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
                                            "PHASE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            readJsonFileContent.phases![index]
                                                .phase ==
                                                null
                                                ? ""
                                                : readJsonFileContent
                                                .phases![index].phase!,
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
                                            "% WEIGHT GIVEN",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            readJsonFileContent.phases![index]
                                                .weightGiven ==
                                                null
                                                ? ""
                                                : "${readJsonFileContent.phases![index].weightGiven!}%",
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
                                            "IMPACT",
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
                                                .phases![index].impact ==
                                                null
                                                ? ""
                                                : readJsonFileContent
                                                .phases![index].impact!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              color: readJsonFileContent
                                                  .phases![index]
                                                  .impact ==
                                                  "High"
                                                  ? Colors.red
                                                  : readJsonFileContent
                                                  .phases![index]
                                                  .impact ==
                                                  "Medium"
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
                                            readJsonFileContent.phases![index]
                                                .startDate ==
                                                null
                                                ? ""
                                                : DateFormat("EEE, MMM d, yyyy")
                                                .format(
                                              DateTime.parse(
                                                readJsonFileContent
                                                    .phases![index]
                                                    .startDate!,
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
                                                .phases![index].endDate ==
                                                null
                                                ? ""
                                                : DateFormat("EEE, MMM d, yyyy")
                                                .format(
                                              DateTime.parse(
                                                readJsonFileContent
                                                    .phases![index]
                                                    .endDate!,
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
                                            readJsonFileContent.phases![index]
                                                .duration ==
                                                null
                                                ? ""
                                                : "${readJsonFileContent.phases![index].duration} weeks",
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
                                       Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                                 MediaQuery.of(context).size.width * 0.035,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 50.0),
                                          Expanded(
                                            child: Text(
                                              readJsonFileContent.phases![index]
                                                  .deliverables ==
                                                  null
                                                  ? ""
                                                  : readJsonFileContent
                                                  .phases![index]
                                                  .deliverables!,
                                              textAlign: TextAlign.left,
                                              maxLines: 250,
                                              style: TextStyle(
                                                //letterSpacing: 8,
                                                fontFamily: 'Electrolize',
                                                fontSize:
                                                 MediaQuery.of(context).size.width * 0.035,
                                              ),
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
                                            "ACTION PLAN",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                               MediaQuery.of(context).size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              readJsonFileContent.phases![index]
                                                  .actionPlan ==
                                                  null
                                                  ? ""
                                                  : readJsonFileContent
                                                  .phases![index].actionPlan!,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                //letterSpacing: 8,
                                                fontFamily: 'Electrolize',
                                                fontSize:
                                                 MediaQuery.of(context).size.width * 0.035,
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
                              SizedBox(height:  MediaQuery.of(context).size.height * 0.02),
                            ],
                          );
                        }),
                  ),
                  readJsonFileContent.phases == null
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