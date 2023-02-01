import 'package:nb_utils/nb_utils.dart';
import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

List<UserModel> recommendationSystemFunction({
  List<UserModel>? allUsers,
  String? skillName,
  String? jobField,
  String? jobSubField,
  String? jobSpecialization,
  String? jobTitle,
  List<SkillModel>? hardSkills,
  String? contractType,
  String? startDate,
  String? endDate,
  double? duration,
}) {
  List<UserModel> allRecommendedUsers = <UserModel>[];

  double totalScore = 0;
  double userScore = 0;
  double userScorePercentage = 0;


  for (int i = 0; i < allUsers!.length; i++) {

    if (startDate.isEmptyOrNull) {
      // Is person available in general?
      if (allUsers[i].availability == false) {
        ///--------------------------- ID - 001 ---------------------------///
        // OUTPUT: Person is not available - DO NOT ADD TO RECOMMENDATIONS
        totalScore = 0;
        userScore = 0;
        allRecommendedUsers = allRecommendedUsers;
      } else {
        // Person is available - is job field available?

        totalScore = totalScoreFunction(
          jobField: jobField == null ? null : jobField,
          jobSubField: jobSubField == null ? null : jobSubField,
          jobSpecialization: jobSpecialization == null ? null : jobSpecialization,
          hardSkills: hardSkills == null ? null : hardSkills,
        );

        userScore = userScoreFunction(
          selectedUser: allUsers.isEmpty ? null : allUsers[i],
          jobField: jobField == null ? null : jobField,
          jobSubField: jobSubField == null ? null : jobSubField,
          jobSpecialization: jobSpecialization == null ? null : jobSpecialization,
          hardSkills: hardSkills == null ? null : hardSkills,
        );

        userScorePercentage = (userScore / totalScore) * 100;

        print(" ${allUsers[i].username} ${userScoreFunction(
          selectedUser: allUsers.isEmpty ? null : allUsers[i],
          jobField: jobField == null ? null : jobField,
          jobSubField: jobSubField == null ? null : jobSubField,
          jobSpecialization: jobSpecialization == null ? null : jobSpecialization,
          hardSkills: hardSkills == null ? null : hardSkills,
        )
        } - $totalScore: - $userScorePercentage");

        if(userScorePercentage >= 60){
          allRecommendedUsers.add(allUsers[i]);
        } else {
          allRecommendedUsers;
        }

        /*///----------- JOB FIELD = EMPTY -----------///
        if (jobField.isEmptyOrNull) {
          // Person is available - job field is not available  - is job sub field available?
          totalScore = totalScore + 0;

          ///----------- JOB SUB FIELD = EMPTY -----------///
          if (jobSubField.isEmptyOrNull) {
            // Person is available - job field is not available - job sub field is not available - is job specialization available?
            totalScore = totalScore + 0;

            ///----------- JOB SPECIALIZATION = EMPTY -----------///
            if (jobSpecialization.isEmptyOrNull) {
              // Person is available - job field is not available - job sub field is not available - job specialization is not available - is hard skills available?
              totalScore = totalScore + 0;

              ///----------- HARD SKILLS LIST = EMPTY -----------///
              if (hardSkills!.isEmpty || hardSkills == null) {
                // Person is available - job field is not available - job sub field is not available - job specialization is not available - hard category skills is not available = DO NOTHING

                ///--------------------------- ID - 002 ---------------------------///
                // OUTPUT: No Information Given - DO NOT ADD TO RECOMMENDATIONS
                totalScore = 0;
                userScore = 0;
              }

              ///----------- HARD SKILLS LIST != EMPTY -----------///
              else {
                // Person is available - job field is not available - job sub field is available - job specialization is not available - hard skills is available - is type of specialization available?

                for (int j = 0; j < hardSkills.length; j++) {
                  ///----------- HARD SKILLS LIST - TYPE OF SPECIALIZATION = EMPTY -----------///
                  if (hardSkills[j].typeOfSpecialization.isEmptyOrNull) {
                    // Person is available - job field is not available - job sub field is not available - job specialization is not available - hard skills is available -- type of specialization is not available - is hard skills category available?
                    totalScore = totalScore + 0;

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY = EMPTY -----------///
                    if (hardSkills[j].skillCategory.isEmptyOrNull) {
                      // Person is available - job field is not available - job sub field is not available - job specialization is not available - hard skills is available -- type of specialization is not available - hard skills category is not available - is hard skills available?
                      totalScore = totalScore + 0;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is not available - job sub field is not available - job specialization is not available - hard skills is available -- type of specialization is not available - hard skills category is not available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is not available - job specialization is not available - hard skills is available -- type of specialization is not available - hard skills category is not available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 003 ---------------------------///
                          // OUTPUT: No Information Given - DO NOT ADD TO RECOMMENDATIONS
                          totalScore = 0;
                          userScore = 0;
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is not available - hard skills is available -- type of specialization is not available - hard skills category is not available - hard skills is not available - level is available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 004 ---------------------------///
                          // OUTPUT: No Information Given - DO NOT ADD TO RECOMMENDATIONS
                          totalScore = 0;
                          userScore = 0;

                          print(
                              " ID - 004: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is not available - job sub field is not available - job specialization is not available - hard skills is available -- type of specialization is not available - hard skills category is not available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is not available - job specialization is not available - hard skills is available -- type of specialization is not available - hard skills category is not available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 005 ---------------------------///

                          print(
                              " ID - 005: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is not available - hard skills is available -- type of specialization is not available - hard skills category is not available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 006 ---------------------------///

                          userScore = userScoreFunction(
                            selectedUser: allUsers[i],
                            jobField: jobField,
                            jobSubField: jobSubField,
                            jobSpecialization: jobSpecialization,
                            hardSkills: [], //hardSkills[j]
                          );

                          print(
                              " ID - 006: TOTAL SCORE = TOTAL SCORE = $totalScore  /  USER SCORE = $userScore  /  USER SCORE = $userScore");
                        }
                      }
                    }

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY!= EMPTY -----------///
                    else {
                      // Person is available - job field is not available - job sub field is not available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - is hard skills available?
                      totalScore = totalScore + 1;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is not available - job sub field is not available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is not available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 007 ---------------------------///

                          if (allUsers[i].hardSkills!.isNotEmpty) {
                            for (int k = 0;
                                k < allUsers[i].hardSkills!.length;
                                k++) {
                              if (hardSkills[j].skillCategory ==
                                  allUsers[i].hardSkills![k].skillCategory) {
                                userScore = userScore + 0.5;
                              } else {
                                userScore = userScore + 0;
                              }
                            }
                          }

                          print(
                              " ID - 007: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 008 ---------------------------///

                          if (allUsers[i].hardSkills!.isEmpty) {
                            for (int k = 0;
                                k < allUsers[i].hardSkills!.length;
                                k++) {
                              if (hardSkills[j].skillCategory ==
                                  allUsers[i].hardSkills![k].skillCategory) {
                                userScore = userScore + 0.5;
                              } else {
                                userScore = userScore + 0;
                              }

                              if (hardSkills[j].level ==
                                  allUsers[i].hardSkills![k].level) {
                                userScore = userScore + 0;
                              } else {
                                userScore = userScore + 0;
                              }
                            }
                          }

                          print(
                              " ID - 008: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is not available - job sub field is not available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is not available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 009 ---------------------------///

                          if (allUsers[i].hardSkills!.isEmpty) {
                            for (int k = 0;
                                k < allUsers[i].hardSkills!.length;
                                k++) {
                              if (hardSkills[j].skillCategory ==
                                  allUsers[i].hardSkills![k].skillCategory) {
                                userScore = userScore + 1;
                              } else {
                                userScore = userScore + 0;
                              }

                              if (hardSkills[j].skill ==
                                  allUsers[i].hardSkills![k].skill) {
                                userScore = userScore + 1;
                              } else {
                                userScore = userScore + 0;
                              }
                            }
                          }

                          print(
                              " ID - 009: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 010 ---------------------------///

                          if (allUsers[i].hardSkills!.isEmpty) {
                            for (int k = 0;
                                k < allUsers[i].hardSkills!.length;
                                k++) {
                              if (hardSkills[j].skillCategory ==
                                  allUsers[i].hardSkills![k].skillCategory) {
                                userScore = userScore + 1;
                              } else {
                                userScore = userScore + 0;
                              }

                              if (hardSkills[j].skill ==
                                  allUsers[i].hardSkills![k].skill) {
                                userScore = userScore + 1;
                              } else {
                                userScore = userScore + 0;
                              }

                              if (hardSkills[j].level ==
                                  allUsers[i].hardSkills![k].level) {
                                userScore = userScore + 1;
                              } else {
                                userScore = userScore + 0;
                              }
                            }
                          }

                          print(
                              " ID - 010: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }
                  }

                  ///----------- TYPE OF SPECIALIZATION != EMPTY -----------///
                  else {
                    // Person is available - job field is not available - job sub field is available - job specialization is not available - type of specialization is available - is hard skills category available?
                    totalScore = totalScore + 1;

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY = EMPTY -----------///
                    if (hardSkills[j].skillCategory.isEmptyOrNull) {
                      // Person is available - job field is not available - job sub field is not available - job specialization is not available - type of specialization is available - hard skills category is not available - is hard skills available?
                      totalScore = totalScore + 0;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is not available - job sub field is not available - job specialization is not available - type of specialization is available - hard skills category is not available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is not available - job specialization is not available - type of specialization is available - hard skills category is not available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 011 ---------------------------///

                          if (allUsers[i].hardSkills!.isEmpty) {
                            for (int k = 0;
                                k < allUsers[i].hardSkills!.length;
                                k++) {
                              if (hardSkills[j].typeOfSpecialization ==
                                  allUsers[i]
                                      .hardSkills![k]
                                      .typeOfSpecialization) {
                                userScore = userScore + 1;
                              } else {
                                userScore = userScore + 0;
                              }
                            }
                          }

                          print(
                              " ID - 011: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is not available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 012 ---------------------------///

                          if (allUsers[i].hardSkills!.isEmpty) {
                            for (int k = 0;
                                k < allUsers[i].hardSkills!.length;
                                k++) {
                              if (hardSkills[j].typeOfSpecialization ==
                                  allUsers[i]
                                      .hardSkills![k]
                                      .typeOfSpecialization) {
                                userScore = userScore + 1;
                              } else {
                                userScore = userScore + 0;
                              }
                            }
                          }

                          print(
                              " ID - 012: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is not available - job sub field is not available - job specialization is not available - type of specialization is available - hard skills category is not available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is not available - job specialization is not available - type of specialization is available - hard skills category is not available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 013 ---------------------------///

                          if (allUsers[i].hardSkills!.isEmpty) {
                            for (int k = 0;
                                k < allUsers[i].hardSkills!.length;
                                k++) {
                              if (hardSkills[j].typeOfSpecialization ==
                                  allUsers[i]
                                      .hardSkills![k]
                                      .typeOfSpecialization) {
                                userScore = userScore + 1;
                              } else {
                                userScore = userScore + 0;
                              }
                            }
                          }

                          print(
                              " ID - 013: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is not available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 014 ---------------------------///

                          print(
                              " ID - 014: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY!= EMPTY -----------///
                    else {
                      // Person is available - job field is not available - job sub field is not available - job specialization is not available - type of specialization is available - hard skills category is available - is hard skills available?
                      totalScore = totalScore + 1;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is not available - job sub field is not available - job specialization is not available - type of specialization is available - hard skills category is available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is not available - job specialization is not available - type of specialization is available - hard skills category is available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 015 ---------------------------///

                          print(
                              " ID - 015: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 016 ---------------------------///

                          print(
                              " ID - 016: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is not available - job sub field is not available - job specialization is not available - type of specialization is available - hard skills category is available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is not available - job specialization is not available - type of specialization is available - hard skills category is available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 017 ---------------------------///

                          print(
                              " ID - 017: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 018 ---------------------------///

                          print(
                              " ID - 018: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }
                  }
                }
              }
            }

            ///----------- JOB SPECIALIZATION != EMPTY -----------///
            else {
              // Person is available - job field is not available - job sub field not is available - job specialization is available - is hard skills available?
              totalScore = totalScore + 1;

              ///----------- HARD SKILLS LIST = EMPTY -----------///
              if (hardSkills!.isEmpty || hardSkills == null) {
                // Person is available - job field is not available - job sub field is not available - job specialization is available - hard category skills is not available

                ///--------------------------- ID - 019 ---------------------------///

                print(
                    " ID - 019: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
              }

              ///----------- HARD SKILLS LIST != EMPTY -----------///
              else {
                // Person is available - job field is not available - job sub field is available - job specialization is available - hard category skills is available - is type of specialization available?

                for (int j = 0; j < hardSkills.length; j++) {
                  ///----------- HARD SKILLS LIST - TYPE OF SPECIALIZATION = EMPTY -----------///
                  if (hardSkills[j].typeOfSpecialization.isEmptyOrNull) {
                    // Person is available - job field is not available - job sub field is not available - job specialization is available - hard skills is not available -- type of specialization is not available - is hard skills category available?
                    totalScore = totalScore + 0;

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY = EMPTY -----------///
                    if (hardSkills[j].skillCategory.isEmptyOrNull) {
                      // Person is available - job field is not available - job sub field is not available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - is hard skills available?
                      totalScore = totalScore + 0;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is not available - job sub field is not available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is not available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 020 ---------------------------///

                          print(
                              " ID - 020: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 021 ---------------------------///

                          print(
                              " ID - 021: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is not available - job sub field is not available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is not available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 022 ---------------------------///

                          print(
                              " ID - 022: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 023 ---------------------------///

                          print(
                              " ID - 023: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY!= EMPTY -----------///
                    else {
                      // Person is available - job field is not available - job sub field is not available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - is hard skills available?
                      totalScore = totalScore + 1;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is not available - job sub field is not available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is not available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 024 ---------------------------///

                          print(
                              " ID - 024: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 025 ---------------------------///

                          print(
                              " ID - 025: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is not available - job sub field is not available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is not available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 026 ---------------------------///

                          print(
                              " ID - 026: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 027 ---------------------------///

                          print(
                              " ID - 027: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }
                  }

                  ///----------- TYPE OF SPECIALIZATION != EMPTY -----------///
                  else {
                    // Person is available - job field is not available - job sub field is available - job specialization is available - type of specialization is available - is hard skills category available?
                    totalScore = totalScore + 1;

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY = EMPTY -----------///
                    if (hardSkills[j].skillCategory.isEmptyOrNull) {
                      // Person is available - job field is not available - job sub field is not available - job specialization is available - type of specialization is available - hard skills category is not available - is hard skills available?
                      totalScore = totalScore + 0;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is not available - job sub field is not available - job specialization is available - type of specialization is available - hard skills category is not available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is not available - job specialization is available - type of specialization is available - hard skills category is not available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 028 ---------------------------///

                          print(
                              " ID - 028: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is not available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 029 ---------------------------///

                          print(
                              " ID - 029: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is not available - job sub field is not available - job specialization is available - type of specialization is available - hard skills category is not available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is not available - job specialization is available - type of specialization is available - hard skills category is not available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 030 ---------------------------///

                          print(
                              " ID - 030: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is not available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 031 ---------------------------///

                          print(
                              " ID - 031: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY!= EMPTY -----------///
                    else {
                      // Person is available - job field is not available - job sub field is not available - job specialization is available - type of specialization is available - hard skills category is available - is hard skills available?
                      totalScore = totalScore + 1;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        totalScore = totalScore + 0;

                        // Person is available - job field is not available - job sub field is not available - job specialization is available - type of specialization is available - hard skills category is available - hard skills is not available - is level available?

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is not available - job specialization is available - type of specialization is available - hard skills category is available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 032 ---------------------------///

                          print(
                              " ID - 032: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 033 ---------------------------///

                          print(
                              " ID - 033: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is not available - job sub field is not available - job specialization is available - type of specialization is available - hard skills category is available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is not available - job specialization is available - type of specialization is available - hard skills category is available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 034 ---------------------------///

                          print(
                              " ID - 034: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 035 ---------------------------///

                          print(
                              " ID - 035: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }
                  }
                }
              }
            }
          }

          ///----------- JOB SUB FIELD != EMPTY -----------///
          else {
            // Person is available - job field is not available - job sub field is available - is job specialization available?
            totalScore = totalScore + 1;

            ///----------- JOB SPECIALIZATION = EMPTY -----------///
            if (jobSpecialization.isEmptyOrNull) {
              // Person is available - job field is not available - job sub field is available - job specialization is not available - is hard skills available?
              totalScore = totalScore + 0;

              ///----------- HARD SKILLS LIST = EMPTY -----------///
              if (hardSkills!.isEmpty || hardSkills == null) {
                // Person is available - job field is not available - job sub field is available - job specialization is not available - hard category skills is not available

                ///--------------------------- ID - 036 ---------------------------///

                print(
                    " ID - 036: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
              }

              ///----------- HARD SKILLS LIST != EMPTY -----------///
              else {
                // Person is available - job field is not available - job sub field is available - job specialization is not available - hard skills is available - is type of specialization available?

                for (int j = 0; j < hardSkills.length; j++) {
                  ///----------- HARD SKILLS LIST - TYPE OF SPECIALIZATION = EMPTY -----------///
                  if (hardSkills[j].typeOfSpecialization.isEmptyOrNull) {
                    // Person is available - job field is not available - job sub field is available - job specialization is not available - hard skills is available -- type of specialization is not available - is hard skills category available?
                    totalScore = totalScore + 0;

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY = EMPTY -----------///
                    if (hardSkills[j].skillCategory.isEmptyOrNull) {
                      // Person is available - job field is not available - job sub field is available - job specialization is not available - hard skills is available -- type of specialization is not available - hard skills category is not available - is hard skills available?
                      totalScore = totalScore + 0;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is not available - job sub field is available - job specialization is not available - hard skills is available -- type of specialization is not available - hard skills category is not available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 037 ---------------------------///

                          print(
                              " ID - 037: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 038 ---------------------------///

                          print(
                              " ID - 038: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is not available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 039 ---------------------------///

                          print(
                              " ID - 039: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 040 ---------------------------///

                          print(
                              " ID - 040: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY != EMPTY -----------///
                    else {
                      // Person is available - job field is not available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - is hard skills available?
                      totalScore = totalScore + 1;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        totalScore = totalScore + 0;

                        // Person is available - job field is not available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is not available - is level available?

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 041 ---------------------------///

                          print(
                              " ID - 041: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 042 ---------------------------///

                          print(
                              " ID - 042: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is not available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 043 ---------------------------///

                          print(
                              " ID - 043: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 044 ---------------------------///

                          print(
                              " ID - 044: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }
                  }

                  ///----------- TYPE OF SPECIALIZATION != EMPTY -----------///
                  else {
                    // Person is available - job field is not available - job sub field is available - job specialization is not available - type of specialization is available - is hard skills category available?
                    totalScore = totalScore + 0;

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY = EMPTY -----------///
                    if (hardSkills[j].skillCategory.isEmptyOrNull) {
                      // Person is available - job field is not available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is not available - is hard skills available?
                      totalScore = totalScore + 0;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is not available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is not available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is not available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 045 ---------------------------///

                          print(
                              " ID - 045: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is not available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 046 ---------------------------///

                          print(
                              " ID - 046: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is not available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is not available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is not available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 047 ---------------------------///

                          print(
                              " ID - 047: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is not available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 048 ---------------------------///

                          print(
                              " ID - 048: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY != EMPTY -----------///
                    else {
                      // Person is available - job field is not available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is available - is hard skills available?
                      totalScore = totalScore + 1;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is not available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 049 ---------------------------///

                          print(
                              " ID - 049: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 050 ---------------------------///

                          print(
                              " ID - 050: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is not available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 051 ---------------------------///

                          print(
                              " ID - 051: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 052 ---------------------------///

                          print(
                              " ID - 052: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }
                  }
                }
              }
            }

            ///----------- JOB SPECIALIZATION != EMPTY -----------///
            else {
              // Person is available - job field is not available - job sub field not is available - job specialization is available - is hard skills available?
              totalScore = totalScore + 1;

              ///----------- HARD SKILLS LIST = EMPTY -----------///
              if (hardSkills!.isEmpty || hardSkills == null) {
                // Person is available - job field is not available - job sub field is available - job specialization is available - hard category skills is not available

                ///--------------------------- ID - 053 ---------------------------///

                print(
                    " ID - 053: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
              }

              ///----------- HARD SKILLS LIST != EMPTY -----------///
              else {
                // Person is available - job field is not available - job sub field is available - job specialization is available - hard category skills is available - is type of specialization available?

                for (int j = 0; j < hardSkills.length; j++) {
                  ///----------- HARD SKILLS LIST - TYPE OF SPECIALIZATION = EMPTY -----------///
                  if (hardSkills[j].typeOfSpecialization.isEmptyOrNull) {
                    // Person is available - job field is not available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - is hard skills category available?
                    totalScore = totalScore + 0;

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY = EMPTY -----------///
                    if (hardSkills[j].skillCategory.isEmptyOrNull) {
                      // Person is available - job field is not available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - is hard skills available?
                      totalScore = totalScore + 0;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is not available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 054 ---------------------------///

                          print(
                              " ID - 054: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 055 ---------------------------///

                          print(
                              " ID - 055: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is not available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 056 ---------------------------///

                          print(
                              " ID - 056: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 057 ---------------------------///

                          print(
                              " ID - 057: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY != EMPTY -----------///
                    else {
                      // Person is available - job field is not available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - is hard skills available?
                      totalScore = totalScore + 1;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is not available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 058 ---------------------------///

                          print(
                              " ID - 058: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 059 ---------------------------///

                          print(
                              " ID - 059: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is not available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 060 ---------------------------///

                          print(
                              " ID - 060: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 061 ---------------------------///

                          print(
                              " ID - 061: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }
                  }

                  ///----------- TYPE OF SPECIALIZATION != EMPTY -----------///
                  else {
                    // Person is available - job field is not available - job sub field is available - job specialization is available - type of specialization is available - is hard skills category available?
                    totalScore = totalScore + 1;

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY = EMPTY -----------///
                    if (hardSkills[j].skillCategory.isEmptyOrNull) {
                      // Person is available - job field is not available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is not available - is hard skills available?
                      totalScore = totalScore + 0;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is not available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is not available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is not available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 062 ---------------------------///

                          print(
                              " ID - 062: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is not available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 063 ---------------------------///

                          print(
                              " ID - 063: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is not available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is not available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is not available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 064 ---------------------------///

                          print(
                              " ID - 064: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is not available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 065 ---------------------------///

                          print(
                              " ID - 065: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY != EMPTY -----------///
                    else {
                      // Person is available - job field is not available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is available - is hard skills available?
                      totalScore = totalScore + 1;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is not available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is available - hard skills is not available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 066 ---------------------------///

                          print(
                              " ID - 066: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 067 ---------------------------///

                          print(
                              " ID - 067: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is not available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is not available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 068 ---------------------------///

                          print(
                              " ID - 068: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is not available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 069 ---------------------------///

                          print(
                              " ID - 069: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }

        ///----------- JOB FIELD != EMPTY -----------///
        else {
          // Person is available - job field is available  - is job field available?
          totalScore = totalScore + 1;

          ///----------- JOB SUB FIELD = EMPTY -----------///
          if (jobSubField.isEmptyOrNull) {
            // Person is available - job field is available - job sub field is not available - is job specialization available?
            totalScore = totalScore + 0;

            ///----------- JOB SPECIALIZATION = EMPTY -----------///
            if (jobSpecialization.isEmptyOrNull) {
              // Person is available - job field is available - job sub field is not available - job specialization is not available - is hard skills available?
              totalScore = totalScore + 0;

              ///----------- HARD SKILLS LIST = EMPTY -----------///
              if (hardSkills!.isEmpty || hardSkills == null) {
                // Person is available - job field is available - job sub field is not available - job specialization is not available - hard category skills is not available = DO NOTHING

                ///--------------------------- ID - 070 ---------------------------///

                print(
                    " ID - 070: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
              }

              ///----------- HARD SKILLS LIST != EMPTY -----------///
              else {
                // Person is available - job field is available - job sub field is available - job specialization is not available - hard category skills is available - is type of specialization available?

                for (int j = 0; j < hardSkills.length; j++) {
                  ///----------- HARD SKILLS LIST - TYPE OF SPECIALIZATION = EMPTY -----------///
                  if (hardSkills[j].typeOfSpecialization.isEmptyOrNull) {
                    // Person is available - job field is available - job sub field is not available - job specialization is not available - hard skills is not available -- type of specialization is not available - is hard skills category available?
                    totalScore = totalScore + 0;

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY = EMPTY -----------///
                    if (hardSkills[j].skillCategory.isEmptyOrNull) {
                      // Person is available - job field is available - job sub field is not available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is not available - is hard skills available?
                      totalScore = totalScore + 0;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is available - job sub field is not available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is not available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 071 ---------------------------///

                          print(
                              " ID - 071: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 072 ---------------------------///

                          print(
                              " ID - 072: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is available - job sub field is not available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is not available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 073 ---------------------------///

                          print(
                              " ID - 073: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 074 ---------------------------///

                          print(
                              " ID - 074: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY != EMPTY -----------///
                    else {
                      // Person is available - job field is available - job sub field is not available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - is hard skills available?
                      totalScore = totalScore + 1;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is available - job sub field is not available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is not available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 075 ---------------------------///

                          print(
                              " ID - 075: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 076 ---------------------------///

                          print(
                              " ID - 076: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is available - job sub field is not available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is not available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 077 ---------------------------///

                          print(
                              " ID - 077: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 078 ---------------------------///

                          print(
                              " ID - 078: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }
                  }

                  ///----------- TYPE OF SPECIALIZATION != EMPTY -----------///
                  else {
                    // Person is available - job field is available - job sub field is available - job specialization is not available - type of specialization is available - is hard skills category available?
                    totalScore = totalScore + 1;

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY = EMPTY -----------///
                    if (hardSkills[j].skillCategory.isEmptyOrNull) {
                      // Person is available - job field is available - job sub field is not available - job specialization is not available - type of specialization is available - hard skills category is not available - is hard skills available?
                      totalScore = totalScore + 0;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is available - job sub field is not available - job specialization is not available - type of specialization is available - hard skills category is not available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is not available - job specialization is not available - type of specialization is available - hard skills category is not available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 079 ---------------------------///

                          print(
                              " ID - 079: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is not available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 080 ---------------------------///

                          print(
                              " ID - 080: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is available - job sub field is not available - job specialization is not available - type of specialization is available - hard skills category is not available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is not available - job specialization is not available - type of specialization is available - hard skills category is not available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 081 ---------------------------///

                          print(
                              " ID - 081: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is not available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 082 ---------------------------///

                          print(
                              " ID - 082: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY != EMPTY -----------///
                    else {
                      // Person is available - job field is available - job sub field is not available - job specialization is not available - type of specialization is available - hard skills category is available - is hard skills available?
                      totalScore = totalScore + 1;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is available - job sub field is not available - job specialization is not available - type of specialization is available - hard skills category is available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is not available - job specialization is not available - type of specialization is available - hard skills category is available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 083 ---------------------------///

                          print(
                              " ID - 083: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 084 ---------------------------///

                          print(
                              " ID - 084: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is available - job sub field is not available - job specialization is not available - type of specialization is available - hard skills category is available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is not available - job specialization is not available - type of specialization is available - hard skills category is available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 085 ---------------------------///

                          print(
                              " ID - 085: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 086 ---------------------------///

                          print(
                              " ID - 086: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }
                  }
                }
              }
            }

            ///----------- JOB SPECIALIZATION != EMPTY -----------///
            else {
              // Person is available - job field is available - job sub field not is available - job specialization is available - is hard skills available?
              totalScore = totalScore + 1;

              ///----------- HARD SKILLS LIST = EMPTY -----------///
              if (hardSkills!.isEmpty || hardSkills == null) {
                // Person is available - job field is available - job sub field is not available - job specialization is available - hard category skills is not available

                ///--------------------------- ID - 087 ---------------------------///

                print(
                    " ID - 087: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
              }

              ///----------- HARD SKILLS LIST != EMPTY -----------///
              else {
                // Person is available - job field is available - job sub field is available - job specialization is available - hard category skills is available - is type of specialization available?

                for (int j = 0; j < hardSkills.length; j++) {
                  ///----------- HARD SKILLS LIST - TYPE OF SPECIALIZATION = EMPTY -----------///
                  if (hardSkills[j].typeOfSpecialization.isEmptyOrNull) {
                    // Person is available - job field is available - job sub field is not available - job specialization is available - hard skills is not available -- type of specialization is not available - is hard skills category available?
                    totalScore = totalScore + 0;

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY = EMPTY -----------///
                    if (hardSkills[j].skillCategory.isEmptyOrNull) {
                      // Person is available - job field is available - job sub field is not available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - is hard skills available?
                      totalScore = totalScore + 0;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is available - job sub field is not available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is not available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 088 ---------------------------///

                          print(
                              " ID - 088: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is not available - level is available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 089 ---------------------------///

                          print(
                              " ID - 089: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is available - job sub field is not available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is not available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 090 ---------------------------///

                          print(
                              " ID - 090: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 091 ---------------------------///

                          print(
                              " ID - 091: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY != EMPTY -----------///
                    else {
                      // Person is available - job field is available - job sub field is not available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - is hard skills available?
                      totalScore = totalScore + 1;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is available - job sub field is not available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is not available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 092 ---------------------------///

                          print(
                              " ID - 092: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 093 ---------------------------///

                          print(
                              " ID - 093: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is available - job sub field is not available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is not available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 094 ---------------------------///

                          print(
                              " ID - 094: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 095 ---------------------------///

                          print(
                              " ID - 095: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }
                  }

                  ///----------- TYPE OF SPECIALIZATION != EMPTY -----------///
                  else {
                    // Person is available - job field is available - job sub field is available - job specialization is available - type of specialization is available - is hard skills category available?
                    totalScore = totalScore + 1;

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY = EMPTY -----------///
                    if (hardSkills[j].skillCategory.isEmptyOrNull) {
                      // Person is available - job field is available - job sub field is not available - job specialization is available - type of specialization is available - hard skills category is not available - is hard skills available?
                      totalScore = totalScore + 0;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is available - job sub field is not available - job specialization is available - type of specialization is available - hard skills category is not available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is not available - job specialization is available - type of specialization is available - hard skills category is not available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 096 ---------------------------///

                          print(
                              " ID - 096: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is not available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 097 ---------------------------///

                          print(
                              " ID - 097: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is available - job sub field is not available - job specialization is available - type of specialization is available - hard skills category is not available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is not available - job specialization is available - type of specialization is available - hard skills category is not available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 098 ---------------------------///

                          print(
                              " ID - 098: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is not available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 099 ---------------------------///

                          print(
                              " ID - 099: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY != EMPTY -----------///
                    else {
                      // Person is available - job field is available - job sub field is not available - job specialization is available - type of specialization is available - hard skills category is available - is hard skills available?
                      totalScore = totalScore + 1;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is available - job sub field is not available - job specialization is available - type of specialization is available - hard skills category is available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is not available - job specialization is available - type of specialization is available - hard skills category is available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 100 ---------------------------///

                          print(
                              " ID - 100: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is available - hard skills is not available - level is available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 101 ---------------------------///

                          print(
                              " ID - 101: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is available - job sub field is not available - job specialization is available - type of specialization is available - hard skills category is available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is not available - job specialization is available - type of specialization is available - hard skills category is available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 102 ---------------------------///

                          print(
                              " ID - 102: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 103 ---------------------------///

                          print(
                              " ID - 103: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }
                  }
                }
              }
            }
          }

          ///----------- JOB SUB FIELD != EMPTY -----------///
          else {
            // Person is available - job field is available - job sub field is available - is job specialization available?
            totalScore = totalScore + 1;

            ///----------- JOB SPECIALIZATION = EMPTY -----------///
            if (jobSpecialization.isEmptyOrNull) {
              // Person is available - job field is available - job sub field is available - job specialization is not available - is hard skills available?
              totalScore = totalScore + 0;

              ///----------- HARD SKILLS LIST = EMPTY -----------///
              if (hardSkills!.isEmpty || hardSkills == null) {
                // Person is available - job field is available - job sub field is available - job specialization is not available - hard category skills is not available

                ///--------------------------- ID - 104 ---------------------------///

                print(
                    " ID - 104: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
              }

              ///----------- HARD SKILLS LIST != EMPTY -----------///
              else {
                // Person is available - job field is available - job sub field is available - job specialization is not available - hard category skills is available - is type of specialization available?

                for (int j = 0; j < hardSkills.length; j++) {
                  ///----------- HARD SKILLS LIST - TYPE OF SPECIALIZATION = EMPTY -----------///
                  if (hardSkills[j].typeOfSpecialization.isEmptyOrNull) {
                    // Person is available - job field is available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - is hard skills category available?
                    totalScore = totalScore + 1;

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY = EMPTY -----------///
                    if (hardSkills[j].skillCategory.isEmptyOrNull) {
                      // Person is available - job field is available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is not available - is hard skills available?
                      totalScore = totalScore + 0;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 105 ---------------------------///

                          print(
                              " ID - 105: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 106 ---------------------------///

                          print(
                              " ID - 106: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 107 ---------------------------///

                          print(
                              " ID - 107: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 108 ---------------------------///

                          print(
                              " ID - 108: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY != EMPTY -----------///
                    else {
                      // Person is available - job field is available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - is hard skills available?
                      totalScore = totalScore + 1;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 109 ---------------------------///

                          print(
                              " ID - 109: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 110 ---------------------------///

                          print(
                              " ID - 110: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 111 ---------------------------///

                          print(
                              " ID - 111: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is not available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 112 ---------------------------///

                          print(
                              " ID - 112: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }
                  }

                  ///----------- TYPE OF SPECIALIZATION != EMPTY -----------///
                  else {
                    // Person is available - job field is available - job sub field is available - job specialization is not available - type of specialization is available - is hard skills category available?
                    totalScore = totalScore + 1;

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY = EMPTY -----------///
                    if (hardSkills[j].skillCategory.isEmptyOrNull) {
                      // Person is available - job field is available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is not available - is hard skills available?
                      totalScore = totalScore + 0;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is not available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is not available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 113 ---------------------------///

                          print(
                              " ID - 113: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is not available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 114 ---------------------------///

                          print(
                              " ID - 114: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is not available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is not available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 115 ---------------------------///

                          print(
                              " ID - 115: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is not available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 116 ---------------------------///

                          print(
                              " ID - 116: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY != EMPTY -----------///
                    else {
                      // Person is available - job field is available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is available - is hard skills available?
                      totalScore = totalScore + 1;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 117 ---------------------------///

                          print(
                              " ID - 117: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 118 ---------------------------///

                          print(
                              " ID - 118: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 119 ---------------------------///

                          print(
                              " ID - 119: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is not available - type of specialization is available - hard skills category is available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 120 ---------------------------///

                          print(
                              " ID - 120: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }
                  }
                }
              }
            }

            ///----------- JOB SPECIALIZATION != EMPTY -----------///
            else {
              // Person is available - job field is available - job sub field not is available - job specialization is available - is hard skills available?
              totalScore = totalScore + 1;

              ///----------- HARD SKILLS LIST = EMPTY -----------///
              if (hardSkills!.isEmpty || hardSkills == null) {
                // Person is available - job field is available - job sub field is available - job specialization is available - hard category skills is not available

                ///--------------------------- ID - 121 ---------------------------///

                print(
                    " ID - 121: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
              }

              ///----------- HARD SKILLS LIST != EMPTY -----------///
              else {
                // Person is available - job field is available - job sub field is available - job specialization is available - hard category skills is available - is type of specialization available?

                for (int j = 0; j < hardSkills.length; j++) {
                  ///----------- HARD SKILLS LIST - TYPE OF SPECIALIZATION = EMPTY -----------///
                  if (hardSkills[j].typeOfSpecialization.isEmptyOrNull) {
                    // Person is available - job field is available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - is hard skills category available?
                    totalScore = totalScore + 0;

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY = EMPTY -----------///
                    if (hardSkills[j].skillCategory.isEmptyOrNull) {
                      // Person is available - job field is available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - is hard skills available?
                      totalScore = totalScore + 0;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 122 ---------------------------///

                          print(
                              " ID - 121: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 123 ---------------------------///

                          print(
                              " ID - 122: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 124 ---------------------------///

                          print(
                              " ID - 123: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is not available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 125 ---------------------------///

                          print(
                              " ID - 125: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY!= EMPTY -----------///
                    else {
                      // Person is available - job field is available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - is hard skills available?
                      totalScore = totalScore + 1;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 126 ---------------------------///

                          print(
                              " ID - 126: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 127 ---------------------------///

                          print(
                              " ID - 127: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 128 ---------------------------///

                          print(
                              " ID - 128: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is available - hard skills is not available -- type of specialization is not available - hard skills category is available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 129 ---------------------------///

                          print(
                              " ID - 129: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }
                  }

                  ///----------- TYPE OF SPECIALIZATION != EMPTY -----------///
                  else {
                    // Person is available - job field is available - job sub field is available - job specialization is available - type of specialization is available - is hard skills category available?
                    totalScore = totalScore + 1;

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY = EMPTY -----------///
                    if (hardSkills[j].skillCategory.isEmptyOrNull) {
                      // Person is available - job field is available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is not available - is hard skills available?
                      totalScore = totalScore + 0;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is not available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is not available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 130 ---------------------------///

                          print(
                              " ID - 130: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is not available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 131 ---------------------------///

                          print(
                              " ID - 131: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is not available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is not available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 132 ---------------------------///

                          print(
                              " ID - 132: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is not available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 133 ---------------------------///

                          print(
                              " ID - 133: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }

                    ///----------- HARD SKILLS LIST - SKILL CATEGORY != EMPTY -----------///
                    else {
                      // Person is available - job field is available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is available - is hard skills available?
                      totalScore = totalScore + 1;

                      ///----------- HARD SKILLS LIST - SKILL = EMPTY -----------///
                      if (hardSkills[j].skill.isEmptyOrNull) {
                        // Person is available - job field is available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is available - hard skills is not available - is level available?
                        totalScore = totalScore + 0;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is available - hard skills is not available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 134 ---------------------------///

                          print(
                              " ID - 134: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is available - hard skills is not available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 135 ---------------------------///

                          print(
                              " ID - 135: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }

                      ///----------- HARD SKILLS LIST - SKILL != EMPTY -----------///
                      else {
                        // Person is available - job field is available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is available - hard skills is available - is level available?
                        totalScore = totalScore + 1;

                        ///----------- HARD SKILLS LIST - SKILL LEVEL = EMPTY -----------///
                        if (hardSkills[j].level.isEmptyOrNull) {
                          // Person is available - job field is available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is available - hard skills is available - level is not available
                          totalScore = totalScore + 0;

                          ///--------------------------- ID - 136 ---------------------------///

                          print(
                              " ID - 136: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }

                        ///----------- HARD SKILLS LIST - SKILL LEVEL != EMPTY -----------///
                        else {
                          // Person is available - job field is available - job sub field is available - job specialization is available - type of specialization is available - hard skills category is available - hard skills is available - level is available
                          totalScore = totalScore + 1;

                          ///--------------------------- ID - 137 ---------------------------///

                          print(
                              " ID - 137: TOTAL SCORE = $totalScore  /  USER SCORE = $userScore");
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }*/
      }
    } else {
      if (endDate.isEmptyOrNull) {
        // Is person available from start date?
      } else {
        // Is person available from start date to end date?

        totalScore = totalScoreFunction(
          jobField: jobField == null ? null : jobField,
          jobSubField: jobSubField == null ? null : jobSubField,
          jobSpecialization: jobSpecialization == null ? null : jobSpecialization,
          hardSkills: hardSkills == null ? null : hardSkills,
        );

        userScore = userScoreFunction(
          selectedUser: allUsers.isEmpty ? null : allUsers[i],
          jobField: jobField == null ? null : jobField,
          jobSubField: jobSubField == null ? null : jobSubField,
          jobSpecialization: jobSpecialization == null ? null : jobSpecialization,
          hardSkills: hardSkills == null ? null : hardSkills,
        );

        userScorePercentage = (userScore / totalScore) * 100;

        if(userScorePercentage >= 60){
          allRecommendedUsers.add(allUsers[i]);
        } else {
          allRecommendedUsers;
        }
      }
    }
  }

  /*if (searchQuery.isEmptyOrNull) {
    if (sdgSelectedOption.isEmpty) {
      if (languageSelectedOption.isEmpty) {
        if (numberFilterSelectedOption == 'Choose One') {
          value = 0;
          maxValue = 0;
          minValue = 0;
          if (sentimentAnalysisFilterSelectedOption.isEmpty) {
            if (sourceFilterSelectedOption.isEmpty) {
              // no search field input, display all items
              return allRecommendedUsers;
            } else {
              return allRecommendedUsers
                  .where((element) =>
                  sourceFilterSelectedOption.contains(element.source!))
                  .toList();
            }
          } else {
            if (sourceFilterSelectedOption.isEmpty) {
              return allRecommendedUsers
                  .where((element) => sentimentAnalysisFilterSelectedOption
                  .contains(element.sentimentAnalysis!))
                  .toList();
            } else {
              return allRecommendedUsers
                  .where((element) =>
              sourceFilterSelectedOption.contains(element.source!) &&
                  sentimentAnalysisFilterSelectedOption
                      .contains(element.sentimentAnalysis!))
                  .toList();
            }
          }
        } else {
          if (sentimentAnalysisFilterSelectedOption.isEmpty) {
            if (sourceFilterSelectedOption.isEmpty) {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                    element.repetition.isBetween(minValue, maxValue))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) => element.repetition!.isEqual(value))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.repetition!.isEqual(value) == false)
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where(
                        (element) => element.repetition!.isGreaterThan(value))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) => (element.repetition!.isEqual(value) ||
                    element.repetition!.isGreaterThan(value)))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) => element.repetition!.isLowerThan(value))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) => (element.repetition!.isEqual(value) ||
                    element.repetition!.isLowerThan(value)))
                    .toList();
              }
            } else {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.repetition.isBetween(minValue, maxValue) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.repetition!.isEqual(value) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.repetition!.isEqual(value) == false &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.repetition!.isGreaterThan(value) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                (element.repetition!.isEqual(value) ||
                    element.repetition!.isGreaterThan(value)) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.repetition!.isLowerThan(value) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                (element.repetition!.isEqual(value) ||
                    element.repetition!.isLowerThan(value)) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              }
            }
          } else {
            if (sourceFilterSelectedOption.isEmpty) {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.repetition.isBetween(minValue, maxValue) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.repetition!.isEqual(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.repetition!.isEqual(value) == false &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.repetition!.isGreaterThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                (element.repetition!.isEqual(value) ||
                    element.repetition!.isGreaterThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.repetition!.isLowerThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                (element.repetition!.isEqual(value) ||
                    element.repetition!.isLowerThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              }
            } else {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.repetition.isBetween(minValue, maxValue) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.repetition!.isEqual(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.repetition!.isEqual(value) == false &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.repetition!.isGreaterThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                (element.repetition!.isEqual(value) ||
                    element.repetition!.isGreaterThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.repetition!.isLowerThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                (element.repetition!.isEqual(value) ||
                    element.repetition!.isLowerThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              }
            }
          }
        }
      } else {
        if (numberFilterSelectedOption == 'Choose One') {
          value = 0;
          maxValue = 0;
          minValue = 0;
          if (sentimentAnalysisFilterSelectedOption.isEmpty) {
            if (sourceFilterSelectedOption.isEmpty) {
              return allRecommendedUsers
                  .where((element) =>
                  languageSelectedOption.contains(element.language!))
                  .toList();
            } else {
              return allRecommendedUsers
                  .where((element) =>
              languageSelectedOption.contains(element.language!) &&
                  sourceFilterSelectedOption.contains(element.source!))
                  .toList();
            }
          } else {
            if (sourceFilterSelectedOption.isEmpty) {
              return allRecommendedUsers
                  .where((element) =>
              languageSelectedOption.contains(element.language!) &&
                  sentimentAnalysisFilterSelectedOption
                      .contains(element.sentimentAnalysis!))
                  .toList();
            } else {
              return allRecommendedUsers
                  .where((element) =>
              languageSelectedOption.contains(element.language!) &&
                  sourceFilterSelectedOption.contains(element.source!) &&
                  sentimentAnalysisFilterSelectedOption
                      .contains(element.sentimentAnalysis!))
                  .toList();
            }
          }
        } else {
          if (sentimentAnalysisFilterSelectedOption.isEmpty) {
            if (sourceFilterSelectedOption.isEmpty) {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    element.repetition.isBetween(minValue, maxValue))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) == false)
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isGreaterThan(value))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isLowerThan(value))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)))
                    .toList();
              }
            } else {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    element.repetition.isBetween(minValue, maxValue) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) == false &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isGreaterThan(value) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isLowerThan(value) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              }
            }
          } else {
            if (sourceFilterSelectedOption.isEmpty) {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    element.repetition.isBetween(minValue, maxValue) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) == false &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isGreaterThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isLowerThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              }
            } else {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    element.repetition.isBetween(minValue, maxValue) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) == false &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isGreaterThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isLowerThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              }
            }
          }
        }
      }
    } else {
      if (languageSelectedOption.isEmpty) {
        if (numberFilterSelectedOption == 'Choose One') {
          value = 0;
          maxValue = 0;
          minValue = 0;
          if (sentimentAnalysisFilterSelectedOption.isEmpty) {
            if (sourceFilterSelectedOption.isEmpty) {
              return allRecommendedUsers
                  .where((element) =>
                  sdgSelectedOption.contains(element.sdgTargeted!))
                  .toList();
            } else {
              return allRecommendedUsers
                  .where((element) =>
              sdgSelectedOption.contains(element.sdgTargeted!) &&
                  sourceFilterSelectedOption.contains(element.source!))
                  .toList();
            }
          } else {
            if (sourceFilterSelectedOption.isEmpty) {
              return allRecommendedUsers
                  .where((element) =>
              sdgSelectedOption.contains(element.sdgTargeted!) &&
                  sentimentAnalysisFilterSelectedOption
                      .contains(element.sentimentAnalysis!))
                  .toList();
            } else {
              return allRecommendedUsers
                  .where((element) =>
              sdgSelectedOption.contains(element.sdgTargeted!) &&
                  sourceFilterSelectedOption.contains(element.source!) &&
                  sentimentAnalysisFilterSelectedOption
                      .contains(element.sentimentAnalysis!))
                  .toList();
            }
          }
        } else {
          if (sentimentAnalysisFilterSelectedOption.isEmpty) {
            if (sourceFilterSelectedOption.isEmpty) {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition.isBetween(minValue, maxValue))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isEqual(value))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isEqual(value) == false)
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isGreaterThan(value))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isLowerThan(value))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)))
                    .toList();
              }
            } else {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition.isBetween(minValue, maxValue) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isEqual(value) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isEqual(value) == false &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isGreaterThan(value) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isLowerThan(value) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              }
            }
          } else {
            if (sourceFilterSelectedOption.isEmpty) {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition.isBetween(minValue, maxValue) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isEqual(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isEqual(value) == false &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isGreaterThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isLowerThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              }
            } else {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition.isBetween(minValue, maxValue) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isEqual(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isEqual(value) == false &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isGreaterThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isLowerThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              }
            }
          }
        }
      } else {
        if (numberFilterSelectedOption == 'Choose One') {
          value = 0;
          maxValue = 0;
          minValue = 0;
          if (sentimentAnalysisFilterSelectedOption.isEmpty) {
            if (sourceFilterSelectedOption.isEmpty) {
              return allRecommendedUsers
                  .where((IssueOfMonthDataModel element) =>
              sdgSelectedOption.contains(element.sdgTargeted!) &&
                  languageSelectedOption.contains(element.language!))
                  .toList();
            } else {
              return allRecommendedUsers
                  .where((IssueOfMonthDataModel element) =>
              sdgSelectedOption.contains(element.sdgTargeted!) &&
                  languageSelectedOption.contains(element.language!) &&
                  sourceFilterSelectedOption.contains(element.source!))
                  .toList();
            }
          } else {
            if (sourceFilterSelectedOption.isEmpty) {
              return allRecommendedUsers
                  .where((IssueOfMonthDataModel element) =>
              sdgSelectedOption.contains(element.sdgTargeted!) &&
                  languageSelectedOption.contains(element.language!) &&
                  sentimentAnalysisFilterSelectedOption
                      .contains(element.sentimentAnalysis!))
                  .toList();
            } else {
              return allRecommendedUsers
                  .where((IssueOfMonthDataModel element) =>
              sdgSelectedOption.contains(element.sdgTargeted!) &&
                  languageSelectedOption.contains(element.language!) &&
                  sourceFilterSelectedOption.contains(element.source!) &&
                  sentimentAnalysisFilterSelectedOption
                      .contains(element.sentimentAnalysis!))
                  .toList();
            }
          }
        } else {
          if (sentimentAnalysisFilterSelectedOption.isEmpty) {
            if (sourceFilterSelectedOption.isEmpty) {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition.isBetween(minValue, maxValue))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) == false)
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isGreaterThan(value))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isLowerThan(value))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)))
                    .toList();
              }
            } else {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition.isBetween(minValue, maxValue) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) == false &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isGreaterThan(value) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isLowerThan(value) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              }
            }
          } else {
            if (sourceFilterSelectedOption.isEmpty) {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition.isBetween(minValue, maxValue) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) == false &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isGreaterThan(value))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isLowerThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              }
            } else {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    element.repetition.isBetween(minValue, maxValue) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) == false &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isGreaterThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isLowerThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              }
            }
          }
        }
      }
    }
  }
  else {
    // allRecommendedUsers = allRecommendedUsers.where((element) => element.issueString!.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    if (sdgSelectedOption.isEmpty) {
      if (languageSelectedOption.isEmpty) {
        if (numberFilterSelectedOption == 'Choose One') {
          value = 0;
          maxValue = 0;
          minValue = 0;
          if (sentimentAnalysisFilterSelectedOption.isEmpty) {
            if (sourceFilterSelectedOption.isEmpty) {
              // no search field input, display all items
              return allRecommendedUsers
                  .where((element) => element.issueString!
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
                  .toList();
            } else {
              return allRecommendedUsers
                  .where((element) =>
              element.issueString!
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) &&
                  sourceFilterSelectedOption.contains(element.source!))
                  .toList();
            }
          } else {
            if (sourceFilterSelectedOption.isEmpty) {
              return allRecommendedUsers
                  .where((element) =>
              element.issueString!
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) &&
                  sentimentAnalysisFilterSelectedOption
                      .contains(element.sentimentAnalysis!))
                  .toList();
            } else {
              return allRecommendedUsers
                  .where((element) =>
              element.issueString!
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) &&
                  sourceFilterSelectedOption.contains(element.source!) &&
                  sentimentAnalysisFilterSelectedOption
                      .contains(element.sentimentAnalysis!))
                  .toList();
            }
          }
        } else {
          if (sentimentAnalysisFilterSelectedOption.isEmpty) {
            if (sourceFilterSelectedOption.isEmpty) {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    element.repetition.isBetween(minValue, maxValue))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    element.repetition!.isEqual(value))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    element.repetition!.isEqual(value) == false)
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    element.repetition!.isGreaterThan(value))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    element.repetition!.isLowerThan(value))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)))
                    .toList();
              }
            } else {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    element.repetition.isBetween(minValue, maxValue) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    element.repetition!.isEqual(value) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    element.repetition!.isEqual(value) == false &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    element.repetition!.isGreaterThan(value) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    element.repetition!.isLowerThan(value) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              }
            }
          } else {
            if (sourceFilterSelectedOption.isEmpty) {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    element.repetition.isBetween(minValue, maxValue) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    element.repetition!.isEqual(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    element.repetition!.isEqual(value) == false &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    element.repetition!.isGreaterThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    element.repetition!.isLowerThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              }
            } else {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    element.repetition.isBetween(minValue, maxValue) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    element.repetition!.isEqual(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    element.repetition!.isEqual(value) == false &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    element.repetition!.isGreaterThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    element.repetition!.isLowerThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              }
            }
          }
        }
      } else {
        if (numberFilterSelectedOption == 'Choose One') {
          value = 0;
          maxValue = 0;
          minValue = 0;
          if (sentimentAnalysisFilterSelectedOption.isEmpty) {
            if (sourceFilterSelectedOption.isEmpty) {
              return allRecommendedUsers
                  .where((element) =>
              element.issueString!
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) &&
                  languageSelectedOption.contains(element.language!))
                  .toList();
            } else {
              return allRecommendedUsers
                  .where((element) =>
              element.issueString!
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) &&
                  languageSelectedOption.contains(element.language!) &&
                  sourceFilterSelectedOption.contains(element.source!))
                  .toList();
            }
          } else {
            if (sourceFilterSelectedOption.isEmpty) {
              return allRecommendedUsers
                  .where((element) =>
              element.issueString!
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) &&
                  languageSelectedOption.contains(element.language!) &&
                  sentimentAnalysisFilterSelectedOption
                      .contains(element.sentimentAnalysis!))
                  .toList();
            } else {
              return allRecommendedUsers
                  .where((element) =>
              element.issueString!
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) &&
                  languageSelectedOption.contains(element.language!) &&
                  sourceFilterSelectedOption.contains(element.source!) &&
                  sentimentAnalysisFilterSelectedOption
                      .contains(element.sentimentAnalysis!))
                  .toList();
            }
          }
        } else {
          if (sentimentAnalysisFilterSelectedOption.isEmpty) {
            if (sourceFilterSelectedOption.isEmpty) {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition.isBetween(minValue, maxValue))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) == false)
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isGreaterThan(value))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isLowerThan(value))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)))
                    .toList();
              }
            } else {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition.isBetween(minValue, maxValue) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) == false &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isGreaterThan(value) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isLowerThan(value) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              }
            }
          } else {
            if (sourceFilterSelectedOption.isEmpty) {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition.isBetween(minValue, maxValue) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) == false &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isGreaterThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isLowerThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              }
            } else {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition.isBetween(minValue, maxValue) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) == false &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isGreaterThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isLowerThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              }
            }
          }
        }
      }
    } else {
      if (languageSelectedOption.isEmpty) {
        if (numberFilterSelectedOption == 'Choose One') {
          value = 0;
          maxValue = 0;
          minValue = 0;
          if (sentimentAnalysisFilterSelectedOption.isEmpty) {
            if (sourceFilterSelectedOption.isEmpty) {
              return allRecommendedUsers
                  .where((element) =>
              element.issueString!
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) &&
                  sdgSelectedOption.contains(element.sdgTargeted!))
                  .toList();
            } else {
              return allRecommendedUsers
                  .where((element) =>
              element.issueString!
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) &&
                  sdgSelectedOption.contains(element.sdgTargeted!) &&
                  sourceFilterSelectedOption.contains(element.source!))
                  .toList();
            }
          } else {
            if (sourceFilterSelectedOption.isEmpty) {
              return allRecommendedUsers
                  .where((element) =>
              element.issueString!
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) &&
                  sdgSelectedOption.contains(element.sdgTargeted!) &&
                  sentimentAnalysisFilterSelectedOption
                      .contains(element.sentimentAnalysis!))
                  .toList();
            } else {
              return allRecommendedUsers
                  .where((element) =>
              element.issueString!
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) &&
                  sdgSelectedOption.contains(element.sdgTargeted!) &&
                  sourceFilterSelectedOption.contains(element.source!) &&
                  sentimentAnalysisFilterSelectedOption
                      .contains(element.sentimentAnalysis!))
                  .toList();
            }
          }
        } else {
          if (sentimentAnalysisFilterSelectedOption.isEmpty) {
            if (sourceFilterSelectedOption.isEmpty) {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition.isBetween(minValue, maxValue))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isEqual(value))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isEqual(value) == false)
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isGreaterThan(value))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isLowerThan(value))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)))
                    .toList();
              }
            } else {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition.isBetween(minValue, maxValue) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isEqual(value) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isEqual(value) == false &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isGreaterThan(value) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isLowerThan(value) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              }
            }
          } else {
            if (sourceFilterSelectedOption.isEmpty) {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition.isBetween(minValue, maxValue) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isEqual(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isEqual(value) == false &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isGreaterThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isLowerThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              }
            } else {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition.isBetween(minValue, maxValue) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isEqual(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isEqual(value) == false &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isGreaterThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    element.repetition!.isLowerThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              }
            }
          }
        }
      } else {
        if (numberFilterSelectedOption == 'Choose One') {
          value = 0;
          maxValue = 0;
          minValue = 0;
          if (sentimentAnalysisFilterSelectedOption.isEmpty) {
            if (sourceFilterSelectedOption.isEmpty) {
              return allRecommendedUsers
                  .where((IssueOfMonthDataModel element) =>
              element.issueString!
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) &&
                  sdgSelectedOption.contains(element.sdgTargeted!) &&
                  languageSelectedOption.contains(element.language!))
                  .toList();
            } else {
              return allRecommendedUsers
                  .where((IssueOfMonthDataModel element) =>
              element.issueString!
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) &&
                  sdgSelectedOption.contains(element.sdgTargeted!) &&
                  languageSelectedOption.contains(element.language!) &&
                  sourceFilterSelectedOption.contains(element.source!))
                  .toList();
            }
          } else {
            if (sourceFilterSelectedOption.isEmpty) {
              return allRecommendedUsers
                  .where((IssueOfMonthDataModel element) =>
              element.issueString!
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) &&
                  sdgSelectedOption.contains(element.sdgTargeted!) &&
                  languageSelectedOption.contains(element.language!) &&
                  sentimentAnalysisFilterSelectedOption
                      .contains(element.sentimentAnalysis!))
                  .toList();
            } else {
              return allRecommendedUsers
                  .where((IssueOfMonthDataModel element) =>
              element.issueString!
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) &&
                  sdgSelectedOption.contains(element.sdgTargeted!) &&
                  languageSelectedOption.contains(element.language!) &&
                  sourceFilterSelectedOption.contains(element.source!) &&
                  sentimentAnalysisFilterSelectedOption
                      .contains(element.sentimentAnalysis!))
                  .toList();
            }
          }
        } else {
          if (sentimentAnalysisFilterSelectedOption.isEmpty) {
            if (sourceFilterSelectedOption.isEmpty) {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition.isBetween(minValue, maxValue))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) == false)
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isGreaterThan(value))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isLowerThan(value))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)))
                    .toList();
              }
            } else {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition.isBetween(minValue, maxValue) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) == false &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isGreaterThan(value) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isLowerThan(value) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              }
            }
          } else {
            if (sourceFilterSelectedOption.isEmpty) {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition.isBetween(minValue, maxValue) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) == false &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isGreaterThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isLowerThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    sdgSelectedOption.contains(element.sdgTargeted!) &&
                    languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis))
                    .toList();
              }
            } else {
              if (numberFilterSelectedOption == "Between") {
                value = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition.isBetween(minValue, maxValue) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Equals") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Does NOT Equal") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isEqual(value) == false &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Greater Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isGreaterThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Greater Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isGreaterThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption == "Less Than") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    element.repetition!.isLowerThan(value) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              } else if (numberFilterSelectedOption ==
                  "Less Than or Equal To") {
                maxValue = 0;
                minValue = 0;
                return allRecommendedUsers
                    .where((element) =>
                element.issueString!
                    .toLowerCase()
                    .contains(searchQuery.toLowerCase()) &&
                    languageSelectedOption.contains(element.language!) &&
                    (element.repetition!.isEqual(value) ||
                        element.repetition!.isLowerThan(value)) &&
                    sentimentAnalysisFilterSelectedOption
                        .contains(element.sentimentAnalysis) &&
                    sourceFilterSelectedOption.contains(element.source))
                    .toList();
              }
            }
          }
        }
      }
    }
  }*/
  return allRecommendedUsers;
}

