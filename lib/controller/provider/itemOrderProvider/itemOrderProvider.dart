import 'package:covefood_users/controller/services/foodOrderServices/foodOrderServices.dart';
import 'package:covefood_users/model/foodModel.dart';
import 'package:flutter/material.dart';

class ItemOrderProvider extends ChangeNotifier{
  List<FoodModel> cartItems = [];

  fetchCartItems()async{
    cartItems = await FoodOrderServices.fetchCartData();
    notifyListeners();
  }
}