import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:swastik/Constant/app_database.dart';
import 'package:swastik/Model/category_model.dart';
import 'package:swastik/Model/estimate_model.dart';
import 'package:swastik/Model/item_model.dart';

class ItemController extends GetxController {
  final TextEditingController itemName = TextEditingController();
  final TextEditingController itemDescription = TextEditingController();
  final TextEditingController itemPrice = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  CategoryModel? selectedCategoryForFrom;
  CategoryModel? selectedCategory;
  bool loader = false;
  bool deleteLoader = false;
  List<ItemModel> items = [];
  List<ItemModel> allItems = [];
  bool fetchDataLoader = false;
  bool isSelectionMode = false;
  List<ItemModel> selectedItems = [];
  DateTime selectedDate = DateTime.now();
  TimeOfDay morningTime1 = TimeOfDay.now();
  TimeOfDay afternoonTime1 = TimeOfDay.now();
  TimeOfDay eveningTime1 = TimeOfDay.now();

  final TextEditingController name = TextEditingController();
  final TextEditingController date = TextEditingController();
  final TextEditingController event = TextEditingController();
  final TextEditingController eventAddress = TextEditingController();
  final TextEditingController homeAddress = TextEditingController();
  final TextEditingController dishPrice = TextEditingController();
  final TextEditingController reference = TextEditingController();
  final TextEditingController mobileNumber = TextEditingController();
  final TextEditingController alternateMobileNumber = TextEditingController();
  final TextEditingController morningTime = TextEditingController();
  final TextEditingController morningDish = TextEditingController();
  final TextEditingController afternoonTime = TextEditingController();
  final TextEditingController afternoonDish = TextEditingController();
  final TextEditingController eveningTime = TextEditingController();
  final TextEditingController eveningDish = TextEditingController();
  final TextEditingController porch = TextEditingController();
  final TextEditingController washbasin = TextEditingController();
  final TextEditingController counter3 = TextEditingController();
  final TextEditingController counter1 = TextEditingController();
  final TextEditingController letters = TextEditingController();
  final TextEditingController elePoint = TextEditingController();
  String? selectionModeId;
  Uint8List? logoImage;
  Uint8List? scLogo;
  Uint8List? address;
  Uint8List? title;
  Uint8List? upperImage;
  Uint8List? bottomImage;
  Uint8List? image50;
  bool loadPdfImages = false;
  bool partyDataLoader = false;
  bool partyDeleteLoader = false;
  List<EstimateModel> estimateList = [];

  setEstimateData(EstimateModel model) async {
    await updateEstimateItems(model);
    selectionModeId = model.id ?? "";
    name.text = model.name ?? "";
    date.text = model.date ?? "";
    event.text = model.eventName ?? "";
    eventAddress.text = model.eventAddress ?? "";
    homeAddress.text = model.residentAddress ?? "";
    reference.text = model.reference ?? "";
    morningDish.text = model.morningDish ?? "";
    morningTime.text = model.morningTime ?? "";
    afternoonDish.text = model.afternoonDish ?? "";
    afternoonTime.text = model.afternoonTime ?? "";
    eveningDish.text = model.eveningDish ?? "";
    eveningTime.text = model.eveningTime ?? "";
    mobileNumber.text = model.mobileNumber ?? "";
    dishPrice.text = model.dishPrice ?? "";
    porch.text = model.porch ?? "";
    washbasin.text = model.washbasin ?? "";
    counter3.text = model.counter3 ?? "";
    counter1.text = model.counter1 ?? "";
    letters.text = model.letters ?? "";
    elePoint.text = model.elePoint ?? "";
    if (model.date!.isNotEmpty) {
      selectedDate = DateFormat("dd/MM/yyyy").parse(model.date!);
    }
    if (model.morningTime!.isNotEmpty) {
      morningTime1 = parseTimeOfDay(model.morningTime!)!;
    }
    if (model.afternoonTime!.isNotEmpty) {
      afternoonTime1 = parseTimeOfDay(model.afternoonTime!)!;
    }
    if (model.eveningTime!.isNotEmpty) {
      eveningTime1 = parseTimeOfDay(model.eveningTime!)!;
    }

    update();
  }

  updateEstimateItems(EstimateModel model) {
    selectedItems = items
        .where((element) => model.selectedItems!.contains(element.id))
        .toList();
    reorderList();
    update();
  }

  TimeOfDay? parseTimeOfDay(String timeString) {
    try {
      timeString = timeString.trim().replaceAll('\u202F', '');
      final DateFormat format = DateFormat("h:mm a");
      final DateTime dateTime = format.parse(timeString);
      return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    } catch (e) {
      log("Error parsing time: $e");
      return null;
    }
  }

