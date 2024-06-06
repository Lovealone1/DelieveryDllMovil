import 'dart:convert';
import 'dart:developer';

import 'package:covefood_users/constant/constant.dart';
import 'package:covefood_users/controller/services/pushNotificationServices/pushNotificationServices.dart';
import 'package:covefood_users/controller/services/userDataCRUDServices/userDataCRUDServices.dart';
import 'package:covefood_users/model/delieveryPartnerLocationModel.dart';
import 'package:covefood_users/model/driverModel.dart';
import 'package:covefood_users/model/userAddressModel.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

class DelieveryPartnerServices {
  static getNearbyDelieveryPartners() async {
    Geofire.initialize('OnlineDrivers');
    //Position currentPosition = await LocationServices.getCurrentLocation();
    UserAddressModel userActiveAddress =
        await UserDataCRUDServices.fetchActiveAddress();
    log(userActiveAddress.toMap().toString());
    Geofire.queryAtLocation(
      userActiveAddress.latitude,
      userActiveAddress.longitude,
      20,
    )!
        .listen((event) async {
      if (event != null) {
        log('Event is not null');
        var callback = event['callBack'];
        switch (callback) {
          case Geofire.onKeyEntered:
            DelieveryPartnerLocationModel model = DelieveryPartnerLocationModel(
              id: event['key'],
              latitude: event['latitude'],
              longitude: event['longitude'],
            );
            log('La data del domiciliario es');

            DriverModel delieveryPartnerData = await getDelieveryPartnerProfileData(model.id);
            log(delieveryPartnerData.toMap().toString());
            PushNotificationServices.sendPushNotificationToNearbyDriveryPartners(delieveryPartnerData, 'foodName');

          case Geofire.onGeoQueryReady:
            log('Query Ready');
            break;
        }
      }
    });
  }

  static getDelieveryPartnerProfileData(String driverID) async {
    try {
      final shapshot =
          await realTimeDatabaseref.child('Driver/$driverID').get();
      if (shapshot.exists) {
        DriverModel delieveryPartnerData = DriverModel.fromMap(
            jsonDecode(jsonEncode(shapshot.value)) as Map<String, dynamic>);
            return delieveryPartnerData;
      }
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }
}
