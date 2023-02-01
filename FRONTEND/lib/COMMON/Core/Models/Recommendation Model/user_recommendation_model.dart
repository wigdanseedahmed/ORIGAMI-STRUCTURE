import 'package:origami_structure/imports.dart';

List<RecommendedUserModel> userRecommendationModelListFromJson(String str) =>
    List<RecommendedUserModel>.from(json.decode(str).map((x) => RecommendedUserModel.fromJson(x)));

String userRecommendationModelListToJson(List<RecommendedUserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

RecommendedUserModel userRecommendationModelFromJson(String str) => RecommendedUserModel.fromJson(json.decode(str));

String userRecommendationModelToJson(RecommendedUserModel data) => json.encode(data.toJson());

class RecommendedUserModel {
  RecommendedUserModel({
    this.recommendedUserId,
    this.projectName,
   this.skillName,
    this.username,
    this.isAssignedTo,
    this.firstName,
    this.lastName,
    this.jobTitle,
    this.userScore,
    this.userScorePercentage,
    this.userJobFieldScore,
    this.userJobSubFieldScore,
    this.userJobSpecializationScore,
    this.userHardSkillsScore,
    this.totalScore,
    this.totalHardSkillsScore,
  });

  String? recommendedUserId;
  String? projectName;
  String? skillName;
  String? username;
  bool? isAssignedTo;
  String? firstName;
  String? lastName;
  String? jobTitle;
  double? userScore;
  double? userScorePercentage;
  double? userJobFieldScore;
  double? userJobSubFieldScore;
  double? userJobSpecializationScore;
  double? userHardSkillsScore;
  double? totalScore;
  double? totalHardSkillsScore;

  factory RecommendedUserModel.fromJson(Map<String, dynamic> json) =>
      RecommendedUserModel(
        recommendedUserId: json["recommendedUserId"] ?? null,
        projectName: json["projectName"] ?? null,
        skillName: json["skillName"] ?? null,
        username: json["username"] ?? null,
        isAssignedTo: json["isAssignedTo"] ?? null,
        firstName: json["firstName"] ?? null,
        lastName: json["lastName"] ?? null,
        jobTitle: json["jobTitle"] ?? null,
        userScore: json["userScore"] == null ? null : json["userScore"].toDouble(),
        userScorePercentage: json["userScorePercentage"] == null ? null : json["userScorePercentage"].toDouble(),
        userJobFieldScore: json["userJobFieldScore"] == null ? null : json["userJobFieldScore"],
        userJobSubFieldScore: json["userJobSubFieldScore"] == null ? null : json["userJobSubFieldScore"],
        userJobSpecializationScore: json["userJobSpecializationScore"] == null ? null : json["userJobSpecializationScore"],
        userHardSkillsScore: json["userHardSkillsScore"] == null ? null : json["userHardSkillsScore"],
        totalScore: json["totalScore"] == null ? null : json["totalScore"],
        totalHardSkillsScore: json["totalHardSkillsScore"] == null ? null : json["totalHardSkillsScore"],
      );

  Map<String, dynamic> toJson() =>
      {
        "recommendedUserId": recommendedUserId ?? null,
        "projectName": projectName ?? null,
        "skillName": skillName ?? null,
        "username": username ?? null,
        "isAssignedTo": isAssignedTo ?? null,
        "firstName": firstName ?? null,
        "lastName": lastName ?? null,
        "jobTitle": jobTitle ?? null,
        "userScore": userScore ?? null,
        "userScorePercentage": userScorePercentage ?? null,
        "userJobFieldScore": userJobFieldScore ?? null,
        "userJobSubFieldScore": userJobSubFieldScore ?? null,
        "userJobSpecializationScore": userJobSpecializationScore ?? null,
        "userHardSkillsScore": userHardSkillsScore ?? null,
        "totalScore": totalScore ?? null,
        "totalHardSkillsScore": totalHardSkillsScore ?? null,
      };
}