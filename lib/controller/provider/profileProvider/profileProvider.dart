import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_delievery/controller/services/imageServices/imageServices.dart';

class ProfileProvider extends ChangeNotifier{
  File? profileImage;
  String? profileImageURL; 

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
}