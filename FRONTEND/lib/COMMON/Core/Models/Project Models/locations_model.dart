import 'package:origami_structure/imports.dart';

LocationsModel locationModelFromJson(String str) => LocationsModel.fromJson(json.decode(str));

String locationModelToJson(LocationsModel data) => json.encode(data.toJson());

class LocationsModel {
  LocationsModel({
    this.locationId,
    this.location,
    this.latitude,
    this.longitude,
    this.localityNameEn,
    this.localityNameAr,
    this.localityNamePcode,
    this.cityNameEn,
    this.cityNameAr,
    this.cityPcode,
    this.stateNameEn,
    this.stateNameAr,
    this.stateNamePcode,
    this.provinceNameEn,
    this.provinceNameAr,
    this.provincePcode,
    this.regionNameEn,
    this.regionNameAr,
    this.regionPcode,
    this.countryEn,
    this.countryAr,
    this.countryPcode,
    this.startDate,
    this.endDate,
    this.duration,
  });

  String? locationId;
  String? location;
  double? latitude;
  double? longitude;
  String? localityNameEn;
  String? localityNameAr;
  String? localityNamePcode;
  String? cityNameEn;
  String? cityNameAr;
  String? cityPcode;
  String? stateNameEn;
  String? stateNameAr;
  String? stateNamePcode;
  String? provinceNameEn;
  String? provinceNameAr;
  String? provincePcode;
  String? regionNameEn;
  String? regionNameAr;
  String? regionPcode;
  String? countryEn;
  String? countryAr;
  String? countryPcode;
  String? startDate;
  String? endDate;
  double? duration;

  factory LocationsModel.fromJson(Map<String, dynamic> json) => LocationsModel(
    locationId: json["locationId"] == null ? null : json["locationId"],
    location: json["location"] == null ? null : json["location"],
    latitude: json["Latitude"] == null ? null : json["Latitude"].toDouble(),
    longitude: json["Longitude"] == null ? null : json["Longitude"].toDouble(),
    localityNameEn: json["localityNameEn"] == null ? null : json["localityNameEn"],
    localityNameAr: json["localityNameAr"] == null ? null : json["localityNameAr"],
    localityNamePcode: json["localityNamePcode"] == null ? null : json["localityNamePcode"],
    cityNameEn: json["cityNameEn"] == null ? null : json["cityNameEn"],
    cityNameAr: json["cityNameAr"] == null ? null : json["cityNameAr"],
    cityPcode: json["cityPcode"] == null ? null : json["cityPcode"],
    stateNameEn: json["stateNameEn"] == null ? null : json["stateNameEn"],
    stateNameAr: json["stateNameAr"] == null ? null : json["stateNameAr"],
    stateNamePcode: json["stateNamePcode"] == null ? null : json["stateNamePcode"],
    provinceNameEn: json["provinceNameEn"] == null ? null : json["provinceNameEn"],
    provinceNameAr: json["provinceNameAr"] == null ? null : json["provinceNameAr"],
    provincePcode: json["provincePcode"] == null ? null : json["provincePcode"],
    regionNameEn: json["regionNameEn"] == null ? null : json["regionNameEn"],
    regionNameAr: json["regionNameAr"] == null ? null : json["regionNameAr"],
    regionPcode: json["regionPcode"] == null ? null : json["regionPcode"],
    countryEn: json["countryEn"] == null ? null : json["countryEn"],
    countryAr: json["countryAr"] == null ? null : json["countryAr"],
    countryPcode: json["countryPcode"] == null ? null : json["countryPcode"],
    startDate: json["startDate"] == null ? null : json["startDate"],
    endDate: json["endDate"] == null ? null : json["endDate"],
    duration: json["duration"] == null ? null :  json["duration"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "locationId": locationId == null ? null : locationId,
    "location": location == null ? null : location,
    "Latitude": latitude == null ? null : latitude,
    "Longitude": longitude == null ? null : longitude,
    "localityNameEn": localityNameEn == null ? null : localityNameEn,
    "localityNameAr": localityNameAr == null ? null : localityNameAr,
    "localityNamePcode": localityNamePcode == null ? null : localityNamePcode,
    "cityNameEn": cityNameEn == null ? null : cityNameEn,
    "cityNameAr": cityNameAr == null ? null : cityNameAr,
    "cityPcode": cityPcode == null ? null : cityPcode,
    "stateNameEn": stateNameEn == null ? null : stateNameEn,
    "stateNameAr": stateNameAr == null ? null : stateNameAr,
    "stateNamePcode": stateNamePcode == null ? null : stateNamePcode,
    "provinceNameEn": provinceNameEn == null ? null : provinceNameEn,
    "provinceNameAr": provinceNameAr == null ? null : provinceNameAr,
    "provincePcode": provincePcode == null ? null : provincePcode,
    "regionNameEn": regionNameEn == null ? null : regionNameEn,
    "regionNameAr": regionNameAr == null ? null : regionNameAr,
    "regionPcode": regionPcode == null ? null : regionPcode,
    "countryEn": countryEn == null ? null : countryEn,
    "countryAr": countryAr == null ? null : countryAr,
    "countryPcode": countryPcode == null ? null : countryPcode,
    "startDate": startDate == null ? null : startDate,
    "endDate": endDate == null ? null : endDate,
    "duration": duration == null ? null : duration,
  };
}