  Future<void> methodImage() async {
    loadPdfImages = true;
    update();
    final ByteData logoByte = await rootBundle.load("assets/images/logo1.png");
    final ByteData scLogoByte =
        await rootBundle.load("assets/images/sc_logo.png");
    final ByteData addressByte =
        await rootBundle.load("assets/images/address.png");
    final ByteData titleByte = await rootBundle.load("assets/images/title.png");
    final ByteData image50Byte =
        await rootBundle.load("assets/images/15days.png");
    final ByteData upperImageByte =
        await rootBundle.load("assets/images/upper_card.png");
    final ByteData bottomImageByte =
        await rootBundle.load("assets/images/bottom_card.png");
    logoImage = (logoByte).buffer.asUint8List();
    scLogo = (scLogoByte).buffer.asUint8List();
    address = (addressByte).buffer.asUint8List();
    title = (titleByte).buffer.asUint8List();
    upperImage = (upperImageByte).buffer.asUint8List();
    bottomImage = (bottomImageByte).buffer.asUint8List();
    image50 = (image50Byte).buffer.asUint8List();
    loadPdfImages = false;
    update();
  }

  updateDate(DateTime value) {
    date.text = DateFormat("dd/MM/yyyy").format(value);
    update();
  }

  updateMorning(String value) {
    morningTime.text = value;
    update();
  }

  updateAfternoon(String value) {
    afternoonTime.text = value;
    update();
  }

  updateEvening(String value) {
    eveningTime.text = value;
    update();
  }

  changeToSelectionMode(bool value) {
    isSelectionMode = value;
    update();
  }

  addSelectedItems(ItemModel value) {
    selectedItems.add(value);
    update();
  }

  clearSelectedCategory() {
    selectedCategory = null;
    filterItemList();
  }

  clearValues() {
    date.clear();
    morningTime.clear();
    morningDish.clear();
    afternoonTime.clear();
    afternoonDish.clear();
    eveningTime.clear();
    eveningDish.clear();
    selectedItems.clear();
    name.clear();
    event.clear();
    eventAddress.clear();
    homeAddress.clear();
    dishPrice.clear();
    reference.clear();
    mobileNumber.clear();
    alternateMobileNumber.clear();
    afternoonTime.clear();
    eveningTime.clear();
    porch.clear();
    washbasin.clear();
    counter3.clear();
    counter1.clear();
    letters.clear();
    elePoint.clear();
    selectedDate = DateTime.now();
    morningTime1 = TimeOfDay.now();
    afternoonTime1 = TimeOfDay.now();
    eveningTime1 = TimeOfDay.now();
    selectionModeId = null;
    update();
  }

  reorderList() {
    selectedItems
        .sort((a, b) => (a.categoryName ?? "").compareTo(b.categoryName ?? ""));
    update();
  }

  removeSelectedItems(ItemModel value) {
    selectedItems.remove(value);
    update();
  }

  updatePartyDataLoader(value) {
    partyDataLoader = value;
    update();
  }

  updateLoader(value) {
    fetchDataLoader = value;
    update();
  }

  updateSelectedCategoryForForm(CategoryModel model) {
    selectedCategoryForFrom = model;
    update();
  }

  updateSelectedCategory(CategoryModel model) {
    selectedCategory = model;
    update();
  }

  Future<bool> addItem() async {
    try {
      loader = true;
      update();
      DocumentReference itemDoc = await AppDataBase()
          .kItemsCollection
          .add({"created_at": Timestamp.now()});

      final data = {
        "created_at": Timestamp.now(),
        "updated_at": Timestamp.now(),
        "id": itemDoc.id.toString(),
        "name": itemName.text.toString(),
        "description": itemDescription.text.toString(),
        "price": itemPrice.text.toString(),
        "categoryId": selectedCategoryForFrom?.id,
        "categoryName": selectedCategoryForFrom?.name,
      };
      await AppDataBase().kItemsCollection.doc(itemDoc.id).set(data);
      loader = false;
      update();
      fetchItems();
      return true;
    } catch (error) {
      log("===ADD=ITEM=ERROR:::::::::::::::$error");
      loader = false;
      update();
      return false;
    }
  }

  Future<bool> updateItem(String itemId) async {
    try {
      loader = true;
      update();

      final updatedData = {
        "updated_at": Timestamp.now(),
        "name": itemName.text.toString(),
        "description": itemDescription.text.toString(),
        "price": itemPrice.text.toString(),
        "categoryId": selectedCategoryForFrom?.id,
        "categoryName": selectedCategoryForFrom?.name,
      };

      await AppDataBase().kItemsCollection.doc(itemId).update(updatedData);

      loader = false;
      update();
      fetchItems();
      return true;
    } catch (error) {
      log("===UPDATE=ITEM=ERROR:::::::::::::::$error");
      loader = false;
      update();
      return false;
    }
  }

  Future<bool> deleteItem(String itemId) async {
    try {
      loader = true;
      update();
      await AppDataBase().kItemsCollection.doc(itemId).delete();
      loader = false;
      update();
      fetchItems();
      return true;
    } catch (error) {
      log("===DELETE=ITEM=ERROR:::::::::::::::$error");
      loader = false;
      update();
      return false;
    }
  }

