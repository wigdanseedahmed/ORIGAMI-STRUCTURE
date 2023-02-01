import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

// ignore: import_Of_legacy_library_into_null_safe
import 'package:flutter_tags/flutter_tags.dart';

class ProjectLocationsMA extends StatefulWidget {
  const ProjectLocationsMA({
    Key? key,
    required this.selectedProject,
    
    required CurvedAnimation animation,
    required MapZoomPanBehavior zoomPanBehavior,
  })  : _animation = animation,
        _zoomPanBehavior = zoomPanBehavior,
        super(key: key);

  final ProjectModel? selectedProject;
  
  final CurvedAnimation _animation;
  final MapZoomPanBehavior _zoomPanBehavior;

  @override
  State<ProjectLocationsMA> createState() =>
      _ProjectLocationsMAState();
}

class _ProjectLocationsMAState extends State<ProjectLocationsMA>
    with TickerProviderStateMixin {
  /// VARIABLES FOR USERS
  List<UserModel>? _allUserData = <UserModel>[];

  List<String>? _allUserNameList = <String>[];
  List<String>? _allUserFullNameList = <String>[];

  Future<List<UserModel>?> readAllUsersJsonData() async {
    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(AppUrl.users);

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

    _allUserData = <UserModel>[];
    _allUserNameList = <String>[];

    if (response.statusCode == 200) {
      _allUserData = userModelListFromJson(response.body);
      // print("User Model Info : ${readJsonFileContent}");

      for (int i = 0; i < _allUserData!.length; i++) {
        _allUserNameList!.add(_allUserData![i].username!);
        _allUserFullNameList!
            .add("${_allUserData![i].firstName} ${_allUserData![i].lastName}");
      }

      // print("User Model Name : ${_allUserFullNameList}");

      return _allUserData;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// VARIABLES FOR PROJECT
  ProjectModel readJsonFileContent = ProjectModel();

  Future<ProjectModel> readLocationInformationJsonData() async {
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

  /// VARIABLES USED TO RETRIEVE AND FILTER THROUGH PROJECT MAP LOCATION FROM BACKEND
  late AnimationController _controller;
  late MapTileLayerController _mapTileLayerController;

  late CurvedAnimation animation;

  late MapZoomPanBehavior zoomPanBehavior;

  @override
  void initState() {

    /// VARIABLES USED TO RETRIEVE AND FILTER THROUGH PROJECT MAP LOCATION FROM BACKEND
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 750),
        reverseDuration: const Duration(milliseconds: 750));
    _mapTileLayerController = MapTileLayerController();
    animation =  CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    zoomPanBehavior =  MapZoomPanBehavior(
        focalLatLng: const MapLatLng(15.508457, 32.522854),
        zoomLevel: 5,
        showToolbar: true,
        toolbarSettings: const MapToolbarSettings(
          position: MapToolbarPosition.topLeft,
          iconColor: Colors.red,
          itemBackgroundColor: Colors.green,
          itemHoverColor: Colors.blue,
        ),);

    _controller.repeat(min: 0.1, max: 1.0, reverse: true);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1.0),
      child: FutureBuilder<ProjectModel>(
        future: readLocationInformationJsonData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  ProjectDetailHeaderMA(
                       headerTitle: 'LOCATION'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "LOCATION ON MAP",
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
                  SizedBox(height:  MediaQuery.of(context).size.height / 70),
                  SizedBox(
                    height: 500,
                    child:SfMaps(
                      layers: [
                        MapTileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          //initialZoomLevel: 3,
                          zoomPanBehavior: zoomPanBehavior,
                          //initialFocalLatLng: const MapLatLng(15.508457, 32.522854),
                          initialMarkersCount: readJsonFileContent.locations!.length,
                          controller: _mapTileLayerController,
                          markerBuilder: (BuildContext context, int index) {
                            const Icon current = Icon(Icons.location_pin, size: 40.0);
                            return MapMarker(
                              latitude: readJsonFileContent.locations![index].latitude ?? 0, //markerData.latitude,
                              longitude: readJsonFileContent.locations![index].longitude ?? 0,//markerData.longitude,
                              child: AnimatedContainer(
                                transform: Matrix4.identity()..translate(0.0, -40 / 2),
                                duration: const Duration(milliseconds: 250),
                                height: 40,
                                width: 40,
                                child: const FittedBox(child: current),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height:  MediaQuery.of(context).size.height / 70),
                  readJsonFileContent.locations == null
                      ? Container()
                      : SizedBox(
                    height: (readJsonFileContent.locations!.length * 750) +
                        ((readJsonFileContent.locations!.length - 1) * 20),
                    child: ListView.builder(
                        itemCount: readJsonFileContent.locations!.length,
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
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text(
                                            "LOCATION ${index + 1}",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: primaryColour,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
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
                                          Text(
                                            readJsonFileContent.locations![index].location == null
                                                ? ""
                                                : readJsonFileContent.locations![index].location!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height:
                                           MediaQuery.of(context).size.height /
                                              70),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
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
                                          Text(
                                            readJsonFileContent.locations![index].localityNameEn == null
                                                ? ""
                                                : readJsonFileContent.locations![index].localityNameEn!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
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
                                          Text(
                                            readJsonFileContent.locations![index].cityNameEn == null
                                                ? ""
                                                : readJsonFileContent.locations![index].cityNameEn!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
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
                                          Text(
                                            readJsonFileContent.locations![index].stateNameEn == null
                                                ? ""
                                                : readJsonFileContent.locations![index].stateNameEn!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
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
                                          Text(
                                            readJsonFileContent.locations![index].provinceNameEn == null
                                                ? ""
                                                : readJsonFileContent.locations![index].provinceNameEn!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
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
                                          Text(
                                            readJsonFileContent.locations![index].regionNameEn == null
                                                ? ""
                                                : readJsonFileContent.locations![index].regionNameEn!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height:
                                           MediaQuery.of(context).size.height /
                                              70),
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
                                            readJsonFileContent.locations![index].startDate ==
                                                null
                                                ? ""
                                                : DateFormat(
                                                "EEE, MMM d, yyyy")
                                                .format(
                                              DateTime.parse(
                                                readJsonFileContent.locations![index].startDate!,
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
                                            readJsonFileContent.locations![index].endDate ==
                                                null
                                                ? ""
                                                : DateFormat(
                                                "EEE, MMM d, yyyy")
                                                .format(
                                              DateTime.parse(
                                                readJsonFileContent.locations![index].endDate!,
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
                                            readJsonFileContent.locations![index].duration ==
                                                null
                                                ? ""
                                                : "${readJsonFileContent.locations![index].duration} weeks",
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
                                      SizedBox(
                                          height:
                                           MediaQuery.of(context).size.height /
                                              70),

                                      Row(
                                        crossAxisAlignment:  CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 30,
                                            child: Row(
                                              children: const [
                                                Icon(Icons.location_on_outlined),
                                                SizedBox(width: 10),
                                                Text(
                                                  "LATITUDE",
                                                  textAlign:
                                                  TextAlign.left,
                                                  style: TextStyle(
                                                    //letterSpacing: 8,
                                                    fontFamily:
                                                    'Electrolize',
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 120),
                                          SizedBox(
                                            height: 30,
                                            child: Row(
                                              children: const [
                                                Icon(Icons
                                                    .location_on_outlined),
                                                SizedBox(width: 10),
                                                Text(
                                                  "LONGITUDE",
                                                  textAlign:
                                                  TextAlign.left,
                                                  style: TextStyle(
                                                    //letterSpacing: 8,
                                                    fontFamily:
                                                    'Electrolize',
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight.bold,
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
                                          Text(
                                            readJsonFileContent.locations![index].latitude == null
                                                ? ""
                                                :  "${readJsonFileContent.locations![index].latitude!}",
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            readJsonFileContent.locations![index].longitude == null
                                                ? ""
                                                :  "${readJsonFileContent.locations![index].longitude!}",
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                          height:
                                           MediaQuery.of(context).size.height /
                                              70),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height:  MediaQuery.of(context).size.height * 0.02)
                            ],
                          );
                        }),
                  ),
                  readJsonFileContent.locations == null || readJsonFileContent.locations!.isEmpty
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
