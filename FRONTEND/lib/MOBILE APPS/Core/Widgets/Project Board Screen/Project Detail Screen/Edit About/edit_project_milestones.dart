import 'package:nb_utils/nb_utils.dart';
import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class EditProjectMilestonesMA extends StatefulWidget {
  const EditProjectMilestonesMA({
    Key? key,
    this.selectedProject,
  }) : super(key: key);

  final ProjectModel? selectedProject;

  @override
  State<EditProjectMilestonesMA> createState() =>
      _EditProjectMilestonesMAState();
}

class _EditProjectMilestonesMAState extends State<EditProjectMilestonesMA> {
  /// Variables used to add more
  bool addNewItemMilestone = false;
  var fullMilestonesContainer = <Container>[];
  var fullMilestones = <MilestonesModel>[];

  /// VARIABLES FOR PROJECT
  ProjectModel readJsonFileContent = ProjectModel();
  Future<ProjectModel>? _futureProjectInformation;

  Future<ProjectModel> readMilestonesInformationJsonData() async {
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

  Future<ProjectModel> writeMilestonesInformationJsonData(
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
    _futureProjectInformation = readMilestonesInformationJsonData();

    /// VARIABLES USED TO EDIT PROJECT DETAILS
    widget.selectedProject!.milestones == [] ||
            widget.selectedProject!.milestones == null
        ? fullMilestones = <MilestonesModel>[]
        : fullMilestones = widget.selectedProject!.milestones!;
    print("fullMilestones $fullMilestones");

    //print("fullMilestonesContainer $fullMilestonesContainer");
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
                buildAddNewMilestone(context),
                fullMilestones.isEmpty
                    ? Container()
                    : SizedBox(
                        height: (fullMilestones.length *
                                MediaQuery.of(context).size.height *
                                0.492) +
                            ((fullMilestones.length - 1) *
                                MediaQuery.of(context).size.height *
                                0.02),
                        child: ListView.builder(
                            itemCount: fullMilestones.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return buildMilestone(index, context);
                            }),
                      ),
                fullMilestones.isEmpty
                    ? Container()
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02),

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
                        "MILESTONES",
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
                          readJsonFileContent.milestones = fullMilestones;

