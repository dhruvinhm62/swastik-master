import 'dart:convert';

List<EstimateModel> estimateModelFromJson(String str) =>
    List<EstimateModel>.from(
        json.decode(str).map((x) => EstimateModel.fromJson(x)));

String estimateModelToJson(List<EstimateModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EstimateModel {
  DateTime? updatedAt;
  DateTime? createdAt;
  String? id;
  String? name;
  String? date;
  String? eventName;
  String? mobileNumber;
  String? alternateMobileNumber;
  String? eventAddress;
  String? residentAddress;
  String? morningTime;
  String? afternoonTime;
  String? eveningTime;
  String? morningDish;
  String? afternoonDish;
  String? eveningDish;
  String? reference;
  String? dishPrice;
  String? elePoint;
  String? letters;
  String? peoples;
  String? washbasin;
  String? counter1;
  String? counter3;
  String? porch;
  List<String>? selectedItems;

  EstimateModel({
    this.updatedAt,
    this.createdAt,
    this.id,
    this.name,
    this.eventName,
    this.mobileNumber,
    this.alternateMobileNumber,
    this.eventAddress,
    this.residentAddress,
    this.afternoonTime,
    this.eveningTime,
    this.reference,
    this.dishPrice,
    this.elePoint,
    this.letters,
    this.peoples,
    this.washbasin,
    this.counter1,
    this.counter3,
    this.porch,
    this.morningDish,
    this.morningTime,
    this.eveningDish,
    this.afternoonDish,
    this.date,
    this.selectedItems,
  });

  factory EstimateModel.fromJson(Map<String, dynamic> json) => EstimateModel(
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"].toDate().toString()),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"].toDate().toString()),
        id: json["id"],
        name: json["name"],
        date: json["date"],
        eventName: json["eventName"],
        mobileNumber: json["mobileNumber"],
        alternateMobileNumber: json["alternateMobileNumber"],
        eventAddress: json["eventAddress"],
        residentAddress: json["residentAddress"],
        morningTime: json["morning_time"],
        afternoonTime: json["afternoon_time"],
        eveningTime: json["evening_time"],
        morningDish: json["morning_dish"],
        afternoonDish: json["afternoon_dish"],
        eveningDish: json["evening_dish"],
        reference: json["reference"],
        dishPrice: json["dishPrice"],
        elePoint: json["elePoint"],
        letters: json["letters"],
        peoples: json["peoples"],
        washbasin: json["washbasin"],
        counter1: json["counter1"],
        counter3: json["counter3"],
        porch: json["porch"],
        selectedItems: json["items"] == null
            ? []
            : List<String>.from(json["items"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
        "name": name,
        "date": date,
        "eventName": eventName,
        "mobileNumber": mobileNumber,
        "alternateMobileNumber": alternateMobileNumber,
        "eventAddress": eventAddress,
        "residentAddress": residentAddress,
        "morning_time": morningTime,
        "afternoon_time": afternoonTime,
        "evening_time": eveningTime,
        "morning_dish": morningDish,
        "afternoon_dish": afternoonDish,
        "evening_dish": eveningDish,
        "reference": reference,
        "dishPrice": dishPrice,
        "elePoint": elePoint,
        "letters": letters,
        "peoples": peoples,
        "washbasin": washbasin,
        "counter1": counter1,
        "counter3": counter3,
        "porch": porch,
        "items": selectedItems == null
            ? []
            : List<dynamic>.from(selectedItems!.map((x) => x)),
      };
}
