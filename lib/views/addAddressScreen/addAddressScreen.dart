// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:covefood_users/constant/constant.dart';
import 'package:covefood_users/controller/provider/profileProvider/profileProvider.dart';
import 'package:covefood_users/controller/services/locationServices/locationServices.dart';
import 'package:covefood_users/controller/services/userDataCRUDServices/userDataCRUDServices.dart';
import 'package:covefood_users/model/userAddressModel.dart';
import 'package:covefood_users/utils/colors.dart';
import 'package:covefood_users/utils/textStyles.dart';
import 'package:covefood_users/widget/commonElevatedButton.dart';
import 'package:covefood_users/widget/textFieldWidget.dart';
import 'package:covefood_users/widget/toastService.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
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
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: FaIcon(
              FontAwesomeIcons.arrowLeft,
              color: black,
            ),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: 3.w,
            vertical: 2.h,
          ),
          children: [
            Text(
              'Agregar nueva dirección',
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
                      isActive: false);
                  await UserDataCRUDServices.addAddress(addressData, context);
                  Navigator.pop(context);
                  context.read<ProfileProvider>().fetchUserAddresses();
                  ToastService.sendScaffoldAlert(
                    msg: 'Dirección agregada correctamente',
                    toastStatus: 'SUCCESS',
                    context: context,
                  );
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
