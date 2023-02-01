import 'package:nb_utils/nb_utils.dart';
import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class EditProjectResourcesMA extends StatefulWidget {
  const EditProjectResourcesMA({
    Key? key,
    
    this.selectedProject,
  }) : super(key: key);

  
  final ProjectModel? selectedProject;

  @override
  State<EditProjectResourcesMA> createState() => _EditProjectResourcesMAState();
}

class _EditProjectResourcesMAState extends State<EditProjectResourcesMA> {
  /// Variables used to add more
  bool addNewItemResource = false;
  var fullResourcesContainer = <Container>[];
  var fullResources = <ResourcesModel>[];

  /// VARIABLES FOR PROJECT
  ProjectModel readJsonFileContent = ProjectModel();
  Future<ProjectModel>? _futureProjectInformation;

  Future<ProjectModel> readResourcesInformationJsonData() async {
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

  Future<ProjectModel> writeResourcesInformationJsonData(
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
    _futureProjectInformation = readResourcesInformationJsonData();
    /// VARIABLES USED TO EDIT PROJECT DETAILS
    widget.selectedProject!.resources == [] ||
            widget.selectedProject!.resources == null
        ? fullResources = <ResourcesModel>[]
        : fullResources = widget.selectedProject!.resources!;
    print("fullResources ${fullResources.length}");
/*
    fullResources.isEmpty
        ? fullResourcesContainer.add(addNewItemResourceContainer())
        : fullResourcesContainer = <Container>[];*/
    //print("fullResourcesContainer $fullResourcesContainer");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("fullResources ${fullResources.length}");
    print("fullResourcesContainer $fullResourcesContainer");
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
                buildAddNewResource(context),
                fullResources.isEmpty
                    ? Container()
                    : SizedBox(
                  height: fullResources.length *  MediaQuery.of(context).size.height * 0.45 +
                      ((fullResources.length - 1) *
                           MediaQuery.of(context).size.height *
                          0.02),
                  child: ListView.builder(
                      itemCount: fullResources.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return buildResource(index, context);
                      }),
                ),
                fullResources.isEmpty
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
                      "RESOURCES",
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
                        readJsonFileContent.resources = fullResources;
                        _futureProjectInformation =
                            writeResourcesInformationJsonData(
                                readJsonFileContent);
                      });
                    },
                  )
                ],
              );
  }

  buildAddNewResource(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "RESOURCES OF PROJECT",
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
              fullResources.add(ResourcesModel());
            });
          },
        )
      ],
    );
  }

  buildResource(int index, BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.black12,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "RESOURCE ${index + 1}",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        //letterSpacing: 8,
                        fontFamily: 'Electrolize',
                        fontSize:
                        MediaQuery.of(context).size.width * 0.045,
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
                            fullResources.remove(fullResources[index]);
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
                      "RESOURCE TOOL",
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
                        initialValue: fullResources[index]
                            .resourcesTool ==
                            null
                            ? ""
                            : fullResources[index]
                            .resourcesTool!,
                        cursorColor: DynamicTheme.of(context)
                            ?.brightness ==
                            Brightness.light
                            ? Colors.grey[100]
                            : Colors.grey[600],
                        onChanged: (newValue) {
                          fullResources[index].resourcesTool =
                              newValue;
                        },
                        onFieldSubmitted: (newValue) {
                          fullResources[index].resourcesTool =
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
                SizedBox(
                    height:  MediaQuery.of(context).size.height / 70),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "RESOURCE TYPE",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        //letterSpacing: 8,
                        fontFamily: 'Electrolize',
                        fontSize:
                        MediaQuery.of(context).size.width * 0.035,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          top: 15.0),
                      width:
                      MediaQuery.of(context).size.width * 0.5,
                      height:  MediaQuery.of(context).size.height *
                          0.065,
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
                              fontSize: MediaQuery.of(context).size
                                  .width /
                                  120,
                              fontFamily: 'Montserrat',
                              letterSpacing: 3,
                            ),
                          ),
                          //mode of dropdown
                          mode: Mode.MENU,
                          //to show search box
                          showSearchBox: true,
                          //list of dropdown items
                          items: resourcesTypeList,
                          onChanged:
                              (String? newValue) {
                            dropDownState(() {
                              fullResources[index].resourcesType = newValue;
                              //print(_allUserNameList!.indexWhere((element) => element == readJsonFileContent.projectSeniorManager!));
                            });
                          },
                          //show selected item
                          selectedItem:
                          fullResources[index].resourcesType ==
                              null
                              ? ""
                              : fullResources[index].resourcesType!,
                        );
                      }),
                    ),
                  ],
                ),
                SizedBox(
                    height:  MediaQuery.of(context).size.height / 70),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "DURATION (in weeks)",
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
                      width:  MediaQuery.of(context).size.width * 0.3,
                      height:  MediaQuery.of(context).size.height * 0.05,
                      child: TextFormField(
                        minLines: 1,
                        maxLines: 250,
                        autofocus: false,
                        initialValue:
                        fullResources[index].duration ==
                            null
                            ? ""
                            : fullResources[index]
                            .duration!
                            .toString(),
                        cursorColor: DynamicTheme.of(context)
                            ?.brightness ==
                            Brightness.light
                            ? Colors.grey[100]
                            : Colors.grey[600],
                        onChanged: (newValue) {
                          fullResources[index].duration = double.parse(newValue);
                        },
                        onFieldSubmitted: (newValue) {
                          fullResources[index].duration =
                              double.parse(newValue);
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
                SizedBox(
                    height:  MediaQuery.of(context).size.height / 70),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height:  MediaQuery.of(context).size.height / 25,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time_outlined,
                          ),
                          SizedBox(
                              width:  MediaQuery.of(context).size.width /
                                  50),
                          Text(
                            "START DATE",
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
                    ),
                    const SizedBox(width: 110),
                    SizedBox(
                      height:  MediaQuery.of(context).size.height / 25,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time_outlined,
                          ),
                          SizedBox(
                              width:  MediaQuery.of(context).size.width /
                                  50),
                          Text(
                            "END DATE",
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
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width:  MediaQuery.of(context).size.width / 3,
                      child: CupertinoDateTextBox(
                        initialValue: fullResources[index]
                            .startDate ==
                            null
                            ? DateTime.now()
                            : DateFormat("yyyy-MM-dd").parse(
                            fullResources[index]
                                .startDate!),
                        onDateChange: (DateTime? newDate) {
                          //print(newDate);
                          setState(() {
                            fullResources[index].startDate =
                                newDate!.toIso8601String();
                          });
                        },
                        hintText: fullResources[index]
                            .startDate ==
                            null
                            ? DateFormat()
                            .format(DateTime.now())
                            : fullResources[index].startDate!,
                      ),
                    ),
                    SizedBox(
                      width:  MediaQuery.of(context).size.width / 3,
                      child: CupertinoDateTextBox(
                        initialValue: fullResources[index]
                            .endDate ==
                            null
                            ? DateTime.now()
                            : DateFormat('yyyy-MM-dd').parse(
                            fullResources[index]
                                .endDate!),
                        onDateChange: (DateTime? newDate) {
                          // print(newDate);
                          setState(() {
                            fullResources[index].endDate =
                                DateFormat('yyyy-MM-dd')
                                    .format(newDate!);
                          });
                        },
                        hintText: fullResources[index]
                            .endDate ==
                            null
                            ? DateFormat()
                            .format(DateTime.now())
                            : fullResources[index].endDate!,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                    height:  MediaQuery.of(context).size.height / 70),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "COST",
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
                      width:  MediaQuery.of(context).size.width * 0.3,
                      height:  MediaQuery.of(context).size.height * 0.05,
                      child: TextFormField(
                        minLines: 1,
                        maxLines: 250,
                        autofocus: false,
                        initialValue: fullResources[index]
                            .cost ==
                            null
                            ? ""
                            : "${fullResources[index].cost!}",
                        cursorColor: DynamicTheme.of(context)
                            ?.brightness ==
                            Brightness.light
                            ? Colors.grey[100]
                            : Colors.grey[600],
                        onChanged: (newValue) {
                          fullResources[index].cost =
                              newValue.toDouble();
                        },
                        onFieldSubmitted: (newValue) {
                          fullResources[index].cost =
                              newValue.toDouble();
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
                SizedBox(
                    height:  MediaQuery.of(context).size.height / 70),
              ],
            ),
          ),
        ),
        SizedBox(height:  MediaQuery.of(context).size.height * 0.02)
      ],
    );
  }
}
