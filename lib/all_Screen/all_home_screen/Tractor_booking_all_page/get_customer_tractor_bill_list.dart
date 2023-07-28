class get_customer_tractor_payment_request_list {
  int? statusCode;
  String? statusMessage;
  List<CustomerTractorPaymentResponse>? response;

  get_customer_tractor_payment_request_list(
      {this.statusCode, this.statusMessage, this.response});

  get_customer_tractor_payment_request_list.fromJson(
      Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    if (json['response'] != null) {
      response = <CustomerTractorPaymentResponse>[];
      json['response'].forEach((v) {
        response!.add(new CustomerTractorPaymentResponse.fromJson(v));
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

class CustomerTractorPaymentResponse {
  int? id;
  String? tractorId;
  String? tractorBillId;
  String? tOwnerId;
  String? tUserId;
  String? tName;
  String? tMobile;
  String? tMachineryUsed;
  String? tStartDate;
  String? tEndDate;
  String? tUnit;
  String? tUsage;
  String? tHours;
  int? tTotal;
  int? tPaidAmt;
  int? tCurrentDue;
  String? tPaidStatus;
  String? createdDate;
  String? tStatus;
  String? trashStatus;
  String? createdAt;
  String? updatedAt;
  String? unitName;
  String? upiId;
  String? onwerName;
  String? onwerMobile;
  CustomerTractorPaymentResponse(
      {this.id,
      this.tractorId,
      this.tractorBillId,
      this.tOwnerId,
      this.tUserId,
      this.tName,
      this.tMobile,
      this.tMachineryUsed,
      this.tStartDate,
      this.tEndDate,
      this.tUnit,
      this.tUsage,
      this.tHours,
      this.tTotal,
      this.tPaidAmt,
      this.tCurrentDue,
      this.tPaidStatus,
      this.createdDate,
      this.tStatus,
      this.trashStatus,
      this.createdAt,
      this.updatedAt,
      this.unitName,
      this.upiId,
      this.onwerName,
      this.onwerMobile});

  CustomerTractorPaymentResponse.fromJson(Map<String, dynamic> json) {
   id = json['id'];
    tractorId = json['tractor_id'];
    tractorBillId = json['tractor_bill_id'];
    tOwnerId = json['t_owner_id'];
    tUserId = json['t_user_id'];
    tName = json['t_name'];
    tMobile = json['t_mobile'];
    tMachineryUsed = json['t_machinery_used'];
    tStartDate = json['t_start_date'];
    tEndDate = json['t_end_date'];
    tUnit = json['t_unit'];
    tUsage = json['t_usage'];
    tHours = json['t_hours'];
    tTotal = json['t_total'];
    tPaidAmt = json['t_paid_amt'];
    tCurrentDue = json['t_current_due'];
    tPaidStatus = json['t_paid_status'];
    createdDate = json['created_date'];
    tStatus = json['t_status'];
    trashStatus = json['trash_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    unitName = json['unit_name'];
    upiId = json['upi_id'];
    onwerName = json['onwer_name'];
    onwerMobile = json['onwer_mobile'];
  }

  Map<String, dynamic> toJson() {
   final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tractor_id'] = this.tractorId;
    data['tractor_bill_id'] = this.tractorBillId;
    data['t_owner_id'] = this.tOwnerId;
    data['t_user_id'] = this.tUserId;
    data['t_name'] = this.tName;
    data['t_mobile'] = this.tMobile;
    data['t_machinery_used'] = this.tMachineryUsed;
    data['t_start_date'] = this.tStartDate;
    data['t_end_date'] = this.tEndDate;
    data['t_unit'] = this.tUnit;
    data['t_usage'] = this.tUsage;
    data['t_hours'] = this.tHours;
    data['t_total'] = this.tTotal;
    data['t_paid_amt'] = this.tPaidAmt;
    data['t_current_due'] = this.tCurrentDue;
    data['t_paid_status'] = this.tPaidStatus;
    data['created_date'] = this.createdDate;
    data['t_status'] = this.tStatus;
    data['trash_status'] = this.trashStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['unit_name'] = this.unitName;
    data['upi_id'] = this.upiId;
    data['onwer_name'] = this.onwerName;
    data['onwer_mobile'] = this.onwerMobile;
    return data;
  }
}
