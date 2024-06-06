import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covefood_users/views/singInLogicScreen/signInLogicScreen.dart';
import 'package:covefood_users/widget/toastService.dart';
import 'package:flutter/material.dart';
import 'package:covefood_users/constant/constant.dart';
import 'package:covefood_users/controller/provider/profileProvider/profileProvider.dart';
import 'package:covefood_users/model/userAddressModel.dart';
import 'package:covefood_users/model/userModel.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class UserDataCRUDServices {
  static registerUser(UserModel data, BuildContext context) async {
    try {
      await firestore
          .collection('User')
          .doc(auth.currentUser!.uid)
          .set(data.toMap())
          .whenComplete(() {
        Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                child: const SignInLogicScreen(),
                type: PageTransitionType.rightToLeft),
            (route) => false);
      });
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  static addAddress(UserAddressModel data, BuildContext context) async {
    try {
      await firestore
          .collection('Address')
          .doc(data.addressID)
          .set(data.toMap())
          .whenComplete(() {
        ToastService.sendScaffoldAlert(
          msg: 'Dirección registrada correctamente',
          toastStatus: 'SUCCESS',
          context: context,
        );
      });
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  static fetchUserData() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('User').doc(auth.currentUser!.uid).get();
      UserModel data = UserModel.fromMap(snapshot.data()!);
      return data;
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  static fetchAddresses() async {
    List<UserAddressModel> addresses = [];
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Address')
          .where('userId', isEqualTo: auth.currentUser!.uid)
          .get();
      // ignore: avoid_function_literals_in_foreach_calls
      snapshot.docs.forEach((element) {
        addresses.add(UserAddressModel.fromMap(element.data()));
      });
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
    return addresses;
  }

  static fetchActiveAddress() async {
    List<UserAddressModel> addresses = [];
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('Address')
          .where('userId', isEqualTo: auth.currentUser!.uid)
          .where('isActive', isEqualTo: true)
          .get();
      snapshot.docs.forEach((element) {
        addresses.add(UserAddressModel.fromMap(element.data()));
      });
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
    return addresses[0];
  }

  static setAddressAsActive(UserAddressModel data, BuildContext context) async {
    List<UserAddressModel> addresses =
        context.read<ProfileProvider>().addresses;

    for (var addressData in addresses) {
      if (addressData.addressID != data.addressID) {
        await firestore
            .collection('Address')
            .doc(addressData.addressID)
            .update({'isActive': false});
      }
    }
    await firestore
        .collection('Address')
        .doc(data.addressID)
        .update({'isActive': true});
  }
}
