import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delievery/controller/provider/authProvider/MobileAuthProvider.dart';
import 'package:food_delievery/controller/services/authServices/mobileAuthServices.dart';
import 'package:food_delievery/utils/colors.dart';
import 'package:food_delievery/utils/textStyles.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:country_picker/country_picker.dart';

class MobileLoginScreen extends StatefulWidget {
  const MobileLoginScreen({super.key});

  @override
  State<MobileLoginScreen> createState() => _MobileLoginScreenState();
}

class _MobileLoginScreenState extends State<MobileLoginScreen> {
  String selectedCountry = '+57';
  TextEditingController mobileController = TextEditingController();
  bool receiveOTPButtonPressed = false; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        receiveOTPButtonPressed = false; 
      });
     });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        children: [
          SizedBox(
            height: 3.h,
          ),
          Text(
            'Ingresa tu número de celular',
            style: AppTextStyles.body16,
          ),
          SizedBox(
            height: 3.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    showPhoneCode:
                        true, // optional. Shows phone code before the country name.
                    onSelect: (Country country) {
                      setState(() {
                        selectedCountry = '+${country.phoneCode}';
                      });
                      print('Select country: ${country.displayName}');
                    },
                  );
                },
                child: Container(
                  height: 6.h,
                  width: 25.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.sp),
                    border: Border.all(color: grey)
                    //color: greyShade3,
                  ),
                  child: Text(
                    selectedCountry,
                    style: AppTextStyles.body14,
                  ),
                ),
              ),
              SizedBox(
                  width: 65.w,
                  child: TextField(
                    controller: mobileController,
                    cursorColor: black,
                    style: AppTextStyles.textFieldTextStyle,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 2.w),
                      hintText: 'Numero de celular',
                      hintStyle: AppTextStyles.textFieldHintTextStyle,
                      //filled: true,
                      //fillColor: greyShade3,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: black,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: grey,
                          )),
                    ),
                  ))
            ],
          ),
          SizedBox(
            height: 3.h,
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  receiveOTPButtonPressed = true; 
                });
                context.read<MobileAuthProvider>().updateMobileNumber('$selectedCountry${mobileController.text.trim()}');
                MobileAuthServices.recieveOTP(context: context, mobileNo: '$selectedCountry${mobileController.text.trim()}');
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: black,
                  minimumSize: Size(90.w, 6.h),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  )),
              child: receiveOTPButtonPressed? CircularProgressIndicator(color:white ,): Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Siguiente',
                      style: AppTextStyles.body16.copyWith(color: white),
                    ),
                  ),
                  Positioned(
                      right: 2.w,
                      child: Icon(Icons.arrow_forward, color: white, size: 4.h))
                ],
              )),
          SizedBox(
            height: 3.w,
          ),
          Text(
            'Al proceder, das tu consentimiento para recibir llamadas, mensajes de WhatsApp o SMS, incluso de forma automática, de delievery y sus afiliados al número proporcionado.',
            style: AppTextStyles.small12.copyWith(color: grey),
          ),
          SizedBox(
            height: 2.h,
          ),
          Row(
            children: [
              Expanded(
                  child: Divider(
                color: grey,
              )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Text(
                  'o',
                  style: AppTextStyles.small12.copyWith(color: grey),
                ),
              ),
              Expanded(
                  child: Divider(
                color: grey,
              ))
            ],
          ),
          SizedBox(
            height: 2.h,
          ),
          ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: white,
                  minimumSize: Size(90.w, 6.h),
                  elevation: 2,
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Continuar con Google',
                      style: AppTextStyles.body16,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Positioned(
                      left: 2.w,
                      child: FaIcon(
                        FontAwesomeIcons.google,
                        color: black,
                        size: 3.h,
                      ))
                ],
              ))
        ],
      )),
    );
  }
}
