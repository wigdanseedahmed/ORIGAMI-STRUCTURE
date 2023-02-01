import 'package:flutter/cupertino.dart';
import 'package:origami_structure/imports.dart';

import 'package:http/http.dart' as http;
import 'dart:io' as Io;

class ProfileScreenMA extends StatefulWidget {
  static const String id = 'profile_screen';

  const ProfileScreenMA({Key? key}) : super(key: key);

  @override
  _ProfileScreenMAState createState() => _ProfileScreenMAState();
}

class _ProfileScreenMAState extends State<ProfileScreenMA>
    with SingleTickerProviderStateMixin {
  /// Variable used to get RESTful-API
  NetworkHandler networkHandler = NetworkHandler();

  /// User Model information Variables
  getUserInfo() async {
    UserProfile.email =
        await CheckSharedPreferences.getUserEmailSharedPreference();
    UserProfile.email =
        await CheckSharedPreferences.getUserEmailSharedPreference();
    var userInfo = await networkHandler
        .get("${AppUrl.getUserUsingEmail}${UserProfile.email}");

    //print(userInfo);
    setState(() {
      UserProfile.username = userInfo['data']['username'];
    });
  }

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
          .where((element) => element.email == UserProfile.email)
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

    /// User Model information Variables
    getUserInfo();

    super.initState();
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
                appBar: appBar(),
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

  appBar() {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsScreenMA(),
              ),
            );
          },
          child: Icon(
            Icons.clear,
            size: 24,
            color: primaryColour,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              size: 24,
              color: primaryColour,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const EditProfileScreenMA(),
                ),
              );
            },
          ),
          const SizedBox(
            width: 20,
          ),
        ],
    );
  }

  buildBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          readUserJsonFileContent.userPhotoFile == null
              ? ClipOval(
            child: Material(
              color: Colors.grey,
              child: SizedBox(
                width: 200,
                height: 200,
                child: Center(
                  child: Text(
                    "${readUserJsonFileContent.firstName![0]}${readUserJsonFileContent.lastName![0]}",
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.1,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromRGBO(76, 75, 75, 1),
                    ),
                  ),
                ),
              ),
            ),
          )
              : ClipOval(
            child: Material(
              color: Colors.transparent,
              child: Ink.image(
                image: MemoryImage(base64Decode(readUserJsonFileContent.userPhotoFile!)),
                fit: BoxFit.cover,
                width: 200,
                height: 200,
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          buildName(),
          const SizedBox(
            height: 24,
          ),
          ExpansionPanelList(
            animationDuration: const Duration(milliseconds: 2000),
            elevation: 0.0,
            children: [
              ExpansionPanel(
                headerBuilder: (context, isExpanded) {
                  return Column(
                    children: [
                      const ProfileItemCardMA(
                        title: "Personal Information",
                        rightWidget: null,
                        callback: null,
                        textStyle: kProfileHeaderTextStyle,
                      ),
                      ProfileItemCardMA(
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
          ),
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
          const SizedBox(
            height: 40,
          ),
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
          const SizedBox(
            height: 40,
          ),
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
          const SizedBox(
            height: 40,
          ),
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
          const SizedBox(
            height: 40,
          ),
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
          const SizedBox(
            height: 40,
          ),
          ExpansionPanelList(
            animationDuration: const Duration(milliseconds: 2000),
            elevation: 0.0,
            children: [
              ExpansionPanel(
                headerBuilder: (context, isExpanded) {
                  return Column(
                    children: [
                      ProfileItemCardMA(
                        title: "Hard Skills",
                        rightWidget: null,
                        callback: () {
                          if (kDebugMode) {
                            print('Tap About');
                          }
                        },
                        textStyle: kProfileHeaderTextStyle,
                      ),
                      ProfileItemCardMA(
                        title:
                            "Hard skills refer to the technical knowledge or training you have gotten through experience. They are specific and essential to each job and are used for completing your tasks.",
                        rightWidget: null,
                        callback: null,
                        textStyle: kProfileSubHeaderDetailTextStyle,
                      ),
                    ],
                  );
                },
                body: buildHardSKills(),
                isExpanded: _expandedHardSkills,
                canTapOnHeader: true,
              ),
            ],
            expansionCallback: (int index, bool isExpanded) {
              _expandedHardSkills = !_expandedHardSkills;
              setState(() {});
            },
          ),
          const SizedBox(
            height: 40,
          ),
          ExpansionPanelList(
            animationDuration: const Duration(milliseconds: 2000),
            elevation: 0.0,
            children: [
              ExpansionPanel(
                headerBuilder: (context, isExpanded) {
                  return Column(
                    children: [
                      const ProfileItemCardMA(
                        title: "Soft Skills",
                        rightWidget: null,
                        callback: null,
                        textStyle: kProfileHeaderTextStyle,
                      ),
                      ProfileItemCardMA(
                        title:
                            "Soft skills, on the other hand, are attributes and habits that describe how you work individually or with others. They are not specific to a job, but indirectly help you adapt to the work environment and company culture.",
                        rightWidget: null,
                        callback: null,
                        textStyle: kProfileSubHeaderDetailTextStyle,
                      ),
                    ],
                  );
                },
                body: buildSoftSkills(),
                isExpanded: _expandedSoftSkills,
                canTapOnHeader: true,
              ),
            ],
            expansionCallback: (int index, bool isExpanded) {
              _expandedSoftSkills = !_expandedSoftSkills;
              setState(() {});
            },
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }

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

  ///------------------------------------- PERSONAL INFORMATION -------------------------------------///
  bool _expandedPersonalInformation = false;

  buildPersonalInformation() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          readUserJsonFileContent.firstName == null
              ? Container()
              : const ProfileItemCardMA(
                  title: "First name",
                  rightWidget: null,
                  callback: null,
                  textStyle: kProfileSubHeaderTextStyle,
                ),
          readUserJsonFileContent.firstName == null
              ? Container()
              : ProfileItemCardMA(
                  title: readUserJsonFileContent.firstName,
                  rightWidget: null,
                  callback: () {
                    if (kDebugMode) {
                      print('Tap Settings Item 01');
                    }
                  },
                  textStyle: kProfileBodyTextStyle,
                ),
          readUserJsonFileContent.lastName == null
              ? Container()
              : const ProfileItemCardMA(
                  title: "Last name",
                  rightWidget: null,
                  callback: null,
                  textStyle: kProfileSubHeaderTextStyle,
                ),
          readUserJsonFileContent.lastName == null
              ? Container()
              : ProfileItemCardMA(
                  title: readUserJsonFileContent.lastName,
                  rightWidget: null,
                  callback: () {
                    if (kDebugMode) {
                      print('Tap Settings Item 01');
                    }
                  },
                  textStyle: kProfileBodyTextStyle,
                ),
          readUserJsonFileContent.username == null
              ? Container()
              : const ProfileItemCardMA(
                  title: "Username",
                  rightWidget: null,
                  callback: null,
                  textStyle: kProfileSubHeaderTextStyle,
                ),
          readUserJsonFileContent.username == null
              ? Container()
              : ProfileItemCardMA(
                  title: readUserJsonFileContent.username,
                  rightWidget: null,
                  callback: () {
                    if (kDebugMode) {
                      print('Tap Settings Item 01');
                    }
                  },
                  textStyle: kProfileBodyTextStyle,
                ),
          readUserJsonFileContent.nationality == null
              ? Container()
              : const ProfileItemCardMA(
                  title: "Nationality",
                  rightWidget: null,
                  callback: null,
                  textStyle: kProfileSubHeaderTextStyle,
                ),
          readUserJsonFileContent.nationality == null
              ? Container()
              : ProfileItemCardMA(
                  title: readUserJsonFileContent.nationality,
                  rightWidget: null,
                  callback: () {
                    if (kDebugMode) {
                      print('Tap Settings Item 01');
                    }
                  },
                  textStyle: kProfileBodyTextStyle,
                ),
          readUserJsonFileContent.dateOfBirth == null
              ? Container()
              : const ProfileItemCardMA(
                  title: "Date of birth",
                  rightWidget: null,
                  callback: null,
                  textStyle: kProfileSubHeaderTextStyle,
                ),
          readUserJsonFileContent.dateOfBirth == null
              ? Container()
              : ProfileItemCardMA(
                  title: DateFormat("EEE, MMM d, yyyy").format(
                      DateTime.parse(readUserJsonFileContent.dateOfBirth!)),
                  rightWidget: null,
                  callback: () {
                    if (kDebugMode) {
                      print('Tap Date of birth');
                    }
                  },
                  textStyle: kProfileBodyTextStyle,
                ),
          readUserJsonFileContent.gender == null
              ? Container()
              : const ProfileItemCardMA(
                  title: "Gender",
                  rightWidget: null,
                  callback: null,
                  textStyle: kProfileSubHeaderTextStyle,
                ),
          readUserJsonFileContent.gender == null
              ? Container()
              : ProfileItemCardMA(
                  title: readUserJsonFileContent.gender,
                  rightWidget: null,
                  callback: () {
                    if (kDebugMode) {
                      print('Tap gender');
                    }
                  },
                  textStyle: kProfileBodyTextStyle,
                ),
          readUserJsonFileContent.personalEmail == null
              ? Container()
              : const ProfileItemCardMA(
                  title: "Personal email",
                  rightWidget: null,
                  callback: null,
                  textStyle: kProfileSubHeaderTextStyle,
                ),
          readUserJsonFileContent.personalEmail == null
              ? Container()
              : ProfileItemCardMA(
                  title: readUserJsonFileContent.personalEmail,
                  rightWidget: null,
                  callback: () {
                    if (kDebugMode) {
                      print('Tap Email');
                    }
                  },
                  textStyle: kProfileBodyTextStyle,
                ),
          readUserJsonFileContent.phoneNumber == null
              ? Container()
              : const ProfileItemCardMA(
                  title: "Phone number",
                  rightWidget: null,
                  callback: null,
                  textStyle: kProfileSubHeaderTextStyle,
                ),
          readUserJsonFileContent.phoneNumber == null
              ? Container()
              : ProfileItemCardMA(
                  title: readUserJsonFileContent.phoneNumber,
                  rightWidget: null,
                  callback: () {
                    if (kDebugMode) {
                      print('Tap Settings Item 01');
                    }
                  },
                  textStyle: kProfileBodyTextStyle,
                ),
          readUserJsonFileContent.optionalPhoneNumber == null
              ? Container()
              : const ProfileItemCardMA(
                  title: "Optional Phone number",
                  rightWidget: null,
                  callback: null,
                  textStyle: kProfileSubHeaderTextStyle,
                ),
          readUserJsonFileContent.optionalPhoneNumber == null
              ? Container()
              : ProfileItemCardMA(
                  title: readUserJsonFileContent.optionalPhoneNumber,
                  rightWidget: null,
                  callback: () {
                    if (kDebugMode) {
                      print('Tap Settings Item 01');
                    }
                  },
                  textStyle: kProfileBodyTextStyle,
                ),
          readUserJsonFileContent.userID == null
              ? Container()
              : const ProfileItemCardMA(
                  title: "User Model ID",
                  rightWidget: null,
                  callback: null,
                  textStyle: kProfileSubHeaderTextStyle,
                ),
          readUserJsonFileContent.userID == null
              ? Container()
              : ProfileItemCardMA(
                  title: readUserJsonFileContent.userID!,
                  rightWidget: null,
                  callback: () {
                    if (kDebugMode) {
                      print('Tap UserID');
                    }
                  },
                  textStyle: kProfileBodyTextStyle,
                ),
        ],
      );

  ///------------------------------------- GENERAL -------------------------------------///
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

  ///------------------------------------- LANGUAGES -------------------------------------///
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

  ///------------------------------------- EDUCATION -------------------------------------///
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

  ///------------------- BACHELORS EDUCATION -------------------///
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
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
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
                                    left: MediaQuery.of(context).size.width * 0.05,
                                    right: MediaQuery.of(context).size.width * 0.065),
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
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height * 0.065,
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
                                            width: MediaQuery.of(context).size.width * 0.125,
                                            height: MediaQuery.of(context).size.height * 0.065,
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

  ///------------------- MASTERS EDUCATION -------------------///
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
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
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
                                    left: MediaQuery.of(context).size.width * 0.05,
                                    right: MediaQuery.of(context).size.width * 0.065),
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
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height * 0.065,
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
                                            width: MediaQuery.of(context).size.width * 0.125,
                                            height: MediaQuery.of(context).size.height * 0.065,
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

  ///------------------- PHD EDUCATION -------------------///
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
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
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
                                    left: MediaQuery.of(context).size.width * 0.05,
                                    right: MediaQuery.of(context).size.width * 0.065),
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
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height * 0.065,
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
                                            width: MediaQuery.of(context).size.width * 0.125,
                                            height: MediaQuery.of(context).size.height * 0.065,
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

  ///------------------- DOCTORAL EDUCATION -------------------///
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
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
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
                                    left: MediaQuery.of(context).size.width * 0.05,
                                    right: MediaQuery.of(context).size.width * 0.065),
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
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height * 0.065,
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
                                            width: MediaQuery.of(context).size.width * 0.125,
                                            height: MediaQuery.of(context).size.height * 0.065,
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

  ///------------------------------------- EXPERIENCE -------------------------------------///
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

  ///------------------- WORK EXPERIENCE -------------------///
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
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
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
                                    left: MediaQuery.of(context).size.width * 0.05,
                                    right: MediaQuery.of(context).size.width * 0.065),
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
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height * 0.065,
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
                                            width: MediaQuery.of(context).size.width * 0.125,
                                            height: MediaQuery.of(context).size.height * 0.065,
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

  ///------------------- VOLUNTEER EXPERIENCE -------------------///
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
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
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
                                    left: MediaQuery.of(context).size.width * 0.05,
                                    right: MediaQuery.of(context).size.width * 0.065),
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
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height * 0.065,
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
                                            width: MediaQuery.of(context).size.width * 0.125,
                                            height: MediaQuery.of(context).size.height * 0.065,
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

  ///------------------------------------- QUALIFICATIONS -------------------------------------///
  bool _expandedQualifications = false;

  buildQualifications() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildProfessionalQualifications(),
          buildEducationalQualifications(),
          buildOtherQualifications(),
        ],
      );

  ///------------------- PROFESSIONAL QUALIFICATIONS -------------------///
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
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
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
                                    left: MediaQuery.of(context).size.width * 0.05,
                                    right: MediaQuery.of(context).size.width * 0.065),
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
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height * 0.065,
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
                                            width: MediaQuery.of(context).size.width * 0.125,
                                            height: MediaQuery.of(context).size.height * 0.065,
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

  ///------------------- EDUCATIONAL QUALIFICATIONS -------------------///
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
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
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
                                    left: MediaQuery.of(context).size.width * 0.05,
                                    right: MediaQuery.of(context).size.width * 0.065),
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
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height * 0.065,
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
                                            width: MediaQuery.of(context).size.width * 0.125,
                                            height: MediaQuery.of(context).size.height * 0.065,
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

  ///------------------- OTHER QUALIFICATIONS -------------------///
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
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "START DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height / 25,
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time_outlined,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context).size.width / 50),
                                          Text(
                                            "END DATE",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              //letterSpacing: 8,
                                              fontFamily: 'Electrolize',
                                              fontSize:
                                                  MediaQuery.of(context).size.width * 0.035,
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
                                    left: MediaQuery.of(context).size.width * 0.05,
                                    right: MediaQuery.of(context).size.width * 0.065),
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
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  height: MediaQuery.of(context).size.height * 0.065,
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
                                            width: MediaQuery.of(context).size.width * 0.125,
                                            height: MediaQuery.of(context).size.height * 0.065,
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

  ///------------------------------------- HARD SKILLS -------------------------------------///
  bool _expandedHardSkills = false;

  buildHardSKills() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          readUserJsonFileContent.hardSkills == null
              ? Container()
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: readUserJsonFileContent.hardSkills!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileItemCardMA(
                          title: "Skill ${index + 1}",
                          rightWidget: null,
                          callback: null,
                          textStyle: TextStyle(
                            fontSize: 18,
                            height: 1.4,
                            fontWeight: FontWeight.w800,
                            color: primaryColour,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, bottom: 12),
                          color: DynamicTheme.of(context)?.brightness ==
                                  Brightness.light
                              ? Colors.white
                              : Colors.black12,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              readUserJsonFileContent.hardSkills![index]
                                          .typeOfSpecialization ==
                                      null
                                  ? Container()
                                  : const ProfileItemCardMA(
                                      title: "Type of Specialization",
                                      rightWidget: null,
                                      callback: null,
                                      textStyle: kProfileSubHeaderTextStyle,
                                    ),
                              readUserJsonFileContent.hardSkills![index]
                                          .typeOfSpecialization ==
                                      null
                                  ? Container()
                                  : ProfileItemCardMA(
                                      title: readUserJsonFileContent
                                          .hardSkills![index]
                                          .typeOfSpecialization!,
                                      rightWidget: null,
                                      callback: () {
                                        if (kDebugMode) {
                                          print('Tap UserID');
                                        }
                                      },
                                      textStyle: kProfileBodyTextStyle,
                                    ),
                              readUserJsonFileContent
                                          .hardSkills![index].skillCategory ==
                                      null
                                  ? Container()
                                  : const ProfileItemCardMA(
                                      title: "Hard Skill Category",
                                      rightWidget: null,
                                      callback: null,
                                      textStyle: kProfileSubHeaderTextStyle,
                                    ),
                              readUserJsonFileContent
                                          .hardSkills![index].skillCategory ==
                                      null
                                  ? Container()
                                  : ProfileItemCardMA(
                                      title: readUserJsonFileContent
                                          .hardSkills![index].skillCategory!,
                                      rightWidget: null,
                                      callback: () {
                                        if (kDebugMode) {
                                          print('Tap UserID');
                                        }
                                      },
                                      textStyle: kProfileBodyTextStyle,
                                    ),
                              readUserJsonFileContent
                                          .hardSkills![index].skill ==
                                      null
                                  ? Container()
                                  : const ProfileItemCardMA(
                                      title: "Hard Skill",
                                      rightWidget: null,
                                      callback: null,
                                      textStyle: kProfileSubHeaderTextStyle,
                                    ),
                              readUserJsonFileContent
                                          .hardSkills![index].skill ==
                                      null
                                  ? Container()
                                  : ProfileItemCardMA(
                                      title: readUserJsonFileContent
                                          .hardSkills![index].skill!,
                                      rightWidget: null,
                                      callback: () {
                                        if (kDebugMode) {
                                          print('Tap UserID');
                                        }
                                      },
                                      textStyle: kProfileBodyTextStyle,
                                    ),
                              readUserJsonFileContent
                                          .hardSkills![index].level ==
                                      null
                                  ? Container()
                                  : ProfileItemCardMA(
                                      title: "Level",
                                      rightWidget: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 12.0),
                                        child: Text(
                                          readUserJsonFileContent
                                              .hardSkills![index].level!,
                                          style: kProfileBodyTextStyle,
                                        ),
                                      ),
                                      callback: null,
                                      textStyle: kProfileSubHeaderTextStyle,
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

  ///------------------------------------- SOFT SKILLS -------------------------------------///
  bool _expandedSoftSkills = false;

  buildSoftSkills() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildAdaptabilitySoftSkills(),
          buildAttentionToDetailSoftSkills(),
          buildCommunicationSoftSkills(),
          buildComputerSoftSkills(),
          buildCreativitySoftSkills(),
          buildLeadershipSoftSkills(),
          buildLifeSoftSkills(),
          buildOrganizationSoftSkills(),
          buildProblemSolvingSoftSkills(),
          buildSocialSoftSkills(),
          buildTeamworkSoftSkills(),
          buildTimeManagementSoftSkills(),
          buildWorkEthicSoftSkills(),
        ],
      );

  ///------------------- ADAPTABILITY -------------------///
  buildAdaptabilitySoftSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Adaptability",
              rightWidget: null,
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.adaptabilitySoftSkills == null
                ? Container()
                : SizedBox(
                    height:
                        readUserJsonFileContent.adaptabilitySoftSkills!.length *
                            MediaQuery.of(context).size.height *
                            0.25,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent
                          .adaptabilitySoftSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const ProfileItemCardMA(
                                            title: "Skill",
                                            rightWidget: null,
                                            callback: null,
                                            textStyle:
                                                kProfileSubHeaderTextStyle,
                                          ),
                                          ProfileItemCardMA(
                                            title: readUserJsonFileContent
                                                .adaptabilitySoftSkills![index]
                                                .skill,
                                            rightWidget: null,
                                            callback: () {
                                              if (kDebugMode) {
                                                print('Tap Settings Item 01');
                                              }
                                            },
                                            textStyle: kProfileBodyTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const ProfileItemCardMA(
                                            title: "Level",
                                            rightWidget: null,
                                            callback: null,
                                            textStyle:
                                                kProfileSubHeaderTextStyle,
                                          ),
                                          ProfileItemCardMA(
                                            title: readUserJsonFileContent
                                                .adaptabilitySoftSkills![index]
                                                .level,
                                            rightWidget: null,
                                            callback: () {
                                              if (kDebugMode) {
                                                print('Tap Settings Item 01');
                                              }
                                            },
                                            textStyle: kProfileBodyTextStyle,
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
            const SizedBox(height: 10),
          ],
        ),
      );

  ///------------------- ATTENTION TO DETAIL -------------------///
  buildAttentionToDetailSoftSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Attention To Detail",
              rightWidget: null,
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.attentionToDetailSoftSkills == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent
                            .attentionToDetailSoftSkills!.length *
                        MediaQuery.of(context).size.height *
                        0.25,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent
                          .attentionToDetailSoftSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const ProfileItemCardMA(
                                            title: "Skill",
                                            rightWidget: null,
                                            callback: null,
                                            textStyle:
                                                kProfileSubHeaderTextStyle,
                                          ),
                                          ProfileItemCardMA(
                                            title: readUserJsonFileContent
                                                .attentionToDetailSoftSkills![
                                                    index]
                                                .skill,
                                            rightWidget: null,
                                            callback: () {
                                              if (kDebugMode) {
                                                print('Tap Settings Item 01');
                                              }
                                            },
                                            textStyle: kProfileBodyTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const ProfileItemCardMA(
                                            title: "Level",
                                            rightWidget: null,
                                            callback: null,
                                            textStyle:
                                                kProfileSubHeaderTextStyle,
                                          ),
                                          ProfileItemCardMA(
                                            title: readUserJsonFileContent
                                                .attentionToDetailSoftSkills![
                                                    index]
                                                .level,
                                            rightWidget: null,
                                            callback: () {
                                              if (kDebugMode) {
                                                print('Tap Settings Item 01');
                                              }
                                            },
                                            textStyle: kProfileBodyTextStyle,
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
            const SizedBox(height: 10),
          ],
        ),
      );

  ///------------------- COMMUNICATION -------------------///
  buildCommunicationSoftSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Communication",
              rightWidget: null,
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.communicationSoftSkills == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent
                            .communicationSoftSkills!.length *
                        MediaQuery.of(context).size.height *
                        0.25,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent
                          .communicationSoftSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const ProfileItemCardMA(
                                            title: "Skill",
                                            rightWidget: null,
                                            callback: null,
                                            textStyle:
                                                kProfileSubHeaderTextStyle,
                                          ),
                                          ProfileItemCardMA(
                                            title: readUserJsonFileContent
                                                .communicationSoftSkills![index]
                                                .skill,
                                            rightWidget: null,
                                            callback: () {
                                              if (kDebugMode) {
                                                print('Tap Settings Item 01');
                                              }
                                            },
                                            textStyle: kProfileBodyTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const ProfileItemCardMA(
                                            title: "Level",
                                            rightWidget: null,
                                            callback: null,
                                            textStyle:
                                                kProfileSubHeaderTextStyle,
                                          ),
                                          ProfileItemCardMA(
                                            title: readUserJsonFileContent
                                                .communicationSoftSkills![index]
                                                .level,
                                            rightWidget: null,
                                            callback: () {
                                              if (kDebugMode) {
                                                print('Tap Settings Item 01');
                                              }
                                            },
                                            textStyle: kProfileBodyTextStyle,
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
            const SizedBox(height: 10),
          ],
        ),
      );

  ///------------------- COMPUTER -------------------///
  buildComputerSoftSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Computer",
              rightWidget: null,
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.computerSoftSkills == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent.computerSoftSkills!.length *
                        MediaQuery.of(context).size.height *
                        0.25,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          readUserJsonFileContent.computerSoftSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const ProfileItemCardMA(
                                            title: "Skill",
                                            rightWidget: null,
                                            callback: null,
                                            textStyle:
                                                kProfileSubHeaderTextStyle,
                                          ),
                                          ProfileItemCardMA(
                                            title: readUserJsonFileContent
                                                .computerSoftSkills![index]
                                                .skill,
                                            rightWidget: null,
                                            callback: () {
                                              if (kDebugMode) {
                                                print('Tap Settings Item 01');
                                              }
                                            },
                                            textStyle: kProfileBodyTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const ProfileItemCardMA(
                                            title: "Level",
                                            rightWidget: null,
                                            callback: null,
                                            textStyle:
                                                kProfileSubHeaderTextStyle,
                                          ),
                                          ProfileItemCardMA(
                                            title: readUserJsonFileContent
                                                .computerSoftSkills![index]
                                                .level,
                                            rightWidget: null,
                                            callback: () {
                                              if (kDebugMode) {
                                                print('Tap Settings Item 01');
                                              }
                                            },
                                            textStyle: kProfileBodyTextStyle,
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
            const SizedBox(height: 10),
          ],
        ),
      );

  ///------------------- CREATIVITY -------------------///
  buildCreativitySoftSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Creativity",
              rightWidget: null,
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.creativitySoftSkills == null
                ? Container()
                : SizedBox(
                    height:
                        readUserJsonFileContent.creativitySoftSkills!.length *
                            MediaQuery.of(context).size.height *
                            0.25,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          readUserJsonFileContent.creativitySoftSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const ProfileItemCardMA(
                                            title: "Skill",
                                            rightWidget: null,
                                            callback: null,
                                            textStyle:
                                                kProfileSubHeaderTextStyle,
                                          ),
                                          ProfileItemCardMA(
                                            title: readUserJsonFileContent
                                                .creativitySoftSkills![index]
                                                .skill,
                                            rightWidget: null,
                                            callback: () {
                                              if (kDebugMode) {
                                                print('Tap Settings Item 01');
                                              }
                                            },
                                            textStyle: kProfileBodyTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const ProfileItemCardMA(
                                            title: "Level",
                                            rightWidget: null,
                                            callback: null,
                                            textStyle:
                                                kProfileSubHeaderTextStyle,
                                          ),
                                          ProfileItemCardMA(
                                            title: readUserJsonFileContent
                                                .creativitySoftSkills![index]
                                                .level,
                                            rightWidget: null,
                                            callback: () {
                                              if (kDebugMode) {
                                                print('Tap Settings Item 01');
                                              }
                                            },
                                            textStyle: kProfileBodyTextStyle,
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
            const SizedBox(height: 10),
          ],
        ),
      );

  ///------------------- LEADERSHIP -------------------///
  buildLeadershipSoftSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Leadership",
              rightWidget: null,
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.leadershipSoftSkills == null
                ? Container()
                : SizedBox(
                    height:
                        readUserJsonFileContent.leadershipSoftSkills!.length *
                            MediaQuery.of(context).size.height *
                            0.25,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          readUserJsonFileContent.leadershipSoftSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const ProfileItemCardMA(
                                            title: "Skill",
                                            rightWidget: null,
                                            callback: null,
                                            textStyle:
                                                kProfileSubHeaderTextStyle,
                                          ),
                                          ProfileItemCardMA(
                                            title: readUserJsonFileContent
                                                .leadershipSoftSkills![index]
                                                .skill,
                                            rightWidget: null,
                                            callback: () {
                                              if (kDebugMode) {
                                                print('Tap Settings Item 01');
                                              }
                                            },
                                            textStyle: kProfileBodyTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const ProfileItemCardMA(
                                            title: "Level",
                                            rightWidget: null,
                                            callback: null,
                                            textStyle:
                                                kProfileSubHeaderTextStyle,
                                          ),
                                          ProfileItemCardMA(
                                            title: readUserJsonFileContent
                                                .leadershipSoftSkills![index]
                                                .level,
                                            rightWidget: null,
                                            callback: () {
                                              if (kDebugMode) {
                                                print('Tap Settings Item 01');
                                              }
                                            },
                                            textStyle: kProfileBodyTextStyle,
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
            const SizedBox(height: 10),
          ],
        ),
      );

  ///------------------- LIFE -------------------///
  buildLifeSoftSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Life",
              rightWidget: null,
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.lifeSoftSkills == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent.lifeSoftSkills!.length *
                        MediaQuery.of(context).size.height *
                        0.25,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent.lifeSoftSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const ProfileItemCardMA(
                                            title: "Skill",
                                            rightWidget: null,
                                            callback: null,
                                            textStyle:
                                                kProfileSubHeaderTextStyle,
                                          ),
                                          ProfileItemCardMA(
                                            title: readUserJsonFileContent
                                                .lifeSoftSkills![index].skill,
                                            rightWidget: null,
                                            callback: () {
                                              if (kDebugMode) {
                                                print('Tap Settings Item 01');
                                              }
                                            },
                                            textStyle: kProfileBodyTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const ProfileItemCardMA(
                                            title: "Level",
                                            rightWidget: null,
                                            callback: null,
                                            textStyle:
                                                kProfileSubHeaderTextStyle,
                                          ),
                                          ProfileItemCardMA(
                                            title: readUserJsonFileContent
                                                .lifeSoftSkills![index].level,
                                            rightWidget: null,
                                            callback: () {
                                              if (kDebugMode) {
                                                print('Tap Settings Item 01');
                                              }
                                            },
                                            textStyle: kProfileBodyTextStyle,
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
            const SizedBox(height: 10),
          ],
        ),
      );

  ///------------------- ORGANIZATIONAL -------------------///
  buildOrganizationSoftSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Organization",
              rightWidget: null,
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.organizationSoftSkills == null
                ? Container()
                : SizedBox(
                    height:
                        readUserJsonFileContent.organizationSoftSkills!.length *
                            MediaQuery.of(context).size.height *
                            0.25,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent
                          .organizationSoftSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const ProfileItemCardMA(
                                            title: "Skill",
                                            rightWidget: null,
                                            callback: null,
                                            textStyle:
                                                kProfileSubHeaderTextStyle,
                                          ),
                                          ProfileItemCardMA(
                                            title: readUserJsonFileContent
                                                .organizationSoftSkills![index]
                                                .skill,
                                            rightWidget: null,
                                            callback: () {
                                              if (kDebugMode) {
                                                print('Tap Settings Item 01');
                                              }
                                            },
                                            textStyle: kProfileBodyTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const ProfileItemCardMA(
                                            title: "Level",
                                            rightWidget: null,
                                            callback: null,
                                            textStyle:
                                                kProfileSubHeaderTextStyle,
                                          ),
                                          ProfileItemCardMA(
                                            title: readUserJsonFileContent
                                                .organizationSoftSkills![index]
                                                .level,
                                            rightWidget: null,
                                            callback: () {
                                              if (kDebugMode) {
                                                print('Tap Settings Item 01');
                                              }
                                            },
                                            textStyle: kProfileBodyTextStyle,
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
            const SizedBox(height: 10),
          ],
        ),
      );

  ///------------------- PROBLEM SOLVING -------------------///
  buildProblemSolvingSoftSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Problem Solving",
              rightWidget: null,
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.problemSolvingSoftSkills == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent
                            .problemSolvingSoftSkills!.length *
                        MediaQuery.of(context).size.height *
                        0.25,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent
                          .problemSolvingSoftSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const ProfileItemCardMA(
                                            title: "Skill",
                                            rightWidget: null,
                                            callback: null,
                                            textStyle:
                                                kProfileSubHeaderTextStyle,
                                          ),
                                          ProfileItemCardMA(
                                            title: readUserJsonFileContent
                                                .problemSolvingSoftSkills![
                                                    index]
                                                .skill,
                                            rightWidget: null,
                                            callback: () {
                                              if (kDebugMode) {
                                                print('Tap Settings Item 01');
                                              }
                                            },
                                            textStyle: kProfileBodyTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const ProfileItemCardMA(
                                            title: "Level",
                                            rightWidget: null,
                                            callback: null,
                                            textStyle:
                                                kProfileSubHeaderTextStyle,
                                          ),
                                          ProfileItemCardMA(
                                            title: readUserJsonFileContent
                                                .problemSolvingSoftSkills![
                                                    index]
                                                .level,
                                            rightWidget: null,
                                            callback: () {
                                              if (kDebugMode) {
                                                print('Tap Settings Item 01');
                                              }
                                            },
                                            textStyle: kProfileBodyTextStyle,
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
            const SizedBox(height: 10),
          ],
        ),
      );

  ///------------------- SOCIAL / INTERPERSONAL -------------------///
  buildSocialSoftSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Social",
              rightWidget: null,
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.socialOrInterpersonalSoftSkills == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent
                            .socialOrInterpersonalSoftSkills!.length *
                        MediaQuery.of(context).size.height *
                        0.25,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent
                          .socialOrInterpersonalSoftSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const ProfileItemCardMA(
                                            title: "Skill",
                                            rightWidget: null,
                                            callback: null,
                                            textStyle:
                                                kProfileSubHeaderTextStyle,
                                          ),
                                          ProfileItemCardMA(
                                            title: readUserJsonFileContent
                                                .socialOrInterpersonalSoftSkills![
                                                    index]
                                                .skill,
                                            rightWidget: null,
                                            callback: () {
                                              if (kDebugMode) {
                                                print('Tap Settings Item 01');
                                              }
                                            },
                                            textStyle: kProfileBodyTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const ProfileItemCardMA(
                                            title: "Level",
                                            rightWidget: null,
                                            callback: null,
                                            textStyle:
                                                kProfileSubHeaderTextStyle,
                                          ),
                                          ProfileItemCardMA(
                                            title: readUserJsonFileContent
                                                .socialOrInterpersonalSoftSkills![
                                                    index]
                                                .level,
                                            rightWidget: null,
                                            callback: () {
                                              if (kDebugMode) {
                                                print('Tap Settings Item 01');
                                              }
                                            },
                                            textStyle: kProfileBodyTextStyle,
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
            const SizedBox(height: 10),
          ],
        ),
      );

  ///------------------- TEAMWORK -------------------///
  buildTeamworkSoftSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Team Work",
              rightWidget: null,
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.teamworkSoftSkills == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent.teamworkSoftSkills!.length *
                        MediaQuery.of(context).size.height *
                        0.25,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          readUserJsonFileContent.teamworkSoftSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const ProfileItemCardMA(
                                            title: "Skill",
                                            rightWidget: null,
                                            callback: null,
                                            textStyle:
                                                kProfileSubHeaderTextStyle,
                                          ),
                                          ProfileItemCardMA(
                                            title: readUserJsonFileContent
                                                .teamworkSoftSkills![index]
                                                .skill,
                                            rightWidget: null,
                                            callback: () {
                                              if (kDebugMode) {
                                                print('Tap Settings Item 01');
                                              }
                                            },
                                            textStyle: kProfileBodyTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const ProfileItemCardMA(
                                            title: "Level",
                                            rightWidget: null,
                                            callback: null,
                                            textStyle:
                                                kProfileSubHeaderTextStyle,
                                          ),
                                          ProfileItemCardMA(
                                            title: readUserJsonFileContent
                                                .teamworkSoftSkills![index]
                                                .level,
                                            rightWidget: null,
                                            callback: () {
                                              if (kDebugMode) {
                                                print('Tap Settings Item 01');
                                              }
                                            },
                                            textStyle: kProfileBodyTextStyle,
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
            const SizedBox(height: 10),
          ],
        ),
      );

  ///------------------- TIME MANAGEMENT -------------------///
  buildTimeManagementSoftSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Time Management",
              rightWidget: null,
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.timeManagementSoftSkills == null
                ? Container()
                : SizedBox(
                    height: readUserJsonFileContent
                            .timeManagementSoftSkills!.length *
                        MediaQuery.of(context).size.height *
                        0.25,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: readUserJsonFileContent
                          .timeManagementSoftSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const ProfileItemCardMA(
                                            title: "Skill",
                                            rightWidget: null,
                                            callback: null,
                                            textStyle:
                                                kProfileSubHeaderTextStyle,
                                          ),
                                          ProfileItemCardMA(
                                            title: readUserJsonFileContent
                                                .timeManagementSoftSkills![
                                                    index]
                                                .skill,
                                            rightWidget: null,
                                            callback: () {
                                              if (kDebugMode) {
                                                print('Tap Settings Item 01');
                                              }
                                            },
                                            textStyle: kProfileBodyTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const ProfileItemCardMA(
                                            title: "Level",
                                            rightWidget: null,
                                            callback: null,
                                            textStyle:
                                                kProfileSubHeaderTextStyle,
                                          ),
                                          ProfileItemCardMA(
                                            title: readUserJsonFileContent
                                                .timeManagementSoftSkills![
                                                    index]
                                                .level,
                                            rightWidget: null,
                                            callback: () {
                                              if (kDebugMode) {
                                                print('Tap Settings Item 01');
                                              }
                                            },
                                            textStyle: kProfileBodyTextStyle,
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
            const SizedBox(height: 10),
          ],
        ),
      );

  ///------------------- WORK ETHICS -------------------///
  buildWorkEthicSoftSkills() => Container(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProfileItemCardMA(
              title: "Work Ethic",
              rightWidget: null,
              callback: () {
                if (kDebugMode) {
                  print('Tap About');
                }
              },
              textStyle: kProfileMidSubHeaderTextStyle,
            ),
            readUserJsonFileContent.workEthicSoftSkills == null
                ? Container()
                : SizedBox(
                    height:
                        readUserJsonFileContent.workEthicSoftSkills!.length *
                            MediaQuery.of(context).size.height *
                            0.25,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          readUserJsonFileContent.workEthicSoftSkills!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 0.0,
                          child: Column(
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ProfileItemCardMA(
                                title: "Skill ${index + 1}",
                                rightWidget: null,
                                callback: null,
                                textStyle: kProfileSubHeaderTextStyle,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          const ProfileItemCardMA(
                                            title: "Skill",
                                            rightWidget: null,
                                            callback: null,
                                            textStyle:
                                                kProfileSubHeaderTextStyle,
                                          ),
                                          ProfileItemCardMA(
                                            title: readUserJsonFileContent
                                                .workEthicSoftSkills![index]
                                                .skill,
                                            rightWidget: null,
                                            callback: () {
                                              if (kDebugMode) {
                                                print('Tap Settings Item 01');
                                              }
                                            },
                                            textStyle: kProfileBodyTextStyle,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 24,
                                        top: 6,
                                        bottom: 6,
                                      ),
                                      color: DynamicTheme.of(context)
                                                  ?.brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.black12,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const ProfileItemCardMA(
                                            title: "Level",
                                            rightWidget: null,
                                            callback: null,
                                            textStyle:
                                                kProfileSubHeaderTextStyle,
                                          ),
                                          ProfileItemCardMA(
                                            title: readUserJsonFileContent
                                                .workEthicSoftSkills![index]
                                                .level,
                                            rightWidget: null,
                                            callback: () {
                                              if (kDebugMode) {
                                                print('Tap Settings Item 01');
                                              }
                                            },
                                            textStyle: kProfileBodyTextStyle,
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
            const SizedBox(height: 10),
          ],
        ),
      );
}

kOpenPageBottom(BuildContext context, Widget page) {
  Navigator.of(context).push(
    CupertinoPageRoute<bool>(
      fullscreenDialog: true,
      builder: (BuildContext context) => page,
    ),
  );
}

kOpenPage(BuildContext context, Widget page) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => page,
    ),
  );
}