                          fullMilestones == []
                              ? readJsonFileContent.milestonesNumber = 0
                              : readJsonFileContent.milestonesNumber =
                                  fullMilestones.length;
                          _futureProjectInformation =
                              writeMilestonesInformationJsonData(
                                  readJsonFileContent);
                        });
                      },
                    )
                  ],
                );
  }

  buildAddNewMilestone(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "MILESTONES OF PROJECT",
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
              fullMilestones.add(MilestonesModel());
            });
          },
        )
      ],
    );
  }

  buildMilestone(int index, BuildContext context) {
    return Column(
                                children: [
                                  Container(
                                    color: Colors.black12,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "MILESTONE ${index + 1}",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                //letterSpacing: 8,
                                                fontFamily: 'Electrolize',
                                                fontSize:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.045,
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
                                                    fullMilestones.remove(
                                                        fullMilestones[
                                                            index]);
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
                                              "MILESTONE",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                //letterSpacing: 8,
                                                fontFamily: 'Electrolize',
                                                fontSize:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.035,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                              child: TextFormField(
                                                minLines: 1,
                                                maxLines: 250,
                                                autofocus: false,
                                                initialValue: fullMilestones[
                                                                index]
                                                            .milestones ==
                                                        null
                                                    ? ""
                                                    : fullMilestones[index]
                                                        .milestones!,
                                                cursorColor: DynamicTheme.of(
                                                                context)
                                                            ?.brightness ==
                                                        Brightness.light
                                                    ? Colors.grey[100]
                                                    : Colors.grey[600],
                                                onChanged: (newValue) {
                                                  fullMilestones[index]
                                                      .milestones = newValue;
                                                },
                                                onFieldSubmitted: (newValue) {
                                                  fullMilestones[index]
                                                      .milestones = newValue;
                                                },
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 0.3,
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
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
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                70),
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
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.035,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                              child: TextFormField(
                                                minLines: 1,
                                                maxLines: 250,
                                                autofocus: false,
                                                initialValue: fullMilestones[
                                                                index]
                                                            .weightGiven ==
                                                        null
                                                    ? ""
                                                    : "${fullMilestones[index].weightGiven!}",
                                                cursorColor: DynamicTheme.of(
                                                                context)
                                                            ?.brightness ==
                                                        Brightness.light
                                                    ? Colors.grey[100]
                                                    : Colors.grey[600],
                                                onChanged: (newValue) {
                                                  fullMilestones[index]
                                                          .weightGiven =
                                                      newValue.toDouble();
                                                },
                                                onFieldSubmitted: (newValue) {
                                                  fullMilestones[index]
                                                          .weightGiven =
                                                      newValue.toDouble();
                                                },
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 0.3,
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
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
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                70),
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
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.035,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.33,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.06,
                                              child: StatefulBuilder(builder:
                                                  (BuildContext context,
                                                      StateSetter
                                                          dropDownState) {
                                                return DropdownSearch<String>(
                                                  popupElevation: 0.0,
                                                  dropdownSearchDecoration:
                                                      InputDecoration(
                                                    labelStyle: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width /
                                                          120,
                                                      fontFamily:
                                                          'Montserrat',
                                                      letterSpacing: 3,
                                                    ),
                                                  ),
                                                  //mode of dropdown
                                                  mode: Mode.MENU,
                                                  //to show search box
                                                  showSearchBox: true,
                                                  //list of dropdown items
                                                  items: impactLabel,
                                                  onChanged:
                                                      (String? newValue) {
                                                    dropDownState(() {
                                                      fullMilestones[index]
                                                          .impact = newValue!;
                                                    });
                                                  },
                                                  //show selected item
                                                  selectedItem:
                                                      fullMilestones[index]
                                                                  .impact ==
                                                              null
                                                          ? "Impact"
                                                          : fullMilestones[
                                                                  index]
                                                              .impact!,
                                                );
                                              }),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                70),
                                        Row(
                                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  25,
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .access_time_outlined,
                                                  ),
                                                  SizedBox(
                                                      width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width /
                                                          50),
                                                  Text(
                                                    "START DATE",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      //letterSpacing: 8,
                                                      fontFamily:
                                                          'Electrolize',
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.035,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 110),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  25,
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons
                                                        .access_time_outlined,
                                                  ),
                                                  SizedBox(
                                                      width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width /
                                                          50),
                                                  Text(
                                                    "END DATE",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      //letterSpacing: 8,
                                                      fontFamily:
                                                          'Electrolize',
                                                      fontSize: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width *
                                                          0.035,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              child: CupertinoDateTextBox(
                                                initialValue: fullMilestones[
                                                                index]
                                                            .startDate ==
                                                        null
                                                    ? DateTime.now()
                                                    : DateFormat("yyyy-MM-dd")
                                                        .parse(fullMilestones[
                                                                index]
                                                            .startDate!),
                                                onDateChange:
                                                    (DateTime? newDate) {
                                                  //print(newDate);
                                                  setState(() {
                                                    fullMilestones[index]
                                                            .startDate =
                                                        newDate!
                                                            .toIso8601String();
                                                  });
                                                },
                                                hintText: fullMilestones[
                                                                index]
                                                            .startDate ==
                                                        null
                                                    ? DateFormat().format(
                                                        DateTime.now())
                                                    : fullMilestones[index]
                                                        .startDate!,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              child: CupertinoDateTextBox(
                                                initialValue: fullMilestones[
                                                                index]
                                                            .endDate ==
                                                        null
                                                    ? DateTime.now()
                                                    : DateFormat('yyyy-MM-dd')
                                                        .parse(fullMilestones[
                                                                index]
                                                            .endDate!),
                                                onDateChange:
                                                    (DateTime? newDate) {
                                                  // print(newDate);
                                                  setState(() {
                                                    fullMilestones[index]
                                                        .endDate = DateFormat(
                                                            'yyyy-MM-dd')
                                                        .format(newDate!);
                                                  });
                                                },
                                                hintText: fullMilestones[
                                                                index]
                                                            .endDate ==
                                                        null
                                                    ? DateFormat().format(
                                                        DateTime.now())
                                                    : fullMilestones[index]
                                                        .endDate!,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                70),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "DELIVERABLES",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                //letterSpacing: 8,
                                                fontFamily: 'Electrolize',
                                                fontSize:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.035,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                              child: TextFormField(
                                                minLines: 1,
                                                maxLines: 250,
                                                autofocus: false,
                                                initialValue: fullMilestones[
                                                                index]
                                                            .deliverables ==
                                                        null
                                                    ? ""
                                                    : fullMilestones[index]
                                                        .deliverables!,
                                                cursorColor: DynamicTheme.of(
                                                                context)
                                                            ?.brightness ==
                                                        Brightness.light
                                                    ? Colors.grey[100]
                                                    : Colors.grey[600],
                                                onChanged: (newValue) {
                                                  fullMilestones[index]
                                                          .deliverables =
                                                      newValue;
                                                },
                                                onFieldSubmitted: (newValue) {
                                                  fullMilestones[index]
                                                          .deliverables =
                                                      newValue;
                                                },
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 0.3,
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
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
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                70),
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
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.035,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                              child: TextFormField(
                                                minLines: 1,
                                                maxLines: 250,
                                                autofocus: false,
                                                initialValue: fullMilestones[
                                                                index]
                                                            .actionPlan ==
                                                        null
                                                    ? ""
                                                    : fullMilestones[index]
                                                        .actionPlan!,
                                                cursorColor: DynamicTheme.of(
                                                                context)
                                                            ?.brightness ==
                                                        Brightness.light
                                                    ? Colors.grey[100]
                                                    : Colors.grey[600],
                                                onChanged: (newValue) {
                                                  fullMilestones[index]
                                                      .actionPlan = newValue;
                                                },
                                                onFieldSubmitted: (newValue) {
                                                  fullMilestones[index]
                                                      .actionPlan = newValue;
                                                },
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                ),
                                                decoration:
                                                    const InputDecoration(
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.black,
                                                      width: 0.3,
                                                    ),
                                                  ),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
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
                                        SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                70),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.02)
                                ],
                              );
  }

  Container addNewItemMilestoneContainer() {
    var itemMilestone = MilestonesModel();
    fullMilestones.add(itemMilestone);
    return Container(
      color: Colors.black12,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "MILESTONE ${fullMilestones.length}",
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
                      fullMilestones.remove(itemMilestone);
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
                "MILESTONE",
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
                  cursorColor:
                      DynamicTheme.of(context)?.brightness == Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                  onChanged: (newValue) {
                    itemMilestone.milestones = newValue;
                  },
                  onFieldSubmitted: (newValue) {
                    itemMilestone.milestones = newValue;
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
                  cursorColor:
                      DynamicTheme.of(context)?.brightness == Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                  onChanged: (newValue) {
                    itemMilestone.weightGiven = newValue.toDouble();
                  },
                  onFieldSubmitted: (newValue) {
                    itemMilestone.weightGiven = newValue.toDouble();
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
                child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter dropDownState) {
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
                        itemMilestone.impact = newValue!;
                      });
                    },
                    //show selected item
                    selectedItem: itemMilestone.impact == null
                        ? "Impact"
                        : itemMilestone.impact!,
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
                  initialValue: DateTime.now(),
                  onDateChange: (DateTime? newDate) {
                    print(newDate);
                    setState(() {
                      itemMilestone.startDate = DateFormat().format(newDate!);
                    });
                  },
                  hintText: DateFormat().format(DateTime.now()),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                child: CupertinoDateTextBox(
                  initialValue: DateTime.now(),
                  onDateChange: (DateTime newDate) {
                    print(newDate);
                    setState(() {
                      itemMilestone.endDate = DateFormat().format(newDate);
                    });
                  },
                  hintText: DateFormat().format(DateTime.now()),
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
                  cursorColor:
                      DynamicTheme.of(context)?.brightness == Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                  onChanged: (newValue) {
                    itemMilestone.deliverables = newValue;
                  },
                  onFieldSubmitted: (newValue) {
                    itemMilestone.deliverables = newValue;
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
                  cursorColor:
                      DynamicTheme.of(context)?.brightness == Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                  onChanged: (newValue) {
                    itemMilestone.actionPlan = newValue;
                  },
                  onFieldSubmitted: (newValue) {
                    itemMilestone.actionPlan = newValue;
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
    );
  }
}
