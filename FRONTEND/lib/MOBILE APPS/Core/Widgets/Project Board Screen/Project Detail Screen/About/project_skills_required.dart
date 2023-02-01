import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class ProjectSkillsRequiredMA extends StatefulWidget {
  const ProjectSkillsRequiredMA({
    Key? key,
    
    this.selectedProject,
  }) : super(key: key);

  
  final ProjectModel? selectedProject;

  @override
  State<ProjectSkillsRequiredMA> createState() => _ProjectSkillsRequiredMAState();
}

class _ProjectSkillsRequiredMAState extends State<ProjectSkillsRequiredMA> {
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
              /// CALCULATE TOTAL NUMBER OF SKILLS ADDED TO USE FOR THE HEIGHT
              int totalSkills = 0;
              // print("readJsonFileContent.skillsRequired!: ${readJsonFileContent.skillsRequired!}");

              for (var i = 0; i < readJsonFileContent.skillsRequired!.length; i++) {
                // print(fullChecklistList.length);
                if (readJsonFileContent.skillsRequired![i].hardSkills == null) {
                  totalSkills = totalSkills + 0;
                } else {
                  for (var j = 0; j < readJsonFileContent.skillsRequired![i].hardSkills!.length; j++) {
                    //print(fullChecklistList[i].checklistItems!.length);

                    totalSkills = totalSkills + 1;
                  }
                }
              }

