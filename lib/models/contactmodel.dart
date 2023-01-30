// To parse this JSON data, do
//
//     final contact = contactFromJson(jsonString);

import 'dart:convert';

List<Contact> contactFromJson(String str) =>
    List<Contact>.from(json.decode(str).map((x) => Contact.fromJson(x)));

String contactToJson(List<Contact> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Contact {
  Contact({
    this.idContact,
    this.detailContact,
    this.createdDate,
    this.updateDate,
  });

  String? idContact;
  String? detailContact;
  DateTime? createdDate;
  dynamic? updateDate;

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
        idContact: json["id_contact"] == null ? null : json["id_contact"],
        detailContact:
            json["detail_contact"] == null ? null : json["detail_contact"],
        createdDate: json["created_date"] == null
            ? null
            : DateTime.parse(json["created_date"]),
        updateDate: json["update_date"],
      );

  Map<String, dynamic> toJson() => {
        "id_contact": idContact == null ? null : idContact,
        "detail_contact": detailContact == null ? null : detailContact,
        "created_date":
            createdDate == null ? null : createdDate!.toIso8601String(),
        "update_date": updateDate,
      };
}
