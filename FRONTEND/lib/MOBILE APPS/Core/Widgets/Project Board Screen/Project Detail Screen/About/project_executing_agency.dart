import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class ProjectExecutingAgencyMA extends StatefulWidget {
  const ProjectExecutingAgencyMA({
    Key? key,
    
    this.selectedProject,
  }) : super(key: key);

  
  final ProjectModel? selectedProject;

  @override
  State<ProjectExecutingAgencyMA> createState() => _ProjectExecutingAgencyMAState();
}

class _ProjectExecutingAgencyMAState extends State<ProjectExecutingAgencyMA> {
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
                       headerTitle: 'EXECUTING AGENCY'),
                  readJsonFileContent.executingAgency == null
                      ? Container()
                      : SizedBox(
                    height: readJsonFileContent.executingAgency!.length * 140 + ((readJsonFileContent.members!.length - 1) * 20),
                    child: ListView.builder(
                        itemCount: readJsonFileContent.executingAgency!.length,
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
                                        "AGENCY ${index + 1}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize:  MediaQuery.of(context).size.width * 0.045,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "AGENCY NAME",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            readJsonFileContent.executingAgency![index]
                                                .executingAgencyName ==
                                                null
                                                ? ""
                                                : readJsonFileContent
                                                .executingAgency![index].executingAgencyName!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5.0),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "AGENCY DEPARTMENT",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            readJsonFileContent.executingAgency![index]
                                                .executingAgencyDepartment ==
                                                null
                                                ? ""
                                                : readJsonFileContent
                                                .executingAgency![index].executingAgencyDepartment!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5.0),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "AGENCY TEAM",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            readJsonFileContent.executingAgency![index]
                                                .executingAgencyTeam ==
                                                null
                                                ? ""
                                                : readJsonFileContent
                                                .executingAgency![index].executingAgencyTeam!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5.0),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "WEBSITE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            readJsonFileContent.executingAgency![index]
                                                .executingAgencyWebsite ==
                                                null
                                                ? ""
                                                : readJsonFileContent
                                                .executingAgency![index].executingAgencyWebsite!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5.0),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "EMAIL",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            readJsonFileContent.executingAgency![index]
                                                .executingAgencyEmail ==
                                                null
                                                ? ""
                                                : readJsonFileContent
                                                .executingAgency![index]
                                                .executingAgencyEmail!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5.0),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height:  MediaQuery.of(context).size.height * 0.02),
                            ],
                          );
                        }),
                  ),
                  readJsonFileContent.executingAgency == null
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