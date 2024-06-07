import 'package:covefood_users/controller/provider/authProvider/mobileAuthProvider.dart';
import 'package:covefood_users/controller/provider/itemOrderProvider/itemOrderProvider.dart';
import 'package:covefood_users/controller/provider/profileProvider/profileProvider.dart';
import 'package:covefood_users/controller/provider/restaurantProvider/restaurantProvider.dart';
import 'package:covefood_users/firebase_options.dart';
import 'package:covefood_users/views/singInLogicScreen/signInLogicScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
          ChangeNotifierProvider<ProfileProvider>(
            create: (_) => ProfileProvider(),
          ),
          ChangeNotifierProvider<ItemOrderProvider>(
            create: (_) => ItemOrderProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(),
          home: const SignInLogicScreen(),
          //home: UserRegistrationScreen(),
        ),
      );
    });
  }
}