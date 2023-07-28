class getCropsbyseason {
  int? statusCode;
  List<CropBySeasonResponse>? statusMessage;

  getCropsbyseason({this.statusCode, this.statusMessage});

  getCropsbyseason.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    if (json['status_message'] != null) {
      statusMessage = <CropBySeasonResponse>[];
      json['status_message'].forEach((v) {
        statusMessage!.add(new CropBySeasonResponse.fromJson(v));
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

class CropBySeasonResponse {
  int? id;
  String? cropId;
  String? cropName;
  String? cropNameHindi;
  String? cropSeason;
  String? cropDescription;
  String? img;
  String? cropNameHnd;
  String? showOnWebsite;
  String? plan;
  String? planId;
  String? cropAdvisary;
  String? advisaryId;
  String? seedSelection;
  String? seedSelectionId;
  String? diseaseStatus;
  String? status;
  String? trashStatus;
  String? createdAt;
  String? updatedAt;

  CropBySeasonResponse(
      {this.id,
      this.cropId,
      this.cropName,
      this.cropNameHindi,
      this.cropSeason,
      this.cropDescription,
      this.img,
      this.cropNameHnd,
      this.showOnWebsite,
      this.plan,
      this.planId,
      this.cropAdvisary,
      this.advisaryId,
      this.seedSelection,
      this.seedSelectionId,
      this.diseaseStatus,
      this.status,
      this.trashStatus,
      this.createdAt,
      this.updatedAt});

  CropBySeasonResponse.fromJson(Map<String, dynamic> json) {
   id = json['id'];
    cropId = json['crop_id'];
    cropName = json['crop_name'];
    cropNameHindi = json['crop_name_hindi'];
    cropSeason = json['crop_season'];
    cropDescription = json['crop_description'];
    img = json['img'];
    cropNameHnd = json['crop_name_hnd'];
    showOnWebsite = json['show_on_website'];
    plan = json['plan'];
    planId = json['plan_id'];
    cropAdvisary = json['crop_advisary'];
    advisaryId = json['advisary_id'];
    seedSelection = json['seed_selection'];
    seedSelectionId = json['seed_selection_id'];
    diseaseStatus = json['disease_status'];
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
    data['crop_name_hindi'] = this.cropNameHindi;
    data['crop_season'] = this.cropSeason;
    data['crop_description'] = this.cropDescription;
    data['img'] = this.img;
    data['crop_name_hnd'] = this.cropNameHnd;
    data['show_on_website'] = this.showOnWebsite;
    data['plan'] = this.plan;
    data['plan_id'] = this.planId;
    data['crop_advisary'] = this.cropAdvisary;
    data['advisary_id'] = this.advisaryId;
    data['seed_selection'] = this.seedSelection;
    data['seed_selection_id'] = this.seedSelectionId;
    data['disease_status'] = this.diseaseStatus;
    data['status'] = this.status;
    data['trash_status'] = this.trashStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
