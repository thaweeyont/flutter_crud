// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User {
  User({
    this.id,
    this.idcard,
    this.fullname,
    this.addressUser,
    this.phoneUser,
    this.profileUser,
    this.statusMember,
    this.status,
    this.createdDate,
    this.updateDate,
  });

  String? id;
  String? idcard;
  String? fullname;
  String? addressUser;
  String? phoneUser;
  String? profileUser;
  String? statusMember;
  String? status;
  DateTime? createdDate;
  dynamic updateDate;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        idcard: json["idcard"] == null ? null : json["idcard"],
        fullname: json["fullname"] == null ? null : json["fullname"],
        addressUser: json["address_user"] == null ? null : json["address_user"],
        phoneUser: json["phone_user"] == null ? null : json["phone_user"],
        profileUser: json["profile_user"] == null ? null : json["profile_user"],
        statusMember:
            json["status_member"] == null ? null : json["status_member"],
        status: json["status"] == null ? null : json["status"],
        createdDate: json["created_date"] == null
            ? null
            : DateTime.parse(json["created_date"]),
        updateDate: json["update_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "idcard": idcard == null ? null : idcard,
        "fullname": fullname == null ? null : fullname,
        "address_user": addressUser == null ? null : addressUser,
        "phone_user": phoneUser == null ? null : phoneUser,
        "profile_user": profileUser == null ? null : profileUser,
        "status_member": statusMember == null ? null : statusMember,
        "status": status == null ? null : status,
        "created_date":
            createdDate == null ? null : createdDate!.toIso8601String(),
        "update_date": updateDate,
      };
}
