class owner_payment_list_model {
  int? statusCode;
  String? statusMessage;
  List<Res>? response;

  owner_payment_list_model(
      {this.statusCode, this.statusMessage, this.response});

  owner_payment_list_model.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    if (json['response'] != null) {
      response = <Res>[];
      json['response'].forEach((v) {
        response!.add(new Res.fromJson(v));
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

class Res {
  int? id;
  Null? tractorId;
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

  Res(
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
        this.updatedAt});

  Res.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}