double totalScoreFunction({
  String? jobField,
  String? jobSubField,
  String? jobSpecialization,
  List<SkillModel>? hardSkills,
}) {
  double totalScore = 0;

  if (jobField != null) {
    totalScore = totalScore + 1;
  } else {
    totalScore = totalScore + 0;
  }

  if (jobSubField != null) {
    totalScore = totalScore + 1;
  } else {
    totalScore = totalScore + 0;
  }

  if (jobSpecialization != null) {
    totalScore = totalScore + 1;
  } else {
    totalScore = totalScore + 0;
  }

  if (hardSkills!.isNotEmpty || hardSkills != null) {
    for (int j = 0; j < hardSkills.length; j++) {
      if (!hardSkills[j].typeOfSpecialization.isEmptyOrNull) {
        totalScore = totalScore + 1;
      } else {
        totalScore = totalScore + 0;
      }

      if (!hardSkills[j].skillCategory.isEmptyOrNull) {
        totalScore = totalScore + 1;
      } else {
        totalScore = totalScore + 0;
      }

      if (!hardSkills[j].skill.isEmptyOrNull) {
        totalScore = totalScore + 1;
      } else {
        totalScore = totalScore + 0;
      }

      if (!hardSkills[j].level.isEmptyOrNull) {
        totalScore = totalScore + 1;
      } else {
        totalScore = totalScore + 0;
      }
    }
  } else {
    totalScore = totalScore + 0;
  }

  return totalScore;
}

