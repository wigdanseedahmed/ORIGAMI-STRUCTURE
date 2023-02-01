import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class ProjectResourcesMA extends StatefulWidget {
  const ProjectResourcesMA({
    Key? key,
    
    this.selectedProject,
  }) : super(key: key);

  
  final ProjectModel? selectedProject;

  @override
  State<ProjectResourcesMA> createState() => _ProjectResourcesMAState();
}

class _ProjectResourcesMAState extends State<ProjectResourcesMA> {
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
              return Column(
                children: [
                  ProjectDetailHeaderMA(
                       headerTitle: 'RESOURCES'),
                  readJsonFileContent.resources == null
                      ? Container()
                      : SizedBox(
                    height: readJsonFileContent.resources!.length *  MediaQuery.of(context).size.height * 0.25 + ((readJsonFileContent.members!.length - 1) *  MediaQuery.of(context).size.height * 0.02),
                    child: ListView.builder(
                        itemCount: readJsonFileContent.resources!.length,
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
                                        "RESOURCE ${index + 1}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          //letterSpacing: 8,
                                          fontFamily: 'Electrolize',
                                          fontSize:  MediaQuery.of(context).size.width * 0.045,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                      const SizedBox(height: 5.0),
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
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            readJsonFileContent.resources![index]
                                                .resourcesType ==
                                                null
                                                ? ""
                                                : readJsonFileContent
                                                .resources![index].resourcesType!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10.0),
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
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            readJsonFileContent.resources![index]
                                                .resourcesTool ==
                                                null
                                                ? ""
                                                : readJsonFileContent
                                                .resources![index].resourcesTool!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10.0),
                                      readJsonFileContent.resources![index].reference ==
                                          null
                                          ? Container()
                                          : Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "REFERENCE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                               MediaQuery.of(context).size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            readJsonFileContent
                                                .resources![index].reference!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                               MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                      readJsonFileContent.resources![index].reference ==
                                          null
                                          ? Container()
                                          : const SizedBox(height: 10.0),
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
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "DURATION",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.035,
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
                                            readJsonFileContent.resources![index]
                                                .startDate ==
                                                null
                                                ? ""
                                                : DateFormat("EEE, MMM d, yyyy")
                                                .format(
                                              DateTime.parse(
                                                readJsonFileContent
                                                    .resources![index]
                                                    .startDate!,
                                              ),
                                            ),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.03,
                                            ),
                                          ),
                                          Text(
                                            readJsonFileContent
                                                .resources![index].endDate ==
                                                null
                                                ? ""
                                                : DateFormat("EEE, MMM d, yyyy")
                                                .format(
                                              DateTime.parse(
                                                readJsonFileContent
                                                    .resources![index].endDate!,
                                              ),
                                            ),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.03,
                                            ),
                                          ),
                                          Text(
                                            readJsonFileContent
                                                .resources![index].duration ==
                                                null
                                                ? ""
                                                : "${readJsonFileContent.resources![index].duration} weeks",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:  MediaQuery.of(context).size.width * 0.03,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10.0),
                                      readJsonFileContent.resources![index].cost == null
                                          ? Container()
                                          : Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
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
                                          ),
                                          const SizedBox(width: 50.0),
                                          Text(
                                            "\$${readJsonFileContent.resources![index].cost!}",
                                            textAlign: TextAlign.left,
                                            maxLines: 250,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                               MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                      readJsonFileContent.resources![index].cost == null
                                          ? Container()
                                          : const SizedBox(height: 10.0),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height:  MediaQuery.of(context).size.height * 0.02),
                            ],
                          );
                        }),
                  ),
                  readJsonFileContent.resources == null
                      ? Container()
                      : SizedBox(height:  MediaQuery.of(context).size.height / 25),
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

/*
SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: DataTable(
                        columnSpacing: 40,
                        headingRowHeight: screenSize.width * 0.05,
                        // defaultColumnWidth: const FixedColumnWidth(150.0),
                        border: TableBorder.all(
                          color: Colors.grey,
                          style: BorderStyle.solid,
                          width: 1,
                        ),
                        columns: [
                          DataColumn(
                            label: Text(
                              "TYPE",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                //letterSpacing: 8,
                                fontFamily: 'Electrolize',
                                fontSize: screenSize.width * 0.035,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "TOOL",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                //letterSpacing: 8,
                                fontFamily: 'Electrolize',
                                fontSize: screenSize.width * 0.035,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "REFERENCE",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                //letterSpacing: 8,
                                fontFamily: 'Electrolize',
                                fontSize: screenSize.width * 0.035,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "COST",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                //letterSpacing: 8,
                                fontFamily: 'Electrolize',
                                fontSize: screenSize.width * 0.035,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "START DATE",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                //letterSpacing: 8,
                                fontFamily: 'Electrolize',
                                fontSize: screenSize.width * 0.035,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "END DATE",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                //letterSpacing: 8,
                                fontFamily: 'Electrolize',
                                fontSize: screenSize.width * 0.035,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "DURATION (weeks)",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                //letterSpacing: 8,
                                fontFamily: 'Electrolize',
                                fontSize: screenSize.width * 0.035,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                        rows: selectedProject!.resources == null
                            ? []
                            : selectedProject!.resources!
                                .map(
                                  (resource) => DataRow(
                                    cells: [
                                      DataCell(
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            resource.resourcesType == null
                                                ? ""
                                                : resource.resourcesType!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: screenSize.width * 0.03,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                            resource.resourcesTool == null
                                                ? ""
                                                : "${resource.resourcesTool}",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: screenSize.width * 0.03,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                            resource.reference == null
                                                ? ""
                                                : resource.reference!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: screenSize.width * 0.03,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            resource.cost == null
                                                ? ""
                                                : "${resource.cost!}",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: screenSize.width * 0.03,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                            resource.startDate == null
                                                ? ""
                                                : resource.startDate!,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: screenSize.width * 0.03,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                            resource.endDate == null
                                                ? ""
                                                : resource.endDate!,
                                            // DateFormat("EEE, MMM d, yyyy").format(DateTime.parse(milestone.endDate!)),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: screenSize.width * 0.03,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                            resource.duration == null
                                                ? ""
                                                : "${resource.duration}",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: screenSize.width * 0.03,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  ],
                ),
              )
 */
