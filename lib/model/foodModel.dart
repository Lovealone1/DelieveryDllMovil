import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
class FoodModel {
  String name;
  String restaurantUID;
  String foodID;
  DateTime uploadTime;
  String description;
  String foodImageURL;
  bool isVegetarian;
  String actualPrice;
  String discountedPrice;
  FoodModel(
      {required this.name,
      required this.restaurantUID,
      required this.foodID,
      required this.uploadTime,
      required this.description,
      required this.foodImageURL,
      required this.isVegetarian,
      required this.actualPrice,
      required this.discountedPrice,});
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'restaurantUID': restaurantUID,
      'foodID': foodID,
      'uploadTime': uploadTime,
      'description': description,
      'foodImageURL': foodImageURL,
      'isVegetarian': isVegetarian,
      'actualPrice': actualPrice,
      'discountedPrice': discountedPrice,
    };
  }

  factory FoodModel.fromMap(Map<String, dynamic> map) {
    return FoodModel(
      name: map['name'] != null ? map['name'] as String : '',
      restaurantUID:
          map['restaurantUID'] != null ? map['restaurantUID'] as String : '',
      foodID: map['foodID'] != null ? map['foodID'] as String : '',
      uploadTime: map['uploadTime'] != null ? (map['uploadTime'] as Timestamp).toDate() : DateTime.now(),
      description:
          map['description'] != null ? map['description'] as String : '',
      foodImageURL:
          map['foodImageURL'] != null ? map['foodImageURL'] as String : '',
      isVegetarian:
          map['isVegetarian'] != null ? map['isVegetarian'] as bool : false,
      actualPrice: map['actualPrice'] != null ? map['actualPrice'] as String : '',
      discountedPrice: map['discountedPrice'] != null ? map['discountedPrice'] as String : '',
    );
  }

  String toJson() => json.encode(toMap());
  factory FoodModel.fromJson(String source) =>
      FoodModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
