import 'dart:convert';

class UserModel {
  String name;
  String profilePicURL;
  String userID;

  UserModel({
    required this.name,
    required this.profilePicURL,
    required this.userID,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePicURL': profilePicURL,
      'userID': userID,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      profilePicURL: map['profilePicURL'] as String,
      userID: map['userID'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
