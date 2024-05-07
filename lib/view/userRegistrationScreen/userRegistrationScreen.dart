import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_delievery/constant/constant.dart';
import 'package:food_delievery/controller/provider/profileProvider/profileProvider.dart';
import 'package:food_delievery/controller/services/imageServices/imageServices.dart';
import 'package:food_delievery/controller/services/locationServices/locationServices.dart';
import 'package:food_delievery/controller/services/userDataCRUDServices/userDataCRUDServices.dart';
import 'package:food_delievery/model/userAddressModel.dart';
import 'package:food_delievery/model/userModel.dart';
import 'package:food_delievery/utils/colors.dart';
import 'package:food_delievery/utils/textStyles.dart';
import 'package:food_delievery/widgets/commonElevatedButton.dart';
import 'package:food_delievery/widgets/textFieldWidget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class UserRegistrationScreen extends StatefulWidget {
  const UserRegistrationScreen({super.key});

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController houseController = TextEditingController();
  TextEditingController apartmentController = TextEditingController();
  TextEditingController saveAddressAsController = TextEditingController();
  bool registerButtonPressed = false;
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(6.2529, -75.5646),
    zoom: 14,
  );
  Completer<GoogleMapController> googleMapController = Completer();
  GoogleMapController? mapController;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          title: Text(
            'Registrate!',
            style: AppTextStyles.body16Bold,
          ),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          children: [
            SizedBox(
              height: 2.h,
            ),
            Consumer<ProfileProvider>(
                builder: (context, profileProvider, child) {
              return InkWell(
                onTap: () async {
                  await context
                      .read<ProfileProvider>()
                      .pickImageFromGallery(context);
                },
                child: CircleAvatar(
                  radius: 5.h,
                  backgroundColor: black,
                  child: CircleAvatar(
                      backgroundColor: white,
                      radius: 5.h - 2,
                      backgroundImage: profileProvider.profileImage != null
                          ? FileImage(profileProvider.profileImage!)
                          : null,
                      child: profileProvider.profileImage == null
                          ? FaIcon(
                              FontAwesomeIcons.user,
                              size: 4.h,
                              color: black,
                            )
                          : null),
                ),
              );
            }),
            SizedBox(
              height: 4.h,
            ),
            CommonTextfield(
              controller: nameController,
              title: 'Nombre',
              hintText: 'Nombre completo',
              keyboardType: TextInputType.name,
            ),
            SizedBox(
              height: 4.h,
            ),
            Text(
              'Dirección',
              style: AppTextStyles.body16Bold,
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              height: 40.h,
              width: 100.w,
              child: GoogleMap(
                initialCameraPosition: initialCameraPosition,
                mapType: MapType.normal,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                zoomControlsEnabled: true,
                zoomGesturesEnabled: true,
                onMapCreated: (GoogleMapController controller) async {
                  googleMapController.complete(controller);
                  mapController = controller;
                  Position currentPosition =
                      await LocationServices.getCurrentLocation();
                  LatLng currentLatLong = LatLng(
                    currentPosition.latitude,
                    currentPosition.longitude,
                  );
                  CameraPosition cameraPosition = CameraPosition(
                    target: currentLatLong,
                    zoom: 14,
                  );
                  mapController!.animateCamera(
                      CameraUpdate.newCameraPosition(cameraPosition));
                },
              ),
            ),
            SizedBox(
              height: 4.h,
            ),
            CommonTextfield(
              controller: houseController,
              title: 'Numero de casa',
              hintText: 'Ingrese el numero de casa',
              keyboardType: TextInputType.name,
            ),
            SizedBox(
              height: 4.h,
            ),
            CommonTextfield(
              controller: apartmentController,
              title: 'Apartamento',
              hintText: 'Numero de apartamento',
              keyboardType: TextInputType.name,
            ),
            SizedBox(
              height: 4.h,
            ),
            CommonTextfield(
              controller: saveAddressAsController,
              title: 'Guardar dirección como',
              hintText: 'Trabajo/ Casa/ Familia/',
              keyboardType: TextInputType.name,
            ),
            SizedBox(
              height: 4.h,
            ),
            CommonElevatedButton(
                onPressed: () async {
                  setState(() {
                    registerButtonPressed = true;
                  });
                  List<String> urls =
                      await ImageServices.uploadImagesToFirebaseStorageNGetURL(
                    images: [context.read<ProfileProvider>().profileImage!],
                    context: context,
                  );
                  UserModel userData = UserModel(
                    name: nameController.text.trim(),
                    profilePicURL: urls[0],
                    userID: auth.currentUser!.uid,
                  );
                  Position location =
                      await LocationServices.getCurrentLocation();
                  String addressID = uuid.v1().toString();
                  UserAddressModel addressData = UserAddressModel(
                      addressID: addressID,
                      userId: auth.currentUser!.uid,
                      latitude: location.latitude,
                      longitude: location.longitude,
                      houseNumber: houseController.text.trim(),
                      apartment: apartmentController.text.trim(),
                      addressTitle: saveAddressAsController.text.trim(),
                      uploadTime: DateTime.now(),
                      isActive: true);
                  // ignore: use_build_context_synchronously
                  UserDataCRUDServices.registerUser(
                    userData,
                    context,
                  );

                  // ignore: use_build_context_synchronously
                  await UserDataCRUDServices.addAddress(addressData, context);
                },
                color: black,
                child: registerButtonPressed
                    ? CircularProgressIndicator(
                        color: white,
                      )
                    : Text(
                        'Guardar dirección',
                        style: AppTextStyles.body16Bold.copyWith(color: white),
                      ))
          ],
        ),
      ),
    );
  }
}
