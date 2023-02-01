import 'package:origami_structure/imports.dart';

DonorModel donorModelFromJson(String str) => DonorModel.fromJson(json.decode(str));

String donorModelToJson(DonorModel data) => json.encode(data.toJson());

class DonorModel {
  DonorModel({
    this.donorName,
    this.donorEmail,
    this.donorWebsite,
    this.donorPhotoUrl,
    this.donorProjectList,
    this.donationAmount,
  });

  String? donorName;
  String? donorEmail;
  String? donorWebsite;
  String? donorPhotoUrl;
  List<String>? donorProjectList;
  double? donationAmount;

  factory DonorModel.fromJson(Map<String, dynamic> json) => DonorModel(
        donorName: json["donorName"] == null ? null : json["donorName"],
        donorEmail: json["donorEmail"] == null ? null : json["donorEmail"],
        donorWebsite: json["donorWebsite"]== null ? null : json["donorWebsite"],
        donorPhotoUrl: json["donorPhotoUrl"]== null ? null : json["donorPhotoUrl"],
        donorProjectList: json["donorProjectList"] == null
            ? null
            : List<String>.from(json["donorProjectList"].map((x) => x)),
        donationAmount: json["donationAmount"]== null ? null :  json["donationAmount"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "donorName": donorName== null ? null : donorName,
        "donorEmail": donorEmail== null ? null : donorEmail,
        "donorWebsite": donorWebsite== null ? null : donorWebsite,
        "donorPhotoUrl": donorPhotoUrl== null ? null : donorPhotoUrl,
        "donorProjectList": donorProjectList == null
            ? null
            : List<dynamic>.from(donorProjectList!.map((x) => x)),
        "donationAmount": donationAmount== null ? null : donationAmount,
      };
}