  Future<void> fetchItems() async {
    try {
      QuerySnapshot querySnapshot = await AppDataBase()
          .kItemsCollection
          .orderBy("name", descending: false)
          .get();
      items = [];
      allItems = [];
      if (querySnapshot.docs.isNotEmpty) {
        items = List<ItemModel>.from(querySnapshot.docs
            .map((x) => ItemModel.fromJson(x.data() as Map<String, dynamic>)));
        allItems = items;
      }
      update();
    } catch (error) {
      log("===FETCH=ITEM=ERROR:::::::::::::::$error");
    }
  }

  void filterItemList() {
    items = [];
    if (selectedCategory == null ||
        selectedCategory?.name == "All Categories") {
      items = allItems;
    } else {
      for (var element in allItems) {
        if (element.categoryId == selectedCategory?.id) {
          items.add(element);
        }
      }
    }
    update();
  }

  Future<bool> addEstimate() async {
    try {
      loader = true;
      update();
      DocumentReference itemDoc = await AppDataBase()
          .kEstimateCollection
          .add({"created_at": Timestamp.now()});

      selectionModeId = itemDoc.id;

      final data = {
        "created_at": Timestamp.now(),
        "updated_at": Timestamp.now(),
        "id": itemDoc.id.toString(),
        "name": name.text.toString(),
        "date": date.text.toString(),
        "morning_time": morningTime.text.toString(),
        "morning_dish": morningDish.text.toString(),
        "afternoon_time": afternoonTime.text.toString(),
        "afternoon_dish": afternoonDish.text.toString(),
        "evening_time": eveningTime.text.toString(),
        "evening_dish": eveningDish.text.toString(),
        "eventName": event.text.toString(),
        "eventAddress": eventAddress.text.toString(),
        "residentAddress": homeAddress.text.toString(),
        "dishPrice": dishPrice.text.toString(),
        "reference": reference.text.toString(),
        "mobileNumber": mobileNumber.text.toString(),
        "alternateMobileNumber": alternateMobileNumber.text.toString(),
        "porch": porch.text.toString(),
        "washbasin": washbasin.text.toString(),
        "counter3": counter3.text.toString(),
        "counter1": counter1.text.toString(),
        "letters": letters.text.toString(),
        "elePoint": elePoint.text.toString(),
        "items": selectedItems.map((e) => e.id).toList()
      };
      await AppDataBase().kEstimateCollection.doc(itemDoc.id).set(data);
      loader = false;
      update();
      return true;
    } catch (error) {
      log("===ADD=ESTIMATE=ERROR:::::::::::::::$error");
      loader = false;
      update();
      return false;
    }
  }

  Future<bool> updateEstimate(String estimateId) async {
    try {
      loader = true;
      update();

      final data = {
        "updated_at": Timestamp.now(),
        "name": name.text.toString(),
        "date": date.text.toString(),
        "morning_time": morningTime.text.toString(),
        "morning_dish": morningDish.text.toString(),
        "afternoon_time": afternoonTime.text.toString(),
        "afternoon_dish": afternoonDish.text.toString(),
        "evening_time": eveningTime.text.toString(),
        "evening_dish": eveningDish.text.toString(),
        "eventName": event.text.toString(),
        "eventAddress": eventAddress.text.toString(),
        "residentAddress": homeAddress.text.toString(),
        "dishPrice": dishPrice.text.toString(),
        "reference": reference.text.toString(),
        "mobileNumber": mobileNumber.text.toString(),
        "alternateMobileNumber": alternateMobileNumber.text.toString(),
        "porch": porch.text.toString(),
        "washbasin": washbasin.text.toString(),
        "counter3": counter3.text.toString(),
        "counter1": counter1.text.toString(),
        "letters": letters.text.toString(),
        "elePoint": elePoint.text.toString(),
        "items": selectedItems.map((e) => e.id).toList()
      };

      await AppDataBase().kEstimateCollection.doc(estimateId).update(data);

      loader = false;
      update();

      return true;
    } catch (error) {
      log("===UPDATE=ESTIMATE=ERROR:::::::::::::::$error");
      loader = false;
      update();
      return false;
    }
  }

  Future<bool> deleteEstimate(String estimateId) async {
    try {
      partyDeleteLoader = true;
      update();
      await AppDataBase().kEstimateCollection.doc(estimateId).delete();
      partyDeleteLoader = false;
      update();
      fetchEstimate();
      return true;
    } catch (error) {
      log("===DELETE=ESTIMATE=ERROR:::::::::::::::$error");
      partyDeleteLoader = false;
      update();
      return false;
    }
  }

  Future<void> fetchEstimate() async {
    try {
      QuerySnapshot querySnapshot = await AppDataBase()
          .kEstimateCollection
          .orderBy("name", descending: false)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        estimateList = List<EstimateModel>.from(querySnapshot.docs.map(
            (x) => EstimateModel.fromJson(x.data() as Map<String, dynamic>)));
      } else {
        estimateList = [];
      }
      update();
    } catch (error) {
      log("===FETCH=ESTIMATE=ERROR:::::::::::::::$error");
    }
  }
}
