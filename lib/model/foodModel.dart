// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


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
  int? quantity;
  DateTime? addedToCartAt;
  String? orderID;
  FoodModel({
    required this.name,
    required this.restaurantUID,
    required this.foodID,
    required this.uploadTime,
    required this.description,
    required this.foodImageURL,
    required this.isVegetarian,
    required this.actualPrice,
    required this.discountedPrice,
    this.quantity,
    this.addedToCartAt,
    this.orderID,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'restaurantUID': restaurantUID,
      'foodID': foodID,
      'uploadTime': uploadTime.millisecondsSinceEpoch,
      'description': description,
      'foodImageURL': foodImageURL,
      'isVegetarian': isVegetarian,
      'actualPrice': actualPrice,
      'discountedPrice': discountedPrice,
      'quantity': quantity,
      'addedToCartAt': addedToCartAt?.millisecondsSinceEpoch,
      'orderID': orderID,
    };
  }

  factory FoodModel.fromMap(Map<String, dynamic> map) {
    return FoodModel(
      name: map['name'] as String,
      restaurantUID: map['restaurantUID'] as String,
      foodID: map['foodID'] as String,
      uploadTime: DateTime.fromMillisecondsSinceEpoch(map['uploadTime'] as int),
      description: map['description'] as String,
      foodImageURL: map['foodImageURL'] as String,
      isVegetarian: map['isVegetarian'] as bool,
      actualPrice: map['actualPrice'] as String,
      discountedPrice: map['discountedPrice'] as String,
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
      addedToCartAt: map['addedToCartAt'] != null ? DateTime.fromMillisecondsSinceEpoch(map['addedToCartAt'] as int) : null,
      orderID: map['orderID'] != null ? map['orderID'] as String : null,
      
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodModel.fromJson(String source) => FoodModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
