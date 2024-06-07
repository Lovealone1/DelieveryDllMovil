import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:covefood_users/controller/services/APIsNKetys/APIs.dart';
import 'package:covefood_users/controller/services/APIsNKetys/keys.dart';
import 'package:covefood_users/model/driverModel.dart';
import 'package:covefood_users/model/foodOrderModel.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:covefood_users/constant/constant.dart';
import 'package:http/http.dart' as http;

class PushNotificationServices {
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static Future initializeFirebaseMessaging() async {
    await firebaseMessaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(firebaseMessagingForegroundHandler);
  }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {}

  static Future<void> firebaseMessagingForegroundHandler(
      RemoteMessage message) async {}

  static Future getToken() async {
    String? token = await firebaseMessaging.getToken();
    log('Token: \n$token');
    await firestore
        .collection('User')
        .doc(auth.currentUser!.uid)
        .update({'cloudMessagingToken': token});
  }

  static subscribeToNotification() {
    firebaseMessaging.subscribeToTopic('COVEFOOD_USER');
  }

  static initializeFCM() {
    initializeFirebaseMessaging();
    getToken();
    subscribeToNotification();
  }

  static sendPushNotificationToNearbyDriveryPartners(DriverModel delieveryPartner, String foodName) async {
      try {
      final api = Uri.parse(APIs.pushNotificationAPI());
      var body = jsonEncode({
        "to": delieveryPartner.cloudMessagingToken,
        "notification": {
          "body": "Domicilio disponible!",
          "title": "Tenemos un domicilio disponible para ti",
        },
        "data": {"foodName": "Text"}
      });
      var headers = {
        'Content-type': 'application/json',
        'Authorization': 'key=$fcmServerKey'
      };
      // ignore: unused_local_variable
      var response = await http.post(api, headers: headers, body: body).then((value){
        log('Notificacion push enviada satisfactoriamente');
      }).timeout(const Duration(seconds: 60), onTimeout:(){
        log('Connection timed out');
        throw TimeoutException('Connection timed out');
      }).onError((error, stackTrace){
        log(error.toString());
        throw Exception(error);
      });
    } catch (e) {
      log(e.toString());
        throw Exception(e);
    }
    
    
  }

  static sendPushNotificationToRestaurant(FoodOrderModel foodOrderData) async {
    try {
      final api = Uri.parse(APIs.pushNotificationAPI());
      var body = jsonEncode({
        "to": foodOrderData.restaurantDetails.cloudMessagingToken,
        "notification": {
          "body": "Nueva orden de ${foodOrderData.foodDetails.name}",
          "title": "Nueva orden ${foodOrderData.foodDetails.name}",
        },
        "data": foodOrderData.toMap
      });
      var headers = {
        'Content-type': 'application/json',
        'Authorization': 'key=$fcmServerKey'
      };
      // ignore: unused_local_variable
      var response = await http.post(api, headers: headers, body: body).then((value){
        log('Notificacion push enviada satisfactoriamente');
      }).timeout(const Duration(seconds: 60), onTimeout:(){
        log('Connection timed out');
        throw TimeoutException('Connection timed out');
      }).onError((error, stackTrace){
        log(error.toString());
        throw Exception(error);
      });
    } catch (e) {
      log(e.toString());
        throw Exception(e);
    }
  }
}
