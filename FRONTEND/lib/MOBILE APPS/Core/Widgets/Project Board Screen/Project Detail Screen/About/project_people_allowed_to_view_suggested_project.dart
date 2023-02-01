import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class PeopleWhoAreAllowedToViewProjectMA extends StatefulWidget {
  const PeopleWhoAreAllowedToViewProjectMA({
    Key? key,
    
    this.selectedProject,
  }) : super(key: key);

  
  final ProjectModel? selectedProject;

  @override
  State<PeopleWhoAreAllowedToViewProjectMA> createState() => _PeopleWhoAreAllowedToViewProjectMAState();
}

class _PeopleWhoAreAllowedToViewProjectMAState extends State<PeopleWhoAreAllowedToViewProjectMA> {
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
              return buildBody(context);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }

  buildBody(BuildContext context) {
    return Column(
              children: [
                const ProjectDetailHeaderMA(
                     headerTitle: "PEOPLE WHO ARE\nALLOWED TO VIEW THE\nPROJECT"),
                readJsonFileContent.members == null
                    ? Container()
                    : SizedBox(
                  height: readJsonFileContent.members!.length *  MediaQuery.of(context).size.height * 0.51 + ((readJsonFileContent.members !.length - 1) *  MediaQuery.of(context).size.height * 0.02),
                  child: ListView.builder(
                      itemCount: readJsonFileContent.members!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return buildPersonAllowedToViewProjectContainer(index, context);
                      }),
                ),
                readJsonFileContent.members  == null
                    ? Container()
                    : SizedBox(height:  MediaQuery.of(context).size.height / 25),
              ],
            );
  }

  buildPersonAllowedToViewProjectContainer(int index, BuildContext context) {
    return Column(
                        children: [
                          Container(
                            color: Colors.black12,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Text(
                                    "PERSON ${index + 1}",
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
                                        "PERSON NAME",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize:  MediaQuery.of(context).size.width * 0.035,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        readJsonFileContent.members![index].memberName ==
                                            null
                                            ? ""
                                            : readJsonFileContent.members![index].memberName!,
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
                                        readJsonFileContent.members![index].jobTitle ==
                                            null
                                            ? ""
                                            : readJsonFileContent.members![index].jobTitle!,
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
                                            : readJsonFileContent.members![index].workEmail!,
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
                                            : readJsonFileContent.members![index].personalEmail!,
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
                                            : readJsonFileContent.members![index].phoneNumber!,
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
                                            : readJsonFileContent.members![index].contractType!,
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
                                            : readJsonFileContent.members![index].extension!,
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
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height:  MediaQuery.of(context).size.height * 0.04),
                        ],
                      );
  }
}