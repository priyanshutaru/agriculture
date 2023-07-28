class formlist {
  int? statusCode;
  String? statusMessage;
  List<Response>? response;

  formlist({this.statusCode, this.statusMessage, this.response});

  formlist.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    if (json['response'] != null) {
      response = <Response>[];
      json['response'].forEach((v) {
        response!.add(new Response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['status_message'] = this.statusMessage;
    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  int? id;
  String? userId;
  String? title;
  String? stateId;
  String? districtId;
  String? tehsilId;
  String? gramShabha;
  String? pin;
  Null? acName;
  String? landNo;
  String? landSize;
  String? status;
  String? trashStatus;
  String? createdAt;
  String? updatedAt;

  Response(
      {this.id,
        this.userId,
        this.title,
        this.stateId,
        this.districtId,
        this.tehsilId,
        this.gramShabha,
        this.pin,
        this.acName,
        this.landNo,
        this.landSize,
        this.status,
        this.trashStatus,
        this.createdAt,
        this.updatedAt});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    stateId = json['state_id'];
    districtId = json['district_id'];
    tehsilId = json['tehsil_id'];
    gramShabha = json['gram_shabha'];
    pin = json['pin'];
    acName = json['ac_name'];
    landNo = json['land_no'];
    landSize = json['land_size'];
    status = json['status'];
    trashStatus = json['trash_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['state_id'] = this.stateId;
    data['district_id'] = this.districtId;
    data['tehsil_id'] = this.tehsilId;
    data['gram_shabha'] = this.gramShabha;
    data['pin'] = this.pin;
    data['ac_name'] = this.acName;
    data['land_no'] = this.landNo;
    data['land_size'] = this.landSize;
    data['status'] = this.status;
    data['trash_status'] = this.trashStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}