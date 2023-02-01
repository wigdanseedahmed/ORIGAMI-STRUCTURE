import 'package:nb_utils/nb_utils.dart';
import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class EditProjectLocationsMA extends StatefulWidget {
  const EditProjectLocationsMA({
    Key? key,
    this.selectedProject,
  }) : super(key: key);

  final ProjectModel? selectedProject;

  @override
  State<EditProjectLocationsMA> createState() => _EditProjectLocationsMAState();
}

class _EditProjectLocationsMAState extends State<EditProjectLocationsMA>
    with TickerProviderStateMixin {
  /// Variables used to add more
  bool addNewItemLocation = false;
  var fullLocationsContainer = <Container>[];
  var fullLocations = <LocationsModel>[];

  /// VARIABLES FOR PROJECT
  ProjectModel readJsonFileContent = ProjectModel();
  Future<ProjectModel>? _futureProjectInformation;

  Future<ProjectModel> readLocationsInformationJsonData() async {
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

  Future<ProjectModel> writeLocationsInformationJsonData(
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

  /// VARIABLES USED TO RETRIEVE AND FILTER THROUGH PROJECT MAP LOCATION FROM BACKEND

  // ValueNotifier<GeoPoint?> notifier = ValueNotifier(null);

  @override
  void initState() {
    _futureProjectInformation = readLocationsInformationJsonData();

    /// VARIABLES USED TO EDIT PROJECT DETAILS
    widget.selectedProject!.locations == null
        ? widget.selectedProject!.locations == []
            ? fullLocations = <LocationsModel>[]
            : fullLocations = <LocationsModel>[]
        : fullLocations = widget.selectedProject!.locations!;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
        buildBodyTitle(context),
        buildAddNewLocation(context),
        fullLocations == null || fullLocations.isEmpty
            ? Container()
            : SizedBox(
                height: (fullLocations.length * 770) +
                    ((fullLocations.length - 1) * 20),
                child: ListView.builder(
                    itemCount: fullLocations.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return buildLocations(index, context);
                    }),
              ),
        fullLocations.isEmpty ? Container() : const SizedBox(height: 100),
      ],
    );
  }

  buildBodyTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "LOCATIONS",
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
              readJsonFileContent.locations = fullLocations;

              fullLocations == []
                  ? readJsonFileContent.locationsNumber = 0
                  : readJsonFileContent.locationsNumber = fullLocations.length;

              _futureProjectInformation =
                  writeLocationsInformationJsonData(readJsonFileContent);
            });
          },
        )
      ],
    );
  }

  buildAddNewLocation(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "LOCATION",
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
              fullLocations.add(LocationsModel());
            });
          },
        )
      ],
    );
  }

  buildLocations(int index, BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.black12,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "LOCATION ${index + 1}",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        //letterSpacing: 8,
                        fontFamily: 'Electrolize',
                        fontSize: 20,
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
                            fullLocations.remove(fullLocations[index]);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "LOCATION\nNAME",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        //letterSpacing: 8,
                        fontFamily: 'Electrolize',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        minLines: 1,
                        maxLines: 250,
                        autofocus: false,
                        initialValue: fullLocations[index].location == null
                            ? ""
                            : fullLocations[index].location!,
                        cursorColor: DynamicTheme.of(context)?.brightness ==
                                Brightness.light
                            ? Colors.grey[100]
                            : Colors.grey[600],
                        onChanged: (newValue) {
                          fullLocations[index].location = newValue;
                        },
                        onFieldSubmitted: (newValue) {
                          fullLocations[index].location = newValue;
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
                    const Text(
                      "LOCALITY",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        //letterSpacing: 8,
                        fontFamily: 'Electrolize',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 8.0),
                      width: 250,
                      height: 60,
                      // width:  MediaQuery.of(context).size.width * 0.5,
                      // height:  MediaQuery.of(context).size.height * 0.065,
                      child: StatefulBuilder(builder:
                          (BuildContext context, StateSetter dropDownState) {
                        return DropdownSearch<String>(
                          popupElevation: 0.0,
                          showClearButton: true,
                          //clearButtonProps: ,
                          dropdownSearchDecoration: const InputDecoration(
                            labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              letterSpacing: 3,
                            ),
                          ),
                          //mode of dropdown
                          mode: Mode.MENU,
                          //to show search box
                          showSearchBox: true,
                          //list of dropdown items
                          items: localitiesList,
                          onChanged: (String? newValue) {
                            dropDownState(() {
                              fullLocations[index].localityNameEn = newValue;
                              //print(_allUserNameList!.indexWhere((element) => element == readJsonFileContent.projectSeniorManager!));
                            });
                          },
                          //show selected item
                          selectedItem:
                              fullLocations[index].localityNameEn == null
                                  ? ""
                                  : fullLocations[index].localityNameEn!,
                        );
                      }),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "CITY",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        //letterSpacing: 8,
                        fontFamily: 'Electrolize',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 8.0),
                      width: 250,
                      height: 60,
                      // width:  MediaQuery.of(context).size.width * 0.5,
                      // height:  MediaQuery.of(context).size.height * 0.065,
                      child: StatefulBuilder(builder:
                          (BuildContext context, StateSetter dropDownState) {
                        return DropdownSearch<String>(
                          popupElevation: 0.0,
                          showClearButton: true,
                          dropdownSearchDecoration: const InputDecoration(
                            labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              letterSpacing: 3,
                            ),
                          ),
                          //mode of dropdown
                          mode: Mode.MENU,
                          //to show search box
                          showSearchBox: true,
                          //list of dropdown items
                          items: cityList,
                          onChanged: (String? newValue) {
                            dropDownState(() {
                              fullLocations[index].cityNameEn = newValue;
                              //print(_allUserNameList!.indexWhere((element) => element == readJsonFileContent.projectSeniorManager!));
                            });
                          },
                          //show selected item
                          selectedItem: fullLocations[index].cityNameEn == null
                              ? ""
                              : fullLocations[index].cityNameEn!,
                        );
                      }),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "STATE",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        //letterSpacing: 8,
                        fontFamily: 'Electrolize',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 8.0),
                      width: 250,
                      height: 60,
                      // width:  MediaQuery.of(context).size.width * 0.5,
                      // height:  MediaQuery.of(context).size.height * 0.065,
                      child: StatefulBuilder(builder:
                          (BuildContext context, StateSetter dropDownState) {
                        return DropdownSearch<String>(
                          popupElevation: 0.0,
                          showClearButton: true,
                          dropdownSearchDecoration: const InputDecoration(
                            labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              letterSpacing: 3,
                            ),
                          ),
                          //mode of dropdown
                          mode: Mode.MENU,
                          //to show search box
                          showSearchBox: true,
                          //list of dropdown items
                          items: stateList,
                          onChanged: (String? newValue) {
                            dropDownState(() {
                              fullLocations[index].stateNameEn = newValue;
                              //print(_allUserNameList!.indexWhere((element) => element == readJsonFileContent.projectSeniorManager!));
                            });
                          },
                          //show selected item
                          selectedItem: fullLocations[index].stateNameEn == null
                              ? ""
                              : fullLocations[index].stateNameEn!,
                        );
                      }),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "PROVINCE",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        //letterSpacing: 8,
                        fontFamily: 'Electrolize',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 8.0),
                      width: 250,
                      height: 60,
                      // width:  MediaQuery.of(context).size.width * 0.5,
                      // height:  MediaQuery.of(context).size.height * 0.065,
                      child: StatefulBuilder(builder:
                          (BuildContext context, StateSetter dropDownState) {
                        return DropdownSearch<String>(
                          popupElevation: 0.0,
                          showClearButton: true,
                          dropdownSearchDecoration: const InputDecoration(
                            labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              letterSpacing: 3,
                            ),
                          ),
                          //mode of dropdown
                          mode: Mode.MENU,
                          //to show search box
                          showSearchBox: true,
                          //list of dropdown items
                          items: provincesList,
                          onChanged: (String? newValue) {
                            dropDownState(() {
                              fullLocations[index].provinceNameEn = newValue;
                              //print(_allUserNameList!.indexWhere((element) => element == readJsonFileContent.projectSeniorManager!));
                            });
                          },
                          //show selected item
                          selectedItem:
                              fullLocations[index].provinceNameEn == null
                                  ? ""
                                  : fullLocations[index].provinceNameEn!,
                        );
                      }),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "REGION",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        //letterSpacing: 8,
                        fontFamily: 'Electrolize',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 8.0),
                      width: 250,
                      height: 60,
                      // width:  MediaQuery.of(context).size.width * 0.5,
                      // height:  MediaQuery.of(context).size.height * 0.065,
                      child: StatefulBuilder(builder:
                          (BuildContext context, StateSetter dropDownState) {
                        return DropdownSearch<String>(
                          popupElevation: 0.0,
                          showClearButton: true,
                          dropdownSearchDecoration: const InputDecoration(
                            labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontFamily: 'Montserrat',
                              letterSpacing: 3,
                            ),
                          ),
                          //mode of dropdown
                          mode: Mode.MENU,
                          //to show search box
                          showSearchBox: true,
                          //list of dropdown items
                          items: regionsList,
                          onChanged: (String? newValue) {
                            dropDownState(() {
                              fullLocations[index].regionNameEn = newValue;
                              //print(_allUserNameList!.indexWhere((element) => element == readJsonFileContent.projectSeniorManager!));
                            });
                          },
                          //show selected item
                          selectedItem:
                              fullLocations[index].regionNameEn == null
                                  ? ""
                                  : fullLocations[index].regionNameEn!,
                        );
                      }),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "DURATION (in weeks)",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        //letterSpacing: 8,
                        fontFamily: 'Electrolize',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 8.0),
                      width: 130,
                      height: 50,
                      child: TextFormField(
                        minLines: 1,
                        maxLines: 250,
                        autofocus: false,
                        initialValue: fullLocations[index].duration == null
                            ? ""
                            : fullLocations[index].duration!.toString(),
                        cursorColor: DynamicTheme.of(context)?.brightness ==
                                Brightness.light
                            ? Colors.grey[100]
                            : Colors.grey[600],
                        onChanged: (newValue) {
                          fullLocations[index].duration =
                              double.parse(newValue);
                        },
                        onFieldSubmitted: (newValue) {
                          fullLocations[index].duration =
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
                SizedBox(height: MediaQuery.of(context).size.height / 70),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: const [
                          Icon(
                            Icons.access_time_outlined,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "START DATE",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                //letterSpacing: 8,
                                fontFamily: 'Electrolize',
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 95),
                    SizedBox(
                      height: 50,
                      child: Row(
                        children: const [
                          Icon(
                            Icons.access_time_outlined,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "END DATE",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                //letterSpacing: 8,
                                fontFamily: 'Electrolize',
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
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
                        initialValue: fullLocations[index].startDate == null
                            ? DateTime.now()
                            : DateFormat("yyyy-MM-dd")
                                .parse(fullLocations[index].startDate!),
                        onDateChange: (DateTime? newDate) {
                          //print(newDate);
                          setState(() {
                            fullLocations[index].startDate =
                                newDate!.toIso8601String();
                          });
                        },
                        hintText: fullLocations[index].startDate == null
                            ? DateFormat().format(DateTime.now())
                            : fullLocations[index].startDate!,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: CupertinoDateTextBox(
                        initialValue: fullLocations[index].endDate == null
                            ? DateTime.now()
                            : DateFormat('yyyy-MM-dd')
                                .parse(fullLocations[index].endDate!),
                        onDateChange: (DateTime? newDate) {
                          // print(newDate);
                          setState(() {
                            fullLocations[index].endDate =
                                DateFormat('yyyy-MM-dd').format(newDate!);
                          });
                        },
                        hintText: fullLocations[index].endDate == null
                            ? DateFormat().format(DateTime.now())
                            : fullLocations[index].endDate!,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 70),
                InkWell(
                  onTap: () async {
                    var location =
                        /* await showSimplePickerLocation(
                                              context: context,
                                              isDismissible: true,
                                              title: "LOCATION PICKER",
                                              titleStyle:
                                              const TextStyle(
                                                letterSpacing: 1,
                                                fontFamily:
                                                'Electrolize',
                                                fontSize: 16,
                                                fontWeight:
                                                FontWeight.bold,
                                              ),
                                              textConfirmPicker: "Pick",
                                              initCurrentUserPosition:
                                              false,
                                              stepZoom: 1,
                                              initZoom: 6,
                                              minZoomLevel: 3,
                                              maxZoomLevel: 18,
                                              initPosition: GeoPoint(
                                                latitude: fullLocations[
                                                index]
                                                    .latitude ==
                                                    null
                                                    ? 15.747757
                                                    : fullLocations[
                                                index]
                                                    .latitude!,
                                                longitude: fullLocations[
                                                index]
                                                    .longitude ==
                                                    null
                                                    ? 30.312735
                                                    : fullLocations[
                                                index]
                                                    .longitude!,
                                              ),
                                              radius: 8.0,
                                            );*/

                        setState(() {
                      /*if (location != null) {
                                                notifier.value = location;

                                                fullLocations[index].latitude = location.latitude;
                                                fullLocations[index].longitude = location.longitude;

                                              } else {
                                                fullLocations[index].latitude = null;
                                                fullLocations[index].longitude = null;
                                              }*/
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "CLICK TO MARK THE\nLOCATION ON THE MAP",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            letterSpacing: 1,
                            fontFamily: 'Electrolize',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColour,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.my_location_sharp,
                        color: primaryColour,
                        size: 32,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 70),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 20),
                    SizedBox(
                      height: 30,
                      child: Row(
                        children: const [
                          Icon(Icons.location_on_outlined),
                          SizedBox(width: 10),
                          Text(
                            "LATITUDE",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              //letterSpacing: 8,
                              fontFamily: 'Electrolize',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 70),
                    SizedBox(
                      height: 30,
                      child: Row(
                        children: const [
                          Icon(Icons.location_on_outlined),
                          SizedBox(width: 10),
                          Text(
                            "LONGITUDE",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              //letterSpacing: 8,
                              fontFamily: 'Electrolize',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
                  children: [
                    SizedBox(
                      width: 175,
                      height: 50,
                      child: TextFormField(
                        minLines: 1,
                        maxLines: 250,
                        autofocus: false,
                        initialValue: fullLocations[index].latitude == null
                            ? ""
                            : "${fullLocations[index].latitude!}",
                        key: Key(fullLocations[index].latitude == null
                            ? ""
                            : "${fullLocations[index].latitude!}"),
                        cursorColor: DynamicTheme.of(
                            context)
                            ?.brightness ==
                            Brightness.light
                            ? Colors.grey[100]
                            : Colors.grey[600],
                        onChanged: (newValue) {
                          setState(() {
                            fullLocations[index]
                                .latitude =
                                newValue
                                    .toDouble();
                          });
                        },
                        onFieldSubmitted:
                            (newValue) {
                          setState(() {
                            fullLocations[index]
                                .latitude =
                                newValue
                                    .toDouble();
                          });
                        },
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        decoration:
                        const InputDecoration(
                          focusedBorder:
                          UnderlineInputBorder(
                            borderSide:
                            BorderSide(
                              color:
                              Colors.black,
                              width: 0.3,
                            ),
                          ),
                          enabledBorder:
                          UnderlineInputBorder(
                            borderSide:
                            BorderSide(
                              color:
                              Colors.black,
                              width: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 175,
                      height: 50,
                      child: TextFormField(
                        minLines: 1,
                        maxLines: 250,
                        autofocus: false,
                        initialValue: fullLocations[index].longitude == null
                            ? ""
                            : "${fullLocations[index].longitude!}",
                        key: Key(fullLocations[index].longitude == null
                            ? ""
                            : "${fullLocations[index].longitude!}"),
                        cursorColor: DynamicTheme.of(
                            context)
                            ?.brightness ==
                            Brightness.light
                            ? Colors.grey[100]
                            : Colors.grey[600],
                        onChanged: (newValue) {
                          setState(() {
                            fullLocations[index]
                                .longitude =
                                newValue
                                    .toDouble();
                          });
                        },
                        onFieldSubmitted:
                            (newValue) {
                          setState(() {
                            fullLocations[index]
                                .longitude =
                                newValue
                                    .toDouble();
                          });
                        },
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        decoration:
                        const InputDecoration(
                          focusedBorder:
                          UnderlineInputBorder(
                            borderSide:
                            BorderSide(
                              color:
                              Colors.black,
                              width: 0.3,
                            ),
                          ),
                          enabledBorder:
                          UnderlineInputBorder(
                            borderSide:
                            BorderSide(
                              color:
                              Colors.black,
                              width: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                /*ValueListenableBuilder<GeoPoint?>(
                                          valueListenable: notifier,
                                          builder: (ctx, location, child) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: 175,
                                                  height: 50,
                                                  child: TextFormField(
                                                    minLines: 1,
                                                    maxLines: 250,
                                                    autofocus: false,
                                                    initialValue: fullLocations[index].latitude == null
                                                        ? ""
                                                        : "${fullLocations[index].latitude!}",
                                                    key: Key(fullLocations[index].latitude == null
                                                        ? ""
                                                        : "${fullLocations[index].latitude!}"),
                                                    cursorColor: DynamicTheme.of(
                                                                    context)
                                                                ?.brightness ==
                                                            Brightness.light
                                                        ? Colors.grey[100]
                                                        : Colors.grey[600],
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        fullLocations[index]
                                                                .latitude =
                                                            newValue
                                                                .toDouble();
                                                      });
                                                    },
                                                    onFieldSubmitted:
                                                        (newValue) {
                                                      setState(() {
                                                        fullLocations[index]
                                                                .latitude =
                                                            newValue
                                                                .toDouble();
                                                      });
                                                    },
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                    decoration:
                                                        const InputDecoration(
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide:
                                                            BorderSide(
                                                          color:
                                                              Colors.black,
                                                          width: 0.3,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide:
                                                            BorderSide(
                                                          color:
                                                              Colors.black,
                                                          width: 0.3,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 175,
                                                  height: 50,
                                                  child: TextFormField(
                                                    minLines: 1,
                                                    maxLines: 250,
                                                    autofocus: false,
                                                    initialValue: fullLocations[index].longitude == null
                                                        ? ""
                                                        : "${fullLocations[index].longitude!}",
                                                    key: Key(fullLocations[index].longitude == null
                                                        ? ""
                                                        : "${fullLocations[index].longitude!}"),
                                                    cursorColor: DynamicTheme.of(
                                                                    context)
                                                                ?.brightness ==
                                                            Brightness.light
                                                        ? Colors.grey[100]
                                                        : Colors.grey[600],
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        fullLocations[index]
                                                                .longitude =
                                                            newValue
                                                                .toDouble();
                                                      });
                                                    },
                                                    onFieldSubmitted:
                                                        (newValue) {
                                                      setState(() {
                                                        fullLocations[index]
                                                                .longitude =
                                                            newValue
                                                                .toDouble();
                                                      });
                                                    },
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                    decoration:
                                                        const InputDecoration(
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderSide:
                                                            BorderSide(
                                                          color:
                                                              Colors.black,
                                                          width: 0.3,
                                                        ),
                                                      ),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderSide:
                                                            BorderSide(
                                                          color:
                                                              Colors.black,
                                                          width: 0.3,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),*/
                SizedBox(height: MediaQuery.of(context).size.height / 70),
              ],
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02)
      ],
    );
  }
}
