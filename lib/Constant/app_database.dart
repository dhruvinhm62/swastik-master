import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class AppDataBase {
  CollectionReference kCategoriesCollection =
      firebaseFirestore.collection("Categories");
  CollectionReference kItemsCollection = firebaseFirestore.collection("Items");
  CollectionReference kEstimateCollection =
      firebaseFirestore.collection("Estimate");
}
