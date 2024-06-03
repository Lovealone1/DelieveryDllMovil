import 'dart:developer';
import 'dart:io';

import 'package:covefood_users/controller/services/imageServices/imageServices.dart';
import 'package:flutter/material.dart';


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