import 'dart:convert';

List<ItemModel> itemModelFromJson(String str) =>
    List<ItemModel>.from(json.decode(str).map((x) => ItemModel.fromJson(x)));

String itemModelToJson(List<ItemModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemModel {
  DateTime? updatedAt;
  String? name;
  DateTime? createdAt;
  String? id;
  String? description;
  String? price;
  String? categoryId;
  String? categoryName;

  ItemModel({
    this.updatedAt,
    this.name,
    this.createdAt,
    this.id,
    this.description,
    this.price,
    this.categoryId,
    this.categoryName,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"].toDate().toString()),
        name: json["name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"].toDate().toString()),
        id: json["id"],
        description: json["description"] ?? "",
        price: json["price"] ?? "",
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
      );

  Map<String, dynamic> toJson() => {
        "updated_at": updatedAt?.toIso8601String(),
        "name": name,
        "created_at": createdAt?.toIso8601String(),
        "id": id,
        "description": description,
        "price": price,
        "categoryId": categoryId,
        "categoryName": categoryName,
      };
}