double userScoreFunction({
  UserModel? selectedUser,
  String? jobField,
  String? jobSubField,
  String? jobSpecialization,
  List<SkillModel>? hardSkills,
}) {
  double userScore = 0;
  int equalTypeOfSpecialization = 0;

  if (hardSkills!.isNotEmpty || selectedUser!.hardSkills!.isNotEmpty) {
    for (int i = 0; i < selectedUser!.hardSkills!.length; i++) {
      for (int j = 0; j < hardSkills.length; j++) {
        if (hardSkills[j].typeOfSpecialization != null &&
            hardSkills[j].skillCategory != null &&
            hardSkills[j].skill != null &&
            hardSkills[j].level != null) {
          if (selectedUser.hardSkills![i].typeOfSpecialization ==
              hardSkills[j].typeOfSpecialization) {
            equalTypeOfSpecialization = equalTypeOfSpecialization + 1;

            if (selectedUser.hardSkills![i].skillCategory ==
                hardSkills[j].skillCategory) {
              if (selectedUser.hardSkills![i].skill == hardSkills[j].skill) {
                if (selectedUser.hardSkills![i].level == hardSkills[j].level) {
                  ///--------------------------- OPTION 1 - OUTPUT 1 ---------------------------///
                  // OUTPUT: Type of Specialization Equal - Skill Category Equal - Skill Equal - Level Equal - SCORE = 4

                  userScore = userScore + 4;
                  // print("STAGE 4: selectedUser.hardSkills$i  hardSkills $j : ${userScore}");
                } else {
                  ///--------------------------- OPTION 1 - OUTPUT 2 ---------------------------///
                  // OUTPUT: Type of Specialization Equal - Skill Category Equal - Skill Equal - Level NOT Equal - SCORE = 3

                  userScore = userScore + 3;
                }
              } else {
                if (selectedUser.hardSkills![i].level == hardSkills[j].level) {
                  ///--------------------------- OPTION 1 - OUTPUT 3 ---------------------------///
                  // OUTPUT: Type of Specialization Equal - Skill Category Equal - Skill NOT Equal - Level Equal - SCORE = 2

                  userScore = userScore + 2;
                } else {
                  ///--------------------------- OPTION 1 - OUTPUT 4 ---------------------------///
                  // OUTPUT: Type of Specialization Equal - Skill Category Equal - Skill NOT Equal - Level NOT Equal - SCORE = 2

                  userScore = userScore + 2;
                }
              }
            } else {
              if (selectedUser.hardSkills![i].skill == hardSkills[j].skill) {
                if (selectedUser.hardSkills![i].level == hardSkills[j].level) {
                  ///--------------------------- OPTION 1 - OUTPUT 5 ---------------------------///
                  // OUTPUT: Type of Specialization Equal - Skill Category NOT Equal - Skill Equal - Level Equal - SCORE = 1

                  userScore = userScore + 1;
                } else {
                  ///--------------------------- OPTION 1 - OUTPUT 6 ---------------------------///
                  // OUTPUT: Type of Specialization Equal - Skill Category NOT Equal - Skill Equal - Level NOT Equal - SCORE = 1

                  userScore = userScore + 0;
                }
              } else {
                if (selectedUser.hardSkills![i].level == hardSkills[j].level) {
                  ///--------------------------- OPTION 1 - OUTPUT 7 ---------------------------///
                  // OUTPUT: Type of Specialization Equal - Skill Category NOT Equal - Skill NOT Equal - Level Equal - SCORE = 4

                  userScore = userScore + 0;
                } else {
                  ///--------------------------- OPTION 1 - OUTPUT 8 ---------------------------///
                  // OUTPUT: Type of Specialization Equal - Skill Category NOT Equal - Skill NOT Equal - Level NOT Equal - SCORE = 4

                  userScore = userScore + 0;
                }
              }
            }
          } else {
            userScore = userScore + 0;

            if (selectedUser.hardSkills![i].skillCategory ==
                hardSkills[j].skillCategory) {
              userScore = userScore + 0;

              if (selectedUser.hardSkills![i].skill == hardSkills[j].skill) {
                if (selectedUser.hardSkills![i].level == hardSkills[j].level) {
                  ///--------------------------- OPTION 1 - OUTPUT 9 ---------------------------///
                  // OUTPUT: Type of Specialization NOT Equal - Skill Category Equal - Skill Equal - Level Equal - SCORE = 0

                  userScore = userScore + 0;
                } else {
                  ///--------------------------- OPTION 1 - OUTPUT 10 ---------------------------///
                  // OUTPUT: Type of Specialization NOT Equal - Skill Category Equal - Skill Equal - Level NOT Equal - SCORE = 0

                  userScore = userScore + 0;
                }
              } else {
                if (selectedUser.hardSkills![i].level == hardSkills[j].level) {
                  ///--------------------------- OPTION 1 - OUTPUT 11 ---------------------------///
                  // OUTPUT: Type of Specialization NOT Equal - Skill Category Equal - Skill NOT Equal - Level Equal - SCORE = 0

                  userScore = userScore + 0;
                } else {
                  ///--------------------------- OPTION 1 - OUTPUT 12 ---------------------------///
                  // OUTPUT: Type of Specialization NOT Equal - Skill Category Equal - Skill NOT Equal - Level NOT Equal - SCORE = 0

                  userScore = userScore + 0;
                }
              }
            } else {
              if (selectedUser.hardSkills![i].skill == hardSkills[j].skill) {
                if (selectedUser.hardSkills![i].level == hardSkills[j].level) {
                  ///--------------------------- OPTION 1 - OUTPUT 13 ---------------------------///
                  // OUTPUT: Type of Specialization NOT Equal - Skill Category NOT Equal - Skill Equal - Level Equal - SCORE = 0

                  userScore = userScore + 0;
                } else {
                  ///--------------------------- OPTION 1 - OUTPUT 14 ---------------------------///
                  // OUTPUT: Type of Specialization NOT Equal - Skill Category NOT Equal - Skill Equal - Level NOT Equal - SCORE = 0

                  userScore = userScore + 0;
                }
              } else {
                if (selectedUser.hardSkills![i].level == hardSkills[j].level) {
                  ///--------------------------- OPTION 1 - OUTPUT 15 ---------------------------///
                  // OUTPUT: Type of Specialization NOT Equal - Skill Category NOT Equal - Skill NOT Equal - Level Equal - SCORE = 0

                  userScore = userScore + 0;
                } else {
                  ///--------------------------- OPTION 1 - OUTPUT 16 ---------------------------///
                  // OUTPUT: Type of Specialization NOT Equal - Skill Category NOT Equal - Skill NOT Equal - Level NOT Equal - SCORE = 0

                  userScore = userScore + 0;
                }
              }
            }
          }
        } else if (hardSkills[j].typeOfSpecialization != null &&
            hardSkills[j].skillCategory != null &&
            hardSkills[j].skill != null &&
            hardSkills[j].level == null) {
          if (selectedUser.hardSkills![i].typeOfSpecialization ==
              hardSkills[j].typeOfSpecialization) {
            equalTypeOfSpecialization = equalTypeOfSpecialization + 1;

            if (selectedUser.hardSkills![i].skillCategory ==
                hardSkills[j].skillCategory) {
              if (selectedUser.hardSkills![i].skill == hardSkills[j].skill) {
                ///--------------------------- OPTION 2 - OUTPUT 1 ---------------------------///
                // OUTPUT: Type of Specialization Equal - Skill Category Equal - Skill Equal - SCORE = 3

                userScore = userScore + 3;
              } else {
                ///--------------------------- OPTION 2 - OUTPUT 2 ---------------------------///
                // OUTPUT: Type of Specialization Equal - Skill Category Equal - Skill NOT Equal - SCORE = 2

                userScore = userScore + 2;
              }
            } else {
              if (selectedUser.hardSkills![i].skill == hardSkills[j].skill) {
                ///--------------------------- OPTION 2 - OUTPUT 3 ---------------------------///
                // OUTPUT: Type of Specialization Equal - Skill Category NOT Equal - Skill Equal - SCORE = 1

                userScore = userScore + 1;
              } else {
                ///--------------------------- OPTION 2 - OUTPUT 4 ---------------------------///
                // OUTPUT: Type of Specialization Equal - Skill Category NOT Equal - Skill NOT Equal - SCORE = 1

                userScore = userScore + 1;
              }
            }
          } else {
            if (selectedUser.hardSkills![i].skillCategory ==
                hardSkills[j].skillCategory) {
              if (selectedUser.hardSkills![i].skill == hardSkills[j].skill) {
                ///--------------------------- OPTION 2 - OUTPUT 5 ---------------------------///
                // OUTPUT: Type of Specialization NOT Equal - Skill Category Equal - Skill Equal - SCORE = 0

                userScore = userScore + 0;
              } else {
                ///--------------------------- OPTION 2 - OUTPUT 6 ---------------------------///
                // OUTPUT: Type of Specialization NOT Equal - Skill Category Equal - Skill NOT Equal - SCORE = 0

                userScore = userScore + 0;
              }
            } else {
              userScore = userScore + 0;

              if (selectedUser.hardSkills![i].skill == hardSkills[j].skill) {
                ///--------------------------- OPTION 2 - OUTPUT 7 ---------------------------///
                // OUTPUT: Type of Specialization NOT Equal - Skill Category NOT Equal - Skill Equal - SCORE = 0

                userScore = userScore + 0;
              } else {
                ///--------------------------- OPTION 2 - OUTPUT 8 ---------------------------///
                // OUTPUT: Type of Specialization NOT Equal - Skill Category NOT Equal - Skill NOT Equal - SCORE = 0

                userScore = userScore + 0;
              }
            }
          }
        } else if (hardSkills[j].typeOfSpecialization != null &&
            hardSkills[j].skillCategory == null &&
            hardSkills[j].skill != null &&
            hardSkills[j].level != null) {
          if (selectedUser.hardSkills![i].typeOfSpecialization ==
              hardSkills[j].typeOfSpecialization) {
            equalTypeOfSpecialization = equalTypeOfSpecialization + 1;

            if (selectedUser.hardSkills![i].skill == hardSkills[j].skill) {
              if (selectedUser.hardSkills![i].level == hardSkills[j].level) {
                ///--------------------------- OPTION 3 - OUTPUT 1 ---------------------------///
                // OUTPUT: Type of Specialization Equal - Skill Equal - Level Equal - SCORE = 3

                userScore = userScore + 3;
              } else {
                ///--------------------------- OPTION 3 - OUTPUT 2 ---------------------------///
                // OUTPUT: Type of Specialization Equal - Skill Equal - Level NOT Equal - SCORE = 2

                userScore = userScore + 2;
              }
            } else {
              if (selectedUser.hardSkills![i].level == hardSkills[j].level) {
                ///--------------------------- OPTION 3 - OUTPUT 3 ---------------------------///
                // OUTPUT: Type of Specialization Equal - Skill NOT Equal - Level Equal - SCORE = 1

                userScore = userScore + 1;
              } else {
                ///--------------------------- OPTION 3 - OUTPUT 4 ---------------------------///
                // OUTPUT: Type of Specialization Equal - Skill NOT Equal - Level NOT Equal - SCORE = 1

                userScore = userScore + 1;
              }
            }
          } else {
            if (selectedUser.hardSkills![i].skill == hardSkills[j].skill) {
              if (selectedUser.hardSkills![i].level == hardSkills[j].level) {
                ///--------------------------- OPTION 3 - OUTPUT 5 ---------------------------///
                // OUTPUT: Type of Specialization NOT Equal - Skill Equal - Level Equal - SCORE = 0

                userScore = userScore + 0;
              } else {
                ///--------------------------- OPTION 3 - OUTPUT 6 ---------------------------///
                // OUTPUT: Type of Specialization NOT Equal - Skill Equal - Level NOT Equal - SCORE = 0

                userScore = userScore + 0;
              }
            } else {
              if (selectedUser.hardSkills![i].level == hardSkills[j].level) {
                ///--------------------------- OPTION 3 - OUTPUT 7 ---------------------------///
                // OUTPUT: Type of Specialization NOT Equal - Skill NOT Equal - Level Equal - SCORE = 0

                userScore = userScore + 0;
              } else {
                ///--------------------------- OPTION 3 - OUTPUT 8 ---------------------------///
                // OUTPUT: Type of Specialization NOT Equal - Skill NOT Equal - Level NOT Equal - SCORE = 0

                userScore = userScore + 0;
              }
            }
          }
        } else if (hardSkills[j].typeOfSpecialization != null &&
            hardSkills[j].skillCategory == null &&
            hardSkills[j].skill != null &&
            hardSkills[j].level == null) {
          if (selectedUser.hardSkills![i].typeOfSpecialization ==
              hardSkills[j].typeOfSpecialization) {
            equalTypeOfSpecialization = equalTypeOfSpecialization + 1;

            if (selectedUser.hardSkills![i].skill == hardSkills[j].skill) {
              ///--------------------------- OPTION 4 - OUTPUT 1 ---------------------------///
              // OUTPUT: Type of Specialization Equal - Skill Equal - SCORE = 2

              userScore = userScore + 2;
            } else {
              ///--------------------------- OPTION 4 - OUTPUT 2 ---------------------------///
              // OUTPUT: Type of Specialization Equal - Skill NOT Equal - SCORE = 3

              userScore = userScore + 1;
            }
          } else {
            if (selectedUser.hardSkills![i].skill == hardSkills[j].skill) {
              ///--------------------------- OPTION 4 - OUTPUT 3 ---------------------------///
              // OUTPUT: Type of Specialization NOT Equal - Skill Equal - SCORE = 0

              userScore = userScore + 0;
            } else {
              ///--------------------------- OPTION 4 - OUTPUT 4 ---------------------------///
              // OUTPUT: Type of Specialization NOT Equal - Skill NOT Equal - SCORE = 0

              userScore = userScore + 0;
            }
          }
        } else {
          userScore = userScore + 0;
        }
      }
    }
  } else {
    userScore = userScore + 0;
  }

  if (jobField != null || selectedUser.jobField != null) {
    if (selectedUser.jobField == jobField) {
      userScore = userScore + 1;
    } else if (selectedUser.jobField != jobField &&
        equalTypeOfSpecialization > 0) {
      userScore = userScore + 0.5;
    } else {
      userScore = userScore + 0;
    }
  } else {
    userScore = userScore + 0;
  }

  if (jobSubField != null || selectedUser.jobSubField != null) {
    if (selectedUser.jobSubField == jobSubField) {
      userScore = userScore + 1;
    } else if (selectedUser.jobSubField != jobSubField &&
        equalTypeOfSpecialization > 0) {
      userScore = userScore + 0.5;
    } else {
      userScore = userScore + 0;
    }
  } else {
    userScore = userScore + 0;
  }

  if (jobSpecialization != null ||
      selectedUser.jobSpecialization != null) {
    if (selectedUser.jobSpecialization == jobSpecialization) {
      userScore = userScore + 1;
    } else if (selectedUser.jobSpecialization != jobSpecialization &&
        equalTypeOfSpecialization > 0) {
      userScore = userScore + 0.5;
    } else {
      userScore = userScore + 0;
    }
  } else {
    userScore = userScore + 0;
  }

  return userScore;
}
