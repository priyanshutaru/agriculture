class Show_Me_Plane {
  int? statusCode;
  String? statusMessage;
  List<Response>? response;

  Show_Me_Plane({this.statusCode, this.statusMessage, this.response});

  Show_Me_Plane.fromJson(Map<String, dynamic> json) {
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
  String? userCropPlanId;
  String? userCropID;
  String? userPlanID;
  String? userUserID;
  String? userDateOfShowing;
  String? addedOn;
  String? taskStatus;
  String? createdAt;
  Null? updateAt;
  String? trashStatus;
  String? cropId;
  String? cropName;
  String? img;
  Null? cropNameHnd;
  String? plan;
  String? planId;
  String? cropAdvisary;
  Null? advisaryId;
  String? seedSelection;
  String? seedSelectionId;
  String? status;
  String? updatedAt;

  Response(
      {this.id,
        this.userCropPlanId,
        this.userCropID,
        this.userPlanID,
        this.userUserID,
        this.userDateOfShowing,
        this.addedOn,
        this.taskStatus,
        this.createdAt,
        this.updateAt,
        this.trashStatus,
        this.cropId,
        this.cropName,
        this.img,
        this.cropNameHnd,
        this.plan,
        this.planId,
        this.cropAdvisary,
        this.advisaryId,
        this.seedSelection,
        this.seedSelectionId,
        this.status,
        this.updatedAt});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userCropPlanId = json['user_CropPlan_id'];
    userCropID = json['user_cropID'];
    userPlanID = json['user_planID'];
    userUserID = json['user_userID'];
    userDateOfShowing = json['user_date_of_showing'];
    addedOn = json['addedOn'];
    taskStatus = json['task_status'];
    createdAt = json['created_at'];
    updateAt = json['update_at'];
    trashStatus = json['trash_status'];
    cropId = json['crop_id'];
    cropName = json['crop_name'];
    img = json['img'];
    cropNameHnd = json['crop_name_hnd'];
    plan = json['plan'];
    planId = json['plan_id'];
    cropAdvisary = json['crop_advisary'];
    advisaryId = json['advisary_id'];
    seedSelection = json['seed_selection'];
    seedSelectionId = json['seed_selection_id'];
    status = json['status'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_CropPlan_id'] = this.userCropPlanId;
    data['user_cropID'] = this.userCropID;
    data['user_planID'] = this.userPlanID;
    data['user_userID'] = this.userUserID;
    data['user_date_of_showing'] = this.userDateOfShowing;
    data['addedOn'] = this.addedOn;
    data['task_status'] = this.taskStatus;
    data['created_at'] = this.createdAt;
    data['update_at'] = this.updateAt;
    data['trash_status'] = this.trashStatus;
    data['crop_id'] = this.cropId;
    data['crop_name'] = this.cropName;
    data['img'] = this.img;
    data['crop_name_hnd'] = this.cropNameHnd;
    data['plan'] = this.plan;
    data['plan_id'] = this.planId;
    data['crop_advisary'] = this.cropAdvisary;
    data['advisary_id'] = this.advisaryId;
    data['seed_selection'] = this.seedSelection;
    data['seed_selection_id'] = this.seedSelectionId;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}