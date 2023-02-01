import 'package:nb_utils/nb_utils.dart';
import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

List<RecommendedUserModel> recommendationSystemFunction({
  List<UserModel>? allUsers,
  String? projectName,
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
  List<UserModel> allRecommendedUsersInformation = <UserModel>[];
  List<RecommendedUserModel> allRecommendedUsers = <RecommendedUserModel>[];

  double totalScore = 0;
  double totalHardScore = 0;

  double userScore = 0;
  double userJobFieldScore = 0;
  double userJobSubFieldScore = 0;
  double userJobSpecializationScore = 0;
  double userHardSkillsScore = 0;
  double userScorePercentage = 0;

  for (int i = 0; i < allUsers!.length; i++) {
    if (startDate.isEmptyOrNull) {
      // Is person available in general?
      if (allUsers[i].availability == false) {
        ///--------------------------- ID - 001 ---------------------------///
        // OUTPUT: Person is not available - DO NOT ADD TO RECOMMENDATIONS
        totalScore = 0;
        userScore = 0;
        allRecommendedUsersInformation = allRecommendedUsersInformation;
        allRecommendedUsers = allRecommendedUsers;
      } else {
        // Person is available - is job field available?

        totalScore = totalScoreFunction(
          jobField: jobField,
          jobSubField: jobSubField,
          jobSpecialization: jobSpecialization,
          hardSkills: hardSkills,
        )[0];

        totalHardScore = totalScoreFunction(
          jobField: jobField,
          jobSubField: jobSubField,
          jobSpecialization: jobSpecialization,
          hardSkills: hardSkills,
        )[1];

        userScore = userScoreFunction(
          selectedUser: allUsers.isEmpty ? null : allUsers[i],
          jobField: jobField,
          jobSubField: jobSubField,
          jobSpecialization: jobSpecialization,
          hardSkills: hardSkills,
        )[0];
        userJobFieldScore = userScoreFunction(
          selectedUser: allUsers.isEmpty ? null : allUsers[i],
          jobField: jobField,
          jobSubField: jobSubField,
          jobSpecialization: jobSpecialization,
          hardSkills: hardSkills,
        )[1];
        userJobSubFieldScore = userScoreFunction(
          selectedUser: allUsers.isEmpty ? null : allUsers[i],
          jobField: jobField,
          jobSubField: jobSubField,
          jobSpecialization: jobSpecialization,
          hardSkills: hardSkills,
        )[2];
        userJobSpecializationScore = userScoreFunction(
          selectedUser: allUsers.isEmpty ? null : allUsers[i],
          jobField: jobField,
          jobSubField: jobSubField,
          jobSpecialization: jobSpecialization,
          hardSkills: hardSkills,
        )[3];
        userHardSkillsScore = userScoreFunction(
          selectedUser: allUsers.isEmpty ? null : allUsers[i],
          jobField: jobField,
          jobSubField: jobSubField,
          jobSpecialization: jobSpecialization,
          hardSkills: hardSkills,
        )[4];

        userScorePercentage = (userScore / totalScore) * 100;

        /*print(" ${allUsers[i].username} ${userScoreFunction(
          selectedUser: allUsers.isEmpty ? null : allUsers[i],
          jobField: jobField,
          jobSubField: jobSubField,
          jobSpecialization: jobSpecialization,
          hardSkills: hardSkills,
        )
        } - $totalScore: - $userScorePercentage");*/

        if (userScorePercentage >= 60) {
          allRecommendedUsersInformation.add(allUsers[i]);
          allRecommendedUsers.add(
            RecommendedUserModel(
              projectName: projectName,
              skillName: skillName,
              username: allUsers[i].username,
              firstName: allUsers[i].firstName,
              lastName: allUsers[i].lastName,
              jobTitle: allUsers[i].jobTitle,
              userScore: userScore,
              userScorePercentage: userScorePercentage,
              userJobFieldScore: userJobFieldScore,
              userJobSubFieldScore: userJobSubFieldScore,
              userJobSpecializationScore: userJobSpecializationScore,
              userHardSkillsScore: userHardSkillsScore,
              totalScore: totalScore,
              totalHardSkillsScore: totalHardScore,
            ),
          );
        } else {
          allRecommendedUsersInformation;
          allRecommendedUsers;
        }
      }
    } else {
      if (endDate.isEmptyOrNull) {
        // Is person available from start date?
      } else {
        // Is person available from start date to end date?

        totalScore = totalScoreFunction(
          jobField: jobField,
          jobSubField: jobSubField,
          jobSpecialization: jobSpecialization,
          hardSkills: hardSkills,
        )[0];

        totalHardScore = totalScoreFunction(
          jobField: jobField,
          jobSubField: jobSubField,
          jobSpecialization: jobSpecialization,
          hardSkills: hardSkills,
        )[1];

        userScore = userScoreFunction(
          selectedUser: allUsers.isEmpty ? null : allUsers[i],
          jobField: jobField,
          jobSubField: jobSubField,
          jobSpecialization: jobSpecialization,
          hardSkills: hardSkills,
        )[0];
        userJobFieldScore = userScoreFunction(
          selectedUser: allUsers.isEmpty ? null : allUsers[i],
          jobField: jobField,
          jobSubField: jobSubField,
          jobSpecialization: jobSpecialization,
          hardSkills: hardSkills,
        )[1];
        userJobSubFieldScore = userScoreFunction(
          selectedUser: allUsers.isEmpty ? null : allUsers[i],
          jobField: jobField,
          jobSubField: jobSubField,
          jobSpecialization: jobSpecialization,
          hardSkills: hardSkills,
        )[2];
        userJobSpecializationScore = userScoreFunction(
          selectedUser: allUsers.isEmpty ? null : allUsers[i],
          jobField: jobField,
          jobSubField: jobSubField,
          jobSpecialization: jobSpecialization,
          hardSkills: hardSkills,
        )[3];
        userHardSkillsScore = userScoreFunction(
          selectedUser: allUsers.isEmpty ? null : allUsers[i],
          jobField: jobField,
          jobSubField: jobSubField,
          jobSpecialization: jobSpecialization,
          hardSkills: hardSkills,
        )[4];

        userScorePercentage = (userScore / totalScore) * 100;

        if (userScorePercentage >= 60) {
          allRecommendedUsersInformation.add(allUsers[i]);
          allRecommendedUsers.add(
            RecommendedUserModel(
              projectName: projectName,
              skillName: skillName,
              username: allUsers[i].username,
              firstName: allUsers[i].firstName,
              lastName: allUsers[i].lastName,
              jobTitle: allUsers[i].jobTitle,
              userScore: userScore,
              userScorePercentage: userScorePercentage,
              userJobFieldScore: userJobFieldScore,
              userJobSubFieldScore: userJobSubFieldScore,
              userJobSpecializationScore: userJobSpecializationScore,
              userHardSkillsScore: userHardSkillsScore,
              totalScore: totalScore,
              totalHardSkillsScore: totalHardScore,
            ),
          );
        } else {
          allRecommendedUsersInformation;
          allRecommendedUsers;
        }
      }
    }
  }

  return allRecommendedUsers;
}

List<double> totalScoreFunction({
  String? jobField,
  String? jobSubField,
  String? jobSpecialization,
  List<SkillModel>? hardSkills,
}) {
  double totalScore = 0;
  double totalHardSkillScore = 0;

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
        totalHardSkillScore = totalHardSkillScore + 1;
      } else {
        totalScore = totalScore + 0;
        totalHardSkillScore = totalHardSkillScore + 0;
      }

      if (!hardSkills[j].skillCategory.isEmptyOrNull) {
        totalScore = totalScore + 1;
        totalHardSkillScore = totalHardSkillScore + 1;
      } else {
        totalScore = totalScore + 0;
        totalHardSkillScore = totalHardSkillScore + 0;
      }

      if (!hardSkills[j].skill.isEmptyOrNull) {
        totalScore = totalScore + 1;
        totalHardSkillScore = totalHardSkillScore + 1;
      } else {
        totalScore = totalScore + 0;
        totalHardSkillScore = totalHardSkillScore + 0;
      }

      if (!hardSkills[j].level.isEmptyOrNull) {
        totalScore = totalScore + 1;
        totalHardSkillScore = totalHardSkillScore + 1;
      } else {
        totalScore = totalScore + 0;
        totalHardSkillScore = totalHardSkillScore + 0;
      }
    }
  } else {
    totalScore = totalScore + 0;
  }

  return [totalScore, totalHardSkillScore];
}

