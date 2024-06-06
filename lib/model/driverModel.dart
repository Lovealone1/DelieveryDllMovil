import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DriverModel {
  String? name; 
  String? profilePictureURL; 
  String? mobileNumber; 
  String? driverID;
  String? vehicleRegistrationNumber;
  String? drivingLicenceNumber; 
  DateTime? registeredDateTime; 
  String? activeDelieveryRequestID;
  String? driverStatus; 
  String? cloudMessagingToken; 
  DriverModel({
    this.name,
    this.profilePictureURL,
    this.mobileNumber,
    this.driverID,
    this.vehicleRegistrationNumber,
    this.drivingLicenceNumber,
    this.registeredDateTime,
    this.activeDelieveryRequestID,
    this.driverStatus,
    this.cloudMessagingToken,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePictureURL': profilePictureURL,
      'mobileNumber': mobileNumber,
      'driverID': driverID,
      'vehicleRegistrationNumber': vehicleRegistrationNumber,
      'drivingLicenceNumber': drivingLicenceNumber,
      'registeredDateTime': registeredDateTime?.millisecondsSinceEpoch,
      'activeDelieveryRequestID': activeDelieveryRequestID,
      'driverStatus': driverStatus,
      'cloudMessagingToken': cloudMessagingToken,
    };
  }

  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      name: map['name'] != null ? map['name'] as String : null,
      profilePictureURL: map['profilePictureURL'] != null ? map['profilePictureURL'] as String : null,
      mobileNumber: map['mobileNumber'] != null ? map['mobileNumber'] as String : null,
      driverID: map['driverID'] != null ? map['driverID'] as String : null,
      vehicleRegistrationNumber: map['vehicleRegistrationNumber'] != null ? map['vehicleRegistrationNumber'] as String : null,
      drivingLicenceNumber: map['drivingLicenceNumber'] != null ? map['drivingLicenceNumber'] as String : null,
      registeredDateTime: map['registeredDateTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['registeredDateTime'] as int) : null,
      activeDelieveryRequestID: map['activeDelieveryRequestID'] != null ? map['activeDelieveryRequestID'] as String : null,
      driverStatus: map['driverStatus'] != null ? map['driverStatus'] as String : null,
      cloudMessagingToken: map['cloudMessagingToken'] != null ? map['cloudMessagingToken'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DriverModel.fromJson(String source) => DriverModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
