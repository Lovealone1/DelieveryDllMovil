import 'dart:developer';

import 'package:covefood_users/controller/services/fetchRestaurantServices/fetchRestaurantServices.dart';
import 'package:covefood_users/model/foodModel.dart';
import 'package:covefood_users/model/restaurantModel.dart';
import 'package:flutter/material.dart';
class RestaurantProvider extends ChangeNotifier {
  List<RestaurantModel> restaurants = [];
  List<FoodModel> foods = [];
  List<FoodModel> restaurantMenu = [];
  List<FoodModel> searchedFood = [];
  addRestaurants(String restaurantID) async {
    RestaurantModel data =
        await RestaurantServices.fetchRestaurantData(restaurantID);
    restaurants.add(data);
    notifyListeners();
    log('Restaurantes capturados');
    log(restaurants.length.toString());
  }

  addFoods(String restaurantID) async {
    List<FoodModel> foodData =
        await RestaurantServices.fetchFoodData(restaurantID);
    foods.addAll(foodData);
    notifyListeners();
    log('Total de platillos capturados');
    log(foods.length.toString());
  }

  getRestaurantMenu(String restaurantID) {
    for (var data in foods) {
      if (data.restaurantUID == restaurantID) {
        restaurantMenu.add(data);
      }
    }
    notifyListeners();
  }

  emptyRestaurantMenu() {
    restaurantMenu = [];
    notifyListeners();
  }

  defultSearchedFood(){
    searchedFood = foods; 
    notifyListeners();
  }

  searchFoodItems(String foodName) {
    searchedFood = [];
    notifyListeners();
    for (var data in foods) {
      if (data.name.toLowerCase().contains(foodName.toLowerCase())) {
        searchedFood.add(data);
      }
    }
    notifyListeners();
  }
}