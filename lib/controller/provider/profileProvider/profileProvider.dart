import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:covefood_users/controller/services/imageServices/imageServices.dart';
import 'package:covefood_users/controller/services/userDataCRUDServices/userDataCRUDServices.dart';
import 'package:covefood_users/model/userAddressModel.dart';
import 'package:covefood_users/model/userModel.dart';

class ProfileProvider extends ChangeNotifier{
  File? profileImage;
  String? profileImageURL; 
  UserModel? userData;
  List<UserAddressModel> addresses = [];
  UserAddressModel? activeAddress;
  pickImageFromGallery(BuildContext context)async{
    profileImage = await ImageServices.pickSingleImage(context: context);
    notifyListeners();
  }

  uploadImageAndGetImageURL(BuildContext context) async{
    List<String> url =
        await ImageServices.uploadImagesToFirebaseStorageNGetURL(
            images: [profileImage!], context: context,);
    if(url.isNotEmpty){
      profileImageURL = url[0];
      log(profileImageURL!);
    }
    notifyListeners();
  }

  fetchUserData()async{
    userData = await UserDataCRUDServices.fetchUserData();
    notifyListeners();
    log(userData!.toMap().toString());
  }

  fetchUserAddresses()async{
    addresses = await UserDataCRUDServices.fetchAddresses();
    for (var address in addresses) {
      if(address.isActive){
        activeAddress = address;
      }
    }
    notifyListeners();
    log(activeAddress!.toMap().toString());
  }
}