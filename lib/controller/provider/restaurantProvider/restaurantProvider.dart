import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:food_delievery/controller/services/authServices/fetchRestaurantsServices/fetchRestaurantServices.dart';
import 'package:food_delievery/model/foodModel.dart';
import 'package:food_delievery/model/restaurantModel.dart';

class RestaurantProvider extends ChangeNotifier {
  List<RestaurantModel> restaurants = [];
  List<FoodModel> foods = [];
  List<FoodModel> restaurantMenu = [];
  addRestaurants(String restaurantID)async{
    RestaurantModel data = await RestaurantServices.fetchRestaurantData(restaurantID);
    restaurants.add(data);
    notifyListeners();
    log('Restaurantes capturados');
    log(restaurants.length.toString());
  }

  addFoods(String restaurantID)async{
    List<FoodModel> foodData = await RestaurantServices.fetchFoodData(restaurantID);
    foods.addAll(foodData);
    notifyListeners();
    log('Total de platillos capturados');
    log(foods.length.toString());
  }

  getRestaurantMenu(String restaurantID){
    for(var data in foods){
      if(data.restaurantUID == restaurantID){
        restaurantMenu.add(data);
      }
    }
    notifyListeners();
  }

  emptyRestaurantMenu(){
    restaurantMenu = [];
    notifyListeners();
  }
}