              return Column(
                children: [
                  ProjectDetailHeaderMA(
                    headerTitle: 'SKILLS REQUIRED',
                  ),
                  readJsonFileContent.skillsRequired == null ||  readJsonFileContent.skillsRequired!.isEmpty
                      ? Container()
                      : SizedBox(
                    height: (readJsonFileContent.skillsRequired!.length * 410) +
                        (totalSkills * 260) +
                        ((readJsonFileContent.skillsRequired!.length - 1) * 20),
                    child: ListView.builder(
                        itemCount: readJsonFileContent.skillsRequired!.length,
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
                                        "SKILL REQUIRED ${index + 1}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize:
                                           MediaQuery.of(context).size.width *
                                              0.045,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColour,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "JOB FIELD",
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
                                      ),
                                      const SizedBox(height: 5.0),
                                      Align(
                                        alignment: Alignment
                                            .centerLeft,
                                        child: Text(
                                          readJsonFileContent.skillsRequired![
                                          index]
                                              .jobField ==
                                              null
                                              ? ""
                                              : readJsonFileContent.skillsRequired![index]
                                              .jobField!,
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
                                      SizedBox(height:  MediaQuery.of(context).size.height / 70),
                                      Align(
                                        alignment: Alignment
                                            .centerLeft,
                                        child: Text(
                                          "JOB SUB-FIELD",
                                          textAlign:
                                          TextAlign.left,
                                          style: TextStyle(
                                            //letterSpacing: 8,
                                            fontFamily:
                                            'Electrolize',
                                            fontSize:MediaQuery.of(context).size
                                                .width *
                                                0.035,
                                            fontWeight:
                                            FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Align(
                                        alignment: Alignment
                                            .centerLeft,
                                        child: Text(
                                          readJsonFileContent.skillsRequired![
                                          index]
                                              .jobSubField ==
                                              null
                                              ? ""
                                              : readJsonFileContent.skillsRequired![index]
                                              .jobSubField!,
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
                                      SizedBox(height:  MediaQuery.of(context).size.height / 70),
                                      Align(
                                        alignment: Alignment
                                            .centerLeft,
                                        child: Text(
                                          "JOB SPECIALIZATION",
                                          textAlign:
                                          TextAlign.left,
                                          style: TextStyle(
                                            //letterSpacing: 8,
                                            fontFamily:
                                            'Electrolize',
                                            fontSize:MediaQuery.of(context).size
                                                .width *
                                                0.035,
                                            fontWeight:
                                            FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5.0),
                                      Align(
                                        alignment: Alignment
                                            .centerLeft,
                                        child: Text(
                                          readJsonFileContent.skillsRequired![
                                          index]
                                              .jobSpecialization ==
                                              null
                                              ? ""
                                              : readJsonFileContent.skillsRequired![index]
                                              .jobSpecialization!,
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
                                      SizedBox(height:  MediaQuery.of(context).size.height / 70),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "JOB TITLE",
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
                                      ),
                                      const SizedBox(height: 5.0),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          readJsonFileContent.skillsRequired![
                                          index]
                                              .jobTitle ==
                                              null
                                              ? ""
                                              : readJsonFileContent.skillsRequired![
                                          index]
                                              .jobTitle!,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            //letterSpacing: 8,
                                            fontFamily: 'Electrolize',
                                            fontSize:
                                             MediaQuery.of(context).size.width *
                                                0.035,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height:  MediaQuery.of(context).size.height / 70),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "SKILLS",
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
                                      ),
                                      const SizedBox(height: 10),
                                      readJsonFileContent.skillsRequired![index].hardSkills == null ?
                                          Container() :
                                      SizedBox(
                                        height: readJsonFileContent.skillsRequired![index].hardSkills!.length * 260,
                                        child: ListView.builder(
                                          itemCount: readJsonFileContent.skillsRequired![index].hardSkills!.length,
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, skillsRequiredIndex) {
                                            return Padding(
                                              padding: EdgeInsets.only(top:  MediaQuery.of(context).size.height * 0.001),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    color: Colors.black12,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: Text(
                                                                  "SKILLS ${skillsRequiredIndex + 1}",
                                                                  textAlign: TextAlign.left,
                                                                  style: TextStyle(
                                                                      letterSpacing: 2,
                                                                      fontFamily: 'Electrolize',
                                                                      fontSize: 15,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: primaryColour
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(height: 10.0),
                                                              Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: Text(
                                                                  "TYPE OF SPECIALIZATION",
                                                                  textAlign: TextAlign.left,
                                                                  style: TextStyle(
                                                                    //letterSpacing: 8,
                                                                    fontFamily: 'Electrolize',
                                                                    fontSize:  MediaQuery.of(context).size.width * 0.035,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(height: 5.0),
                                                              Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: Text(

                                                                  readJsonFileContent.skillsRequired![index].hardSkills![skillsRequiredIndex]
                                                                      .typeOfSpecialization ==
                                                                      null
                                                                      ? ""
                                                                      : readJsonFileContent.skillsRequired![index].hardSkills![
                                                                  skillsRequiredIndex]
                                                                      .typeOfSpecialization!,
                                                                  textAlign: TextAlign.left,
                                                                  style: TextStyle(
                                                                    //letterSpacing: 8,
                                                                    fontFamily: 'Electrolize',
                                                                    fontSize:  MediaQuery.of(context).size.width * 0.035,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height:  MediaQuery.of(context).size.height / 70),
                                                              Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: Text(
                                                                  "HARD SKILL CATEGORY",
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
                                                              const SizedBox(height: 5.0),
                                                              Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: Text(

                                                                  readJsonFileContent.skillsRequired![index].hardSkills![skillsRequiredIndex]
                                                                      .skillCategory ==
                                                                      null
                                                                      ? ""
                                                                      : readJsonFileContent.skillsRequired![index].hardSkills![
                                                                  skillsRequiredIndex]
                                                                      .skillCategory!,
                                                                  textAlign: TextAlign.left,
                                                                  style: TextStyle(
                                                                    //letterSpacing: 8,
                                                                    fontFamily: 'Electrolize',
                                                                    fontSize:  MediaQuery.of(context).size.width * 0.035,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height:  MediaQuery.of(context).size.height / 70),
                                                              Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: Text(
                                                                  "HARD SKILL",
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
                                                              const SizedBox(height: 5.0),
                                                              Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: Text(

                                                                  readJsonFileContent.skillsRequired![index].hardSkills![skillsRequiredIndex]
                                                                      .skill ==
                                                                      null
                                                                      ? ""
                                                                      : readJsonFileContent.skillsRequired![index].hardSkills![
                                                                  skillsRequiredIndex]
                                                                      .skill!,
                                                                  textAlign: TextAlign.left,
                                                                  style: TextStyle(
                                                                    //letterSpacing: 8,
                                                                    fontFamily: 'Electrolize',
                                                                    fontSize:  MediaQuery.of(context).size.width * 0.035,
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height:  MediaQuery.of(context).size.height / 70),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: Text(
                                                                  "LEVEL",
                                                                  textAlign: TextAlign.left,
                                                                  style: TextStyle(
                                                                    //letterSpacing: 8,
                                                                    fontFamily: 'Electrolize',
                                                                    fontSize:  MediaQuery.of(context).size.width * 0.035,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                              ),
                                                              Align(
                                                                alignment: Alignment.centerLeft,
                                                                child: Text(
                                                                  readJsonFileContent.skillsRequired![index].hardSkills![skillsRequiredIndex].level ==
                                                                      null
                                                                      ? ""
                                                                      : readJsonFileContent.skillsRequired![index].hardSkills![skillsRequiredIndex]
                                                                      .level!,
                                                                  textAlign: TextAlign.left,
                                                                  style: TextStyle(
                                                                    //letterSpacing: 8,
                                                                    fontFamily: 'Electrolize',
                                                                    fontSize:  MediaQuery.of(context).size.width * 0.035,
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
                                      SizedBox(height:  MediaQuery.of(context).size.height / 70),
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
                                               MediaQuery.of(context).size.width *
                                                  0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            readJsonFileContent
                                                .skillsRequired![
                                            index]
                                                .contractType ==
                                                null
                                                ? ""
                                                : readJsonFileContent
                                                .skillsRequired![index]
                                                .contractType!,
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
                                      SizedBox(height:  MediaQuery.of(context).size.height / 70),
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
                                                .skillsRequired![
                                            index]
                                                .startDate ==
                                                null
                                                ? ""
                                                : DateFormat(
                                                "EEE, MMM d, yyyy")
                                                .format(
                                              DateTime.parse(
                                                readJsonFileContent
                                                    .skillsRequired![
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
                                                .skillsRequired![
                                            index]
                                                .endDate ==
                                                null
                                                ? ""
                                                : DateFormat(
                                                "EEE, MMM d, yyyy")
                                                .format(
                                              DateTime.parse(
                                                readJsonFileContent
                                                    .skillsRequired![
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
                                                .skillsRequired![
                                            index]
                                                .duration ==
                                                null
                                                ? ""
                                                : "${readJsonFileContent.skillsRequired![index].duration}",
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
                                      SizedBox(height:  MediaQuery.of(context).size.height / 70),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "ASSIGNED TO",
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
                                                .skillsRequired![
                                            index]
                                                .assignedTo ==
                                                null
                                                ? ""
                                                : readJsonFileContent
                                                .skillsRequired![index]
                                                .assignedTo!,
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
                                      SizedBox(height:  MediaQuery.of(context).size.height / 70),
                                    ],
                                  ),
                                ),
                              ),
                              const  SizedBox(height: 10)
                            ],
                          );
                        }),
                  ),
                  readJsonFileContent.skillsRequired == null || readJsonFileContent.skillsRequired!.isEmpty
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