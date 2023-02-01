import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class ProjectBudgetMA extends StatefulWidget {
  const ProjectBudgetMA({
    Key? key,
    
    this.selectedProject,
  }) : super(key: key);

  
  final ProjectModel? selectedProject;

  @override
  State<ProjectBudgetMA> createState() => _ProjectBudgetMAState();
}

class _ProjectBudgetMAState extends State<ProjectBudgetMA> {
  /// VARIABLES FOR PROJECT
  ProjectModel readJsonFileContent = ProjectModel();

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
        future: readBudgetInformationJsonData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  const ProjectDetailHeaderMA(
                      
                      headerTitle: 'BUDGET'),
                  readJsonFileContent.budget == null
                      ? Container()
                      : SizedBox(
                          height: (readJsonFileContent.budget!.length *
                                  190) +
                              ((readJsonFileContent.budget!.length - 1) *
                                  20),
                          child: ListView.builder(
                              itemCount:
                                  readJsonFileContent.budget!.length,
                              physics:
                                  const NeverScrollableScrollPhysics(),
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
                                              "ITEM ${index + 1}",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                //letterSpacing: 8,
                                                fontFamily: 'Electrolize',
                                                fontSize: MediaQuery.of(context).size.width *
                                                    0.045,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueGrey,
                                              ),
                                            ),
                                            const SizedBox(height: 5.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "ITEM NAME",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    //letterSpacing: 8,
                                                    fontFamily:
                                                        'Electrolize',
                                                    fontSize: MediaQuery.of(context).size.width *
                                                        0.035,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  readJsonFileContent
                                                              .budget![
                                                                  index]
                                                              .item ==
                                                          null
                                                      ? ""
                                                      : readJsonFileContent
                                                          .budget![index]
                                                          .item!,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    //letterSpacing: 8,
                                                    fontFamily:
                                                        'Electrolize',
                                                    fontSize: MediaQuery.of(context).size.width
                                                           *
                                                        0.035,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10.0),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "ITEM TYPE",
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    //letterSpacing: 8,
                                                    fontFamily:
                                                        'Electrolize',
                                                    fontSize: MediaQuery.of(context).size.width *
                                                        0.035,
                                                    fontWeight:
                                                        FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  readJsonFileContent
                                                              .budget![
                                                                  index]
                                                              .itemType ==
                                                          null
                                                      ? ""
                                                      : readJsonFileContent
                                                          .budget![index]
                                                          .itemType!,
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    //letterSpacing: 8,
                                                    fontFamily:
                                                        'Electrolize',
                                                    fontSize: MediaQuery.of(context).size.width
                                                            *
                                                        0.035,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10.0),
                                             Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "PURCHASE FROM",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          //letterSpacing: 8,
                                                          fontFamily:
                                                              'Electrolize',
                                                          fontSize: MediaQuery.of(context).size
                                                                  .width *
                                                              0.035,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        readJsonFileContent
                                                            .budget![
                                                        index]
                                                            .purchaseFrom ==
                                                            null
                                                            ? ""
                                                            : readJsonFileContent
                                                            .budget![index]
                                                            .purchaseFrom!,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Electrolize',
                                                          fontSize: MediaQuery.of(context).size
                                                                  .width *
                                                              0.035,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                             const SizedBox(
                                                    height: 10.0),
                                             Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "PURCHASE DATE",
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          //letterSpacing: 8,
                                                          fontFamily:
                                                              'Electrolize',
                                                          fontSize: MediaQuery.of(context).size
                                                                  .width *
                                                              0.035,
                                                          fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        readJsonFileContent
                                                            .budget![
                                                        index]
                                                            .purchaseDate ==
                                                            null
                                                            ? ""
                                                            : DateFormat(
                                                                "EEE, MMM d, yyyy")
                                                            .format(
                                                          DateTime.parse(
                                                            readJsonFileContent
                                                                .budget![
                                                                    index]
                                                                .purchaseDate!,
                                                          ),
                                                        ),
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Electrolize',
                                                          fontSize: MediaQuery.of(context).size
                                                                  .width *
                                                              0.035,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                             const SizedBox(
                                                    height: 10.0),
                                             Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Align(
                                                        alignment: Alignment
                                                            .topLeft,
                                                        child: Text(
                                                          "COST",
                                                          textAlign:
                                                              TextAlign
                                                                  .left,
                                                          style: TextStyle(
                                                            //letterSpacing: 8,
                                                            fontFamily:
                                                                'Electrolize',
                                                            fontSize:MediaQuery.of(context).size
                                                                    .width *
                                                                0.035,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          width: 50.0),
                                                      Text(
                                                        readJsonFileContent
                                                            .budget![
                                                        index]
                                                            .cost ==
                                                            null
                                                            ? "\$0"
                                                            : "\$${readJsonFileContent.budget![index].cost!}",
                                                        textAlign:
                                                            TextAlign.left,
                                                        maxLines: 250,
                                                        style: TextStyle(
                                                          //letterSpacing: 8,
                                                          fontFamily:
                                                              'Electrolize',
                                                          fontSize: MediaQuery.of(context).size
                                                                  .width *
                                                              0.035,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                             const SizedBox(
                                                    height: 10.0),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                );
                              }),
                        ),
                  readJsonFileContent.budget == null
                      ? Container()
                      : const SizedBox(height: 100),

                  readJsonFileContent.totalBudget == null? Container():Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Budget:",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          //letterSpacing: 8,
                          fontFamily: 'Electrolize',
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "\$${readJsonFileContent.totalBudget!}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          //letterSpacing: 8,
                          fontFamily: 'Electrolize',
                          fontSize: MediaQuery.of(context).size.width * 0.045,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height:  MediaQuery.of(context).size.height * 0.12),
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
