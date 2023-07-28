class get_customer_list {
  int? statusCode;
  String? statusMessage;
  List<Response>? response;

  get_customer_list({this.statusCode, this.statusMessage, this.response});

  get_customer_list.fromJson(Map<String, dynamic> json) {
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
  String? utcrId;
  String? ownerId;
  String? utcrUserId;
  String? utcrUserName;
  String? utcrUserMobile;
  String? utcrNewOld;
  String? utcrStatus;
  String? createdAt;
  Null? updatedAt;
  String? trashStatus;

  Response(
      {this.id,
        this.utcrId,
        this.ownerId,
        this.utcrUserId,
        this.utcrUserName,
        this.utcrUserMobile,
        this.utcrNewOld,
        this.utcrStatus,
        this.createdAt,
        this.updatedAt,
        this.trashStatus});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    utcrId = json['utcr_id'];
    ownerId = json['owner_id'];
    utcrUserId = json['utcr_user_id'];
    utcrUserName = json['utcr_user_name'];
    utcrUserMobile = json['utcr_user_mobile'];
    utcrNewOld = json['utcr_new_old'];
    utcrStatus = json['utcr_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    trashStatus = json['trash_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['utcr_id'] = this.utcrId;
    data['owner_id'] = this.ownerId;
    data['utcr_user_id'] = this.utcrUserId;
    data['utcr_user_name'] = this.utcrUserName;
    data['utcr_user_mobile'] = this.utcrUserMobile;
    data['utcr_new_old'] = this.utcrNewOld;
    data['utcr_status'] = this.utcrStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['trash_status'] = this.trashStatus;
    return data;
  }
}