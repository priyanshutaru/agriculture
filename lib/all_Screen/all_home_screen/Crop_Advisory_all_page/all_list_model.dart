class get_all_task_list {
  int? statusCode;
  String? statusMessage;
  List<AllTaskResponse>? response;

  get_all_task_list({
    this.statusCode,
    this.statusMessage,
    this.response,
  });

  get_all_task_list.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    if (json['response'] != null) {
      response = <AllTaskResponse>[];
      json['response'].forEach((v) {
        response!.add(new AllTaskResponse.fromJson(v));
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

class AllTaskResponse {
   int? id;
  String? userCptlId;
  String? userCptlUserID;
  String? userCptlCropplanID;
  String? userCptlTaskId;
  String? userCptlStartDate;
  String? userCptlEndDate;
  String? userCptlFinishedOn;
  String? userCptlStatus;
  String? createdAt;
  String? updateAt;
  String? trashStatus;
  String? taskId;
  String? cropId;
  String? planId;
  String? taskNo;
  String? taskLanguage;
  String? haveDisease;
  String? title;
  String? tip;
  String? insHeading;
  String? instDes;
  String? instDur;
  String? status;
  String? updatedAt;
  String? cropName;
  String? cropNameHindi;
  String? cropSeason;
  String? cropDescription;
  String? img;
  String? cropNameHnd;
  String? showOnWebsite;
  String? plan;
  String? cropAdvisary;
  String? advisaryId;
  String? seedSelection;
  String? seedSelectionId;
  String? diseaseStatus;
  String? cropids;
  String? taskStatus;

  AllTaskResponse(
      {this.id,
      this.userCptlId,
      this.userCptlUserID,
      this.userCptlCropplanID,
      this.userCptlTaskId,
      this.userCptlStartDate,
      this.userCptlEndDate,
      this.userCptlFinishedOn,
      this.userCptlStatus,
      this.createdAt,
      this.updateAt,
      this.trashStatus,
      this.taskId,
      this.cropId,
      this.planId,
      this.taskNo,
      this.taskLanguage,
      this.haveDisease,
      this.title,
      this.tip,
      this.insHeading,
      this.instDes,
      this.instDur,
      this.status,
      this.updatedAt,
      this.cropName,
      this.cropNameHindi,
      this.cropSeason,
      this.cropDescription,
      this.img,
      this.cropNameHnd,
      this.showOnWebsite,
      this.plan,
      this.cropAdvisary,
      this.advisaryId,
      this.seedSelection,
      this.seedSelectionId,
      this.diseaseStatus,
      this.cropids,
      this.taskStatus});

  AllTaskResponse.fromJson(Map<String, dynamic> json) {
 id = json['id'];
    userCptlId = json['user_cptl_id'];
    userCptlUserID = json['user_cptl_user_ID'];
    userCptlCropplanID = json['user_cptl_cropplanID'];
    userCptlTaskId = json['user_cptl_task_id'];
    userCptlStartDate = json['user_cptl_start_date'];
    userCptlEndDate = json['user_cptl_end_date'];
    userCptlFinishedOn = json['user_cptl_finished_on'];
    userCptlStatus = json['user_cptl_status'];
    createdAt = json['created_at'];
    updateAt = json['update_at'];
    trashStatus = json['trash_status'];
    taskId = json['task_id'];
    cropId = json['crop_id'];
    planId = json['plan_id'];
    taskNo = json['task_no'];
    taskLanguage = json['task_language'];
    haveDisease = json['have_disease'];
    title = json['title'];
    tip = json['tip'];
    insHeading = json['ins_heading'];
    instDes = json['inst_des'];
    instDur = json['inst_dur'];
    status = json['status'];
    updatedAt = json['updated_at'];
    cropName = json['crop_name'];
    cropNameHindi = json['crop_name_hindi'];
    cropSeason = json['crop_season'];
    cropDescription = json['crop_description'];
    img = json['img'];
    cropNameHnd = json['crop_name_hnd'];
    showOnWebsite = json['show_on_website'];
    plan = json['plan'];
    cropAdvisary = json['crop_advisary'];
    advisaryId = json['advisary_id'];
    seedSelection = json['seed_selection'];
    seedSelectionId = json['seed_selection_id'];
    diseaseStatus = json['disease_status'];
    cropids = json['cropids'];
    taskStatus = json['task_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_cptl_id'] = this.userCptlId;
    data['user_cptl_user_ID'] = this.userCptlUserID;
    data['user_cptl_cropplanID'] = this.userCptlCropplanID;
    data['user_cptl_task_id'] = this.userCptlTaskId;
    data['user_cptl_start_date'] = this.userCptlStartDate;
    data['user_cptl_end_date'] = this.userCptlEndDate;
    data['user_cptl_finished_on'] = this.userCptlFinishedOn;
    data['user_cptl_status'] = this.userCptlStatus;
    data['created_at'] = this.createdAt;
    data['update_at'] = this.updateAt;
    data['trash_status'] = this.trashStatus;
    data['task_id'] = this.taskId;
    data['crop_id'] = this.cropId;
    data['plan_id'] = this.planId;
    data['task_no'] = this.taskNo;
    data['task_language'] = this.taskLanguage;
    data['have_disease'] = this.haveDisease;
    data['title'] = this.title;
    data['tip'] = this.tip;
    data['ins_heading'] = this.insHeading;
    data['inst_des'] = this.instDes;
    data['inst_dur'] = this.instDur;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['crop_name'] = this.cropName;
    data['crop_name_hindi'] = this.cropNameHindi;
    data['crop_season'] = this.cropSeason;
    data['crop_description'] = this.cropDescription;
    data['img'] = this.img;
    data['crop_name_hnd'] = this.cropNameHnd;
    data['show_on_website'] = this.showOnWebsite;
    data['plan'] = this.plan;
    data['crop_advisary'] = this.cropAdvisary;
    data['advisary_id'] = this.advisaryId;
    data['seed_selection'] = this.seedSelection;
    data['seed_selection_id'] = this.seedSelectionId;
    data['disease_status'] = this.diseaseStatus;
    data['cropids'] = this.cropids;
    data['task_status'] = this.taskStatus;
    return data;
  }
}

