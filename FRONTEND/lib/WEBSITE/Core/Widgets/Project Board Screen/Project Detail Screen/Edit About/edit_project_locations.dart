import 'dart:ui';

import 'package:nb_utils/nb_utils.dart';
import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class EditProjectLocationsWS extends StatefulWidget {
  const EditProjectLocationsWS({
    Key? key,
    required this.selectedUser,
    this.selectedProject,
    required this.navigationMenu,
  }) : super(key: key);

  final UserModel? selectedUser;
  final ProjectModel? selectedProject;
  final NavigationMenu navigationMenu;

  @override
  State<EditProjectLocationsWS> createState() => _EditProjectLocationsWSState();
}

class _EditProjectLocationsWSState extends State<EditProjectLocationsWS>
    with TickerProviderStateMixin {
  /// Variables used to add more
  bool addNewItemLocation = false;
  var fullLocationsContainer = <Container>[];
  var fullLocations = <LocationsModel>[];

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

  Future<ProjectModel> writeProjectData(
      ProjectModel selectedProjectInformation) async {
    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(
        "${AppUrl.updateProjectByProjectName}${widget.selectedProject!.projectName}");

    // print(selectedProjectInformation);

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
    _futureProjectInformation = readProjectData();

    /// VARIABLES USED TO EDIT PROJECT DETAILS
    widget.selectedProject!.locations == null ||
            widget.selectedProject!.locations == []
        ? fullLocations = <LocationsModel>[]
        : fullLocations = widget.selectedProject!.locations!;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1.0),
      child: FutureBuilder<ProjectModel>(
        future: _futureProjectInformation,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              rows.clear();
              if (fullLocations == null || fullLocations.isEmpty) {
                rows;
              } else {
                for (int i = 0; i < fullLocations.length; i++) {
                  rows.add(
                    PlutoRow(
                      cells: {
                        'id': PlutoCell(value: '${i + 1}'),
                        'location': PlutoCell(value: fullLocations[i].location),
                        'locality':
                            PlutoCell(value: fullLocations[i].localityNameEn),
                        'city': PlutoCell(value: fullLocations[i].cityNameEn),
                        'state': PlutoCell(value: fullLocations[i].stateNameEn),
                        'province':
                            PlutoCell(value: fullLocations[i].provinceNameEn),
                        'region':
                            PlutoCell(value: fullLocations[i].regionNameEn),
                        'country': PlutoCell(value: fullLocations[i].countryEn),
                        'latitude': PlutoCell(value: fullLocations[i].latitude),
                        'longitude':
                            PlutoCell(value: fullLocations[i].longitude),
                        'start date':
                            PlutoCell(value: fullLocations[i].startDate),
                        'end date': PlutoCell(value: fullLocations[i].endDate),
                        'duration': PlutoCell(value: fullLocations[i].duration),
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

  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      title: 'Id',
      field: 'id',
      type: PlutoColumnType.text(),
      backgroundColor: kShamrock,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Location',
      field: 'location',
      type: PlutoColumnType.text(),
      backgroundColor: kBlueChill,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Locality',
      field: 'locality',
      type: PlutoColumnType.select(localitiesList),
      backgroundColor: kDeepSapphire,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'City',
      field: 'city',
      type: PlutoColumnType.select(cityList),
      backgroundColor: kDeepSapphire,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'State',
      field: 'state',
      type: PlutoColumnType.select(stateList),
      backgroundColor: kDeepSapphire,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Province',
      field: 'province',
      type: PlutoColumnType.select(provincesList),
      backgroundColor: kDeepSapphire,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Region',
      field: 'region',
      type: PlutoColumnType.select(regionsList),
      backgroundColor: kDeepSapphire,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Country',
      field: 'country',
      type: PlutoColumnType.text(),
      backgroundColor: kDeepSapphire,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Latitude',
      field: 'latitude',
      type: PlutoColumnType.number(),
      backgroundColor: kTolopea,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Longitude',
      field: 'longitude',
      type: PlutoColumnType.number(),
      backgroundColor: kTolopea,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Start Date',
      field: 'start date',
      type: PlutoColumnType.date(),
      backgroundColor: kViolet,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'End Date',
      field: 'end date',
      type: PlutoColumnType.date(),
      backgroundColor: kViolet,
      enableEditingMode: true,
    ),
    PlutoColumn(
      title: 'Duration',
      field: 'duration',
      type: PlutoColumnType.number(),
      backgroundColor: kViolet,
      enableEditingMode: true,
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

  buildBody(BuildContext context, Size screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'LOCATION',
              textAlign: TextAlign.left,
              style: TextStyle(
                letterSpacing: 1,
                fontFamily: 'Electrolize',
                fontSize: MediaQuery.of(context).size.width / 75,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: (() {
                    setState(() {
                      if (bodyViewSelected == "Table") {
                        bodyViewSelected = "Grid";
                      } else if (bodyViewSelected == "Grid") {
                        bodyViewSelected = "Table";
                      }
                    });
                  }),
                  icon: Icon(
                    bodyViewSelected == "Table"
                        ? Icons.grid_view_rounded
                        : Icons.table_view_rounded,
                  ),
                ),
                bodyViewSelected == "Table"
                    ? tableOptionsPopup(): gridOptionsPopup(),
              ],
            ),
          ],
        ),
        SizedBox(height: screenSize.height / 20),
        // buildMap(context, screenSize),

        bodyViewSelected == "Table"
            ? buildTable(context, screenSize)
            : buildGrid(context),
      ],
    );
  }

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late PlutoGridStateManager stateManager;

  late String bodyViewSelected = "Table";

  int addCount = 1;

  int addedCount = 0;

  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  void handleAddColumns() {
    final List<PlutoColumn> addedColumns = [];

    for (var i = 0; i < addCount; i += 1) {
      addedColumns.add(
        PlutoColumn(
          title: "column${++addedCount}",
          field: 'column${++addedCount}',
          type: PlutoColumnType.text(),
        ),
      );
    }

    stateManager.insertColumns(
      stateManager.bodyColumns.length,
      addedColumns,
    );
  }

  void handleAddRows() {
    setState(() {
      fullLocations
          .add(LocationsModel()..locationId = "${fullLocations.length + 1}");

      final newRows = stateManager.getNewRows(count: addCount);

      stateManager.appendRows(newRows);

      stateManager.setCurrentCell(
        newRows.first.cells.entries.first.value,
        stateManager.refRows.length - 1,
      );

      stateManager.moveScrollByRow(
        PlutoMoveDirection.down,
        stateManager.refRows.length - 2,
      );

      stateManager.setKeepFocus(true);

      readJsonFileContent.locations = fullLocations;

      fullLocations == []
          ? readJsonFileContent.locationsNumber = 0
          : readJsonFileContent.locationsNumber = fullLocations.length;

      _futureProjectInformation = writeProjectData(readJsonFileContent);
    });
  }

  void handleAddGrids() {
    setState(() {
      fullLocations
          .add(LocationsModel()..locationId = "${fullLocations.length + 1}");

      readJsonFileContent.locations = fullLocations;

      fullLocations == []
          ? readJsonFileContent.locationsNumber = 0
          : readJsonFileContent.locationsNumber = fullLocations.length;

      _futureProjectInformation = writeProjectData(readJsonFileContent);
    });
  }

  void handleSaveAll() {
    stateManager.setShowLoading(true);

    Future.delayed(const Duration(milliseconds: 500), () {
      for (var row in stateManager.refRows) {
        if (row.cells['id']!.value == '') {
          row.cells['id']!.value = 'guest';
        }

        if (row.cells['name']!.value == '') {
          row.cells['name']!.value = 'anonymous';
        }
      }

      stateManager.setShowLoading(false);
    });
  }

  void handleRemoveCurrentColumnButton() {
    final currentColumn = stateManager.currentColumn;

    if (currentColumn == null) {
      return;
    }

    stateManager.removeColumns([currentColumn]);
  }

  void handleRemoveCurrentRowButton() {
    setState(() {
      fullLocations.removeAt(stateManager.currentRowIdx!);

      stateManager.removeCurrentRow();

      readJsonFileContent.locations = fullLocations;

      _futureProjectInformation = writeProjectData(readJsonFileContent);
    });
  }

  void handleRemoveSelectedRowsButton() {
    setState(() {
      print(stateManager.currentSelectingRows);
      print(stateManager.currentSelectingRows.last.sortIdx!);
      // fullLocations.removeRange(stateManager.currentSelectingRows);

      stateManager.removeRows(stateManager.currentSelectingRows);

      readJsonFileContent.locations = fullLocations;

      _futureProjectInformation = writeProjectData(readJsonFileContent);
    });
  }

  void handleFiltering() {
    stateManager.setShowColumnFilter(!stateManager.showColumnFilter);
  }

  void setGridSelectingMode(PlutoGridSelectingMode? mode) {
    if (mode == null || gridSelectingMode == mode) {
      return;
    }

    setState(() {
      gridSelectingMode = mode;
      stateManager.setSelectingMode(mode);
    });
  }

  Widget tableOptionsPopup() => PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert_sharp),
      offset: const Offset(0, 0),
      itemBuilder: (context) => [
            /*const PopupMenuItem(
        value: 1,
        child: Text(
          "Add Columns",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),*/
            const PopupMenuItem(
              value: 2,
              child: Text(
                "Add New Location",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            /* const PopupMenuItem(
        value: 3,
        child: Text(
          "Save All",
          style: TextStyle(
              fontWeight: FontWeight.w700),
        ),
      ),*/
            /*const PopupMenuItem(
        value: 4,
        child: Text(
          "Remove Current Column",
          style: TextStyle(
              fontWeight: FontWeight.w700),
        ),
      ),*/
            const PopupMenuItem(
                    value: 5,
                    child: Text(
                      "Remove Current Selected Location",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ), const PopupMenuItem(
                    value: 6,
                    child: Text(
                      "Remove Selected Locations",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
            /* const PopupMenuItem(
        value: 7,
        child: Text(
          "Toggle Filtering",
          style: TextStyle(
              fontWeight: FontWeight.w700),
        ),
      ),*/
            /* const PopupMenuItem(
        value: 8,
        child: Text(
          "Cells",
          style: TextStyle(
              fontWeight: FontWeight.w700),
        ),
      ),*/
          ],
      onSelected: (int) {
        setState(() {
          int == 1
              ? handleAddColumns()
              : int == 2
                  ? bodyViewSelected == "Table"
                      ? handleAddRows()
                      : handleAddGrids()
                  : int == 3
                      ? handleSaveAll()
                      : int == 4
                          ? handleRemoveCurrentColumnButton()
                          : int == 5
                              ? handleRemoveCurrentRowButton()
                              : int == 6
                                  ? handleRemoveSelectedRowsButton()
                                  : int == 7
                                      ? handleFiltering()
                                      : Container();
        });
      });

  Widget gridOptionsPopup() => PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert_sharp),
      offset: const Offset(0, 0),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 2,
          child: Text(
            "Add New Location",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
      onSelected: (int) {
        setState(() {
          int == 1
              ? handleAddColumns()
              : int == 2
              ? bodyViewSelected == "Table"
              ? handleAddRows()
              : handleAddGrids()
              : int == 3
              ? handleSaveAll()
              : int == 4
              ? handleRemoveCurrentColumnButton()
              : int == 5
              ? handleRemoveCurrentRowButton()
              : int == 6
              ? handleRemoveSelectedRowsButton()
              : int == 7
              ? handleFiltering()
              : Container();
        });
      });

  /*buildMap(BuildContext context, Size screenSize) {
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
                initialMarkersCount: fullLocations.length,
                controller: _mapTileLayerController,
                markerBuilder: (BuildContext context, int index) {
                  const Icon current = Icon(Icons.location_pin, size: 40.0);
                  return MapMarker(
                    latitude: fullLocations[index].latitude ??
                        0, //markerData.latitude,
                    longitude:
                    fullLocations[index].longitude ??
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
  }*/

  ///----------------------------- BUILD TABLE VIEW -----------------------------///
  buildTable(BuildContext context, Size screenSize) {
    return SizedBox(
      width: double.infinity,
      height: fullLocations == null || fullLocations.isEmpty
          ? (screenSize.height * 0.131)
          : (screenSize.height * 0.131) +
              (rows.length * screenSize.height * 0.065),
      child: PlutoGrid(
        key: UniqueKey(),
        columns: columns,
        rows: rows,
        columnGroups: columnGroups,
        onLoaded: (PlutoGridOnLoadedEvent event) {
          stateManager = event.stateManager;
        },
        onChanged: (PlutoGridOnChangedEvent event) {
          setState(() {
            if (event.columnIdx == 1) {
              fullLocations[event.rowIdx!].location = event.value;
            } else if (event.columnIdx == 2) {
              fullLocations[event.rowIdx!].localityNameEn = event.value;
            } else if (event.columnIdx == 3) {
              fullLocations[event.rowIdx!].cityNameEn = event.value;
            } else if (event.columnIdx == 4) {
              fullLocations[event.rowIdx!].stateNameEn = event.value;
            } else if (event.columnIdx == 5) {
              fullLocations[event.rowIdx!].provinceNameEn = event.value;
            } else if (event.columnIdx == 6) {
              fullLocations[event.rowIdx!].regionNameEn = event.value;
            } else if (event.columnIdx == 7) {
              fullLocations[event.rowIdx!].countryEn = event.value;
            } else if (event.columnIdx == 8) {
              fullLocations[event.rowIdx!].latitude = event.value;
            } else if (event.columnIdx == 9) {
              fullLocations[event.rowIdx!].longitude = event.value;
            } else if (event.columnIdx == 10) {
              fullLocations[event.rowIdx!].startDate = event.value;
            } else if (event.columnIdx == 11) {
              fullLocations[event.rowIdx!].endDate = event.value;
            } else if (event.columnIdx == 12) {
              fullLocations[event.rowIdx!].duration = event.value;
            }

            readJsonFileContent.locations = fullLocations;

            fullLocations == []
                ? readJsonFileContent.locationsNumber = 0
                : readJsonFileContent.locationsNumber = fullLocations.length;

            _futureProjectInformation = writeProjectData(readJsonFileContent);
          });
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
  buildGrid(BuildContext context) {
    return Column(
      children: [
        fullLocations.isEmpty
            ? Container()
            : SizedBox(
                height: (fullLocations.length * 750) +
                    ((fullLocations.length - 1) * 20),
                child: ListView.builder(
                    itemCount: fullLocations.length,
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
                                        MainAxisAlignment.spaceBetween,
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
                                              fullLocations
                                                  .remove(fullLocations[index]);

                                              readJsonFileContent.locations =
                                                  fullLocations;

                                              _futureProjectInformation =
                                                  writeProjectData(
                                                      readJsonFileContent);
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
                                      const Text(
                                        "LOCATION NAME",
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
                                          initialValue: fullLocations[index]
                                                      .location ==
                                                  null
                                              ? ""
                                              : fullLocations[index].location!,
                                          cursorColor: DynamicTheme.of(context)
                                                      ?.brightness ==
                                                  Brightness.light
                                              ? Colors.grey[100]
                                              : Colors.grey[600],
                                          onChanged: (newValue) {
                                            fullLocations[index].location =
                                                newValue;

                                            readJsonFileContent.locations =
                                                fullLocations;

                                            fullLocations == []
                                                ? readJsonFileContent
                                                    .locationsNumber = 0
                                                : readJsonFileContent
                                                        .locationsNumber =
                                                    fullLocations.length;

                                            _futureProjectInformation =
                                                writeProjectData(
                                                    readJsonFileContent);
                                          },
                                          onFieldSubmitted: (newValue) {
                                            fullLocations[index].location =
                                                newValue;

                                            readJsonFileContent.locations =
                                                fullLocations;

                                            fullLocations == []
                                                ? readJsonFileContent
                                                    .locationsNumber = 0
                                                : readJsonFileContent
                                                        .locationsNumber =
                                                    fullLocations.length;

                                            _futureProjectInformation =
                                                writeProjectData(
                                                    readJsonFileContent);
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
                                      height:
                                          MediaQuery.of(context).size.height /
                                              70),
                                  Row(
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
                                      Container(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        width: 250,
                                        height: 60,
                                        // width:  MediaQuery.of(context).size.width * 0.5,
                                        // height:  MediaQuery.of(context).size.height * 0.065,
                                        child: StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter dropDownState) {
                                          return DropdownSearch<String>(
                                            popupElevation: 0.0,
                                            showClearButton: true,
                                            //clearButtonProps: ,
                                            dropdownSearchDecoration:
                                                const InputDecoration(
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
                                                fullLocations[index]
                                                    .localityNameEn = newValue;
                                                //print(_allUserNameList!.indexWhere((element) => element == readJsonFileContent.projectSeniorManager!));

                                                readJsonFileContent.locations =
                                                    fullLocations;

                                                fullLocations == []
                                                    ? readJsonFileContent
                                                        .locationsNumber = 0
                                                    : readJsonFileContent
                                                            .locationsNumber =
                                                        fullLocations.length;

                                                _futureProjectInformation =
                                                    writeProjectData(
                                                        readJsonFileContent);
                                              });
                                            },
                                            //show selected item
                                            selectedItem: fullLocations[index]
                                                        .localityNameEn ==
                                                    null
                                                ? ""
                                                : fullLocations[index]
                                                    .localityNameEn!,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  Row(
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
                                      Container(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        width: 250,
                                        height: 60,
                                        // width:  MediaQuery.of(context).size.width * 0.5,
                                        // height:  MediaQuery.of(context).size.height * 0.065,
                                        child: StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter dropDownState) {
                                          return DropdownSearch<String>(
                                            popupElevation: 0.0,
                                            showClearButton: true,
                                            dropdownSearchDecoration:
                                                const InputDecoration(
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
                                                fullLocations[index]
                                                    .cityNameEn = newValue;
                                                //print(_allUserNameList!.indexWhere((element) => element == readJsonFileContent.projectSeniorManager!));

                                                readJsonFileContent.locations =
                                                    fullLocations;

                                                fullLocations == []
                                                    ? readJsonFileContent
                                                        .locationsNumber = 0
                                                    : readJsonFileContent
                                                            .locationsNumber =
                                                        fullLocations.length;

                                                _futureProjectInformation =
                                                    writeProjectData(
                                                        readJsonFileContent);
                                              });
                                            },
                                            //show selected item
                                            selectedItem: fullLocations[index]
                                                        .cityNameEn ==
                                                    null
                                                ? ""
                                                : fullLocations[index]
                                                    .cityNameEn!,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  Row(
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
                                      Container(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        width: 250,
                                        height: 60,
                                        // width:  MediaQuery.of(context).size.width * 0.5,
                                        // height:  MediaQuery.of(context).size.height * 0.065,
                                        child: StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter dropDownState) {
                                          return DropdownSearch<String>(
                                            popupElevation: 0.0,
                                            showClearButton: true,
                                            dropdownSearchDecoration:
                                                const InputDecoration(
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
                                                fullLocations[index]
                                                    .stateNameEn = newValue;
                                                //print(_allUserNameList!.indexWhere((element) => element == readJsonFileContent.projectSeniorManager!));

                                                readJsonFileContent.locations =
                                                    fullLocations;

                                                fullLocations == []
                                                    ? readJsonFileContent
                                                        .locationsNumber = 0
                                                    : readJsonFileContent
                                                            .locationsNumber =
                                                        fullLocations.length;

                                                _futureProjectInformation =
                                                    writeProjectData(
                                                        readJsonFileContent);
                                              });
                                            },
                                            //show selected item
                                            selectedItem: fullLocations[index]
                                                        .stateNameEn ==
                                                    null
                                                ? ""
                                                : fullLocations[index]
                                                    .stateNameEn!,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  Row(
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
                                      Container(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        width: 250,
                                        height: 60,
                                        // width:  MediaQuery.of(context).size.width * 0.5,
                                        // height:  MediaQuery.of(context).size.height * 0.065,
                                        child: StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter dropDownState) {
                                          return DropdownSearch<String>(
                                            popupElevation: 0.0,
                                            showClearButton: true,
                                            dropdownSearchDecoration:
                                                const InputDecoration(
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
                                                fullLocations[index]
                                                    .provinceNameEn = newValue;
                                                //print(_allUserNameList!.indexWhere((element) => element == readJsonFileContent.projectSeniorManager!));

                                                readJsonFileContent.locations =
                                                    fullLocations;

                                                fullLocations == []
                                                    ? readJsonFileContent
                                                        .locationsNumber = 0
                                                    : readJsonFileContent
                                                            .locationsNumber =
                                                        fullLocations.length;

                                                _futureProjectInformation =
                                                    writeProjectData(
                                                        readJsonFileContent);
                                              });
                                            },
                                            //show selected item
                                            selectedItem: fullLocations[index]
                                                        .provinceNameEn ==
                                                    null
                                                ? ""
                                                : fullLocations[index]
                                                    .provinceNameEn!,
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  Row(
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
                                      Container(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        width: 250,
                                        height: 60,
                                        // width:  MediaQuery.of(context).size.width * 0.5,
                                        // height:  MediaQuery.of(context).size.height * 0.065,
                                        child: StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter dropDownState) {
                                          return DropdownSearch<String>(
                                            popupElevation: 0.0,
                                            showClearButton: true,
                                            dropdownSearchDecoration:
                                                const InputDecoration(
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
                                                fullLocations[index]
                                                    .regionNameEn = newValue;
                                                //print(_allUserNameList!.indexWhere((element) => element == readJsonFileContent.projectSeniorManager!));

                                                readJsonFileContent.locations =
                                                    fullLocations;

                                                fullLocations == []
                                                    ? readJsonFileContent
                                                        .locationsNumber = 0
                                                    : readJsonFileContent
                                                            .locationsNumber =
                                                        fullLocations.length;

                                                _futureProjectInformation =
                                                    writeProjectData(
                                                        readJsonFileContent);
                                              });
                                            },
                                            //show selected item
                                            selectedItem: fullLocations[index]
                                                        .regionNameEn ==
                                                    null
                                                ? ""
                                                : fullLocations[index]
                                                    .regionNameEn!,
                                          );
                                        }),
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
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        width: 130,
                                        height: 50,
                                        child: TextFormField(
                                          minLines: 1,
                                          maxLines: 250,
                                          autofocus: false,
                                          initialValue:
                                              fullLocations[index].duration ==
                                                      null
                                                  ? ""
                                                  : fullLocations[index]
                                                      .duration!
                                                      .toString(),
                                          cursorColor: DynamicTheme.of(context)
                                                      ?.brightness ==
                                                  Brightness.light
                                              ? Colors.grey[100]
                                              : Colors.grey[600],
                                          onChanged: (newValue) {
                                            fullLocations[index].duration =
                                                double.parse(newValue);

                                            readJsonFileContent.locations =
                                                fullLocations;

                                            fullLocations == []
                                                ? readJsonFileContent
                                                    .locationsNumber = 0
                                                : readJsonFileContent
                                                        .locationsNumber =
                                                    fullLocations.length;

                                            _futureProjectInformation =
                                                writeProjectData(
                                                    readJsonFileContent);
                                          },
                                          onFieldSubmitted: (newValue) {
                                            fullLocations[index].duration =
                                                double.parse(newValue);

                                            readJsonFileContent.locations =
                                                fullLocations;

                                            fullLocations == []
                                                ? readJsonFileContent
                                                    .locationsNumber = 0
                                                : readJsonFileContent
                                                        .locationsNumber =
                                                    fullLocations.length;

                                            _futureProjectInformation =
                                                writeProjectData(
                                                    readJsonFileContent);
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
                                      height:
                                          MediaQuery.of(context).size.height /
                                              70),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: CupertinoDateTextBox(
                                          initialValue: fullLocations[index]
                                                      .startDate ==
                                                  null
                                              ? DateTime.now()
                                              : DateFormat("yyyy-MM-dd").parse(
                                                  fullLocations[index]
                                                      .startDate!),
                                          onDateChange: (DateTime? newDate) {
                                            //print(newDate);
                                            setState(() {
                                              fullLocations[index].startDate =
                                                  newDate!.toIso8601String();

                                              readJsonFileContent.locations =
                                                  fullLocations;

                                              fullLocations == []
                                                  ? readJsonFileContent
                                                      .locationsNumber = 0
                                                  : readJsonFileContent
                                                          .locationsNumber =
                                                      fullLocations.length;

                                              _futureProjectInformation =
                                                  writeProjectData(
                                                      readJsonFileContent);
                                            });
                                          },
                                          hintText: fullLocations[index]
                                                      .startDate ==
                                                  null
                                              ? DateFormat()
                                                  .format(DateTime.now())
                                              : fullLocations[index].startDate!,
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: CupertinoDateTextBox(
                                          initialValue: fullLocations[index]
                                                      .endDate ==
                                                  null
                                              ? DateTime.now()
                                              : DateFormat('yyyy-MM-dd').parse(
                                                  fullLocations[index]
                                                      .endDate!),
                                          onDateChange: (DateTime? newDate) {
                                            // print(newDate);
                                            setState(() {
                                              fullLocations[index].endDate =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(newDate!);

                                              readJsonFileContent.locations =
                                                  fullLocations;

                                              fullLocations == []
                                                  ? readJsonFileContent
                                                      .locationsNumber = 0
                                                  : readJsonFileContent
                                                          .locationsNumber =
                                                      fullLocations.length;

                                              _futureProjectInformation =
                                                  writeProjectData(
                                                      readJsonFileContent);
                                            });
                                          },
                                          hintText: fullLocations[index]
                                                      .endDate ==
                                                  null
                                              ? DateFormat()
                                                  .format(DateTime.now())
                                              : fullLocations[index].endDate!,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              70),
                                  // InkWell(
                                  //   onTap: () async {
                                  //     var location =
                                  //     await showSimplePickerLocation(
                                  //       context: context,
                                  //       isDismissible: true,
                                  //       title: "LOCATION PICKER",
                                  //       titleStyle:
                                  //       const TextStyle(
                                  //         letterSpacing: 1,
                                  //         fontFamily:
                                  //         'Electrolize',
                                  //         fontSize: 16,
                                  //         fontWeight:
                                  //         FontWeight.bold,
                                  //       ),
                                  //       textConfirmPicker: "Pick",
                                  //       initCurrentUserPosition:
                                  //       false,
                                  //       stepZoom: 1,
                                  //       initZoom: 6,
                                  //       minZoomLevel: 3,
                                  //       maxZoomLevel: 18,
                                  //       initPosition: GeoPoint(
                                  //         latitude: fullLocations[
                                  //         index]
                                  //             .latitude ==
                                  //             null
                                  //             ? 15.747757
                                  //             : fullLocations[
                                  //         index]
                                  //             .latitude!,
                                  //         longitude: fullLocations[
                                  //         index]
                                  //             .longitude ==
                                  //             null
                                  //             ? 30.312735
                                  //             : fullLocations[
                                  //         index]
                                  //             .longitude!,
                                  //       ),
                                  //       radius: 8.0,
                                  //     );
                                  //
                                  //     setState(() {
                                  //
                                  //       if (location != null) {
                                  //         notifier.value = location;
                                  //
                                  //         fullLocations[index].latitude = location.latitude;
                                  //         fullLocations[index].longitude = location.longitude;
                                  //
                                  //       } else {
                                  //         fullLocations[index].latitude = null;
                                  //         fullLocations[index].longitude = null;
                                  //       }
                                  //     });
                                  //
                                  //   },
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //        Align(
                                  //          alignment: Alignment.centerLeft,
                                  //         child: Text(
                                  //           "CLICK TO MARK THE\nLOCATION ON THE MAP",
                                  //           textAlign: TextAlign.left,
                                  //           style: TextStyle(
                                  //             letterSpacing: 1,
                                  //             fontFamily: 'Electrolize',
                                  //             fontSize: 16,
                                  //             fontWeight: FontWeight.bold,
                                  //             color: primaryColour,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //        Icon(
                                  //          Icons.my_location_sharp,
                                  //          color: primaryColour,
                                  //          size: 32,
                                  //        ),
                                  //     ],
                                  //   ),
                                  // ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              70),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        width:
                                        MediaQuery.of(context).size.width *
                                            0.2,
                                        child: Row(
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
                                      const SizedBox(width: 70),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        width:
                                        MediaQuery.of(context).size.width *
                                            0.2,
                                        child: Row(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: TextFormField(
                                          minLines: 1,
                                          maxLines: 250,
                                          autofocus: false,
                                          initialValue: fullLocations[index]
                                                      .latitude ==
                                                  null
                                              ? ""
                                              : "${fullLocations[index].latitude!}",
                                          key: Key(fullLocations[index]
                                                      .latitude ==
                                                  null
                                              ? ""
                                              : "${fullLocations[index].latitude!}"),
                                          cursorColor: DynamicTheme.of(context)
                                                      ?.brightness ==
                                                  Brightness.light
                                              ? Colors.grey[100]
                                              : Colors.grey[600],
                                          onChanged: (newValue) {
                                            setState(() {
                                              fullLocations[index].latitude =
                                                  newValue.toDouble();

                                              readJsonFileContent.locations =
                                                  fullLocations;

                                              fullLocations == []
                                                  ? readJsonFileContent
                                                      .locationsNumber = 0
                                                  : readJsonFileContent
                                                          .locationsNumber =
                                                      fullLocations.length;

                                              _futureProjectInformation =
                                                  writeProjectData(
                                                      readJsonFileContent);
                                            });
                                          },
                                          onFieldSubmitted: (newValue) {
                                            setState(() {
                                              fullLocations[index].latitude =
                                                  newValue.toDouble();

                                              readJsonFileContent.locations =
                                                  fullLocations;

                                              fullLocations == []
                                                  ? readJsonFileContent
                                                      .locationsNumber = 0
                                                  : readJsonFileContent
                                                          .locationsNumber =
                                                      fullLocations.length;

                                              _futureProjectInformation =
                                                  writeProjectData(
                                                      readJsonFileContent);
                                            });
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
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        width:
                                        MediaQuery.of(context).size.width *
                                            0.2,
                                        child: TextFormField(
                                          minLines: 1,
                                          maxLines: 250,
                                          autofocus: false,
                                          initialValue: fullLocations[index]
                                                      .longitude ==
                                                  null
                                              ? ""
                                              : "${fullLocations[index].longitude!}",
                                          key: Key(fullLocations[index]
                                                      .longitude ==
                                                  null
                                              ? ""
                                              : "${fullLocations[index].longitude!}"),
                                          cursorColor: DynamicTheme.of(context)
                                                      ?.brightness ==
                                                  Brightness.light
                                              ? Colors.grey[100]
                                              : Colors.grey[600],
                                          onChanged: (newValue) {
                                            setState(() {
                                              fullLocations[index].longitude =
                                                  newValue.toDouble();

                                              readJsonFileContent.locations =
                                                  fullLocations;

                                              fullLocations == []
                                                  ? readJsonFileContent
                                                      .locationsNumber = 0
                                                  : readJsonFileContent
                                                          .locationsNumber =
                                                      fullLocations.length;

                                              _futureProjectInformation =
                                                  writeProjectData(
                                                      readJsonFileContent);
                                            });
                                          },
                                          onFieldSubmitted: (newValue) {
                                            setState(() {
                                              fullLocations[index].longitude =
                                                  newValue.toDouble();

                                              readJsonFileContent.locations =
                                                  fullLocations;

                                              fullLocations == []
                                                  ? readJsonFileContent
                                                      .locationsNumber = 0
                                                  : readJsonFileContent
                                                          .locationsNumber =
                                                      fullLocations.length;

                                              _futureProjectInformation =
                                                  writeProjectData(
                                                      readJsonFileContent);
                                            });
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
                                      height:
                                          MediaQuery.of(context).size.height /
                                              70),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02)
                        ],
                      );
                    }),
              ),
        fullLocations.isEmpty ? Container() : const SizedBox(height: 100),
      ],
    );
  }
}