List<double> userScoreFunction({
  UserModel? selectedUser,
  String? jobField,
  String? jobSubField,
  String? jobSpecialization,
  List<SkillModel>? hardSkills,
}) {
  double userScore = 0;
  double userJobFieldScore = 0;
  double userJobSubFieldScore = 0;
  double userJobSpecializationScore = 0;
  double userHardSkillsScore = 0;
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

  userHardSkillsScore = userScore;

  if (jobField != null || selectedUser.jobField != null) {
    if (selectedUser.jobField == jobField) {
      userScore = userScore + 1;
      userJobFieldScore = 1;
    } else if (selectedUser.jobField != jobField &&
        equalTypeOfSpecialization > 0) {
      userScore = userScore + 0.5;
      userJobFieldScore = 0.5;
    } else {
      userScore = userScore + 0;
      userJobFieldScore = 0;
    }
  } else {
    userScore = userScore + 0;
    userJobFieldScore = 0;
  }

  if (jobSubField != null || selectedUser.jobSubField != null) {
    if (selectedUser.jobSubField == jobSubField) {
      userScore = userScore + 1;
      userJobSubFieldScore = 1;
    } else if (selectedUser.jobSubField != jobSubField &&
        equalTypeOfSpecialization > 0) {
      userScore = userScore + 0.5;
      userJobSubFieldScore = 0.5;
    } else {
      userScore = userScore + 0;
      userJobSubFieldScore = 0;
    }
  } else {
    userScore = userScore + 0;
    userJobSubFieldScore = 0;
  }

  if (jobSpecialization != null || selectedUser.jobSpecialization != null) {
    if (selectedUser.jobSpecialization == jobSpecialization) {
      userScore = userScore + 1;
      userJobSpecializationScore = 1;
    } else if (selectedUser.jobSpecialization != jobSpecialization &&
        equalTypeOfSpecialization > 0) {
      userScore = userScore + 0.5;
      userJobSpecializationScore = 0.5;
    } else {
      userScore = userScore + 0;
      userJobSpecializationScore = 0;
    }
  } else {
    userScore = userScore + 0;
    userJobSpecializationScore = 0;
  }

  return [
    userScore,
    userJobFieldScore,
    userJobSubFieldScore,
    userJobSpecializationScore,
    userHardSkillsScore
  ];
}
