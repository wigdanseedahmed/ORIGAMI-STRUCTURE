import 'package:nb_utils/nb_utils.dart';
import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class EditProjectPhasesMA extends StatefulWidget {
  const EditProjectPhasesMA({
    Key? key,
    this.selectedProject,
  }) : super(key: key);

  final ProjectModel? selectedProject;

  @override
  State<EditProjectPhasesMA> createState() => _EditProjectPhasesMAState();
}

class _EditProjectPhasesMAState extends State<EditProjectPhasesMA> {
  /// Variables used to add more
  bool addNewItemPhase = false;
  var fullPhasesContainer = <Container>[];
  var fullPhases = <PhasesModel>[];

  /// VARIABLES FOR PROJECT
  ProjectModel readJsonFileContent = ProjectModel();
  Future<ProjectModel>? _futureProjectInformation;

  Future<ProjectModel> readPhasesInformationJsonData() async {
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

  Future<ProjectModel> writePhasesInformationJsonData(
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
    _futureProjectInformation = readPhasesInformationJsonData();

    /// VARIABLES USED TO EDIT PROJECT DETAILS
    widget.selectedProject!.phases == null
        ? widget.selectedProject!.phases == []
            ? fullPhases = <PhasesModel>[]
            : fullPhases = <PhasesModel>[]
        : fullPhases = widget.selectedProject!.phases!;
    print("fullPhases ${fullPhases.length}");

    /*fullPhases.isEmpty
        ? fullPhasesContainer.add(addNewItemPhaseContainer()):
    fullPhasesContainer = <Container>[];*/
    //print("fullPhasesContainer $fullPhasesContainer");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("fullPhases ${fullPhases.length}");
    print("fullPhasesContainer $fullPhasesContainer");
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
        buildAddNewPhase(context),
        fullPhases.isEmpty
            ? Container()
            : SizedBox(
                height: (fullPhases.length *
                        MediaQuery.of(context).size.height *
                        0.492) +
                    ((fullPhases.length - 1) *
                        MediaQuery.of(context).size.height *
                        0.02),
                child: ListView.builder(
                    itemCount: fullPhases.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return buildPhase(index, context);
                    }),
              ),
        fullPhases.isEmpty
            ? Container()
            : SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
            "PHASES",
            textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 4,
              fontFamily: 'Electrolize',
              fontSize: MediaQuery.of(context).size.width * 0.05,
              color: Colors.grey,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.save_outlined),
          color: primaryColour,
          onPressed: () {
            setState(() {
              readJsonFileContent.phases = fullPhases;

              fullPhases == []
                  ? readJsonFileContent.phasesNumber = 0
                  : readJsonFileContent.phasesNumber = fullPhases.length;

              _futureProjectInformation =
                  writePhasesInformationJsonData(readJsonFileContent);
            });
          },
        )
      ],
    );
  }

  buildAddNewPhase(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "PHASES OF PROJECT",
            textAlign: TextAlign.left,
            style: TextStyle(
              letterSpacing: 1,
              fontFamily: 'Electrolize',
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              fullPhases.add(PhasesModel());
            });
          },
        )
      ],
    );
  }

  buildPhase(int index, BuildContext context) {
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
                    "PHASE ${index + 1}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      //letterSpacing: 8,
                      fontFamily: 'Electrolize',
                      fontSize: MediaQuery.of(context).size.width * 0.045,
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
                          fullPhases.remove(fullPhases[index]);
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "PHASE",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      //letterSpacing: 8,
                      fontFamily: 'Electrolize',
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 250,
                      autofocus: false,
                      initialValue: fullPhases[index].phase == null
                          ? ""
                          : fullPhases[index].phase!,
                      cursorColor: DynamicTheme.of(context)?.brightness ==
                              Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                      onChanged: (newValue) {
                        fullPhases[index].phase = newValue;
                      },
                      onFieldSubmitted: (newValue) {
                        fullPhases[index].phase = newValue;
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
              SizedBox(height: MediaQuery.of(context).size.height / 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "% WEIGHT GIVEN",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      //letterSpacing: 8,
                      fontFamily: 'Electrolize',
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 250,
                      autofocus: false,
                      initialValue: fullPhases[index].weightGiven == null
                          ? ""
                          : "${fullPhases[index].weightGiven!}",
                      cursorColor: DynamicTheme.of(context)?.brightness ==
                              Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                      onChanged: (newValue) {
                        fullPhases[index].weightGiven = newValue.toDouble();
                      },
                      onFieldSubmitted: (newValue) {
                        fullPhases[index].weightGiven = newValue.toDouble();
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
              SizedBox(height: MediaQuery.of(context).size.height / 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "IMPACT",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      //letterSpacing: 8,
                      fontFamily: 'Electrolize',
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.33,
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: StatefulBuilder(builder:
                        (BuildContext context, StateSetter dropDownState) {
                      return DropdownSearch<String>(
                        popupElevation: 0.0,
                        dropdownSearchDecoration: InputDecoration(
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: MediaQuery.of(context).size.width / 120,
                            fontFamily: 'Montserrat',
                            letterSpacing: 3,
                          ),
                        ),
                        //mode of dropdown
                        mode: Mode.MENU,
                        //to show search box
                        showSearchBox: true,
                        //list of dropdown items
                        items: impactLabel,
                        onChanged: (String? newValue) {
                          dropDownState(() {
                            fullPhases[index].impact = newValue!;
                          });
                        },
                        //show selected item
                        selectedItem: fullPhases[index].impact == null
                            ? "Impact"
                            : fullPhases[index].impact!,
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 70),
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 25,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time_outlined,
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width / 50),
                        Text(
                          "START DATE",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            //letterSpacing: 8,
                            fontFamily: 'Electrolize',
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 110),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 25,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.access_time_outlined,
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width / 50),
                        Text(
                          "END DATE",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            //letterSpacing: 8,
                            fontFamily: 'Electrolize',
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: CupertinoDateTextBox(
                      initialValue: fullPhases[index].startDate == null
                          ? DateTime.now()
                          : DateFormat("yyyy-MM-dd")
                              .parse(fullPhases[index].startDate!),
                      onDateChange: (DateTime? newDate) {
                        //print(newDate);
                        setState(() {
                          fullPhases[index].startDate =
                              newDate!.toIso8601String();
                        });
                      },
                      hintText: fullPhases[index].startDate == null
                          ? DateFormat().format(DateTime.now())
                          : fullPhases[index].startDate!,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: CupertinoDateTextBox(
                      initialValue: fullPhases[index].endDate == null
                          ? DateTime.now()
                          : DateFormat('yyyy-MM-dd')
                              .parse(fullPhases[index].endDate!),
                      onDateChange: (DateTime? newDate) {
                        // print(newDate);
                        setState(() {
                          fullPhases[index].endDate =
                              DateFormat('yyyy-MM-dd').format(newDate!);
                        });
                      },
                      hintText: fullPhases[index].endDate == null
                          ? DateFormat().format(DateTime.now())
                          : fullPhases[index].endDate!,
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "DELIVERABLES",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      //letterSpacing: 8,
                      fontFamily: 'Electrolize',
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 250,
                      autofocus: false,
                      initialValue: fullPhases[index].deliverables == null
                          ? ""
                          : fullPhases[index].deliverables!,
                      cursorColor: DynamicTheme.of(context)?.brightness ==
                              Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                      onChanged: (newValue) {
                        fullPhases[index].deliverables = newValue;
                      },
                      onFieldSubmitted: (newValue) {
                        fullPhases[index].deliverables = newValue;
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
              SizedBox(height: MediaQuery.of(context).size.height / 70),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ACTION PLAN",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      //letterSpacing: 8,
                      fontFamily: 'Electrolize',
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 250,
                      autofocus: false,
                      initialValue: fullPhases[index].actionPlan == null
                          ? ""
                          : fullPhases[index].actionPlan!,
                      cursorColor: DynamicTheme.of(context)?.brightness ==
                              Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                      onChanged: (newValue) {
                        fullPhases[index].actionPlan = newValue;
                      },
                      onFieldSubmitted: (newValue) {
                        fullPhases[index].actionPlan = newValue;
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
              SizedBox(height: MediaQuery.of(context).size.height / 70),
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02)
      ],
    );
  }
}
