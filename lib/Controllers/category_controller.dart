import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:swastik/Constant/app_database.dart';
import 'package:swastik/Controllers/items_controller.dart';
import 'package:swastik/Model/category_model.dart';

class CategoryController extends GetxController {
  final TextEditingController categoryName = TextEditingController();

  bool loader = false;
  bool deleteLoader = false;
  List<CategoryModel> categories = [];
  bool fetchDataLoader = false;

  updateLoader(value) {
    fetchDataLoader = value;
    update();
  }

  List<CategoryModel> categoriesAll = [
    CategoryModel(
      name: "All Categories",
      createdAt: DateTime.now(),
      id: "",
      updatedAt: DateTime.now(),
    )
  ];

  Future<bool> addCategory() async {
    try {
      loader = true;
      update();
      DocumentReference categoryDoc = await AppDataBase()
          .kCategoriesCollection
          .add({"created_at": Timestamp.now()});
      final data = {
        "created_at": Timestamp.now(),
        "updated_at": Timestamp.now(),
        "id": categoryDoc.id.toString(),
        "name": categoryName.text.toString(),
      };
      await AppDataBase().kCategoriesCollection.doc(categoryDoc.id).set(data);
      loader = false;
      update();
      await fetchCategories();
      return true;
    } catch (error) {
      log("===ADD=CATEGORY=ERROR:::::::::::::::$error");
      loader = false;
      update();
      return false;
    }
  }

  Future<bool> updateCategory(String categoryId) async {
    try {
      loader = true;
      update();

      final relatedItemsQuery = await AppDataBase()
          .kItemsCollection
          .where("categoryId", isEqualTo: categoryId)
          .get();

      for (var item in relatedItemsQuery.docs) {
        await AppDataBase()
            .kItemsCollection
            .doc(item.id)
            .update({"categoryName": categoryName.text.toString()});
      }

      final updatedData = {
        "updated_at": Timestamp.now(),
        "name": categoryName.text.toString(),
      };
      await AppDataBase()
          .kCategoriesCollection
          .doc(categoryId)
          .update(updatedData);
      loader = false;
      update();
      await fetchCategories();
      Get.find<ItemController>().fetchItems();
      return true;
    } catch (error) {
      log("===UPDATE=CATEGORY=ERROR:::::::::::::::$error");
      loader = false;
      update();
      return false;
    }
  }

  Future<bool> deleteCategory(String categoryId) async {
    try {
      deleteLoader = true;
      update();

      final relatedItemsQuery = await AppDataBase()
          .kItemsCollection
          .where("categoryId", isEqualTo: categoryId)
          .get();

      for (var item in relatedItemsQuery.docs) {
        await AppDataBase().kItemsCollection.doc(item.id).delete();
      }

      await AppDataBase().kCategoriesCollection.doc(categoryId).delete();

      deleteLoader = false;
      update();
      fetchCategories();
      Get.find<ItemController>().fetchItems();
      return true;
    } catch (error) {
      log("===DELETE=CATEGORY=ERROR:::::::::::::::$error");
      deleteLoader = false;
      update();
      return false;
    }
  }

  Future<void> fetchCategories() async {
    update();
    try {
      QuerySnapshot querySnapshot = await AppDataBase()
          .kCategoriesCollection
          .orderBy("name", descending: false)
          .get();
      categories = [];
      categoriesAll = [
        CategoryModel(
          name: "All Categories",
          createdAt: DateTime.now(),
          id: "",
          updatedAt: DateTime.now(),
        )
      ];
      if (querySnapshot.docs.isNotEmpty) {
        categories = List<CategoryModel>.from(querySnapshot.docs.map(
            (x) => CategoryModel.fromJson(x.data() as Map<String, dynamic>)));
        for (var element in categories) {
          categoriesAll.add(element);
        }
      }
      update();
    } catch (error) {
      log("===FETCH=CATEGORY=ERROR:::::::::::::::$error");
    }
  }
}
