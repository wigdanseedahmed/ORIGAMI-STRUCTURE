import 'dart:ui';

import 'package:origami_structure/imports.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;

// ignore: import_Of_legacy_library_into_null_safe
import 'package:flutter_tags/flutter_tags.dart';

class ProjectLocationsWS extends StatefulWidget {
  const ProjectLocationsWS({
    Key? key,
    required this.selectedUser,
    this.selectedProject,
    required this.navigationMenu,
  }) : super(key: key);

  final UserModel? selectedUser;
  final ProjectModel? selectedProject;
  final NavigationMenu navigationMenu;

  @override
  State<ProjectLocationsWS> createState() => _ProjectLocationsWSState();
}

class _ProjectLocationsWSState extends State<ProjectLocationsWS>
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
    animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    zoomPanBehavior = MapZoomPanBehavior(
      focalLatLng: const MapLatLng(15.508457, 32.522854),
      zoomLevel: 5,
      showToolbar: true,
      toolbarSettings: const MapToolbarSettings(
        position: MapToolbarPosition.topLeft,
        iconColor: Colors.red,
        itemBackgroundColor: Colors.green,
        itemHoverColor: Colors.blue,
      ),
    );

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
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1.0),
      child: FutureBuilder<ProjectModel>(
        future: readProjectData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (readJsonFileContent.locations == null ||
                  readJsonFileContent.locations!.isEmpty) {
                rows;
              } else {
                for (int i = 0;
                    i < readJsonFileContent.locations!.length;
                    i++) {
                  rows.add(
                    PlutoRow(
                      cells: {
                        'id': PlutoCell(value: '${i + 1}'),
                        'location': PlutoCell(
                            value: readJsonFileContent.locations![i].location),
                        'locality': PlutoCell(
                            value: readJsonFileContent
                                .locations![i].localityNameEn),
                        'city': PlutoCell(
                            value:
                                readJsonFileContent.locations![i].cityNameEn),
                        'state': PlutoCell(
                            value:
                                readJsonFileContent.locations![i].stateNameEn),
                        'province': PlutoCell(
                            value: readJsonFileContent
                                .locations![i].provinceNameEn),
                        'region': PlutoCell(
                            value:
                                readJsonFileContent.locations![i].regionNameEn),
                        'country': PlutoCell(
                            value: readJsonFileContent.locations![i].countryEn),
                        'latitude': PlutoCell(
                            value: readJsonFileContent.locations![i].latitude),
                        'longitude': PlutoCell(
                            value: readJsonFileContent.locations![i].longitude),
                        'start date': PlutoCell(
                            value: readJsonFileContent.locations![i].startDate),
                        'end date': PlutoCell(
                            value: readJsonFileContent.locations![i].endDate),
                        'duration': PlutoCell(
                            value: readJsonFileContent.locations![i].duration),
                      },
                    ),
                  );
                }
              }

              return buildBody(context, screenSize);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }

  late String bodyViewSelected = "Table";

  buildBody(BuildContext context, Size screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildMap(context, screenSize),
        buildBodyInfo(context, screenSize),
      ],
    );
  }

  buildMap(BuildContext context, Size screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenSize.height / 20),
        const Align(
          alignment: Alignment.centerLeft,
          child: ProjectDetailHeaderWS(headerTitle: 'LOCATION ON MAP'),
        ),
        SizedBox(height: screenSize.height / 30),
        SizedBox(
          height: 500,
          child: SfMaps(
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
                    latitude: readJsonFileContent.locations![index].latitude ??
                        0, //markerData.latitude,
                    longitude:
                    readJsonFileContent.locations![index].longitude ??
                        0, //markerData.longitude,
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
        SizedBox(height: screenSize.height / 30),
      ],
    );
  }

  buildBodyInfo(BuildContext context, Size screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: ProjectDetailHeaderWS(headerTitle: 'LOCATION', icon: Icon(
            bodyViewSelected == "Table"
                ? Icons.grid_view_rounded
                : Icons.table_view_rounded,
          ),
            onPressed: () {
              setState(() {
                if (bodyViewSelected == "Table") {
                  bodyViewSelected = "Grid";
                } else if (bodyViewSelected == "Grid") {
                  bodyViewSelected = "Table";
                }
              });
            },),
        ),
        SizedBox(height: screenSize.height / 20),
        bodyViewSelected == "Table"
            ? buildTableView(screenSize)
            : readJsonFileContent.locations == null || readJsonFileContent.locations!.isEmpty
            ? Container()
            : buildGridView(
          screenSize: screenSize,
          crossAxisCount: 4,
          crossAxisCellCount:
          ResponsiveWidget.isLargeScreen(context) ? 2 : 1,
        ),
        SizedBox(height: screenSize.height / 10),
      ],
    );
  }

  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      title: 'Id',
      field: 'id',
      type: PlutoColumnType.text(),
      backgroundColor: kShamrock,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Location',
      field: 'location',
      type: PlutoColumnType.text(),
      backgroundColor: kBlueChill,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Locality',
      field: 'locality',
      type: PlutoColumnType.text(),
      backgroundColor: kDeepSapphire,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'City',
      field: 'city',
      type: PlutoColumnType.text(),
      backgroundColor: kDeepSapphire,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'State',
      field: 'state',
      type: PlutoColumnType.text(),
      backgroundColor: kDeepSapphire,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Province',
      field: 'province',
      type: PlutoColumnType.text(),
      backgroundColor: kDeepSapphire,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Region',
      field: 'region',
      type: PlutoColumnType.text(),
      backgroundColor: kDeepSapphire,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Country',
      field: 'country',
      type: PlutoColumnType.text(),
      backgroundColor: kDeepSapphire,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Latitude',
      field: 'latitude',
      type: PlutoColumnType.number(),
      backgroundColor: kTolopea,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Longitude',
      field: 'longitude',
      type: PlutoColumnType.number(),
      backgroundColor: kTolopea,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Start Date',
      field: 'start date',
      type: PlutoColumnType.date(),
      backgroundColor: kViolet,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'End Date',
      field: 'end date',
      type: PlutoColumnType.date(),
      backgroundColor: kViolet,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
    PlutoColumn(
      title: 'Duration',
      field: 'duration',
      type: PlutoColumnType.number(),
      backgroundColor: kViolet,
      enableEditingMode: false,
      readOnly: true,
      renderer: (rendererContext) {
        Color textColor = Colors.transparent;

        if (rendererContext.cell.value == null) {
          textColor = Colors.transparent;
        } else {
          textColor = Colors.black;
        }

        return Text(
          rendererContext.cell.value.toString(),
          style: TextStyle(
            color: textColor,
            fontFamily: 'Electrolize',
            fontWeight: FontWeight.w500,
          ),
        );
      },
    ),
  ];

  final List<PlutoRow> rows = [];

  /// columnGroups that can group columns can be omitted.
  final List<PlutoColumnGroup> columnGroups = [
    PlutoColumnGroup(title: 'Id', fields: ['id'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Location', fields: ['location'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Locality', fields: ['locality'], expandedColumn: true),
    PlutoColumnGroup(title: 'City', fields: ['city'], expandedColumn: true),
    PlutoColumnGroup(title: 'State', fields: ['state'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Province', fields: ['province'], expandedColumn: true),
    PlutoColumnGroup(title: 'Region', fields: ['region'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Country', fields: ['country'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Latitude', fields: ['latitude'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Longitude', fields: ['longitude'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Start Date', fields: ['start date'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'End Date', fields: ['end date'], expandedColumn: true),
    PlutoColumnGroup(
        title: 'Duration', fields: ['duration'], expandedColumn: true),
  ];

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late final PlutoGridStateManager stateManager;

  ///----------------------------- BUILD TABLE VIEW -----------------------------///
 buildTableView(Size screenSize) {
    return SizedBox(
        width: double.infinity,
        height: readJsonFileContent.locations == null ||
                readJsonFileContent.locations!.isEmpty
            ? (screenSize.height * 0.131)
            : (screenSize.height * 0.131) +
                (rows.length * screenSize.height * 0.065),
        child: PlutoGrid(
          columns: columns,
          rows: rows,
          columnGroups: columnGroups,
          onLoaded: (PlutoGridOnLoadedEvent event) {
            stateManager = event.stateManager;
          },
          onChanged: (PlutoGridOnChangedEvent event) {
            print(event);
          },
          configuration: const PlutoGridConfiguration(
            columnSize: PlutoGridColumnSizeConfig(
              autoSizeMode: PlutoAutoSizeMode.none,
            ),
            style: PlutoGridStyleConfig(
              gridBorderColor: Colors.transparent,
              gridBackgroundColor: Colors.transparent,
              borderColor: Colors.transparent,
              iconColor: kPlatinum,
              columnTextStyle: TextStyle(
                color: kPlatinum,
                decoration: TextDecoration.none,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
  }

  ///----------------------------- BUILD GRID VIEW -----------------------------///

  buildGridView({
    required Size screenSize,
    required int crossAxisCount,
    required int crossAxisCellCount,
    Axis headerAxis = Axis.horizontal,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StaggeredGridView.countBuilder(
          crossAxisCount: crossAxisCount,
          itemCount: readJsonFileContent.locations!.length,
          addAutomaticKeepAlives: false,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      // border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "LOCATION ${index + 1}",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              //letterSpacing: 8,
                              fontFamily: 'Electrolize',
                              fontSize: MediaQuery.of(context)
                                  .size
                                  .width *
                                  0.013,
                              fontWeight: FontWeight.bold,
                              color: primaryColour,
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
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
                                readJsonFileContent.locations![index]
                                    .location ==
                                    null
                                    ? ""
                                    : readJsonFileContent
                                    .locations![index].location!,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  //letterSpacing: 8,
                                  fontFamily: 'Electrolize',
                                  fontSize: MediaQuery.of(context)
                                      .size
                                      .width *
                                      0.01,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                              MediaQuery.of(context).size.height /
                                  70),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
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
                                readJsonFileContent.locations![index]
                                    .localityNameEn ==
                                    null
                                    ? ""
                                    : readJsonFileContent
                                    .locations![index]
                                    .localityNameEn!,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  //letterSpacing: 8,
                                  fontFamily: 'Electrolize',
                                  fontSize: MediaQuery.of(context)
                                      .size
                                      .width *
                                      0.01,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
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
                                readJsonFileContent.locations![index]
                                    .cityNameEn ==
                                    null
                                    ? ""
                                    : readJsonFileContent
                                    .locations![index].cityNameEn!,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  //letterSpacing: 8,
                                  fontFamily: 'Electrolize',
                                  fontSize: MediaQuery.of(context)
                                      .size
                                      .width *
                                      0.01,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
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
                                readJsonFileContent.locations![index]
                                    .stateNameEn ==
                                    null
                                    ? ""
                                    : readJsonFileContent
                                    .locations![index].stateNameEn!,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  //letterSpacing: 8,
                                  fontFamily: 'Electrolize',
                                  fontSize: MediaQuery.of(context)
                                      .size
                                      .width *
                                      0.01,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
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
                                readJsonFileContent.locations![index]
                                    .provinceNameEn ==
                                    null
                                    ? ""
                                    : readJsonFileContent
                                    .locations![index]
                                    .provinceNameEn!,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  //letterSpacing: 8,
                                  fontFamily: 'Electrolize',
                                  fontSize: MediaQuery.of(context)
                                      .size
                                      .width *
                                      0.01,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
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
                                readJsonFileContent.locations![index]
                                    .regionNameEn ==
                                    null
                                    ? ""
                                    : readJsonFileContent
                                    .locations![index]
                                    .regionNameEn!,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  //letterSpacing: 8,
                                  fontFamily: 'Electrolize',
                                  fontSize: MediaQuery.of(context)
                                      .size
                                      .width *
                                      0.01,
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
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.07,
                                child: Text(
                                  "START DATE",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    //letterSpacing: 8,
                                    fontFamily: 'Electrolize',
                                    fontSize: MediaQuery.of(context)
                                        .size
                                        .width *
                                        0.01,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.07,
                                child: Text(
                                  "END DATE",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    //letterSpacing: 8,
                                    fontFamily: 'Electrolize',
                                    fontSize: MediaQuery.of(context)
                                        .size
                                        .width *
                                        0.01,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.06,
                                child: Text(
                                  "DURATION",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    //letterSpacing: 8,
                                    fontFamily: 'Electrolize',
                                    fontSize: MediaQuery.of(context)
                                        .size
                                        .width *
                                        0.01,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.07,
                                child: Text(
                                  readJsonFileContent.locations![index]
                                      .startDate ==
                                      null
                                      ? ""
                                      : DateFormat("EEE, MMM d, yyyy")
                                      .format(
                                    DateTime.parse(
                                      readJsonFileContent
                                          .locations![index]
                                          .startDate!,
                                    ),
                                  ),
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    //letterSpacing: 8,
                                    fontFamily: 'Electrolize',
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.07,
                                child: Text(
                                  readJsonFileContent.locations![index]
                                      .endDate ==
                                      null
                                      ? ""
                                      : DateFormat("EEE, MMM d, yyyy")
                                      .format(
                                    DateTime.parse(
                                      readJsonFileContent
                                          .locations![index]
                                          .endDate!,
                                    ),
                                  ),
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    //letterSpacing: 8,
                                    fontFamily: 'Electrolize',
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.06,
                                child: Text(
                                  readJsonFileContent.locations![index]
                                      .duration ==
                                      null
                                      ? ""
                                      : "${readJsonFileContent.locations![index].duration} weeks",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    //letterSpacing: 8,
                                    fontFamily: 'Electrolize',
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                              height:
                              MediaQuery.of(context).size.height /
                                  70),
                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 30,
                                width:
                                MediaQuery.of(context).size.width *
                                    0.1,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
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
                              SizedBox(
                                height: 30,
                                width:
                                MediaQuery.of(context).size.width *
                                    0.1,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width:
                                MediaQuery.of(context).size.width *
                                    0.1,
                                child: Text(
                                  readJsonFileContent.locations![index]
                                      .latitude ==
                                      null
                                      ? ""
                                      : "${readJsonFileContent.locations![index].latitude!}",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    //letterSpacing: 8,
                                    fontFamily: 'Electrolize',
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width:
                                MediaQuery.of(context).size.width *
                                    0.1,
                                child: Text(
                                  readJsonFileContent.locations![index]
                                      .longitude ==
                                      null
                                      ? ""
                                      : "${readJsonFileContent.locations![index].longitude!}",
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    //letterSpacing: 8,
                                    fontFamily: 'Electrolize',
                                    fontSize: 15,
                                  ),
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
                ],
              ),
            );
          },
          staggeredTileBuilder: (int index) =>
              StaggeredTile.fit(crossAxisCellCount),
        ),
      ],
    );
  }

}
