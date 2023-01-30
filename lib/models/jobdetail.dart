// To parse this JSON data, do
//
//     final jobdetail = jobdetailFromJson(jsonString);

import 'dart:convert';

List<Jobdetail> jobdetailFromJson(String str) =>
    List<Jobdetail>.from(json.decode(str).map((x) => Jobdetail.fromJson(x)));

String jobdetailToJson(List<Jobdetail> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Jobdetail {
  Jobdetail({
    this.idJobDetail,
    this.idJob,
    this.titleDetail,
    this.textDetail,
    this.warringDetail,
    this.statusDetail,
    this.statusScore,
    this.createdDate,
    this.updateDate,
    this.time,
  });

  String? idJobDetail;
  String? idJob;
  String? titleDetail;
  String? textDetail;
  dynamic warringDetail;
  String? statusDetail;
  String? statusScore;
  DateTime? createdDate;
  dynamic updateDate;
  String? time;

  factory Jobdetail.fromJson(Map<String, dynamic> json) => Jobdetail(
        idJobDetail:
            json["id_job_detail"] == null ? null : json["id_job_detail"],
        idJob: json["id_job"] == null ? null : json["id_job"],
        titleDetail: json["title_detail"] == null ? null : json["title_detail"],
        textDetail: json["text_detail"] == null ? null : json["text_detail"],
        warringDetail: json["warring_detail"],
        statusDetail:
            json["status_detail"] == null ? null : json["status_detail"],
        statusScore: json["status_score"] == null ? null : json["status_score"],
        createdDate: json["created_date"] == null
            ? null
            : DateTime.parse(json["created_date"]),
        updateDate: json["update_date"],
        time: json["time"] == null ? null : json["time"],
      );

  Map<String, dynamic> toJson() => {
        "id_job_detail": idJobDetail == null ? null : idJobDetail,
        "id_job": idJob == null ? null : idJob,
        "title_detail": titleDetail == null ? null : titleDetail,
        "text_detail": textDetail == null ? null : textDetail,
        "warring_detail": warringDetail,
        "status_detail": statusDetail == null ? null : statusDetail,
        "status_score": statusScore == null ? null : statusScore,
        "created_date":
            createdDate == null ? null : createdDate!.toIso8601String(),
        "update_date": updateDate,
        "time": time == null ? null : time,
      };
}
