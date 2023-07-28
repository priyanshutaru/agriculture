class get_tubewell_customer_list {
  int? statusCode;
  String? statusMessage;
  List<CustomerResponse>? response;

  get_tubewell_customer_list({this.statusCode, this.statusMessage, this.response});

  get_tubewell_customer_list.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    if (json['response'] != null) {
      response = <CustomerResponse>[];
      json['response'].forEach((v) {
        response!.add(new CustomerResponse.fromJson(v));
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

class CustomerResponse {
  int? id;
  String? tw_cstmr_id;
  String? tw_owner_id;
  String? tw_cstmr_userID;
  String? tw_cstmr_name;
  String? tw_cstmr_number;
  String? tw_cstmr_user_status;
  String? status;
  String? createdAt;
  Null? updatedAt;
  String? trashStatus;

  CustomerResponse(
      {this.id,
        this.tw_cstmr_id,
        this.tw_owner_id,
        this.tw_cstmr_userID,
        this.tw_cstmr_name,
        this.tw_cstmr_number,
        this.tw_cstmr_user_status,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.trashStatus});

  CustomerResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tw_cstmr_id = json['tw_cstmr_id'];
    tw_owner_id = json['tw_owner_id'];
    tw_cstmr_userID = json['tw_cstmr_userID'];
    tw_cstmr_name = json['tw_cstmr_name'];
    tw_cstmr_number = json['tw_cstmr_number'];
    tw_cstmr_user_status = json['tw_cstmr_user_status'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    trashStatus = json['trash_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tw_cstmr_id'] = this.tw_cstmr_id;
    data['tw_owner_id'] = this.tw_owner_id;
    data['tw_cstmr_userID'] = this.tw_cstmr_userID;
    data['tw_cstmr_name'] = this.tw_cstmr_name;
    data['tw_cstmr_number'] = this.tw_cstmr_number;
    data['tw_cstmr_user_status'] = this.tw_cstmr_user_status;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['trash_status'] = this.trashStatus;
    return data;
  }
}