import 'package:flutter/material.dart';
import 'package:food_delievery/view/authScreens/mobileLoginScreen.dart';
import 'package:sizer/sizer.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, _,__){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
        ),
        home: MobileLoginScreen()
      );
    });

  }
}


