import 'package:flutter/material.dart';

class MobileAuthProvider extends ChangeNotifier{
  String? verificationID; 
  String? mobileNumber; 
  updateVerificationID(String verification){
    verificationID = verification; 
    notifyListeners();
  }

  updateMobileNumber(String number){
    mobileNumber = number; 
    notifyListeners();
  }
}