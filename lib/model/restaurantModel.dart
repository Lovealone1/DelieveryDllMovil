import 'dart:convert';

import 'package:food_delievery/model/adress.dart';

class RestaurantModel {
  String? restaurantName;
  String? restaurantLicenseNumber;
  String? restaurantUID;
  List<String>? bannerImages;
  AddressModel? address;
  RestaurantModel(
      {this.restaurantName,
      this.restaurantLicenseNumber,
      this.restaurantUID,
      this.bannerImages,
      this.address});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'restaurantName': restaurantName,
      'restaurantLicenseNumber': restaurantLicenseNumber,
      'restaurantUID': restaurantUID,
      'bannerImages': bannerImages,
      'address': address?.toMap(),
    };
  }

  factory RestaurantModel.fromMap(Map<String, dynamic> map) {
    return RestaurantModel(
      restaurantName: map['restaurantName'] != null
          ? map['restaurantName'] as String
          : null,
      restaurantLicenseNumber: map['restaurantLicenseNumber'] != null
          ? map['restaurantLicenseNumber'] as String
          : null,
      restaurantUID:
          map['restaurantUID'] != null ? map['restaurantUID'] as String : null,
      bannerImages: map['bannerImages'] != null
          ? List<String>.from((map['bannerImages'] as List<dynamic>).cast<String>())
          : null,
      address: map['address'] != null
          ? AddressModel.fromMap(map['address'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());
  factory RestaurantModel.fromJson(String source) =>
      RestaurantModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
