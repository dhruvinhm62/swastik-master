import 'dart:convert';

List<CategoryModel> categoryModelFromJson(String str) =>
    List<CategoryModel>.from(
        json.decode(str).map((x) => CategoryModel.fromJson(x)));

String categoryModelToJson(List<CategoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryModel {
  DateTime? updatedAt;
  String? name;
  DateTime? createdAt;
  String? id;

  CategoryModel({
    this.updatedAt,
    this.name,
    this.createdAt,
    this.id,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"].toDate().toString()),
        name: json["name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"].toDate().toString()),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "updated_at": updatedAt?.toIso8601String(),
        "name": name,
        "created_at": createdAt?.toIso8601String(),
        "id": id,
      };
}
