import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delievery/constant/constant.dart';
import 'package:food_delievery/controller/provider/authProvider/MobileAuthProvider.dart';
import 'package:food_delievery/view/authScreens/mobileLoginScreen.dart';
import 'package:food_delievery/view/authScreens/otpScreen.dart';
import 'package:food_delievery/view/bottomNavigationBar/bottomNavigationBar.dart';
import 'package:food_delievery/view/signInLogicScreen/signInLoginScreen.dart';
import 'package:food_delievery/view/userRegistrationScreen/userRegistrationScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class MobileAuthServices {
  static bool checkAuthentication(BuildContext context) {
    User? user = auth.currentUser;
    if (user == null) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MobileLoginScreen()),
          (route) => false);
      return false;
    }
    checkUserRegistration(context: context);
    return true;
  }

  static recieveOTP(
      {required BuildContext context, required String mobileNo}) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: mobileNo,
        verificationCompleted: (PhoneAuthCredential credentials) {
          log(credentials.toString());
        },
        verificationFailed: (FirebaseAuthException exception) {
          log(exception.toString());
          throw Exception(exception);
        },
        codeSent: (String verificationID, int? resendToken) {
          context
              .read<MobileAuthProvider>()
              .updateVerificationID(verificationID);
          Navigator.push(
              context,
              PageTransition(
                  child: const OTPScreen(),
                  type: PageTransitionType.rightToLeft));
        },
        codeAutoRetrievalTimeout: (String verificationID) {},
      );
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  static verifyOTP({required BuildContext context, required String otp}) async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: context.read<MobileAuthProvider>().verificationID!,
        smsCode: otp,
      );
      await auth.signInWithCredential(credential);
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        PageTransition(
          child: const SignInLogicScreen(),
          type: PageTransitionType.rightToLeft,
        ),
      );
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  static checkUserRegistration({required BuildContext context}) async {
    bool userIsRegistered = false;
    try {
      await firestore
          .collection('User')
          .where('userID', isEqualTo: auth.currentUser!.uid)
          .get()
          .then((value) {
        value.size > 0 ? userIsRegistered = true : userIsRegistered = false;
        log('El usuario ya está registrado = $userIsRegistered');
        if (userIsRegistered) {
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                child: const BottomNavigationBarDelievery(),
                type: PageTransitionType.rightToLeft),
            (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                child: const UserRegistrationScreen(),
                type: PageTransitionType.rightToLeft),
            (route) => false,
          );
        }
      });
    } catch (e) {
      log(e.toString());
      throw Exception(e);
    }
  }

  static signOut(BuildContext context) {
    auth.signOut();
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) {
      return const SignInLogicScreen();
    }), (route) => false);
  }

  static Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Iniciar el flujo de autenticación de Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtener los detalles de autenticación de la solicitud
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Crear una credencial con los tokens de acceso e ID
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Iniciar sesión con la credencial de Google en Firebase
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Verificar si el usuario está registrado
      bool isUserRegistered = await checkUserRegistration(context: context);

      // Si el usuario está registrado, lo redirigimos a la aplicación
      if (isUserRegistered) {
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            child: const BottomNavigationBarDelievery(),
            type: PageTransitionType.rightToLeft,
          ),
          (route) => false,
        );
      } else {
        // Si el usuario no está registrado, lo redirigimos a la pantalla de registro
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            child: const UserRegistrationScreen(),
            type: PageTransitionType.rightToLeft,
          ),
          (route) => false,
        );
      }
    } catch (e) {
      // Manejar cualquier error que pueda ocurrir durante el proceso
      throw Exception('Error al iniciar sesión con Google: $e');
    }
  }
}
