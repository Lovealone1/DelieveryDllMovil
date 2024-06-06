import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covefood_users/constant/constant.dart';
import 'package:covefood_users/controller/provider/restaurantProvider/restaurantProvider.dart';
import 'package:covefood_users/model/foodModel.dart';
import 'package:covefood_users/model/restaurantModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:provider/provider.dart';


class RestaurantServices {
  static Future<void> getNearbyRestaurants(BuildContext context) async {
    try {
      // Obtener la colección de restaurantes de Firestore
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Restaurant').get();
      List<QueryDocumentSnapshot> docs = snapshot.docs;

      if (docs.isEmpty) {
        throw Exception('No nearby restaurants found');
      }

      for (var doc in docs) {
        String restaurantID = doc.id;
        context.read<RestaurantProvider>().addRestaurants(restaurantID);
        context.read<RestaurantProvider>().addFoods(restaurantID);
      }
      
      log('Query Ready');
    } catch (e) {
      log('Error fetching restaurants: $e');
      throw Exception('Error fetching restaurants');
    }
  }

  static removeGeofireListeners() async {
    bool? response = await Geofire.stopListener();
    log(response.toString());
  }

  static fetchResturantData(String restaurantUID) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('Restaurant').doc(restaurantUID).get();

      RestaurantModel data = RestaurantModel.fromMap(snapshot.data()!);
      return data;
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  static fetchFoodData(String resturantID) async {
    List<FoodModel> foodData = [];
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Food')
          .orderBy('uploadTime', descending: true)
          .where('resturantUID', isEqualTo: resturantID)
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

class ResturantProvider {
}