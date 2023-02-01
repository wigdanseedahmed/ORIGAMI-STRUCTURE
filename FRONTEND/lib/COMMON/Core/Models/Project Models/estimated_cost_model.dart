import 'package:origami_structure/imports.dart';

EstimatedCostModel estimatedCostModelFromJson(String str) => EstimatedCostModel.fromJson(json.decode(str));

String estimatedCostModelModelToJson(EstimatedCostModel data) => json.encode(data.toJson());

class EstimatedCostModel {
  EstimatedCostModel({
    this.item,
    this.purchaseDate,
    this.purchaseFrom,
    this.cost,
  });

  String? item;
  String? purchaseDate;
  String? purchaseFrom;
  double? cost;

  factory EstimatedCostModel.fromJson(Map<String, dynamic> json) => EstimatedCostModel(
        item: json["item"] == null ? null : json["item"] ,
        purchaseDate: json["purchaseDate"] == null ? null : json["purchaseDate"],
        purchaseFrom: json["purchaseFrom"] == null ? null : json["purchaseFrom"] ,
        cost:  json["cost"] == null ? null : json["cost"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "item":  item == null ? null : item,
        "purchaseDate":  purchaseDate== null ? null : purchaseDate,
        "purchaseFrom":  purchaseFrom== null ? null : purchaseFrom,
        "cost":  cost == null ? null : cost,
      };
}
