import 'dart:convert';

class RestaurantIDnLocationModel{
  
  String id;
  double latitude;
  double longitude;
  RestaurantIDnLocationModel({
    required this.id,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory RestaurantIDnLocationModel.fromMap(Map<String, dynamic> map) {
    return RestaurantIDnLocationModel(
      id: map['id'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory RestaurantIDnLocationModel.fromJson(String source) => RestaurantIDnLocationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}