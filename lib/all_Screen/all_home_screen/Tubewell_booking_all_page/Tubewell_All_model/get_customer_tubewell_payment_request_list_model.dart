class get_customer_tubewell_payment_request_list {
  int? statusCode;
  String? statusMessage;
  List<CustomerTubewellPaymentResponse>? response;

  get_customer_tubewell_payment_request_list(
      {this.statusCode, this.statusMessage, this.response});

  get_customer_tubewell_payment_request_list.fromJson(
      Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    if (json['response'] != null) {
      response = <CustomerTubewellPaymentResponse>[];
      json['response'].forEach((v) {
        response!.add(new CustomerTubewellPaymentResponse.fromJson(v));
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

class CustomerTubewellPaymentResponse {
 int? id;
  String? tubewellId;
  String? billId;
  String? userId;
  String? customerId;
  String? name;
  String? mobile;
  String? irrigation;
  String? startTime;
  String? endTime;
  String? date;
  String? rate;
  String? hours;
  String? total;
  String? paidAmt;
  String? currentDue;
  String? paidStatus;
  String? createdDate;
  String? status;
  String? trashStatus;
  String? createdAt;
  String? updatedAt;
  String? onwerName;
  String? onwerMobile;
  String? upiId;
  CustomerTubewellPaymentResponse(
      {this.id,
      this.tubewellId,
      this.billId,
      this.userId,
      this.customerId,
      this.name,
      this.mobile,
      this.irrigation,
      this.startTime,
      this.endTime,
      this.date,
      this.rate,
      this.hours,
      this.total,
      this.paidAmt,
      this.currentDue,
      this.paidStatus,
      this.createdDate,
      this.status,
      this.trashStatus,
      this.createdAt,
      this.updatedAt,
      this.onwerName,
      this.onwerMobile,
      this.upiId});

  CustomerTubewellPaymentResponse.fromJson(Map<String, dynamic> json) {
  id = json['id'];
    tubewellId = json['tubewell_id'];
    billId = json['bill_id'];
    userId = json['user_id'];
    customerId = json['customer_id'];
    name = json['name'];
    mobile = json['mobile'];
    irrigation = json['irrigation'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    date = json['date'];
    rate = json['rate'];
    hours = json['hours'];
    total = json['total'];
    paidAmt = json['paid_amt'];
    currentDue = json['current_due'];
    paidStatus = json['paid_status'];
    createdDate = json['created_date'];
    status = json['status'];
    trashStatus = json['trash_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    onwerName = json['onwer_name'];
    onwerMobile = json['onwer_mobile'];
    upiId = json['upi_id'];
  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tubewell_id'] = this.tubewellId;
    data['bill_id'] = this.billId;
    data['user_id'] = this.userId;
    data['customer_id'] = this.customerId;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['irrigation'] = this.irrigation;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['date'] = this.date;
    data['rate'] = this.rate;
    data['hours'] = this.hours;
    data['total'] = this.total;
    data['paid_amt'] = this.paidAmt;
    data['current_due'] = this.currentDue;
    data['paid_status'] = this.paidStatus;
    data['created_date'] = this.createdDate;
    data['status'] = this.status;
    data['trash_status'] = this.trashStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['onwer_name'] = this.onwerName;
    data['onwer_mobile'] = this.onwerMobile;
    data['upi_id'] = this.upiId;
    return data;
  }
}
