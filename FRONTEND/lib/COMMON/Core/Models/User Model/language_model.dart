import 'package:origami_structure/imports.dart';

LanguageModel languageModelFromJson(String str) => LanguageModel.fromJson(json.decode(str));

String languageModelToJson(LanguageModel data) => json.encode(data.toJson());

class LanguageModel {
  LanguageModel({
    this.language,
    this.level,
  });

  String? language;
  String? level;

  factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
    language: json["language"] == null ? null : json["language"],
    level: json["level"] == null ? null : json["level"],
  );

  Map<String, dynamic> toJson() => {
    "language": language == null ? null : language,
    "level": level == null ? null : level,
  };
}
