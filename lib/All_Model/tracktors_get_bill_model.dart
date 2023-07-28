class get_tractor_bill {
  int? statusCode;
  List<Data>? data;

  get_tractor_bill({this.statusCode, this.data});

  get_tractor_bill.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  Null? tractorId;
  String? tractorBillId;
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

  Data(
      {this.id,
        this.tractorId,
        this.tractorBillId,
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

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tractorId = json['tractor_id'];
    tractorBillId = json['tractor_bill_id'];
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