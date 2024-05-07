import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserAddressModel {
  String addressID;
  String userId;
  double latitude; 
  double longitude; 
  String houseNumber;
  String apartment;
  String addressTitle; 
  DateTime uploadTime; 
  bool isActive; 
  UserAddressModel({
    required this.addressID,
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.houseNumber,
    required this.apartment,
    required this.addressTitle,
    required this.uploadTime,
    required this.isActive,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'addressID': addressID,
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
      'houseNumber': houseNumber,
      'apartment': apartment,
      'addressTitle': addressTitle,
      'uploadTime': uploadTime.millisecondsSinceEpoch,
      'isActive': isActive,
    };
  }

  factory UserAddressModel.fromMap(Map<String, dynamic> map) {
    return UserAddressModel(
      addressID: map['addressID'] as String,
      userId: map['userId'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      houseNumber: map['houseNumber'] as String,
      apartment: map['apartment'] as String,
      addressTitle: map['addressTitle'] as String,
      uploadTime: DateTime.fromMillisecondsSinceEpoch(map['uploadTime'] as int),
      isActive: map['isActive'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserAddressModel.fromJson(String source) => UserAddressModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
