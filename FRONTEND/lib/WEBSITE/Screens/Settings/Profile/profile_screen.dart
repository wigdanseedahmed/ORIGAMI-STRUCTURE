import 'package:flutter/cupertino.dart';
import 'package:origami_structure/imports.dart';

import 'package:http/http.dart' as http;
import 'dart:io' as Io;

class ProfileScreenWS extends StatefulWidget {
  static const String id = 'profile_screen';

  const ProfileScreenWS({
    Key? key,
    required this.readUserContent,
    required this.selectedProfileSideMenuItemInt,
  }) : super(key: key);

  final UserModel readUserContent;
  final int selectedProfileSideMenuItemInt;

  @override
  _ProfileScreenWSState createState() => _ProfileScreenWSState();
}

class _ProfileScreenWSState extends State<ProfileScreenWS>
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
    Size screenSize = MediaQuery
        .of(context)
        .size;
    _opacity = _scrollPosition < MediaQuery
        .of(context)
        .size
        .height * 0.40
        ? _scrollPosition / (MediaQuery
        .of(context)
        .size
        .height * 0.40)
        : 1;

    return buildBody();
  }

  buildBody() {
    return Column(
      children: [
        widget.readUserContent.userPhotoFile == null
            ? ClipOval(
          child: Material(
            color: Colors.grey,
            child: SizedBox(
              width: 200,
              height: 200,
              child: Center(
                child: Text(
                  "${widget.readUserContent.firstName![0]}${widget
                      .readUserContent.lastName![0]}",
                  style: TextStyle(
                    fontSize: MediaQuery
                        .of(context)
                        .size
                        .width * 0.1,
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
              image: MemoryImage(
                  base64Decode(widget.readUserContent.userPhotoFile!)),
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
        widget.selectedProfileSideMenuItemInt == 0
            ? buildPersonalInformation()
            : widget.selectedProfileSideMenuItemInt == 1
            ? buildGeneral()
            : widget.selectedProfileSideMenuItemInt == 2
            ? buildLanguages()
            : widget.selectedProfileSideMenuItemInt == 3
            ? buildEducation()
            : widget.selectedProfileSideMenuItemInt == 4
            ? buildExperience()
            : widget.selectedProfileSideMenuItemInt == 5
            ? buildQualifications()
            : widget.selectedProfileSideMenuItemInt == 6
            ? buildSoftSkills()
            : buildHardSKills(),
      ],
    );
  }

  buildExpandedBody() {
    return Column(
      children: [
        widget.readUserContent.userPhotoFile == null
            ? ClipOval(
          child: Material(
            color: Colors.grey,
            child: SizedBox(
              width: 200,
              height: 200,
              child: Center(
                child: Text(
                  "${widget.readUserContent.firstName![0]}${widget
                      .readUserContent.lastName![0]}",
                  style: TextStyle(
                    fontSize: MediaQuery
                        .of(context)
                        .size
                        .width * 0.1,
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
              image: MemoryImage(
                  base64Decode(widget.readUserContent.userPhotoFile!)),
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
    );
  }

  buildName() =>
      Column(
        children: [
          Text(
            "${widget.readUserContent.firstName} ${widget.readUserContent
                .lastName}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            widget.readUserContent.jobTitle!,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 4),
        ],
      );

  /// PERSONAL INFORMATION ///
  bool _expandedPersonalInformation = false;

  buildPersonalInformation() =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.readUserContent.firstName == null
              ? Container()
              : const ProfileItemCardMA(
            title: "First name",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          widget.readUserContent.firstName == null
              ? Container()
              : ProfileItemCardMA(
            title: widget.readUserContent.firstName,
            rightWidget: null,
            callback: () {
              if (kDebugMode) {
                print('Tap Settings Item 01');
              }
            },
            textStyle: kProfileBodyTextStyle,
          ),
          widget.readUserContent.lastName == null
              ? Container()
              : const ProfileItemCardMA(
            title: "Last name",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          widget.readUserContent.lastName == null
              ? Container()
              : ProfileItemCardMA(
            title: widget.readUserContent.lastName,
            rightWidget: null,
            callback: () {
              if (kDebugMode) {
                print('Tap Settings Item 01');
              }
            },
            textStyle: kProfileBodyTextStyle,
          ),
          widget.readUserContent.username == null
              ? Container()
              : const ProfileItemCardMA(
            title: "Username",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          widget.readUserContent.username == null
              ? Container()
              : ProfileItemCardMA(
            title: widget.readUserContent.username,
            rightWidget: null,
            callback: () {
              if (kDebugMode) {
                print('Tap Settings Item 01');
              }
            },
            textStyle: kProfileBodyTextStyle,
          ),
          widget.readUserContent.nationality == null
              ? Container()
              : const ProfileItemCardMA(
            title: "Nationality",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          widget.readUserContent.nationality == null
              ? Container()
              : ProfileItemCardMA(
            title: widget.readUserContent.nationality,
            rightWidget: null,
            callback: () {
              if (kDebugMode) {
                print('Tap Settings Item 01');
              }
            },
            textStyle: kProfileBodyTextStyle,
          ),
          widget.readUserContent.dateOfBirth == null
              ? Container()
              : const ProfileItemCardMA(
            title: "Date of birth",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          widget.readUserContent.dateOfBirth == null
              ? Container()
              : ProfileItemCardMA(
            title: DateFormat("EEE, MMM d, yyyy").format(
                DateTime.parse(widget.readUserContent.dateOfBirth!)),
            rightWidget: null,
            callback: () {
              if (kDebugMode) {
                print('Tap Date of birth');
              }
            },
            textStyle: kProfileBodyTextStyle,
          ),
          widget.readUserContent.gender == null
              ? Container()
              : const ProfileItemCardMA(
            title: "Gender",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          widget.readUserContent.gender == null
              ? Container()
              : ProfileItemCardMA(
            title: widget.readUserContent.gender,
            rightWidget: null,
            callback: () {
              if (kDebugMode) {
                print('Tap gender');
              }
            },
            textStyle: kProfileBodyTextStyle,
          ),
          widget.readUserContent.personalEmail == null
              ? Container()
              : const ProfileItemCardMA(
            title: "Personal email",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          widget.readUserContent.personalEmail == null
              ? Container()
              : ProfileItemCardMA(
            title: widget.readUserContent.personalEmail,
            rightWidget: null,
            callback: () {
              if (kDebugMode) {
                print('Tap Email');
              }
            },
            textStyle: kProfileBodyTextStyle,
          ),
          widget.readUserContent.phoneNumber == null
              ? Container()
              : const ProfileItemCardMA(
            title: "Phone number",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          widget.readUserContent.phoneNumber == null
              ? Container()
              : ProfileItemCardMA(
            title: widget.readUserContent.phoneNumber,
            rightWidget: null,
            callback: () {
              if (kDebugMode) {
                print('Tap Settings Item 01');
              }
            },
            textStyle: kProfileBodyTextStyle,
          ),
          widget.readUserContent.optionalPhoneNumber == null
              ? Container()
              : const ProfileItemCardMA(
            title: "Optional Phone number",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          widget.readUserContent.optionalPhoneNumber == null
              ? Container()
              : ProfileItemCardMA(
            title: widget.readUserContent.optionalPhoneNumber,
            rightWidget: null,
            callback: () {
              if (kDebugMode) {
                print('Tap Settings Item 01');
              }
            },
            textStyle: kProfileBodyTextStyle,
          ),
          widget.readUserContent.userID == null
              ? Container()
              : const ProfileItemCardMA(
            title: "User Model ID",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          widget.readUserContent.userID == null
              ? Container()
              : ProfileItemCardMA(
            title: widget.readUserContent.userID!,
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

  /// GENERAL ///
  bool _expandedGeneral = false;

  buildGeneral() =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.readUserContent.countryOfEmployment == null
              ? Container()
              : const ProfileItemCardMA(
            title: "Country of employment",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          widget.readUserContent.countryOfEmployment == null
              ? Container()
              : ProfileItemCardMA(
            title: widget.readUserContent.countryOfEmployment,
            rightWidget: null,
            callback: () {
              if (kDebugMode) {
                print('Tap Settings Item 01');
              }
            },
            textStyle: kProfileBodyTextStyle,
          ),
          widget.readUserContent.workEmail == null
              ? Container()
              : const ProfileItemCardMA(
            title: "Work email",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          widget.readUserContent.workEmail == null
              ? Container()
              : ProfileItemCardMA(
            title: widget.readUserContent.workEmail,
            rightWidget: null,
            callback: () {
              if (kDebugMode) {
                print('Tap Date of birth');
              }
            },
            textStyle: kProfileBodyTextStyle,
          ),
          widget.readUserContent.jobDepartment == null
              ? Container()
              : const ProfileItemCardMA(
            title: "Job Department",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          widget.readUserContent.jobDepartment == null
              ? Container()
              : ProfileItemCardMA(
            title: widget.readUserContent.jobDepartment,
            rightWidget: null,
            callback: () {
              if (kDebugMode) {
                print('Tap Date of birth');
              }
            },
            textStyle: kProfileBodyTextStyle,
          ),
          widget.readUserContent.jobTeam == null
              ? Container()
              : const ProfileItemCardMA(
            title: "Department Team",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          widget.readUserContent.jobTeam == null
              ? Container()
              : ProfileItemCardMA(
            title: widget.readUserContent.jobTeam,
            rightWidget: null,
            callback: () {
              if (kDebugMode) {
                print('Tap Date of birth');
              }
            },
            textStyle: kProfileBodyTextStyle,
          ),
          widget.readUserContent.jobField == null
              ? Container()
              : const ProfileItemCardMA(
            title: "Job Field",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          widget.readUserContent.jobField == null
              ? Container()
              : ProfileItemCardMA(
            title: widget.readUserContent.jobField,
            rightWidget: null,
            callback: () {
              if (kDebugMode) {
                print('Tap Date of birth');
              }
            },
            textStyle: kProfileBodyTextStyle,
          ),
          widget.readUserContent.jobSubField == null
              ? Container()
              : const ProfileItemCardMA(
            title: "Job Sub-Field",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          widget.readUserContent.jobSubField == null
              ? Container()
              : ProfileItemCardMA(
            title: widget.readUserContent.jobSubField,
            rightWidget: null,
            callback: () {
              if (kDebugMode) {
                print('Tap Date of jobSubField');
              }
            },
            textStyle: kProfileBodyTextStyle,
          ),
          widget.readUserContent.jobSpecialization == null
              ? Container()
              : const ProfileItemCardMA(
            title: "Job Specialization",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          widget.readUserContent.jobSpecialization == null
              ? Container()
              : ProfileItemCardMA(
            title: widget.readUserContent.jobSpecialization,
            rightWidget: null,
            callback: () {
              if (kDebugMode) {
                print('Tap Date of jobSpecialization');
              }
            },
            textStyle: kProfileBodyTextStyle,
          ),
          widget.readUserContent.jobContractType == null
              ? Container()
              : const ProfileItemCardMA(
            title: "Contract Type",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          widget.readUserContent.jobContractType == null
              ? Container()
              : ProfileItemCardMA(
            title: widget.readUserContent.jobContractType,
            rightWidget: null,
            callback: () {
              if (kDebugMode) {
                print('Tap Date of birth');
              }
            },
            textStyle: kProfileBodyTextStyle,
          ),
          widget.readUserContent.jobContractExpirationDate == null
              ? Container()
              : const ProfileItemCardMA(
            title: "Contract Expiration Date",
            rightWidget: null,
            callback: null,
            textStyle: kProfileSubHeaderTextStyle,
          ),
          widget.readUserContent.jobContractExpirationDate == null
              ? Container()
              : ProfileItemCardMA(
            title: DateFormat("EEE, MMM d, yyyy").format(DateTime.parse(
                widget.readUserContent.jobContractExpirationDate!)),
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

  /// LANGUAGES ///
  bool _expandedLanguages = false;

  buildLanguages() =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.readUserContent.languages == null
              ? Container()
              : ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.readUserContent.languages!.length,
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
                    color: DynamicTheme
                        .of(context)
                        ?.brightness ==
                        Brightness.light
                        ? Colors.white
                        : Colors.black12,
                    child: Row(
                      children: [
                        Text(
                          widget.readUserContent.languages![index]
                              .language!,
                          style: kProfileBodyTextStyle,
                        ),
                        const SizedBox(width: 100),
                        widget.readUserContent.languages![index].level ==
                            null
                            ? Container()
                            : Text(
                          widget.readUserContent.languages![index]
                              .level!,
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

  /// EDUCATION ///
  bool _expandedEducation = false;

  buildEducation() =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildBachelors(),
          buildMasters(),
          buildPHD(),
          buildDoctoral(),
        ],
      );

  buildBachelors() =>
      Container(
        color: DynamicTheme
            .of(context)
            ?.brightness == Brightness.light
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
            widget.readUserContent.bachelors == null
                ? Container()
                : SizedBox(
              height: widget.readUserContent.bachelors!.length *
                  MediaQuery
                      .of(context)
                      .size
                      .height *
                  0.815,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.readUserContent.bachelors!.length,
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
                          title: widget.readUserContent.bachelors![index]
                              .discipline,
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
                          title: widget.readUserContent.bachelors![index]
                              .institutionName,
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
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height /
                                    25,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_outlined,
                                    ),
                                    SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            50),
                                    Text(
                                      "START DATE",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        //letterSpacing: 8,
                                        fontFamily: 'Electrolize',
                                        fontSize: MediaQuery
                                            .of(context)
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
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width *
                                      0.15),
                              SizedBox(
                                height:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height /
                                    25,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_outlined,
                                    ),
                                    SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            50),
                                    Text(
                                      "END DATE",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        //letterSpacing: 8,
                                        fontFamily: 'Electrolize',
                                        fontSize: MediaQuery
                                            .of(context)
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
                              left: MediaQuery
                                  .of(context)
                                  .size
                                  .width *
                                  0.05,
                              right: MediaQuery
                                  .of(context)
                                  .size
                                  .width *
                                  0.065),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              ProfileItemCardMA(
                                title:
                                "${DateFormat('yyyy-MM-dd').parse(
                                    widget.readUserContent.bachelors![index]
                                        .startDate!)}",
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              ProfileItemCardMA(
                                title:
                                "${DateFormat('yyyy-MM-dd').parse(
                                    widget.readUserContent.bachelors![index]
                                        .endDate!)}",
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
                            MediaQuery
                                .of(context)
                                .size
                                .width * 0.25,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height *
                                0.065,
                            child: ProfileItemCardMA(
                              title:
                              "${widget.readUserContent.bachelors![index]
                                  .duration!}",
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
                          title: widget.readUserContent.bachelors![index]
                              .description,
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
                        widget.readUserContent.bachelors![index]
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
                          color: DynamicTheme
                              .of(context)
                              ?.brightness ==
                              Brightness.light
                              ? Colors.white
                              : Colors.black12,
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width *
                                    0.125,
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height *
                                    0.065,
                                child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    child: Image.network(
                                      widget
                                          .readUserContent
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
                                      widget
                                          .readUserContent
                                          .bachelors![index]
                                          .educationReferenceFileName!,
                                      style:
                                      kProfileSubHeaderTextStyle,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${(widget.readUserContent
                                          .bachelors![index]
                                          .educationReferenceSize! / 1024)
                                          .ceil()} KB',
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

  buildMasters() =>
      Container(
        color: DynamicTheme
            .of(context)
            ?.brightness == Brightness.light
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
            widget.readUserContent.masters == null
                ? Container()
                : SizedBox(
              height: widget.readUserContent.masters!.length *
                  MediaQuery
                      .of(context)
                      .size
                      .height *
                  0.815,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.readUserContent.masters!.length,
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
                          title: widget
                              .readUserContent.masters![index].discipline,
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
                          title: widget.readUserContent.masters![index]
                              .institutionName,
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
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height /
                                    25,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_outlined,
                                    ),
                                    SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            50),
                                    Text(
                                      "START DATE",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        //letterSpacing: 8,
                                        fontFamily: 'Electrolize',
                                        fontSize: MediaQuery
                                            .of(context)
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
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width *
                                      0.15),
                              SizedBox(
                                height:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height /
                                    25,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_outlined,
                                    ),
                                    SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            50),
                                    Text(
                                      "END DATE",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        //letterSpacing: 8,
                                        fontFamily: 'Electrolize',
                                        fontSize: MediaQuery
                                            .of(context)
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
                              left: MediaQuery
                                  .of(context)
                                  .size
                                  .width *
                                  0.05,
                              right: MediaQuery
                                  .of(context)
                                  .size
                                  .width *
                                  0.065),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              ProfileItemCardMA(
                                title:
                                "${DateFormat('yyyy-MM-dd').parse(
                                    widget.readUserContent.masters![index]
                                        .startDate!)}",
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              ProfileItemCardMA(
                                title:
                                "${DateFormat('yyyy-MM-dd').parse(
                                    widget.readUserContent.masters![index]
                                        .endDate!)}",
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
                            MediaQuery
                                .of(context)
                                .size
                                .width * 0.25,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height *
                                0.065,
                            child: ProfileItemCardMA(
                              title:
                              "${widget.readUserContent.masters![index]
                                  .duration!}",
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
                          title: widget.readUserContent.masters![index]
                              .description,
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
                        widget.readUserContent.masters![index]
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
                          color: DynamicTheme
                              .of(context)
                              ?.brightness ==
                              Brightness.light
                              ? Colors.white
                              : Colors.black12,
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width *
                                    0.125,
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height *
                                    0.065,
                                child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    child: Image.network(
                                      widget
                                          .readUserContent
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
                                      widget
                                          .readUserContent
                                          .masters![index]
                                          .educationReferenceFileName!,
                                      style:
                                      kProfileSubHeaderTextStyle,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${(widget.readUserContent.masters![index]
                                          .educationReferenceSize! / 1024)
                                          .ceil()} KB',
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

  buildPHD() =>
      Container(
        color: DynamicTheme
            .of(context)
            ?.brightness == Brightness.light
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
            widget.readUserContent.phd == null
                ? Container()
                : SizedBox(
              height: widget.readUserContent.phd!.length *
                  MediaQuery
                      .of(context)
                      .size
                      .height *
                  0.815,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.readUserContent.phd!.length,
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
                          title: widget
                              .readUserContent.phd![index].discipline,
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
                          title: widget.readUserContent.phd![index]
                              .institutionName,
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
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height /
                                    25,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_outlined,
                                    ),
                                    SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            50),
                                    Text(
                                      "START DATE",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        //letterSpacing: 8,
                                        fontFamily: 'Electrolize',
                                        fontSize: MediaQuery
                                            .of(context)
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
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width *
                                      0.15),
                              SizedBox(
                                height:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height /
                                    25,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_outlined,
                                    ),
                                    SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            50),
                                    Text(
                                      "END DATE",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        //letterSpacing: 8,
                                        fontFamily: 'Electrolize',
                                        fontSize: MediaQuery
                                            .of(context)
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
                              left: MediaQuery
                                  .of(context)
                                  .size
                                  .width *
                                  0.05,
                              right: MediaQuery
                                  .of(context)
                                  .size
                                  .width *
                                  0.065),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              ProfileItemCardMA(
                                title:
                                "${DateFormat('yyyy-MM-dd').parse(
                                    widget.readUserContent.phd![index]
                                        .startDate!)}",
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              ProfileItemCardMA(
                                title:
                                "${DateFormat('yyyy-MM-dd').parse(
                                    widget.readUserContent.phd![index]
                                        .endDate!)}",
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
                            MediaQuery
                                .of(context)
                                .size
                                .width * 0.25,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height *
                                0.065,
                            child: ProfileItemCardMA(
                              title:
                              "${widget.readUserContent.phd![index].duration!}",
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
                          title: widget
                              .readUserContent.phd![index].description,
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
                        widget.readUserContent.phd![index]
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
                          color: DynamicTheme
                              .of(context)
                              ?.brightness ==
                              Brightness.light
                              ? Colors.white
                              : Colors.black12,
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width *
                                    0.125,
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height *
                                    0.065,
                                child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    child: Image.network(
                                      widget
                                          .readUserContent
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
                                      widget
                                          .readUserContent
                                          .phd![index]
                                          .educationReferenceFileName!,
                                      style:
                                      kProfileSubHeaderTextStyle,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${(widget.readUserContent.phd![index]
                                          .educationReferenceSize! / 1024)
                                          .ceil()} KB',
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

  buildDoctoral() =>
      Container(
        color: DynamicTheme
            .of(context)
            ?.brightness == Brightness.light
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
            widget.readUserContent.doctoral == null
                ? Container()
                : SizedBox(
              height: widget.readUserContent.doctoral!.length *
                  MediaQuery
                      .of(context)
                      .size
                      .height *
                  0.815,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.readUserContent.doctoral!.length,
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
                          title: widget.readUserContent.doctoral![index]
                              .discipline,
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
                          title: widget.readUserContent.doctoral![index]
                              .institutionName,
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
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height /
                                    25,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_outlined,
                                    ),
                                    SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            50),
                                    Text(
                                      "START DATE",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        //letterSpacing: 8,
                                        fontFamily: 'Electrolize',
                                        fontSize: MediaQuery
                                            .of(context)
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
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width *
                                      0.15),
                              SizedBox(
                                height:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height /
                                    25,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_outlined,
                                    ),
                                    SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            50),
                                    Text(
                                      "END DATE",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        //letterSpacing: 8,
                                        fontFamily: 'Electrolize',
                                        fontSize: MediaQuery
                                            .of(context)
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
                              left: MediaQuery
                                  .of(context)
                                  .size
                                  .width *
                                  0.05,
                              right: MediaQuery
                                  .of(context)
                                  .size
                                  .width *
                                  0.065),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              ProfileItemCardMA(
                                title:
                                "${DateFormat('yyyy-MM-dd').parse(
                                    widget.readUserContent.doctoral![index]
                                        .startDate!)}",
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              ProfileItemCardMA(
                                title:
                                "${DateFormat('yyyy-MM-dd').parse(
                                    widget.readUserContent.doctoral![index]
                                        .endDate!)}",
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
                            MediaQuery
                                .of(context)
                                .size
                                .width * 0.25,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height *
                                0.065,
                            child: ProfileItemCardMA(
                              title:
                              "${widget.readUserContent.doctoral![index]
                                  .duration!}",
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
                          title: widget.readUserContent.doctoral![index]
                              .description,
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
                        widget.readUserContent.doctoral![index]
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
                          color: DynamicTheme
                              .of(context)
                              ?.brightness ==
                              Brightness.light
                              ? Colors.white
                              : Colors.black12,
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width *
                                    0.125,
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height *
                                    0.065,
                                child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    child: Image.network(
                                      widget
                                          .readUserContent
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
                                      widget
                                          .readUserContent
                                          .doctoral![index]
                                          .educationReferenceFileName!,
                                      style:
                                      kProfileSubHeaderTextStyle,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${(widget.readUserContent
                                          .doctoral![index]
                                          .educationReferenceSize! / 1024)
                                          .ceil()} KB',
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

  /// EXPERIENCE ///
  bool _expandedExperience = false;

  buildExperience() =>
      Column(
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
          widget.readUserContent.cvFile == null
              ? Container()
              : Container(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              top: 6,
              bottom: 6,
            ),
            color:
            DynamicTheme
                .of(context)
                ?.brightness == Brightness.light
                ? Colors.white
                : Colors.black12,
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.125,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.065,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.readUserContent.cvName!
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
                        widget.readUserContent.cvName!,
                        style: kProfileSubHeaderTextStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${(widget.readUserContent.cvSize! / 1024).ceil()} KB',
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

  buildWorkExperience() =>
      Container(
        color: DynamicTheme
            .of(context)
            ?.brightness == Brightness.light
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
            widget.readUserContent.workExperience == null
                ? Container()
                : SizedBox(
              height: widget.readUserContent.workExperience!.length *
                  MediaQuery
                      .of(context)
                      .size
                      .height *
                  0.815,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.readUserContent.workExperience!.length,
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
                          title: widget.readUserContent
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
                          title: widget.readUserContent
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
                          title: widget.readUserContent
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
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height /
                                    25,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_outlined,
                                    ),
                                    SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            50),
                                    Text(
                                      "START DATE",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        //letterSpacing: 8,
                                        fontFamily: 'Electrolize',
                                        fontSize: MediaQuery
                                            .of(context)
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
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width *
                                      0.15),
                              SizedBox(
                                height:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height /
                                    25,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_outlined,
                                    ),
                                    SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            50),
                                    Text(
                                      "END DATE",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        //letterSpacing: 8,
                                        fontFamily: 'Electrolize',
                                        fontSize: MediaQuery
                                            .of(context)
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
                              left: MediaQuery
                                  .of(context)
                                  .size
                                  .width *
                                  0.05,
                              right: MediaQuery
                                  .of(context)
                                  .size
                                  .width *
                                  0.065),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              ProfileItemCardMA(
                                title:
                                "${DateFormat('yyyy-MM-dd').parse(
                                    widget.readUserContent
                                        .workExperience![index].startDate!)}",
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              ProfileItemCardMA(
                                title:
                                "${DateFormat('yyyy-MM-dd').parse(
                                    widget.readUserContent
                                        .workExperience![index].endDate!)}",
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
                            MediaQuery
                                .of(context)
                                .size
                                .width * 0.25,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height *
                                0.065,
                            child: ProfileItemCardMA(
                              title:
                              "${widget.readUserContent.workExperience![index]
                                  .duration!}",
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
                          title: widget.readUserContent
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
                          title: widget
                              .readUserContent
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
                          title: widget
                              .readUserContent
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
                        widget.readUserContent.workExperience![index]
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
                          color: DynamicTheme
                              .of(context)
                              ?.brightness ==
                              Brightness.light
                              ? Colors.white
                              : Colors.black12,
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width *
                                    0.125,
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height *
                                    0.065,
                                child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    child: Image.network(
                                      widget
                                          .readUserContent
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
                                      widget
                                          .readUserContent
                                          .workExperience![index]
                                          .referenceName!,
                                      style:
                                      kProfileSubHeaderTextStyle,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${(widget.readUserContent
                                          .workExperience![index]
                                          .referenceSize! / 1024).ceil()} KB',
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

  buildVolunteerExperience() =>
      Container(
        color: DynamicTheme
            .of(context)
            ?.brightness == Brightness.light
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
            widget.readUserContent.volunteerExperience == null
                ? Container()
                : SizedBox(
              height: widget.readUserContent.volunteerExperience!.length *
                  MediaQuery
                      .of(context)
                      .size
                      .height *
                  0.815,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                widget.readUserContent.volunteerExperience!.length,
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
                          title: widget.readUserContent
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
                          title: widget.readUserContent
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
                          title: widget.readUserContent
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
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height /
                                    25,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_outlined,
                                    ),
                                    SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            50),
                                    Text(
                                      "START DATE",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        //letterSpacing: 8,
                                        fontFamily: 'Electrolize',
                                        fontSize: MediaQuery
                                            .of(context)
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
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width *
                                      0.15),
                              SizedBox(
                                height:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height /
                                    25,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_outlined,
                                    ),
                                    SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            50),
                                    Text(
                                      "END DATE",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        //letterSpacing: 8,
                                        fontFamily: 'Electrolize',
                                        fontSize: MediaQuery
                                            .of(context)
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
                              left: MediaQuery
                                  .of(context)
                                  .size
                                  .width *
                                  0.05,
                              right: MediaQuery
                                  .of(context)
                                  .size
                                  .width *
                                  0.065),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              ProfileItemCardMA(
                                title:
                                "${DateFormat('yyyy-MM-dd').parse(
                                    widget.readUserContent
                                        .volunteerExperience![index]
                                        .startDate!)}",
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              ProfileItemCardMA(
                                title:
                                "${DateFormat('yyyy-MM-dd').parse(
                                    widget.readUserContent
                                        .volunteerExperience![index]
                                        .endDate!)}",
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
                            MediaQuery
                                .of(context)
                                .size
                                .width * 0.25,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height *
                                0.065,
                            child: ProfileItemCardMA(
                              title:
                              "${widget.readUserContent
                                  .volunteerExperience![index].duration!}",
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
                          title: widget.readUserContent
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
                          title: widget
                              .readUserContent
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
                          title: widget
                              .readUserContent
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
                        widget.readUserContent.volunteerExperience![index]
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
                          color: DynamicTheme
                              .of(context)
                              ?.brightness ==
                              Brightness.light
                              ? Colors.white
                              : Colors.black12,
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width *
                                    0.125,
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height *
                                    0.065,
                                child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    child: Image.network(
                                      widget
                                          .readUserContent
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
                                      widget
                                          .readUserContent
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
                                      '${(widget.readUserContent
                                          .volunteerExperience![index]
                                          .referenceSize! / 1024).ceil()} KB',
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

  /// QUALIFICATIONS ///
  bool _expandedQualifications = false;

  buildQualifications() =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildProfessionalQualifications(),
          buildEducationalQualifications(),
          buildOtherQualifications(),
        ],
      );

  /// QUALIFICATIONS ~ PROFESSIONAL QUALIFICATIONS
  buildProfessionalQualifications() =>
      Container(
        color: DynamicTheme
            .of(context)
            ?.brightness == Brightness.light
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
            widget.readUserContent.professionalQualifications == null
                ? Container()
                : SizedBox(
              height: widget.readUserContent.professionalQualifications!
                  .length *
                  MediaQuery
                      .of(context)
                      .size
                      .height *
                  1,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget
                    .readUserContent.professionalQualifications!.length,
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
                          title: widget
                              .readUserContent
                              .professionalQualifications![index]
                              .title ==
                              null
                              ? ""
                              : widget
                              .readUserContent
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
                          title: widget
                              .readUserContent
                              .professionalQualifications![index]
                              .obtainedFrom ==
                              null
                              ? ""
                              : widget
                              .readUserContent
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
                          title: widget
                              .readUserContent
                              .professionalQualifications![index]
                              .description ==
                              null
                              ? ""
                              : widget
                              .readUserContent
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
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height /
                                    25,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_outlined,
                                    ),
                                    SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            50),
                                    Text(
                                      "START DATE",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        //letterSpacing: 8,
                                        fontFamily: 'Electrolize',
                                        fontSize: MediaQuery
                                            .of(context)
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
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width *
                                      0.15),
                              SizedBox(
                                height:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height /
                                    25,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_outlined,
                                    ),
                                    SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            50),
                                    Text(
                                      "END DATE",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        //letterSpacing: 8,
                                        fontFamily: 'Electrolize',
                                        fontSize: MediaQuery
                                            .of(context)
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
                              left: MediaQuery
                                  .of(context)
                                  .size
                                  .width *
                                  0.05,
                              right: MediaQuery
                                  .of(context)
                                  .size
                                  .width *
                                  0.065),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              ProfileItemCardMA(
                                title:
                                "${DateFormat('yyyy-MM-dd').parse(
                                    widget.readUserContent
                                        .professionalQualifications![index]
                                        .startDate!)}",
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              ProfileItemCardMA(
                                title:
                                "${DateFormat('yyyy-MM-dd').parse(
                                    widget.readUserContent
                                        .professionalQualifications![index]
                                        .endDate!)}",
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
                            MediaQuery
                                .of(context)
                                .size
                                .width * 0.25,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height *
                                0.065,
                            child: ProfileItemCardMA(
                              title:
                              "${widget.readUserContent
                                  .professionalQualifications![index]
                                  .duration}",
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
                        widget
                            .readUserContent
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
                          color: DynamicTheme
                              .of(context)
                              ?.brightness ==
                              Brightness.light
                              ? Colors.white
                              : Colors.black12,
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width *
                                    0.125,
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height *
                                    0.065,
                                child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    child: Image.network(
                                      widget
                                          .readUserContent
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
                                      widget
                                          .readUserContent
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
                                      '${(widget.readUserContent
                                          .professionalQualifications![index]
                                          .qualificationSize! / 1024)
                                          .ceil()} KB',
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
                                    widget
                                        .readUserContent
                                        .professionalQualifications![
                                    index]
                                        .qualificationFileName = null;
                                    widget
                                        .readUserContent
                                        .professionalQualifications![
                                    index]
                                        .qualificationFile = null;
                                    widget
                                        .readUserContent
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

  /// QUALIFICATIONS ~ EDUCATIONAL QUALIFICATIONS
  buildEducationalQualifications() =>
      Container(
        color: DynamicTheme
            .of(context)
            ?.brightness == Brightness.light
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
            widget.readUserContent.educationalQualifications == null
                ? Container()
                : SizedBox(
              height: widget
                  .readUserContent.educationalQualifications!.length *
                  MediaQuery
                      .of(context)
                      .size
                      .height *
                  1,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget
                    .readUserContent.educationalQualifications!.length,
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
                          title: widget
                              .readUserContent
                              .educationalQualifications![index]
                              .title ==
                              null
                              ? ""
                              : widget
                              .readUserContent
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
                          title: widget
                              .readUserContent
                              .educationalQualifications![index]
                              .obtainedFrom ==
                              null
                              ? ""
                              : widget
                              .readUserContent
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
                          title: widget
                              .readUserContent
                              .educationalQualifications![index]
                              .description ==
                              null
                              ? ""
                              : widget
                              .readUserContent
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
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height /
                                    25,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_outlined,
                                    ),
                                    SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            50),
                                    Text(
                                      "START DATE",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        //letterSpacing: 8,
                                        fontFamily: 'Electrolize',
                                        fontSize: MediaQuery
                                            .of(context)
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
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width *
                                      0.15),
                              SizedBox(
                                height:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height /
                                    25,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_outlined,
                                    ),
                                    SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            50),
                                    Text(
                                      "END DATE",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        //letterSpacing: 8,
                                        fontFamily: 'Electrolize',
                                        fontSize: MediaQuery
                                            .of(context)
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
                              left: MediaQuery
                                  .of(context)
                                  .size
                                  .width *
                                  0.05,
                              right: MediaQuery
                                  .of(context)
                                  .size
                                  .width *
                                  0.065),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              ProfileItemCardMA(
                                title:
                                "${DateFormat('yyyy-MM-dd').parse(
                                    widget.readUserContent
                                        .educationalQualifications![index]
                                        .startDate!)}",
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              ProfileItemCardMA(
                                title:
                                "${DateFormat('yyyy-MM-dd').parse(
                                    widget.readUserContent
                                        .educationalQualifications![index]
                                        .endDate!)}",
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
                            MediaQuery
                                .of(context)
                                .size
                                .width * 0.25,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height *
                                0.065,
                            child: ProfileItemCardMA(
                              title:
                              "${widget.readUserContent
                                  .educationalQualifications![index].duration}",
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
                        widget
                            .readUserContent
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
                          color: DynamicTheme
                              .of(context)
                              ?.brightness ==
                              Brightness.light
                              ? Colors.white
                              : Colors.black12,
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width *
                                    0.125,
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height *
                                    0.065,
                                child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    child: Image.network(
                                      widget
                                          .readUserContent
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
                                      widget
                                          .readUserContent
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
                                      '${(widget.readUserContent
                                          .educationalQualifications![index]
                                          .qualificationSize! / 1024)
                                          .ceil()} KB',
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
                                    widget
                                        .readUserContent
                                        .educationalQualifications![
                                    index]
                                        .qualificationFileName = null;
                                    widget
                                        .readUserContent
                                        .educationalQualifications![
                                    index]
                                        .qualificationFile = null;
                                    widget
                                        .readUserContent
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

  /// QUALIFICATIONS ~ OTHER QUALIFICATIONS
  buildOtherQualifications() =>
      Container(
        color: DynamicTheme
            .of(context)
            ?.brightness == Brightness.light
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
            widget.readUserContent.otherQualifications == null
                ? Container()
                : SizedBox(
              height: widget.readUserContent.otherQualifications!.length *
                  MediaQuery
                      .of(context)
                      .size
                      .height *
                  1,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                widget.readUserContent.otherQualifications!.length,
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
                          title: widget
                              .readUserContent
                              .otherQualifications![index]
                              .title ==
                              null
                              ? ""
                              : widget.readUserContent
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
                          title: widget
                              .readUserContent
                              .otherQualifications![index]
                              .obtainedFrom ==
                              null
                              ? ""
                              : widget
                              .readUserContent
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
                          title: widget
                              .readUserContent
                              .otherQualifications![index]
                              .description ==
                              null
                              ? ""
                              : widget
                              .readUserContent
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
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height /
                                    25,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_outlined,
                                    ),
                                    SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            50),
                                    Text(
                                      "START DATE",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        //letterSpacing: 8,
                                        fontFamily: 'Electrolize',
                                        fontSize: MediaQuery
                                            .of(context)
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
                                  MediaQuery
                                      .of(context)
                                      .size
                                      .width *
                                      0.15),
                              SizedBox(
                                height:
                                MediaQuery
                                    .of(context)
                                    .size
                                    .height /
                                    25,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_outlined,
                                    ),
                                    SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width /
                                            50),
                                    Text(
                                      "END DATE",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        //letterSpacing: 8,
                                        fontFamily: 'Electrolize',
                                        fontSize: MediaQuery
                                            .of(context)
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
                              left: MediaQuery
                                  .of(context)
                                  .size
                                  .width *
                                  0.05,
                              right: MediaQuery
                                  .of(context)
                                  .size
                                  .width *
                                  0.065),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              ProfileItemCardMA(
                                title:
                                "${DateFormat('yyyy-MM-dd').parse(
                                    widget.readUserContent
                                        .otherQualifications![index]
                                        .startDate!)}",
                                textStyle: kProfileBodyTextStyle,
                                callback: () {},
                                rightWidget: null,
                              ),
                              ProfileItemCardMA(
                                title:
                                "${DateFormat('yyyy-MM-dd').parse(
                                    widget.readUserContent
                                        .otherQualifications![index]
                                        .endDate!)}",
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
                            MediaQuery
                                .of(context)
                                .size
                                .width * 0.25,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height *
                                0.065,
                            child: ProfileItemCardMA(
                              title:
                              "${widget.readUserContent
                                  .otherQualifications![index].duration}",
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
                        widget.readUserContent.otherQualifications![index]
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
                          color: DynamicTheme
                              .of(context)
                              ?.brightness ==
                              Brightness.light
                              ? Colors.white
                              : Colors.black12,
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width *
                                    0.125,
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height *
                                    0.065,
                                child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    child: Image.network(
                                      widget
                                          .readUserContent
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
                                      widget
                                          .readUserContent
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
                                      '${(widget.readUserContent
                                          .otherQualifications![index]
                                          .qualificationSize! / 1024)
                                          .ceil()} KB',
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
                                    widget
                                        .readUserContent
                                        .otherQualifications![index]
                                        .qualificationFileName = null;
                                    widget
                                        .readUserContent
                                        .otherQualifications![index]
                                        .qualificationFile = null;
                                    widget
                                        .readUserContent
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

  /// HARD SKILLS ///
  bool _expandedHardSkills = false;

  buildHardSKills() =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.readUserContent.hardSkills == null
              ? Container()
              : ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.readUserContent.hardSkills!.length,
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
                    color: DynamicTheme
                        .of(context)
                        ?.brightness ==
                        Brightness.light
                        ? Colors.white
                        : Colors.black12,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.readUserContent.hardSkills![index]
                            .typeOfSpecialization ==
                            null
                            ? Container()
                            : const ProfileItemCardMA(
                          title: "Type of Specialization",
                          rightWidget: null,
                          callback: null,
                          textStyle: kProfileSubHeaderTextStyle,
                        ),
                        widget.readUserContent.hardSkills![index]
                            .typeOfSpecialization ==
                            null
                            ? Container()
                            : ProfileItemCardMA(
                          title: widget
                              .readUserContent
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
                        widget.readUserContent.hardSkills![index]
                            .skillCategory ==
                            null
                            ? Container()
                            : const ProfileItemCardMA(
                          title: "Hard Skill Category",
                          rightWidget: null,
                          callback: null,
                          textStyle: kProfileSubHeaderTextStyle,
                        ),
                        widget.readUserContent.hardSkills![index]
                            .skillCategory ==
                            null
                            ? Container()
                            : ProfileItemCardMA(
                          title: widget.readUserContent
                              .hardSkills![index].skillCategory!,
                          rightWidget: null,
                          callback: () {
                            if (kDebugMode) {
                              print('Tap UserID');
                            }
                          },
                          textStyle: kProfileBodyTextStyle,
                        ),
                        widget.readUserContent.hardSkills![index].skill ==
                            null
                            ? Container()
                            : const ProfileItemCardMA(
                          title: "Hard Skill",
                          rightWidget: null,
                          callback: null,
                          textStyle: kProfileSubHeaderTextStyle,
                        ),
                        widget.readUserContent.hardSkills![index].skill ==
                            null
                            ? Container()
                            : ProfileItemCardMA(
                          title: widget.readUserContent
                              .hardSkills![index].skill!,
                          rightWidget: null,
                          callback: () {
                            if (kDebugMode) {
                              print('Tap UserID');
                            }
                          },
                          textStyle: kProfileBodyTextStyle,
                        ),
                        widget.readUserContent.hardSkills![index].level ==
                            null
                            ? Container()
                            : ProfileItemCardMA(
                          title: "Level",
                          rightWidget: Padding(
                            padding:
                            const EdgeInsets.only(top: 12.0),
                            child: Text(
                              widget.readUserContent
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

  /// SOFT SKILLS ///
  bool _expandedSoftSkills = false;

  buildSoftSkills() =>
      Column(
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

  /// SOFT SKILLS ~ ADAPTABILITY
  buildAdaptabilitySoftSkills() =>
      Container(
        color: DynamicTheme
            .of(context)
            ?.brightness == Brightness.light
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
            widget.readUserContent.adaptabilitySoftSkills == null
                ? Container()
                : SizedBox(
              height:
              widget.readUserContent.adaptabilitySoftSkills!.length *
                  MediaQuery
                      .of(context)
                      .size
                      .height *
                  0.25,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                widget.readUserContent.adaptabilitySoftSkills!.length,
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
                                color: DynamicTheme
                                    .of(context)
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
                                      title: widget
                                          .readUserContent
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
                                color: DynamicTheme
                                    .of(context)
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
                                      title: widget
                                          .readUserContent
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

  /// SOFT SKILLS ~ ATTENTION TO DETAIL
  buildAttentionToDetailSoftSkills() =>
      Container(
        color: DynamicTheme
            .of(context)
            ?.brightness == Brightness.light
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
            widget.readUserContent.attentionToDetailSoftSkills == null
                ? Container()
                : SizedBox(
              height: widget.readUserContent.attentionToDetailSoftSkills!
                  .length *
                  MediaQuery
                      .of(context)
                      .size
                      .height *
                  0.25,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget
                    .readUserContent.attentionToDetailSoftSkills!.length,
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
                                color: DynamicTheme
                                    .of(context)
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
                                      title: widget
                                          .readUserContent
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
                                color: DynamicTheme
                                    .of(context)
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
                                      title: widget
                                          .readUserContent
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

  /// SOFT SKILLS ~ COMMUNICATION
  buildCommunicationSoftSkills() =>
      Container(
        color: DynamicTheme
            .of(context)
            ?.brightness == Brightness.light
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
            widget.readUserContent.communicationSoftSkills == null
                ? Container()
                : SizedBox(
              height:
              widget.readUserContent.communicationSoftSkills!.length *
                  MediaQuery
                      .of(context)
                      .size
                      .height *
                  0.25,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget
                    .readUserContent.communicationSoftSkills!.length,
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
                                color: DynamicTheme
                                    .of(context)
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
                                      title: widget
                                          .readUserContent
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
                                color: DynamicTheme
                                    .of(context)
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
                                      title: widget
                                          .readUserContent
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

  /// SOFT SKILLS ~ COMPUTER
  buildComputerSoftSkills() =>
      Container(
        color: DynamicTheme
            .of(context)
            ?.brightness == Brightness.light
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
            widget.readUserContent.computerSoftSkills == null
                ? Container()
                : SizedBox(
              height: widget.readUserContent.computerSoftSkills!.length *
                  MediaQuery
                      .of(context)
                      .size
                      .height *
                  0.25,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                widget.readUserContent.computerSoftSkills!.length,
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
                                color: DynamicTheme
                                    .of(context)
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
                                      title: widget
                                          .readUserContent
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
                                color: DynamicTheme
                                    .of(context)
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
                                      title: widget
                                          .readUserContent
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

  /// SOFT SKILLS ~ CREATIVITY
  buildCreativitySoftSkills() =>
      Container(
        color: DynamicTheme
            .of(context)
            ?.brightness == Brightness.light
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
            widget.readUserContent.creativitySoftSkills == null
                ? Container()
                : SizedBox(
              height:
              widget.readUserContent.creativitySoftSkills!.length *
                  MediaQuery
                      .of(context)
                      .size
                      .height *
                  0.25,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                widget.readUserContent.creativitySoftSkills!.length,
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
                                color: DynamicTheme
                                    .of(context)
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
                                      title: widget
                                          .readUserContent
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
                                color: DynamicTheme
                                    .of(context)
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
                                      title: widget
                                          .readUserContent
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

  /// SOFT SKILLS ~ LEADERSHIP
  buildLeadershipSoftSkills() =>
      Container(
        color: DynamicTheme
            .of(context)
            ?.brightness == Brightness.light
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
            widget.readUserContent.leadershipSoftSkills == null
                ? Container()
                : SizedBox(
              height:
              widget.readUserContent.leadershipSoftSkills!.length *
                  MediaQuery
                      .of(context)
                      .size
                      .height *
                  0.25,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                widget.readUserContent.leadershipSoftSkills!.length,
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
                                color: DynamicTheme
                                    .of(context)
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
                                      title: widget
                                          .readUserContent
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
                                color: DynamicTheme
                                    .of(context)
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
                                      title: widget
                                          .readUserContent
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

  /// SOFT SKILLS ~ LIFE
  buildLifeSoftSkills() =>
      Container(
        color: DynamicTheme
            .of(context)
            ?.brightness == Brightness.light
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
            widget.readUserContent.lifeSoftSkills == null
                ? Container()
                : SizedBox(
              height: widget.readUserContent.lifeSoftSkills!.length *
                  MediaQuery
                      .of(context)
                      .size
                      .height *
                  0.25,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.readUserContent.lifeSoftSkills!.length,
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
                                color: DynamicTheme
                                    .of(context)
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
                                      title: widget.readUserContent
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
                                color: DynamicTheme
                                    .of(context)
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
                                      title: widget.readUserContent
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

  /// SOFT SKILLS ~ ORGANIZATIONAL
  buildOrganizationSoftSkills() =>
      Container(
        color: DynamicTheme
            .of(context)
            ?.brightness == Brightness.light
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
            widget.readUserContent.organizationSoftSkills == null
                ? Container()
                : SizedBox(
              height:
              widget.readUserContent.organizationSoftSkills!.length *
                  MediaQuery
                      .of(context)
                      .size
                      .height *
                  0.25,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                widget.readUserContent.organizationSoftSkills!.length,
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
                                color: DynamicTheme
                                    .of(context)
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
                                      title: widget
                                          .readUserContent
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
                                color: DynamicTheme
                                    .of(context)
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
                                      title: widget
                                          .readUserContent
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

  /// SOFT SKILLS ~ PROBLEM SOLVING
  buildProblemSolvingSoftSkills() =>
      Container(
        color: DynamicTheme
            .of(context)
            ?.brightness == Brightness.light
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
            widget.readUserContent.problemSolvingSoftSkills == null
                ? Container()
                : SizedBox(
              height: widget
                  .readUserContent.problemSolvingSoftSkills!.length *
                  MediaQuery
                      .of(context)
                      .size
                      .height *
                  0.25,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget
                    .readUserContent.problemSolvingSoftSkills!.length,
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
                                color: DynamicTheme
                                    .of(context)
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
                                      title: widget
                                          .readUserContent
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
                                color: DynamicTheme
                                    .of(context)
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
                                      title: widget
                                          .readUserContent
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

  /// SOFT SKILLS ~ SOCIAL / INTERPERSONAL
  buildSocialSoftSkills() =>
      Container(
        color: DynamicTheme
            .of(context)
            ?.brightness == Brightness.light
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
            widget.readUserContent.socialOrInterpersonalSoftSkills == null
                ? Container()
                : SizedBox(
              height: widget.readUserContent
                  .socialOrInterpersonalSoftSkills!.length *
                  MediaQuery
                      .of(context)
                      .size
                      .height *
                  0.25,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.readUserContent
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
                                color: DynamicTheme
                                    .of(context)
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
                                      title: widget
                                          .readUserContent
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
                                color: DynamicTheme
                                    .of(context)
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
                                      title: widget
                                          .readUserContent
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

  /// SOFT SKILLS ~ TEAMWORK
  buildTeamworkSoftSkills() =>
      Container(
        color: DynamicTheme
            .of(context)
            ?.brightness == Brightness.light
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
            widget.readUserContent.teamworkSoftSkills == null
                ? Container()
                : SizedBox(
              height: widget.readUserContent.teamworkSoftSkills!.length *
                  MediaQuery
                      .of(context)
                      .size
                      .height *
                  0.25,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                widget.readUserContent.teamworkSoftSkills!.length,
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
                                color: DynamicTheme
                                    .of(context)
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
                                      title: widget
                                          .readUserContent
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
                                color: DynamicTheme
                                    .of(context)
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
                                      title: widget
                                          .readUserContent
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

  /// SOFT SKILLS ~ TIME MANAGEMENT
  buildTimeManagementSoftSkills() =>
      Container(
        color: DynamicTheme
            .of(context)
            ?.brightness == Brightness.light
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
            widget.readUserContent.timeManagementSoftSkills == null
                ? Container()
                : SizedBox(
              height: widget
                  .readUserContent.timeManagementSoftSkills!.length *
                  MediaQuery
                      .of(context)
                      .size
                      .height *
                  0.25,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget
                    .readUserContent.timeManagementSoftSkills!.length,
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
                                color: DynamicTheme
                                    .of(context)
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
                                      title: widget
                                          .readUserContent
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
                                color: DynamicTheme
                                    .of(context)
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
                                      title: widget
                                          .readUserContent
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

  /// SOFT SKILLS ~ WORK ETHICS
  buildWorkEthicSoftSkills() =>
      Container(
        color: DynamicTheme
            .of(context)
            ?.brightness == Brightness.light
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
            widget.readUserContent.workEthicSoftSkills == null
                ? Container()
                : SizedBox(
              height: widget.readUserContent.workEthicSoftSkills!.length *
                  MediaQuery
                      .of(context)
                      .size
                      .height *
                  0.25,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                widget.readUserContent.workEthicSoftSkills!.length,
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
                                color: DynamicTheme
                                    .of(context)
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
                                      title: widget
                                          .readUserContent
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
                                color: DynamicTheme
                                    .of(context)
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
                                      title: widget
                                          .readUserContent
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
