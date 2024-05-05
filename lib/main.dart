import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_delievery/controller/provider/authProvider/MobileAuthProvider.dart';
import 'package:food_delievery/controller/provider/restaurantProvider/restaurantProvider.dart';
import 'package:food_delievery/firebase_options.dart';
//import 'package:food_delievery/view/authScreens/mobileLoginScreen.dart';
//import 'package:food_delievery/view/authScreens/otpScreen.dart';
//import 'package:food_delievery/view/bottomNavigationBar/bottomNavigationBar.dart';
import 'package:food_delievery/view/signInLogicScreen/signInLoginScreen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FoodDelievery());
}

class FoodDelievery extends StatelessWidget {
  const FoodDelievery({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, _, __) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<MobileAuthProvider>(
            create: (_) => MobileAuthProvider(),
          ),
          ChangeNotifierProvider<RestaurantProvider>(
            create: (_) => RestaurantProvider(),
          ),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(),
            home: const SignInLogicScreen()),
      );
    });
  }
}
