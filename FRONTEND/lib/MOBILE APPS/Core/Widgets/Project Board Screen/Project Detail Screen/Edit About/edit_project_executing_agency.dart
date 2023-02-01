import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class EditProjectExecutingAgencyMA extends StatefulWidget {
  const EditProjectExecutingAgencyMA({
    Key? key,
    
    this.selectedProject,
  }) : super(key: key);

  
  final ProjectModel? selectedProject;

  @override
  State<EditProjectExecutingAgencyMA> createState() =>
      _EditProjectExecutingAgencyMAState();
}

class _EditProjectExecutingAgencyMAState
    extends State<EditProjectExecutingAgencyMA> {
  /// Variables used to add more
  bool addNewItemExecutingAgency = false;
  var fullExecutingAgencyContainer = <Container>[];
  var fullExecutingAgency = <ExecutingAgencyModel>[];

  /// VARIABLES FOR PROJECT
  ProjectModel readJsonFileContent = ProjectModel();
  Future<ProjectModel>? _futureProjectInformation;

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

  Future<ProjectModel> writeGeneralInformationJsonData(
      ProjectModel selectedProjectInformation) async {
    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(
        "${AppUrl.updateProjectByProjectName}${widget.selectedProject!.projectName}");

    print(selectedProjectInformation);

    /// Create Request to get data and response to read data
    final response = await http.put(
      uri,
      headers: {
        "Access-Control-Allow-Origin": "*",
        // Required for CORS support to work
        "Access-Control-Allow-Headers":
        "Content-Type, Access-Control-Allow-Origin, Accept",
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Methods": "POST, DELETE, GET, PUT"
      },
      body: json.encode(selectedProjectInformation.toJson()),
    );
    //print(response.body);

    if (response.statusCode == 200) {
      readJsonFileContent = projectFromJson(response.body);
      //print(readJsonFileContent);
      return readJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }


  @override
  void initState() {
    _futureProjectInformation = readProjectData();

    /// VARIABLES USED TO EDIT PROJECT DETAILS
    widget.selectedProject!.executingAgency == [] ||
            widget.selectedProject!.executingAgency == null
        ? fullExecutingAgency = <ExecutingAgencyModel>[]
        : fullExecutingAgency = widget.selectedProject!.executingAgency!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1.0),
      child: FutureBuilder<ProjectModel>(
        future: _futureProjectInformation,
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
                buildTitle(context),
                buildAddExecutingAgency(context),
                fullExecutingAgency.isEmpty
                    ? Container()
                    : SizedBox(
                  height: fullExecutingAgency.length *
                       MediaQuery.of(context).size.height *
                      0.385 + ((fullExecutingAgency.length - 1) *  MediaQuery.of(context).size.height * 0.02),
                  child: ListView.builder(
                      itemCount: fullExecutingAgency.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return buildExecutingAgency(index, context);
                      }),
                ),
                fullExecutingAgency.isEmpty
                    ? Container()
                    : SizedBox(height:  MediaQuery.of(context).size.height * 0.02),
              ],
            );
  }

  buildTitle(BuildContext context) {
    return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "EXECUTING AGENCY",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          letterSpacing: 4,
                          fontFamily: 'Electrolize',
                          fontSize:  MediaQuery.of(context).size.width * 0.05,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.save_outlined),
                      color: primaryColour,
                      onPressed: () {
                        setState(() {
                          readJsonFileContent.executingAgency = fullExecutingAgency;
                          _futureProjectInformation =
                              writeGeneralInformationJsonData(
                                  readJsonFileContent);
                        });
                      },
                    )
                  ],
                );
  }

  buildAddExecutingAgency(BuildContext context) {

    print(MediaQuery.of(context).size.width);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "EXECUTING AGENCIES OF PROJECT",
            textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 1,
              fontFamily: 'Electrolize',
              fontSize: MediaQuery.of(context).size.width * 0.038,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              fullExecutingAgency.add(ExecutingAgencyModel());
            });
          },
        )
      ],
    );
  }

  buildExecutingAgency(int index, BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.black12,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "EXECUTING AGENCY ${index + 1}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      //letterSpacing: 8,
                      fontFamily: 'Electrolize',
                      fontSize:  MediaQuery.of(context).size.width * 0.045,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          fullExecutingAgency.remove(fullExecutingAgency[index]);
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "EXECUTING AGENCY",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      //letterSpacing: 8,
                      fontFamily: 'Electrolize',
                      fontSize:
                      MediaQuery.of(context).size.width * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width:  MediaQuery.of(context).size.width * 0.5,
                    height:  MediaQuery.of(context).size.height * 0.05,
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 250,
                      autofocus: false,
                      initialValue: fullExecutingAgency[index]
                          .executingAgencyName ==
                          null
                          ? ""
                          : fullExecutingAgency[index]
                          .executingAgencyName!,
                      cursorColor: DynamicTheme.of(context)
                          ?.brightness ==
                          Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                      onChanged: (newValue) {
                        fullExecutingAgency[index]
                            .executingAgencyName = newValue;
                      },
                      onFieldSubmitted: (newValue) {
                        fullExecutingAgency[index]
                            .executingAgencyName = newValue;
                      },
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 0.3,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 0.3,
                          ),
                        ),
                      ),
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
                    "DEPARTMENT",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      //letterSpacing: 8,
                      fontFamily: 'Electrolize',
                      fontSize:
                      MediaQuery.of(context).size.width * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width:  MediaQuery.of(context).size.width * 0.5,
                    height:  MediaQuery.of(context).size.height * 0.05,
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 250,
                      autofocus: false,
                      initialValue: fullExecutingAgency[index]
                          .executingAgencyDepartment ==
                          null
                          ? ""
                          : fullExecutingAgency[index]
                          .executingAgencyDepartment!,
                      cursorColor: DynamicTheme.of(context)
                          ?.brightness ==
                          Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                      onChanged: (newValue) {
                        fullExecutingAgency[index]
                            .executingAgencyDepartment =
                            newValue;
                      },
                      onFieldSubmitted: (newValue) {
                        fullExecutingAgency[index]
                            .executingAgencyDepartment =
                            newValue;
                      },
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 0.3,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 0.3,
                          ),
                        ),
                      ),
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
                    "TEAM",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      //letterSpacing: 8,
                      fontFamily: 'Electrolize',
                      fontSize:
                      MediaQuery.of(context).size.width * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width:  MediaQuery.of(context).size.width * 0.5,
                    height:  MediaQuery.of(context).size.height * 0.05,
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 250,
                      autofocus: false,
                      initialValue: fullExecutingAgency[index]
                          .executingAgencyTeam ==
                          null
                          ? ""
                          : fullExecutingAgency[index]
                          .executingAgencyTeam!,
                      cursorColor: DynamicTheme.of(context)
                          ?.brightness ==
                          Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                      onChanged: (newValue) {
                        fullExecutingAgency[index]
                            .executingAgencyTeam = newValue;
                      },
                      onFieldSubmitted: (newValue) {
                        fullExecutingAgency[index]
                            .executingAgencyTeam = newValue;
                      },
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 0.3,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 0.3,
                          ),
                        ),
                      ),
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
                    "WEBSITE",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      //letterSpacing: 8,
                      fontFamily: 'Electrolize',
                      fontSize:
                      MediaQuery.of(context).size.width * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width:  MediaQuery.of(context).size.width * 0.5,
                    height:  MediaQuery.of(context).size.height * 0.05,
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 250,
                      autofocus: false,
                      initialValue: fullExecutingAgency[index]
                          .executingAgencyWebsite ==
                          null
                          ? ""
                          : fullExecutingAgency[index]
                          .executingAgencyWebsite!,
                      cursorColor: DynamicTheme.of(context)
                          ?.brightness ==
                          Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                      onChanged: (newValue) {
                        fullExecutingAgency[index]
                            .executingAgencyWebsite =
                            newValue;
                      },
                      onFieldSubmitted: (newValue) {
                        fullExecutingAgency[index]
                            .executingAgencyWebsite =
                            newValue;
                      },
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 0.3,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 0.3,
                          ),
                        ),
                      ),
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
                    "EMAIL",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      //letterSpacing: 8,
                      fontFamily: 'Electrolize',
                      fontSize:
                      MediaQuery.of(context).size.width * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width:  MediaQuery.of(context).size.width * 0.5,
                    height:  MediaQuery.of(context).size.height * 0.05,
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 250,
                      autofocus: false,
                      initialValue: fullExecutingAgency[index]
                          .executingAgencyEmail ==
                          null
                          ? ""
                          : fullExecutingAgency[index]
                          .executingAgencyEmail!,
                      cursorColor: DynamicTheme.of(context)
                          ?.brightness ==
                          Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                      onChanged: (newValue) {
                        fullExecutingAgency[index]
                            .executingAgencyEmail = newValue;
                      },
                      onFieldSubmitted: (newValue) {
                        fullExecutingAgency[index]
                            .executingAgencyEmail = newValue;
                      },
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      decoration: const InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 0.3,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height:  MediaQuery.of(context).size.height / 70),
            ],
          ),
        ),
        SizedBox(height:  MediaQuery.of(context).size.height * 0.02)
      ],
    );
  }

}
