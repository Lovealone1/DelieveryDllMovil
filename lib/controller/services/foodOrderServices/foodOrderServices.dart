// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covefood_users/constant/constant.dart';
import 'package:covefood_users/controller/provider/itemOrderProvider/itemOrderProvider.dart';
import 'package:covefood_users/controller/services/pushNotificationServices/pushNotificationServices.dart';
import 'package:covefood_users/model/foodModel.dart';
import 'package:covefood_users/model/foodOrderModel.dart';
import 'package:covefood_users/widget/toastService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FoodOrderServices {
  static orderStatus(int status) {
    switch (status) {
      case 0:
        return 'PREPARANDO_COMIDA';
      case 1:
        return 'COMIDA_RECOGIDA_POR_DOMICILIARIO';
      case 2:
        return 'COMIDA_ENTREGADA';
    }
  }

  static placeFoodOrderRequest(
      FoodOrderModel foodOrderModel, BuildContext context) async {
    try {
      // Convert the food order model to a map
      Map<String, dynamic> orderMap = foodOrderModel.toMap();

      // Log the entire map to see its structure and values
      log('Order Map: $orderMap');

      // Validate and log each key-value pair
      orderMap.forEach((key, value) {
        log('Key: $key, Value: $value, Type: ${value.runtimeType}');
        if (value is DateTime) {
          throw ArgumentError('Invalid DateTime value for key: $key');
        }
      });

      // Attempt to set the data in the database
      await realTimeDatabaseref
          .child('Orders/${foodOrderModel.orderID}')
          .set(orderMap);

      // Log success message
      log('Order placed successfully: ${orderMap.toString()}');

      // Trigger push notification
      PushNotificationServices.sendPushNotificationToRestaurant(foodOrderModel);

      // Show success toast
      ToastService.sendScaffoldAlert(
        msg: 'La orden se ha hecho satisfactoriamente',
        toastStatus: 'SUCCESS',
        context: context,
      );
    } catch (error) {
      // Log the error with a detailed message
      log('Error placing order: ${error.toString()}');

      // Show error toast
      ToastService.sendScaffoldAlert(
        msg: 'Error al hacer su pedido',
        toastStatus: 'ERROR',
        context: context,
      );
    }
  }

  static addToCart(FoodOrderModel foodOrderModel, BuildContext context) async {
    realTimeDatabaseref
        .child('Cart/${auth.currentUser!.uid}/${foodOrderModel.orderID}')
        .set(foodOrderModel.toMap())
        .then((value) {
      ToastService.sendScaffoldAlert(
        msg: 'Platillo agregado al carrito',
        toastStatus: 'SUCCESS',
        context: context,
      );
    }).onError((error, stackTrace) {
      ToastService.sendScaffoldAlert(
        msg: 'Error al agregar al carrito',
        toastStatus: 'ERROR',
        context: context,
      );
    });
  }

  static addItemToCart(FoodModel foodData, BuildContext context) async {
    try {
      await firestore
          .collection('Cart')
          .doc(auth.currentUser!.uid)
          .collection('CartItem')
          .doc(foodData.orderID)
          .set(foodData.toMap())
          .whenComplete(() {
        ToastService.sendScaffoldAlert(
            msg: 'Platillo agregado al carrito',
            toastStatus: 'SUCCESS',
            context: context);
      });
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  static fetchCartData() async {
    List<FoodModel> itemAddedToCart = [];
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Cart')
          .doc(auth.currentUser!.uid)
          .collection('CartItem')
          .orderBy(
            'addedToCartAt',
            descending: true,
          )
          .get();
      snapshot.docs.forEach((element) {
        itemAddedToCart.add(FoodModel.fromMap(element.data()));
      });
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
    return itemAddedToCart;
  }

  static updateQuantity(String cartItemID, int currentQuantity,
      BuildContext context, bool isAdded) async {
    try {
      if (currentQuantity == 1 && !isAdded) {
        await firestore
            .collection('Cart')
            .doc(auth.currentUser!.uid)
            .collection('CartItem')
            .doc(cartItemID)
            .delete()
            .then((value) {
          context.read<ItemOrderProvider>().fetchCartItems();
        });
      }
      await firestore
          .collection('Cart')
          .doc(auth.currentUser!.uid)
          .collection('CartItem')
          .doc(cartItemID)
          .update({
        'quantity': isAdded ? currentQuantity + 1 : currentQuantity - 1
      }).then((value) {
        context.read<ItemOrderProvider>().fetchCartItems();
      });
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }
}
