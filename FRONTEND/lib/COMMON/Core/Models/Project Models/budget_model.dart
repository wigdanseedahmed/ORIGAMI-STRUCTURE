import 'package:origami_structure/imports.dart';

BudgetModel budgetModelFromJson(String str) =>
    BudgetModel.fromJson(json.decode(str));

String budgetModelToJson(BudgetModel data) => json.encode(data.toJson());

class BudgetModel {
  BudgetModel({
    this.item,
    this.itemType,
    this.purchaseDate,
    this.purchaseFrom,
    this.duration,
    this.cost,
  });

  String? item;
  String? itemType;
  String? purchaseDate;
  String? purchaseFrom;
  double? duration;
  double? cost;

  factory BudgetModel.fromJson(Map<String, dynamic> json) => BudgetModel(
        item: json["item"] == null ? null : json["item"],
        itemType: json["itemType"] == null ? null : json["itemType"],
        purchaseDate:
            json["purchaseDate"] == null ? null : json["purchaseDate"],
        purchaseFrom:
            json["purchaseFrom"] == null ? null : json["purchaseFrom"],
        duration: json["duration"] == null ? null :  json["duration"].toDouble(),
        cost: json["cost"] == null ? null : json["cost"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "item": item == null ? null : item,
        "itemType": itemType == null ? null : itemType,
        "purchaseDate": purchaseDate == null ? null : purchaseDate,
        "purchaseFrom": purchaseFrom == null ? null : purchaseFrom,
        "duration": duration == null ? null : duration,
        "cost": cost == null ? null : cost,
      };
}
