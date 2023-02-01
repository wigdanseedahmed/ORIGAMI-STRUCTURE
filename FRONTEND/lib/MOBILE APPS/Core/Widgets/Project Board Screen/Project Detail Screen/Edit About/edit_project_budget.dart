import 'package:nb_utils/nb_utils.dart';
import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class EditProjectBudgetMA extends StatefulWidget {
  const EditProjectBudgetMA({
    Key? key,
    required this.selectedProject,
    
  }) : super(key: key);

  final ProjectModel? selectedProject;
  

  @override
  State<EditProjectBudgetMA> createState() => _EditProjectBudgetMAState();
}

class _EditProjectBudgetMAState extends State<EditProjectBudgetMA>
    with TickerProviderStateMixin {
  /// Variables used to add more
  bool addNewItemBudget = false;
  var fullBudgetsContainer = <Container>[];
  List<BudgetModel> fullBudgets = <BudgetModel>[];

  double totalDonatedAmount = 0.0;

  /// VARIABLES FOR PROJECT
  ProjectModel readJsonFileContent = ProjectModel();
  Future<ProjectModel>? _futureProjectInformation;

  Future<ProjectModel> readBudgetInformationJsonData() async {
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
      print("Project Info : ${readJsonFileContent.budget}");

      return readJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  Future<ProjectModel> writeBudgetInformationJsonData(
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
    _futureProjectInformation = readBudgetInformationJsonData();

    /// VARIABLES USED TO EDIT PROJECT DETAILS
    widget.selectedProject!.budget == [] ||
            widget.selectedProject!.budget == null
        ? fullBudgets = <BudgetModel>[]
        : fullBudgets = widget.selectedProject!.budget!;

    // print("fullBudgets ${fullBudgets.length}");
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

  Column buildBody(BuildContext context) {
    return Column(
              children: [
                buildTitle(context),
                buildAddNewItem(context),
                fullBudgets == null || fullBudgets.isEmpty
                    ? Container()
                    : SizedBox(
                        height: fullBudgets.length *
                                 MediaQuery.of(context).size.height *
                                0.55 +
                            ((fullBudgets.length - 1) *
                                 MediaQuery.of(context).size.height *
                                0.02),
                        child: ListView.builder(
                          itemCount: fullBudgets.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return buildBudgetItem(index, context);
                          },
                        ),
                      ),
                fullBudgets == null || fullBudgets.isEmpty
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
                      "BUDGET",
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
                        readJsonFileContent.budget = fullBudgets;
                        readJsonFileContent.totalBudget = 0;

                        for(var i =0; i<fullBudgets.length; i++){
                          if(fullBudgets[i].cost !=null){
                            readJsonFileContent.totalBudget = readJsonFileContent.totalBudget! + fullBudgets[i].cost!;
                          }else{
                            readJsonFileContent.totalBudget = readJsonFileContent.totalBudget! + 0;
                        }
                        }

                        _futureProjectInformation =
                            writeBudgetInformationJsonData(
                                readJsonFileContent);
                      });
                    },
                  )
                ],
              );
  }

  buildAddNewItem(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "BUDGET ITEMS OF PROJECT",
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
              fullBudgets.add(BudgetModel());
            });
          },
        )
      ],
    );
  }

  buildBudgetItem(int index, BuildContext context) {
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
                    "ITEM ${index + 1}",
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
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          fullBudgets.remove(
                              fullBudgets[index]);
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
                    "ITEM",
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
                  Container(
                    padding: const EdgeInsets.only(
                        top: 15.0),
                    width:
                    MediaQuery.of(context).size.width * 0.5,
                    height:  MediaQuery.of(context).size.height *
                        0.065,
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 250,
                      autofocus: false,
                      initialValue: fullBudgets[index]
                          .item ==
                          null
                          ? ""
                          : fullBudgets[index].item!,
                      cursorColor:
                      DynamicTheme.of(context)
                          ?.brightness ==
                          Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                      onChanged: (newValue) {
                        fullBudgets[index].item =
                            newValue;
                      },
                      onFieldSubmitted: (newValue) {
                        fullBudgets[index].item =
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
                  height:
                  MediaQuery.of(context).size.height / 70),
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ITEM TYPE",
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
                            fullBudgets[index]
                                .itemType = newValue;
                            //print(_allUserNameList!.indexWhere((element) => element == readJsonFileContent.projectSeniorManager!));
                          });
                        },
                        //show selected item
                        selectedItem:
                        fullBudgets[index]
                            .itemType ==
                            null
                            ? ""
                            : fullBudgets[index]
                            .itemType!,
                      );
                    }),
                  ),
                ],
              ),
              SizedBox(
                  height:
                  MediaQuery.of(context).size.height / 70),
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "PURCHASE FROM",
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
                  Container(
                    padding: const EdgeInsets.only(
                        top: 15.0),
                    width:
                    MediaQuery.of(context).size.width * 0.5,
                    height:  MediaQuery.of(context).size.height *
                        0.065,
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 250,
                      autofocus: false,
                      initialValue: fullBudgets[index]
                          .purchaseFrom ==
                          null
                          ? ""
                          : fullBudgets[index]
                          .purchaseFrom!,
                      cursorColor:
                      DynamicTheme.of(context)
                          ?.brightness ==
                          Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                      onChanged: (newValue) {
                        fullBudgets[index]
                            .purchaseFrom = newValue;
                      },
                      onFieldSubmitted: (newValue) {
                        fullBudgets[index]
                            .purchaseFrom = newValue;
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
                  height:
                  MediaQuery.of(context).size.height / 70),
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height:
                    MediaQuery.of(context).size.height / 25,
                    child: Row(
                      children: [
                        const Icon(
                          Icons
                              .calendar_today_outlined,
                        ),
                        SizedBox(
                            width:  MediaQuery.of(context).size
                                .width /
                                50),
                        Text(
                          "PURCHASE DATE",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            //letterSpacing: 8,
                            fontFamily: 'Electrolize',
                            fontSize: MediaQuery.of(context).size
                                .width *
                                0.035,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width:
                    MediaQuery.of(context).size.width / 3,
                    child: CupertinoDateTextBox(
                      initialValue: fullBudgets[index]
                          .purchaseDate ==
                          null
                          ? DateTime.now()
                          : DateFormat("yyyy-MM-dd")
                          .parse(
                          fullBudgets[index]
                              .purchaseDate!),
                      onDateChange:
                          (DateTime? newDate) {
                        //print(newDate);
                        setState(() {
                          fullBudgets[index]
                              .purchaseDate =
                              newDate!
                                  .toIso8601String();
                        });
                      },
                      hintText: fullBudgets[index]
                          .purchaseDate ==
                          null
                          ? DateFormat()
                          .format(DateTime.now())
                          : fullBudgets[index]
                          .purchaseDate!,
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height:
                  MediaQuery.of(context).size.height / 70),
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
                      MediaQuery.of(context).size.width *
                          0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 15.0),
                    width:
                    MediaQuery.of(context).size.width * 0.3,
                    height:  MediaQuery.of(context).size.height *
                        0.065,
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 250,
                      autofocus: false,
                      initialValue: fullBudgets[index]
                          .duration ==
                          null
                          ? ""
                          : fullBudgets[index]
                          .duration!
                          .toString(),
                      cursorColor:
                      DynamicTheme.of(context)
                          ?.brightness ==
                          Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                      onChanged: (newValue) {
                        fullBudgets[index].duration =
                            double.parse(newValue);
                      },
                      onFieldSubmitted: (newValue) {
                        fullBudgets[index].duration =
                            double.parse(newValue);
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
                  height:
                  MediaQuery.of(context).size.height / 70),
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
                      MediaQuery.of(context).size.width *
                          0.035,
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
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 250,
                      autofocus: false,
                      initialValue:
                      fullBudgets[index].cost ==
                          null
                          ? ""
                          : fullBudgets[index]
                          .cost!
                          .toString(),
                      cursorColor:
                      DynamicTheme.of(context)
                          ?.brightness ==
                          Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                      onChanged: (newValue) {
                        fullBudgets[index].cost =
                            double.parse(newValue);
                      },
                      onFieldSubmitted: (newValue) {
                        fullBudgets[index].cost =
                            double.parse(newValue);
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
                  height:
                  MediaQuery.of(context).size.height / 70),
            ],
          ),
        ),
        SizedBox(
            height:  MediaQuery.of(context).size.height * 0.02)
      ],
    );
  }
}
