import 'package:flutter/cupertino.dart';
import 'package:origami_structure/imports.dart';
import 'package:line_icons/line_icons.dart' as lineIcons;

import 'package:http/http.dart' as http;

class RecommendedUserProfileScreenMA extends StatefulWidget {
  final UserModel selectedRecommendedUserInformation;
  final RecommendedUserModel selectedRecommendedUserResultDetails;
  final List<RecommendedUserModel> allRecommendedUsers;

  const RecommendedUserProfileScreenMA({
    Key? key,
    required this.selectedRecommendedUserInformation,
    required this.selectedRecommendedUserResultDetails,
    required this.allRecommendedUsers,
  }) : super(key: key);

  @override
  _RecommendedUserProfileScreenMAState createState() =>
      _RecommendedUserProfileScreenMAState();
}

class _RecommendedUserProfileScreenMAState
    extends State<RecommendedUserProfileScreenMA>
    with TickerProviderStateMixin {
  /// Variable used to get RESTful-API
  NetworkHandler networkHandler = NetworkHandler();

  UserModel readUserJsonFileContent = UserModel();

  Future<UserModel> readingUserJsonData() async {
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
    // print('Response status: ${response.statusCode}');
    // print('Response Enter body: ${response.body}');

    if (response.statusCode == 200) {
      readUserJsonFileContent = userModelListFromJson(response.body)
          .where((element) =>
              element.username ==
              widget.selectedRecommendedUserResultDetails.username)
          .toList()[0];
      //print("User Model Info : ${readUserJsonFileContent.firstName}");

      return readUserJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  ///VARIABLES USED TO DETERMINE SCREEN SIZE
  late ScrollController _scrollController;
  double _scrollPosition = 0;
  double _opacity = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    /// VARIABLES USED TO SCROLL THROUGH SCREEN
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    tabBarController = TabController(vsync: this, length: 3);

    super.initState();
  }

  @override
  void dispose() {
    tabBarController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _opacity = _scrollPosition < MediaQuery.of(context).size.height * 0.40
        ? _scrollPosition / (MediaQuery.of(context).size.height * 0.40)
        : 1;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1.0),
      child: FutureBuilder<UserModel>(
        future: readingUserJsonData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Scaffold(
                body: buildBody(),
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


  buildBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          /*ExpansionPanelList(
            animationDuration: const Duration(milliseconds: 2000),
            elevation: 0.0,
            children: [
              ExpansionPanel(
                headerBuilder: (context, isExpanded) {
                  return Column(
                    children: [
                      const ProfileItemCard(
                        title: "Personal Information",
                        rightWidget: null,
                        callback: null,
                        textStyle: kProfileHeaderTextStyle,
                      ),
                      ProfileItemCard(
                        title:
                            "General information about yourself that is relevant to your job",
                        rightWidget: null,
                        callback: null,
                        textStyle: kProfileSubHeaderDetailTextStyle,
                      ),
                    ],
                  );
                },
                body: buildPersonalInformation(),
                isExpanded: _expandedPersonalInformation,
                canTapOnHeader: true,
              ),
            ],
            expansionCallback: (int index, bool isExpanded) {
              _expandedPersonalInformation = !_expandedPersonalInformation;
              setState(() {});
            },
          ),
          const SizedBox(
            height: 40,
          ),*/
          buildRecommendedUserProfileBody(),
        ],
      ),
    );
  }


  TabController? tabBarController;

  buildName() => Column(
        children: [
          Text(
            "${readUserJsonFileContent.firstName} ${readUserJsonFileContent.lastName}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            readUserJsonFileContent.jobTitle!,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 4),
        ],
      );

  ///-------------------------------------- PROFILE BODY --------------------------------------///
  buildRecommendedUserProfileBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExpansionPanelList(
          animationDuration: const Duration(milliseconds: 2000),
          elevation: 0.0,
          children: [
            ExpansionPanel(
              headerBuilder: (context, isExpanded) {
                return Column(
                  children: [
                    ProfileItemCardMA(
                      title: "General",
                      rightWidget: null,
                      callback: () {
                        if (kDebugMode) {
                          print('Tap About');
                        }
                      },
                      textStyle: kProfileHeaderTextStyle,
                    ),
                    ProfileItemCardMA(
                      title: "General information about your job",
                      rightWidget: null,
                      callback: null,
                      textStyle: kProfileSubHeaderDetailTextStyle,
                    ),
                  ],
                );
              },
              body: buildGeneral(),
              isExpanded: _expandedGeneral,
              canTapOnHeader: true,
            ),
          ],
          expansionCallback: (int index, bool isExpanded) {
            _expandedGeneral = !_expandedGeneral;
            setState(() {});
          },
        ),
        const SizedBox(height: 40),
        ExpansionPanelList(
          animationDuration: const Duration(milliseconds: 2000),
          elevation: 0.0,
          children: [
            ExpansionPanel(
              headerBuilder: (context, isExpanded) {
                return Column(
                  children: [
                    ProfileItemCardMA(
                      title: "Languages",
                      rightWidget: null,
                      callback: () {
                        if (kDebugMode) {
                          print('Tap About');
                        }
                      },
                      textStyle: kProfileHeaderTextStyle,
                    ),
                    ProfileItemCardMA(
                      title: "The languages you know",
                      rightWidget: null,
                      callback: null,
                      textStyle: kProfileSubHeaderDetailTextStyle,
                    ),
                  ],
                );
              },
              body: buildLanguages(),
              isExpanded: _expandedLanguages,
              canTapOnHeader: true,
            ),
          ],
          expansionCallback: (int index, bool isExpanded) {
            _expandedLanguages = !_expandedLanguages;
            setState(() {});
          },
        ),
        const SizedBox(height: 40),
        ExpansionPanelList(
          animationDuration: const Duration(milliseconds: 2000),
          elevation: 0.0,
          children: [
            ExpansionPanel(
              headerBuilder: (context, isExpanded) {
                return Column(
                  children: [
                    const ProfileItemCardMA(
                      title: "Education",
                      rightWidget: null,
                      callback: null,
                      textStyle: kProfileHeaderTextStyle,
                    ),
                    ProfileItemCardMA(
                      title: "General information about your education",
                      rightWidget: null,
                      callback: null,
                      textStyle: kProfileSubHeaderDetailTextStyle,
                    ),
                  ],
                );
              },
              body: buildEducation(),
              isExpanded: _expandedEducation,
              canTapOnHeader: true,
            ),
          ],
          expansionCallback: (int index, bool isExpanded) {
            _expandedEducation = !_expandedEducation;
            setState(() {});
          },
        ),
        const SizedBox(height: 40),
        ExpansionPanelList(
          animationDuration: const Duration(milliseconds: 2000),
          elevation: 0.0,
          children: [
            ExpansionPanel(
              headerBuilder: (context, isExpanded) {
                return Column(
                  children: [
                    const ProfileItemCardMA(
                      title: "Experience",
                      rightWidget: null,
                      callback: null,
                      textStyle: kProfileHeaderTextStyle,
                    ),
                    ProfileItemCardMA(
                      title:
                      "Any experience gained through work or volunteering",
                      rightWidget: null,
                      callback: null,
                      textStyle: kProfileSubHeaderDetailTextStyle,
                    ),
                  ],
                );
              },
              body: buildExperience(),
              isExpanded: _expandedExperience,
              canTapOnHeader: true,
            ),
          ],
          expansionCallback: (int index, bool isExpanded) {
            _expandedExperience = !_expandedExperience;
            setState(() {});
          },
        ),
        const SizedBox(height: 40),
        ExpansionPanelList(
          animationDuration: const Duration(milliseconds: 2000),
          elevation: 0.0,
          children: [
            ExpansionPanel(
              headerBuilder: (context, isExpanded) {
                return Column(
                  children: [
                    const ProfileItemCardMA(
                      title: "Qualifications",
                      rightWidget: null,
                      callback: null,
                      textStyle: kProfileHeaderTextStyle,
                    ),
                    ProfileItemCardMA(
                      title:
                      "Qualifications acquired other than your education",
                      rightWidget: null,
                      callback: null,
                      textStyle: kProfileSubHeaderDetailTextStyle,
                    ),
                  ],
                );
              },
              body: buildQualifications(),
              isExpanded: _expandedQualifications,
              canTapOnHeader: true,
            ),
          ],
          expansionCallback: (int index, bool isExpanded) {
            _expandedQualifications = !_expandedQualifications;
            setState(() {});
          },
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  ///------------------- GENERAL -------------------///
  bool _expandedGeneral = false;

  buildGeneral() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          readUserJsonFileContent.countryOfEmployment == null
              ? Container()
              : const ProfileItemCardMA(
                  title: "Country of employment",
                  rightWidget: null,
                  callback: null,
                  textStyle: kProfileSubHeaderTextStyle,
                ),
          readUserJsonFileContent.countryOfEmployment == null
              ? Container()
              : ProfileItemCardMA(
                  title: readUserJsonFileContent.countryOfEmployment,
                  rightWidget: null,
                  callback: () {
                    if (kDebugMode) {
                      print('Tap Settings Item 01');
                    }
                  },
                  textStyle: kProfileBodyTextStyle,
                ),
          readUserJsonFileContent.workEmail == null
              ? Container()
              : const ProfileItemCardMA(
                  title: "Work email",
                  rightWidget: null,
                  callback: null,
                  textStyle: kProfileSubHeaderTextStyle,
                ),
          readUserJsonFileContent.workEmail == null
              ? Container()
              : ProfileItemCardMA(
                  title: readUserJsonFileContent.workEmail,
                  rightWidget: null,
                  callback: () {
                    if (kDebugMode) {
                      print('Tap Date of birth');
                    }
                  },
                  textStyle: kProfileBodyTextStyle,
                ),
          readUserJsonFileContent.jobDepartment == null
              ? Container()
              : const ProfileItemCardMA(
                  title: "Job Department",
                  rightWidget: null,
                  callback: null,
                  textStyle: kProfileSubHeaderTextStyle,
                ),
          readUserJsonFileContent.jobDepartment == null
              ? Container()
              : ProfileItemCardMA(
                  title: readUserJsonFileContent.jobDepartment,
                  rightWidget: null,
                  callback: () {
                    if (kDebugMode) {
                      print('Tap Date of birth');
                    }
                  },
                  textStyle: kProfileBodyTextStyle,
                ),
          readUserJsonFileContent.jobTeam == null
              ? Container()
              : const ProfileItemCardMA(
                  title: "Department Team",
                  rightWidget: null,
                  callback: null,
                  textStyle: kProfileSubHeaderTextStyle,
                ),
          readUserJsonFileContent.jobTeam == null
              ? Container()
              : ProfileItemCardMA(
                  title: readUserJsonFileContent.jobTeam,
                  rightWidget: null,
                  callback: () {
                    if (kDebugMode) {
                      print('Tap Date of birth');
                    }
                  },
                  textStyle: kProfileBodyTextStyle,
                ),
          readUserJsonFileContent.jobField == null
              ? Container()
              : const ProfileItemCardMA(
                  title: "Job Field",
                  rightWidget: null,
                  callback: null,
                  textStyle: kProfileSubHeaderTextStyle,
                ),
          readUserJsonFileContent.jobField == null
              ? Container()
              : ProfileItemCardMA(
                  title: readUserJsonFileContent.jobField,
                  rightWidget: null,
                  callback: () {
                    if (kDebugMode) {
                      print('Tap Date of birth');
                    }
                  },
                  textStyle: kProfileBodyTextStyle,
                ),
          readUserJsonFileContent.jobSubField == null
              ? Container()
              : const ProfileItemCardMA(
                  title: "Job Sub-Field",
                  rightWidget: null,
                  callback: null,
                  textStyle: kProfileSubHeaderTextStyle,
                ),
          readUserJsonFileContent.jobSubField == null
              ? Container()
              : ProfileItemCardMA(
                  title: readUserJsonFileContent.jobSubField,
                  rightWidget: null,
                  callback: () {
                    if (kDebugMode) {
                      print('Tap Date of jobSubField');
                    }
                  },
                  textStyle: kProfileBodyTextStyle,
                ),
          readUserJsonFileContent.jobSpecialization == null
              ? Container()
              : const ProfileItemCardMA(
                  title: "Job Specialization",
                  rightWidget: null,
                  callback: null,
                  textStyle: kProfileSubHeaderTextStyle,
                ),
          readUserJsonFileContent.jobSpecialization == null
              ? Container()
              : ProfileItemCardMA(
                  title: readUserJsonFileContent.jobSpecialization,
                  rightWidget: null,
                  callback: () {
                    if (kDebugMode) {
                      print('Tap Date of jobSpecialization');
                    }
                  },
                  textStyle: kProfileBodyTextStyle,
                ),
          readUserJsonFileContent.jobContractType == null
              ? Container()
              : const ProfileItemCardMA(
                  title: "Contract Type",
                  rightWidget: null,
                  callback: null,
                  textStyle: kProfileSubHeaderTextStyle,
                ),
          readUserJsonFileContent.jobContractType == null
              ? Container()
              : ProfileItemCardMA(
                  title: readUserJsonFileContent.jobContractType,
                  rightWidget: null,
                  callback: () {
                    if (kDebugMode) {
                      print('Tap Date of birth');
                    }
                  },
                  textStyle: kProfileBodyTextStyle,
                ),
          readUserJsonFileContent.jobContractExpirationDate == null
              ? Container()
              : const ProfileItemCardMA(
                  title: "Contract Expiration Date",
                  rightWidget: null,
                  callback: null,
                  textStyle: kProfileSubHeaderTextStyle,
                ),
          readUserJsonFileContent.jobContractExpirationDate == null
              ? Container()
              : ProfileItemCardMA(
                  title: DateFormat("EEE, MMM d, yyyy").format(DateTime.parse(
                      readUserJsonFileContent.jobContractExpirationDate!)),
                  rightWidget: null,
                  callback: () {
                    if (kDebugMode) {
                      print('Tap Date of birth');
                    }
                  },
                  textStyle: kProfileBodyTextStyle,
                ),
        ],
      );

  ///------------------- LANGUAGES -------------------///
  bool _expandedLanguages = false;

  buildLanguages() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          readUserJsonFileContent.languages == null
              ? Container()
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: readUserJsonFileContent.languages!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ProfileItemCardMA(
                          title: "Language ${index + 1}",
                          rightWidget: null,
                          callback: null,
                          textStyle: kProfileSubHeaderTextStyle,
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, bottom: 12),
                          color: DynamicTheme.of(context)?.brightness ==
                                  Brightness.light
                              ? Colors.white
                              : Colors.black12,
                          child: Row(
                            children: [
                              Text(
                                readUserJsonFileContent
                                    .languages![index].language!,
                                style: kProfileBodyTextStyle,
                              ),
                              const SizedBox(width: 100),
                              readUserJsonFileContent.languages![index].level ==
                                      null
                                  ? Container()
                                  : Text(
                                      readUserJsonFileContent
                                          .languages![index].level!,
                                      style: kProfileBodyTextStyle,
                                    ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ],
      );

  ///------------------- EDUCATION -------------------///
  bool _expandedEducation = false;

  buildEducation() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildBachelors(),
          buildMasters(),
          buildPHD(),
          buildDoctoral(),
        ],
      );

  ///--- EDUCATION ~ BACHELORS
  buildBachelors() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Bachelors",
              rightWidget: null,
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.bachelors == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent.bachelors!.length *
                        MediaQuery.of(context).size.height *
                        0.815,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent.bachelors!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Bachelors ${index + 1}",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Discipline",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                    .bachelors![index].discipline,
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Institution",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                    .bachelors![index].institutionName,
                                textStyle: kProfileSubHeaderDetailTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: MediaQuery.of(context)
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
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.05,
                                    right: MediaQuery.of(context).size.width *
                                        0.065),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ProfileItemCardMA(
                                      title:
                                          "${DateFormat('yyyy-MM-dd').parse(readUserJsonFileContent.bachelors![index].startDate!)}",
                                      textStyle: kProfileBodyTextStyle,
                                      callback: () {},
                                      rightWidget: null,
                                    ),
                                    ProfileItemCardMA(
                                      title:
                                          "${DateFormat('yyyy-MM-dd').parse(readUserJsonFileContent.bachelors![index].endDate!)}",
                                      textStyle: kProfileBodyTextStyle,
                                      callback: () {},
                                      rightWidget: null,
                                    ),
                                  ],
                                ),
                              ),
                              ProfileItemCardMA(
                                title: "Duration (in weeks)",
                                rightWidget: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height *
                                      0.065,
                                  child: ProfileItemCardMA(
                                    title:
                                        "${readUserJsonFileContent.bachelors![index].duration!}",
                                    textStyle: kProfileBodyTextStyle,
                                    callback: () {},
                                    rightWidget: null,
                                  ),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Description",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                    .bachelors![index].description,
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              ProfileItemCardMA(
                                title: "Transcript/Certificate",
                                rightWidget: Icon(
                                  Icons.attach_file_outlined,
                                  color: Colors.grey[600],
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              readUserJsonFileContent.bachelors![index]
                                          .educationReferenceFile ==
                                      null
                                  ? Container()
                                  : Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        right: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.125,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.065,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  readUserJsonFileContent
                                                              .bachelors![index]
                                                              .educationReferenceFileName!
                                                              .toString()
                                                              .split('.')
                                                              .last ==
                                                          "pdf"
                                                      ? pdfLogo
                                                      : fileLogo,
                                                  width: 70,
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  readUserJsonFileContent
                                                      .bachelors![index]
                                                      .educationReferenceFileName!,
                                                  style:
                                                      kProfileSubHeaderTextStyle,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${(readUserJsonFileContent.bachelors![index].educationReferenceSize! / 1024).ceil()} KB',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      );

  ///--- EDUCATION ~ MASTERS
  buildMasters() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Masters",
              rightWidget: null,
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.masters == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent.masters!.length *
                        MediaQuery.of(context).size.height *
                        0.815,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent.masters!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Masters ${index + 1}",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Discipline",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                    .masters![index].discipline,
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Institution",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                    .masters![index].institutionName,
                                textStyle: kProfileSubHeaderDetailTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: MediaQuery.of(context)
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
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.05,
                                    right: MediaQuery.of(context).size.width *
                                        0.065),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ProfileItemCardMA(
                                      title:
                                          "${DateFormat('yyyy-MM-dd').parse(readUserJsonFileContent.masters![index].startDate!)}",
                                      textStyle: kProfileBodyTextStyle,
                                      callback: () {},
                                      rightWidget: null,
                                    ),
                                    ProfileItemCardMA(
                                      title:
                                          "${DateFormat('yyyy-MM-dd').parse(readUserJsonFileContent.masters![index].endDate!)}",
                                      textStyle: kProfileBodyTextStyle,
                                      callback: () {},
                                      rightWidget: null,
                                    ),
                                  ],
                                ),
                              ),
                              ProfileItemCardMA(
                                title: "Duration (in weeks)",
                                rightWidget: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height *
                                      0.065,
                                  child: ProfileItemCardMA(
                                    title:
                                        "${readUserJsonFileContent.masters![index].duration!}",
                                    textStyle: kProfileBodyTextStyle,
                                    callback: () {},
                                    rightWidget: null,
                                  ),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Description",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                    .masters![index].description,
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              ProfileItemCardMA(
                                title: "Transcript/Certificate",
                                rightWidget: Icon(
                                  Icons.attach_file_outlined,
                                  color: Colors.grey[600],
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              readUserJsonFileContent.masters![index]
                                          .educationReferenceFile ==
                                      null
                                  ? Container()
                                  : Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        right: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.125,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.065,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  readUserJsonFileContent
                                                              .masters![index]
                                                              .educationReferenceFileName!
                                                              .toString()
                                                              .split('.')
                                                              .last ==
                                                          "pdf"
                                                      ? pdfLogo
                                                      : fileLogo,
                                                  width: 70,
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  readUserJsonFileContent
                                                      .masters![index]
                                                      .educationReferenceFileName!,
                                                  style:
                                                      kProfileSubHeaderTextStyle,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${(readUserJsonFileContent.masters![index].educationReferenceSize! / 1024).ceil()} KB',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      );

  ///--- EDUCATION ~ PHD
  buildPHD() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "PHD",
              rightWidget: null,
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.phd == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent.phd!.length *
                        MediaQuery.of(context).size.height *
                        0.815,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent.phd!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "PHD ${index + 1}",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Discipline",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                    .phd![index].discipline,
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Institution",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                    .phd![index].institutionName,
                                textStyle: kProfileSubHeaderDetailTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: MediaQuery.of(context)
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
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.05,
                                    right: MediaQuery.of(context).size.width *
                                        0.065),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ProfileItemCardMA(
                                      title:
                                          "${DateFormat('yyyy-MM-dd').parse(readUserJsonFileContent.phd![index].startDate!)}",
                                      textStyle: kProfileBodyTextStyle,
                                      callback: () {},
                                      rightWidget: null,
                                    ),
                                    ProfileItemCardMA(
                                      title:
                                          "${DateFormat('yyyy-MM-dd').parse(readUserJsonFileContent.phd![index].endDate!)}",
                                      textStyle: kProfileBodyTextStyle,
                                      callback: () {},
                                      rightWidget: null,
                                    ),
                                  ],
                                ),
                              ),
                              ProfileItemCardMA(
                                title: "Duration (in weeks)",
                                rightWidget: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height *
                                      0.065,
                                  child: ProfileItemCardMA(
                                    title:
                                        "${readUserJsonFileContent.phd![index].duration!}",
                                    textStyle: kProfileBodyTextStyle,
                                    callback: () {},
                                    rightWidget: null,
                                  ),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Description",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                    .phd![index].description,
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              ProfileItemCardMA(
                                title: "Transcript/Certificate",
                                rightWidget: Icon(
                                  Icons.attach_file_outlined,
                                  color: Colors.grey[600],
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              readUserJsonFileContent
                                          .phd![index].educationReferenceFile ==
                                      null
                                  ? Container()
                                  : Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        right: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.125,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.065,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  readUserJsonFileContent
                                                              .phd![index]
                                                              .educationReferenceFileName!
                                                              .toString()
                                                              .split('.')
                                                              .last ==
                                                          "pdf"
                                                      ? pdfLogo
                                                      : fileLogo,
                                                  width: 70,
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  readUserJsonFileContent
                                                      .phd![index]
                                                      .educationReferenceFileName!,
                                                  style:
                                                      kProfileSubHeaderTextStyle,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${(readUserJsonFileContent.phd![index].educationReferenceSize! / 1024).ceil()} KB',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      );

  ///--- EDUCATION ~ DOCTORAL
  buildDoctoral() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Doctoral",
              rightWidget: null,
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.doctoral == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent.doctoral!.length *
                        MediaQuery.of(context).size.height *
                        0.815,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent.doctoral!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Doctoral ${index + 1}",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Discipline",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                    .doctoral![index].discipline,
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Institution",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                    .doctoral![index].institutionName,
                                textStyle: kProfileSubHeaderDetailTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: MediaQuery.of(context)
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
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.05,
                                    right: MediaQuery.of(context).size.width *
                                        0.065),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ProfileItemCardMA(
                                      title:
                                          "${DateFormat('yyyy-MM-dd').parse(readUserJsonFileContent.doctoral![index].startDate!)}",
                                      textStyle: kProfileBodyTextStyle,
                                      callback: () {},
                                      rightWidget: null,
                                    ),
                                    ProfileItemCardMA(
                                      title:
                                          "${DateFormat('yyyy-MM-dd').parse(readUserJsonFileContent.doctoral![index].endDate!)}",
                                      textStyle: kProfileBodyTextStyle,
                                      callback: () {},
                                      rightWidget: null,
                                    ),
                                  ],
                                ),
                              ),
                              ProfileItemCardMA(
                                title: "Duration (in weeks)",
                                rightWidget: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height *
                                      0.065,
                                  child: ProfileItemCardMA(
                                    title:
                                        "${readUserJsonFileContent.doctoral![index].duration!}",
                                    textStyle: kProfileBodyTextStyle,
                                    callback: () {},
                                    rightWidget: null,
                                  ),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Description",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                    .doctoral![index].description,
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              ProfileItemCardMA(
                                title: "Transcript/Certificate",
                                rightWidget: Icon(
                                  Icons.attach_file_outlined,
                                  color: Colors.grey[600],
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              readUserJsonFileContent.doctoral![index]
                                          .educationReferenceFile ==
                                      null
                                  ? Container()
                                  : Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        right: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.125,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.065,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  readUserJsonFileContent
                                                              .doctoral![index]
                                                              .educationReferenceFileName!
                                                              .toString()
                                                              .split('.')
                                                              .last ==
                                                          "pdf"
                                                      ? pdfLogo
                                                      : fileLogo,
                                                  width: 70,
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  readUserJsonFileContent
                                                      .doctoral![index]
                                                      .educationReferenceFileName!,
                                                  style:
                                                      kProfileSubHeaderTextStyle,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${(readUserJsonFileContent.doctoral![index].educationReferenceSize! / 1024).ceil()} KB',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      );

  ///------------------- EXPERIENCE -------------------///
  bool _expandedExperience = false;

  buildExperience() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildWorkExperience(),
          buildVolunteerExperience(),
          ProfileItemCardMA(
            title: "C.V.",
            rightWidget: Icon(
              Icons.attach_file_outlined,
              color: Colors.grey[600],
            ),
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          readUserJsonFileContent.cvFile == null
              ? Container()
              : Container(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 6,
                    bottom: 6,
                  ),
                  color:
                      DynamicTheme.of(context)?.brightness == Brightness.light
                          ? Colors.white
                          : Colors.black12,
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.125,
                        height: MediaQuery.of(context).size.height * 0.065,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              readUserJsonFileContent.cvName!
                                          .toString()
                                          .split('.')
                                          .last ==
                                      "pdf"
                                  ? pdfLogo
                                  : fileLogo,
                              width: 70,
                            )),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              readUserJsonFileContent.cvName!,
                              style: kProfileSubHeaderTextStyle,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${(readUserJsonFileContent.cvSize! / 1024).ceil()} KB',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      );

  ///--- EXPERIENCE ~ WORK EXPERIENCE
  buildWorkExperience() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Work Experience",
              rightWidget: null,
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.workExperience == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent.workExperience!.length *
                        MediaQuery.of(context).size.height *
                        0.815,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent.workExperience!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Work Experience ${index + 1}",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Job Title",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                    .workExperience![index].jobTitle,
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Work Place",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                    .workExperience![index].workArea,
                                textStyle: kProfileSubHeaderDetailTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Job Description",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                    .workExperience![index].jobDescription,
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: MediaQuery.of(context)
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
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.05,
                                    right: MediaQuery.of(context).size.width *
                                        0.065),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ProfileItemCardMA(
                                      title:
                                          "${DateFormat('yyyy-MM-dd').parse(readUserJsonFileContent.workExperience![index].startDate!)}",
                                      textStyle: kProfileBodyTextStyle,
                                      callback: () {},
                                      rightWidget: null,
                                    ),
                                    ProfileItemCardMA(
                                      title:
                                          "${DateFormat('yyyy-MM-dd').parse(readUserJsonFileContent.workExperience![index].endDate!)}",
                                      textStyle: kProfileBodyTextStyle,
                                      callback: () {},
                                      rightWidget: null,
                                    ),
                                  ],
                                ),
                              ),
                              ProfileItemCardMA(
                                title: "Duration (in weeks)",
                                rightWidget: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height *
                                      0.065,
                                  child: ProfileItemCardMA(
                                    title:
                                        "${readUserJsonFileContent.workExperience![index].duration!}",
                                    textStyle: kProfileBodyTextStyle,
                                    callback: () {},
                                    rightWidget: null,
                                  ),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Reference",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileMidSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Written By",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                    .workExperience![index].referenceBy,
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Phone Number",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                    .workExperience![index]
                                    .referencePhoneNumber,
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Email Address",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                    .workExperience![index]
                                    .referenceEmailAddress,
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Upload File",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              readUserJsonFileContent.workExperience![index]
                                          .referenceFile ==
                                      null
                                  ? Container()
                                  : Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        right: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.125,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.065,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  readUserJsonFileContent
                                                              .workExperience![
                                                                  index]
                                                              .referenceName!
                                                              .toString()
                                                              .split('.')
                                                              .last ==
                                                          "pdf"
                                                      ? pdfLogo
                                                      : fileLogo,
                                                  width: 70,
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  readUserJsonFileContent
                                                      .workExperience![index]
                                                      .referenceName!,
                                                  style:
                                                      kProfileSubHeaderTextStyle,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${(readUserJsonFileContent.workExperience![index].referenceSize! / 1024).ceil()} KB',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      );

  ///--- EXPERIENCE ~ VOLUNTEER EXPERIENCE
  buildVolunteerExperience() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Volunteer Experience",
              rightWidget: null,
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.volunteerExperience == null
                ? Container()
                : SizedBox(
                    height:
                        readUserJsonFileContent.volunteerExperience!.length *
                            MediaQuery.of(context).size.height *
                            0.815,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          readUserJsonFileContent.volunteerExperience!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Work Experience ${index + 1}",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Title",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                    .volunteerExperience![index].title,
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Work Place",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                    .volunteerExperience![index].workArea,
                                textStyle: kProfileSubHeaderDetailTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Description",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                    .volunteerExperience![index].description,
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: MediaQuery.of(context)
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
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.05,
                                    right: MediaQuery.of(context).size.width *
                                        0.065),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ProfileItemCardMA(
                                      title:
                                          "${DateFormat('yyyy-MM-dd').parse(readUserJsonFileContent.volunteerExperience![index].startDate!)}",
                                      textStyle: kProfileBodyTextStyle,
                                      callback: () {},
                                      rightWidget: null,
                                    ),
                                    ProfileItemCardMA(
                                      title:
                                          "${DateFormat('yyyy-MM-dd').parse(readUserJsonFileContent.volunteerExperience![index].endDate!)}",
                                      textStyle: kProfileBodyTextStyle,
                                      callback: () {},
                                      rightWidget: null,
                                    ),
                                  ],
                                ),
                              ),
                              ProfileItemCardMA(
                                title: "Duration (in weeks)",
                                rightWidget: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height *
                                      0.065,
                                  child: ProfileItemCardMA(
                                    title:
                                        "${readUserJsonFileContent.volunteerExperience![index].duration!}",
                                    textStyle: kProfileBodyTextStyle,
                                    callback: () {},
                                    rightWidget: null,
                                  ),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Reference",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileMidSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Written By",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                    .volunteerExperience![index].referenceBy,
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Phone Number",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                    .volunteerExperience![index]
                                    .referencePhoneNumber,
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Email Address",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                    .volunteerExperience![index]
                                    .referenceEmailAddress,
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              const ProfileItemCardMA(
                                title: "Upload File",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              readUserJsonFileContent
                                          .volunteerExperience![index]
                                          .referenceFile ==
                                      null
                                  ? Container()
                                  : Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        right: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.125,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.065,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  readUserJsonFileContent
                                                              .volunteerExperience![
                                                                  index]
                                                              .referenceName!
                                                              .toString()
                                                              .split('.')
                                                              .last ==
                                                          "pdf"
                                                      ? pdfLogo
                                                      : fileLogo,
                                                  width: 70,
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  readUserJsonFileContent
                                                      .volunteerExperience![
                                                          index]
                                                      .referenceName!,
                                                  style:
                                                      kProfileSubHeaderTextStyle,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${(readUserJsonFileContent.volunteerExperience![index].referenceSize! / 1024).ceil()} KB',
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey.shade500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      );

  ///------------------- QUALIFICATIONS -------------------///
  bool _expandedQualifications = false;

  buildQualifications() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildProfessionalQualifications(),
          buildEducationalQualifications(),
          buildOtherQualifications(),
        ],
      );

  ///--- QUALIFICATIONS ~ PROFESSIONAL QUALIFICATIONS
  buildProfessionalQualifications() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Professional Qualifications",
              rightWidget: null,
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.professionalQualifications == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent
                            .professionalQualifications!.length *
                        MediaQuery.of(context).size.height *
                        1,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent
                          .professionalQualifications!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title:
                                    "Professional Qualification ${index + 1}",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Title",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                            .professionalQualifications![index]
                                            .title ==
                                        null
                                    ? ""
                                    : readUserJsonFileContent
                                        .professionalQualifications![index]
                                        .title!,
                                rightWidget: null,
                                callback: () {
                                  if (kDebugMode) {
                                    print('Tap Settings Item 01');
                                  }
                                },
                                textStyle: kProfileBodyTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Obtained From",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                            .professionalQualifications![index]
                                            .obtainedFrom ==
                                        null
                                    ? ""
                                    : readUserJsonFileContent
                                        .professionalQualifications![index]
                                        .obtainedFrom!,
                                rightWidget: null,
                                callback: () {
                                  if (kDebugMode) {
                                    print('Tap Settings Item 01');
                                  }
                                },
                                textStyle: kProfileBodyTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Description",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                            .professionalQualifications![index]
                                            .description ==
                                        null
                                    ? ""
                                    : readUserJsonFileContent
                                        .professionalQualifications![index]
                                        .description!,
                                rightWidget: null,
                                callback: () {
                                  if (kDebugMode) {
                                    print('Tap Settings Item 01');
                                  }
                                },
                                textStyle: kProfileBodyTextStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: MediaQuery.of(context)
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
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.05,
                                    right: MediaQuery.of(context).size.width *
                                        0.065),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ProfileItemCardMA(
                                      title:
                                          "${DateFormat('yyyy-MM-dd').parse(readUserJsonFileContent.professionalQualifications![index].startDate!)}",
                                      textStyle: kProfileBodyTextStyle,
                                      callback: () {},
                                      rightWidget: null,
                                    ),
                                    ProfileItemCardMA(
                                      title:
                                          "${DateFormat('yyyy-MM-dd').parse(readUserJsonFileContent.professionalQualifications![index].endDate!)}",
                                      textStyle: kProfileBodyTextStyle,
                                      callback: () {},
                                      rightWidget: null,
                                    ),
                                  ],
                                ),
                              ),
                              ProfileItemCardMA(
                                title: "Duration (in weeks)",
                                rightWidget: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height *
                                      0.065,
                                  child: ProfileItemCardMA(
                                    title:
                                        "${readUserJsonFileContent.professionalQualifications![index].duration}",
                                    textStyle: kProfileBodyTextStyle,
                                    callback: () {},
                                    rightWidget: null,
                                  ),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Upload Certificate File",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              readUserJsonFileContent
                                          .professionalQualifications![index]
                                          .qualificationFile ==
                                      null
                                  ? Container()
                                  : Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        right: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.125,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.065,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  readUserJsonFileContent
                                                              .professionalQualifications![
                                                                  index]
                                                              .qualificationFileName!
                                                              .toString()
                                                              .split('.')
                                                              .last ==
                                                          "pdf"
                                                      ? pdfLogo
                                                      : fileLogo,
                                                  width: 70,
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  readUserJsonFileContent
                                                      .professionalQualifications![
                                                          index]
                                                      .qualificationFileName!,
                                                  style:
                                                      kProfileSubHeaderTextStyle,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${(readUserJsonFileContent.professionalQualifications![index].qualificationSize! / 1024).ceil()} KB',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.clear,
                                              color: Colors.grey[600],
                                              size: 32,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                readUserJsonFileContent
                                                    .professionalQualifications![
                                                        index]
                                                    .qualificationFileName = null;
                                                readUserJsonFileContent
                                                    .professionalQualifications![
                                                        index]
                                                    .qualificationFile = null;
                                                readUserJsonFileContent
                                                    .professionalQualifications![
                                                        index]
                                                    .qualificationSize = null;
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );

  ///--- QUALIFICATIONS ~ EDUCATIONAL QUALIFICATIONS
  buildEducationalQualifications() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Educational Qualifications",
              rightWidget: null,
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.educationalQualifications == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent
                            .educationalQualifications!.length *
                        MediaQuery.of(context).size.height *
                        1,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent
                          .educationalQualifications!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Educational Qualification ${index + 1}",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Title",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                            .educationalQualifications![index]
                                            .title ==
                                        null
                                    ? ""
                                    : readUserJsonFileContent
                                        .educationalQualifications![index]
                                        .title!,
                                rightWidget: null,
                                callback: () {
                                  if (kDebugMode) {
                                    print('Tap Settings Item 01');
                                  }
                                },
                                textStyle: kProfileBodyTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Obtained From",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                            .educationalQualifications![index]
                                            .obtainedFrom ==
                                        null
                                    ? ""
                                    : readUserJsonFileContent
                                        .educationalQualifications![index]
                                        .obtainedFrom!,
                                rightWidget: null,
                                callback: () {
                                  if (kDebugMode) {
                                    print('Tap Settings Item 01');
                                  }
                                },
                                textStyle: kProfileBodyTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Description",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                            .educationalQualifications![index]
                                            .description ==
                                        null
                                    ? ""
                                    : readUserJsonFileContent
                                        .educationalQualifications![index]
                                        .description!,
                                rightWidget: null,
                                callback: () {
                                  if (kDebugMode) {
                                    print('Tap Settings Item 01');
                                  }
                                },
                                textStyle: kProfileBodyTextStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: MediaQuery.of(context)
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
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.05,
                                    right: MediaQuery.of(context).size.width *
                                        0.065),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ProfileItemCardMA(
                                      title:
                                          "${DateFormat('yyyy-MM-dd').parse(readUserJsonFileContent.educationalQualifications![index].startDate!)}",
                                      textStyle: kProfileBodyTextStyle,
                                      callback: () {},
                                      rightWidget: null,
                                    ),
                                    ProfileItemCardMA(
                                      title:
                                          "${DateFormat('yyyy-MM-dd').parse(readUserJsonFileContent.educationalQualifications![index].endDate!)}",
                                      textStyle: kProfileBodyTextStyle,
                                      callback: () {},
                                      rightWidget: null,
                                    ),
                                  ],
                                ),
                              ),
                              ProfileItemCardMA(
                                title: "Duration (in weeks)",
                                rightWidget: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height *
                                      0.065,
                                  child: ProfileItemCardMA(
                                    title:
                                        "${readUserJsonFileContent.educationalQualifications![index].duration}",
                                    textStyle: kProfileBodyTextStyle,
                                    callback: () {},
                                    rightWidget: null,
                                  ),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Upload Certificate File",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              readUserJsonFileContent
                                          .educationalQualifications![index]
                                          .qualificationFile ==
                                      null
                                  ? Container()
                                  : Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        right: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.125,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.065,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  readUserJsonFileContent
                                                              .educationalQualifications![
                                                                  index]
                                                              .qualificationFileName!
                                                              .toString()
                                                              .split('.')
                                                              .last ==
                                                          "pdf"
                                                      ? pdfLogo
                                                      : fileLogo,
                                                  width: 70,
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  readUserJsonFileContent
                                                      .educationalQualifications![
                                                          index]
                                                      .qualificationFileName!,
                                                  style:
                                                      kProfileSubHeaderTextStyle,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${(readUserJsonFileContent.educationalQualifications![index].qualificationSize! / 1024).ceil()} KB',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.clear,
                                              color: Colors.grey[600],
                                              size: 32,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                readUserJsonFileContent
                                                    .educationalQualifications![
                                                        index]
                                                    .qualificationFileName = null;
                                                readUserJsonFileContent
                                                    .educationalQualifications![
                                                        index]
                                                    .qualificationFile = null;
                                                readUserJsonFileContent
                                                    .educationalQualifications![
                                                        index]
                                                    .qualificationSize = null;
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );

  ///--- QUALIFICATIONS ~ OTHER QUALIFICATIONS
  buildOtherQualifications() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Other Qualifications",
              rightWidget: null,
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.otherQualifications == null
                ? Container()
                : SizedBox(
                    height:
                        readUserJsonFileContent.otherQualifications!.length *
                            MediaQuery.of(context).size.height *
                            1,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          readUserJsonFileContent.otherQualifications!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Other Qualification ${index + 1}",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Title",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                            .otherQualifications![index]
                                            .title ==
                                        null
                                    ? ""
                                    : readUserJsonFileContent
                                        .otherQualifications![index].title!,
                                rightWidget: null,
                                callback: () {
                                  if (kDebugMode) {
                                    print('Tap Settings Item 01');
                                  }
                                },
                                textStyle: kProfileBodyTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Obtained From",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                            .otherQualifications![index]
                                            .obtainedFrom ==
                                        null
                                    ? ""
                                    : readUserJsonFileContent
                                        .otherQualifications![index]
                                        .obtainedFrom!,
                                rightWidget: null,
                                callback: () {
                                  if (kDebugMode) {
                                    print('Tap Settings Item 01');
                                  }
                                },
                                textStyle: kProfileBodyTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Description",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              ProfileItemCardMA(
                                title: readUserJsonFileContent
                                            .otherQualifications![index]
                                            .description ==
                                        null
                                    ? ""
                                    : readUserJsonFileContent
                                        .otherQualifications![index]
                                        .description!,
                                rightWidget: null,
                                callback: () {
                                  if (kDebugMode) {
                                    print('Tap Settings Item 01');
                                  }
                                },
                                textStyle: kProfileBodyTextStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize: MediaQuery.of(context)
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
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.05,
                                    right: MediaQuery.of(context).size.width *
                                        0.065),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ProfileItemCardMA(
                                      title:
                                          "${DateFormat('yyyy-MM-dd').parse(readUserJsonFileContent.otherQualifications![index].startDate!)}",
                                      textStyle: kProfileBodyTextStyle,
                                      callback: () {},
                                      rightWidget: null,
                                    ),
                                    ProfileItemCardMA(
                                      title:
                                          "${DateFormat('yyyy-MM-dd').parse(readUserJsonFileContent.otherQualifications![index].endDate!)}",
                                      textStyle: kProfileBodyTextStyle,
                                      callback: () {},
                                      rightWidget: null,
                                    ),
                                  ],
                                ),
                              ),
                              ProfileItemCardMA(
                                title: "Duration (in weeks)",
                                rightWidget: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height *
                                      0.065,
                                  child: ProfileItemCardMA(
                                    title:
                                        "${readUserJsonFileContent.otherQualifications![index].duration}",
                                    textStyle: kProfileBodyTextStyle,
                                    callback: () {},
                                    rightWidget: null,
                                  ),
                                ),
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              const ProfileItemCardMA(
                                title: "Upload Certificate File",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              readUserJsonFileContent
                                          .otherQualifications![index]
                                          .qualificationFile ==
                                      null
                                  ? Container()
                                  : Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        right: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.125,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.065,
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  readUserJsonFileContent
                                                              .otherQualifications![
                                                                  index]
                                                              .qualificationFileName!
                                                              .toString()
                                                              .split('.')
                                                              .last ==
                                                          "pdf"
                                                      ? pdfLogo
                                                      : fileLogo,
                                                  width: 70,
                                                )),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  readUserJsonFileContent
                                                      .otherQualifications![
                                                          index]
                                                      .qualificationFileName!,
                                                  style:
                                                      kProfileSubHeaderTextStyle,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  '${(readUserJsonFileContent.otherQualifications![index].qualificationSize! / 1024).ceil()} KB',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          Colors.grey.shade500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.clear,
                                              color: Colors.grey[600],
                                              size: 32,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                readUserJsonFileContent
                                                    .otherQualifications![index]
                                                    .qualificationFileName = null;
                                                readUserJsonFileContent
                                                    .otherQualifications![index]
                                                    .qualificationFile = null;
                                                readUserJsonFileContent
                                                    .otherQualifications![index]
                                                    .qualificationSize = null;
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 10),
          ],
        ),
      );

}