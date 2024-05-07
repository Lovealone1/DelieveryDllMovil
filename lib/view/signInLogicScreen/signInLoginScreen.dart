import 'package:flutter/material.dart';
import 'package:food_delievery/controller/services/authServices/mobileAuthServices.dart';

class SignInLogicScreen extends StatefulWidget {
  const SignInLogicScreen({super.key});

  @override
  State<SignInLogicScreen> createState() => _SignInLogicScreenState();
}

class _SignInLogicScreenState extends State<SignInLogicScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MobileAuthServices.checkAuthentication(context);
     });
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Image(
        image: AssetImage(
          'assets/images/splashScreenImage/SplashScreen.png',
        ),fit: BoxFit.fill,
      ),
    );
  }
}
