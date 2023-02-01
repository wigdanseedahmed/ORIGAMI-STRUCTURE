import 'package:nb_utils/nb_utils.dart';
import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class EditProjectDonorsMA extends StatefulWidget {
  const EditProjectDonorsMA({
    Key? key,
    
    this.selectedProject,
  }) : super(key: key);

  
  final ProjectModel? selectedProject;

  @override
  State<EditProjectDonorsMA> createState() => _EditProjectDonorsMAState();
}

class _EditProjectDonorsMAState extends State<EditProjectDonorsMA> {
  /// Variables used to add more
  bool addNewItemDonor = false;
  var fullDonorsContainer = <Container>[];
  var fullDonors = <DonorModel>[];

  /// VARIABLES FOR PROJECT
  ProjectModel readJsonFileContent = ProjectModel();
  Future<ProjectModel>? _futureProjectInformation;

  Future<ProjectModel> readDonorInformationJsonData() async {
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

  Future<ProjectModel> writeDonorInformationJsonData(
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
    _futureProjectInformation = readDonorInformationJsonData();
    /// VARIABLES USED TO EDIT PROJECT DETAILS
    widget.selectedProject!.donor == [] || widget.selectedProject!.donor == null
        ? fullDonors = <DonorModel>[]
        : fullDonors = widget.selectedProject!.donor!;
    print("fullDonors ${fullDonors.length}");
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
                buildAddDonor(context),
                fullDonors.isEmpty
                    ? Container()
                    : SizedBox(
                  height: fullDonors.length *  MediaQuery.of(context).size.height * 0.325 + ((fullDonors.length - 1) *  MediaQuery.of(context).size.height * 0.02),
                  child: ListView.builder(
                      itemCount: fullDonors.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return buildDonor(index, context);
                      }),
                ),
                fullDonors.isEmpty
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
                        "DONORS",
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
                          readJsonFileContent.donor = fullDonors;
                          readJsonFileContent.totalDonatedAmount = 0;

                          for(var i =0; i<fullDonors.length; i++){
                            if(fullDonors[i].donationAmount !=null){
                              readJsonFileContent.totalDonatedAmount = readJsonFileContent.totalDonatedAmount! + fullDonors[i].donationAmount!;
                            }else{
                              readJsonFileContent.totalDonatedAmount = readJsonFileContent.totalDonatedAmount! + 0;
                            }
                          }

                          _futureProjectInformation =
                              writeDonorInformationJsonData(
                                  readJsonFileContent);
                        });
                      },
                    )
                  ],
                );
  }

  buildAddDonor(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "DONORS OF PROJECT",
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
              fullDonors.add(DonorModel());
            });
          },
        )
      ],
    );
  }

  buildDonor(int index, BuildContext context) {
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
                    "DONOR ${index + 1}",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      //letterSpacing: 8,
                      fontFamily: 'Electrolize',
                      fontSize:  MediaQuery.of(context).size.width * 0.045,
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
                          fullDonors.remove(fullDonors[index]);
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
                    "DONOR NAME",
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
                      initialValue:
                      fullDonors[index].donorName == null
                          ? ""
                          : fullDonors[index].donorName!,
                      cursorColor: DynamicTheme.of(context)
                          ?.brightness ==
                          Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                      onChanged: (newValue) {
                        fullDonors[index].donorName =
                            newValue;
                      },
                      onFieldSubmitted: (newValue) {
                        fullDonors[index].donorName =
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
              SizedBox(height:  MediaQuery.of(context).size.height / 70),
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "WEBSITE",
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
                      initialValue: fullDonors[index]
                          .donorWebsite ==
                          null
                          ? ""
                          : fullDonors[index].donorWebsite!,
                      cursorColor: DynamicTheme.of(context)
                          ?.brightness ==
                          Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                      onChanged: (newValue) {
                        fullDonors[index].donorWebsite =
                            newValue;
                      },
                      onFieldSubmitted: (newValue) {
                        fullDonors[index].donorWebsite =
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
              SizedBox(height:  MediaQuery.of(context).size.height / 70),
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "EMAIL",
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
                      initialValue:
                      fullDonors[index].donorEmail == null
                          ? ""
                          : fullDonors[index].donorEmail!,
                      cursorColor: DynamicTheme.of(context)
                          ?.brightness ==
                          Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                      onChanged: (newValue) {
                        fullDonors[index].donorEmail =
                            newValue;
                      },
                      onFieldSubmitted: (newValue) {
                        fullDonors[index].donorEmail =
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
              SizedBox(height:  MediaQuery.of(context).size.height / 70),
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "DONATED AMOUNT",
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
                      fullDonors[index].donationAmount ==
                          null
                          ? ""
                          : fullDonors[index]
                          .donationAmount!
                          .toString(),
                      cursorColor: DynamicTheme.of(context)
                          ?.brightness ==
                          Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                      onChanged: (newValue) {
                        fullDonors[index].donationAmount =
                            double.parse(newValue);
                      },
                      onFieldSubmitted: (newValue) {
                        fullDonors[index].donationAmount =
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
              SizedBox(height:  MediaQuery.of(context).size.height / 70),
            ],
          ),
        ),
        SizedBox(height:  MediaQuery.of(context).size.height * 0.02)
      ],
    );
  }
}
