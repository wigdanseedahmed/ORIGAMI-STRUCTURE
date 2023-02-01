import 'package:flutter/cupertino.dart';
import 'package:origami_structure/imports.dart';
import 'package:line_icons/line_icons.dart' as lineIcons;

import 'package:http/http.dart' as http;

class RecommendedUserSkillsScreenMA extends StatefulWidget {
  final UserModel selectedRecommendedUserInformation;
  final RecommendedUserModel selectedRecommendedUserResultDetails;
  final List<RecommendedUserModel> allRecommendedUsers;

  const RecommendedUserSkillsScreenMA({
    Key? key,
    required this.selectedRecommendedUserInformation,
    required this.selectedRecommendedUserResultDetails,
    required this.allRecommendedUsers,
  }) : super(key: key);

  @override
  _RecommendedUserSkillsScreenMAState createState() =>
      _RecommendedUserSkillsScreenMAState();
}

class _RecommendedUserSkillsScreenMAState
    extends State<RecommendedUserSkillsScreenMA>
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

    super.initState();
  }

  @override
  void dispose() {
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
          buildRecommendedUserProfileBody(),
        ],
      ),
    );
  }

  ///-------------------------------------- PROFILE BODY --------------------------------------///
  buildRecommendedUserProfileBody() {
    return Column(
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
        const SizedBox(height: 40),
      ],
    );
  }

  ///------------------- HARD SKILLS -------------------///
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

  ///------------------- SOFT SKILLS -------------------///
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

  ///--- SOFT SKILLS ~ ADAPTABILITY
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

  ///--- SOFT SKILLS ~ ATTENTION TO DETAIL
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

  ///--- SOFT SKILLS ~ COMMUNICATION
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

  ///--- SOFT SKILLS ~ COMPUTER
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

  ///--- SOFT SKILLS ~ CREATIVITY
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

  ///--- SOFT SKILLS ~ LEADERSHIP
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

  ///--- SOFT SKILLS ~ LIFE
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

  ///--- SOFT SKILLS ~ ORGANIZATIONAL
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

  ///--- SOFT SKILLS ~ PROBLEM SOLVING
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

  ///--- SOFT SKILLS ~ SOCIAL / INTERPERSONAL
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

  ///--- SOFT SKILLS ~ TEAMWORK
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

  ///--- SOFT SKILLS ~ TIME MANAGEMENT
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

  ///--- SOFT SKILLS ~ WORK ETHICS
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