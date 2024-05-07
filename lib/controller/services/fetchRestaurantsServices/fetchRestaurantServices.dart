import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:food_delievery/constant/constant.dart';
import 'package:food_delievery/controller/provider/restaurantProvider/restaurantProvider.dart';
//import 'package:food_delievery/controller/provider/restaurantProvider/restaurantProvider.dart';
//import 'package:food_delievery/controller/services/locationServices/locationServices.dart';
import 'package:food_delievery/controller/services/userDataCRUDServices/userDataCRUDServices.dart';
import 'package:food_delievery/model/foodModel.dart';
import 'package:food_delievery/model/restaurantIDnLocationModel.dart';
import 'package:food_delievery/model/restaurantModel.dart';
import 'package:food_delievery/model/userAddressModel.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
//import 'package:provider/provider.dart';

class RestaurantServices {
  static getNearbyRestaurants(BuildContext context) async {
    Geofire.initialize('Restaurantes');
    //Position currentPosition = await LocationServices.getCurrentLocation();
    UserAddressModel userActiveAddress = await UserDataCRUDServices.fetchActiveAddress();
    log(userActiveAddress.toMap().toString());
    Geofire.queryAtLocation(
      userActiveAddress.latitude,
      userActiveAddress.longitude,
      20,
    )!
        .listen((event) {
      if (event != null) {
        log('Event is not null');
        var callback = event['callBack'];
        switch (callback) {
          case Geofire.onKeyEntered:
            RestaurantIDnLocationModel model = RestaurantIDnLocationModel(
              id: event['key'],
              latitude: event['latitude'],
              longitude: event['longitude'],
            );
            log('La data del restaurante es');
            log(model.toJson().toString());
            context.read<RestaurantProvider>().addRestaurants(model.id);
            context.read<RestaurantProvider>().addFoods(model.id);

          case Geofire.onGeoQueryReady:
            log('Query Ready');
            break;
        }
      }
    });
  }

  static fetchRestaurantData(String restaurantID) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Restaurant')
          .doc(restaurantID)
          .get();
      RestaurantModel data = RestaurantModel.fromMap(snapshot.data()!);
      return data;
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  static fetchFoodData(String restaurantID) async {
    List<FoodModel> foodData = [];
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Food')
          .orderBy('uploadTime', descending: true)
          .where('restaurantUID', isEqualTo: restaurantID)
          .get();
      snapshot.docs.forEach((element) {
        foodData.add(FoodModel.fromMap(element.data()));
      });
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
    return foodData;
  }


}
