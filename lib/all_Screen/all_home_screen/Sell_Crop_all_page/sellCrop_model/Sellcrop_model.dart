class sellcroplist {
  int? statusCode;
  List<StatusMessage>? statusMessage;

  sellcroplist({this.statusCode, this.statusMessage});

  sellcroplist.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    if (json['status_message'] != null) {
      statusMessage = <StatusMessage>[];
      json['status_message'].forEach((v) {
        statusMessage!.add(new StatusMessage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    if (this.statusMessage != null) {
      data['status_message'] =
          this.statusMessage!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StatusMessage {
  int? id;
  String? cropId;
  String? cropName;
  String? img;
  String? cropNameHnd;
  String? plan;
  String? planId;
  String? status;
  String? trashStatus;
  String? createdAt;
  String? updatedAt;

  StatusMessage(
      {this.id,
        this.cropId,
        this.cropName,
        this.img,
        this.cropNameHnd,
        this.plan,
        this.planId,
        this.status,
        this.trashStatus,
        this.createdAt,
        this.updatedAt});

  StatusMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cropId = json['crop_id'];
    cropName = json['crop_name'];
    img = json['img'];
    cropNameHnd = json['crop_name_hnd'];
    plan = json['plan'];
    planId = json['plan_id'];
    status = json['status'];
    trashStatus = json['trash_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['crop_id'] = this.cropId;
    data['crop_name'] = this.cropName;
    data['img'] = this.img;
    data['crop_name_hnd'] = this.cropNameHnd;
    data['plan'] = this.plan;
    data['plan_id'] = this.planId;
    data['status'] = this.status;
    data['trash_status'] = this.trashStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
