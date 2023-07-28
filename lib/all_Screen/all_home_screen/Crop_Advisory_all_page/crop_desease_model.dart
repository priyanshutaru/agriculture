class get_all_crop_disease {
  int? statusCode;
  String? statusMessage;
  List<CropDesaesesResponse>? response;

  get_all_crop_disease({this.statusCode, this.statusMessage, this.response});

  get_all_crop_disease.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    if (json['response'] != null) {
      response = <CropDesaesesResponse>[];
      json['response'].forEach((v) {
        response!.add(new CropDesaesesResponse.fromJson(v));
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

class CropDesaesesResponse {
  int? id;
  String? diseaseId;
  String? cropId;
  String? diseaseLanguage;
  String? disesTitle;
  String? disease_title_hindi;
  String? disesImage;
  String? disesDescription;
  String? disease_dis_hindi;
  String? disesStatus;
  String? disesAddedBy;
  String? createdAt;
  String? updatedAt;
  String? trashStatus;

  CropDesaesesResponse(
      {this.id,
      this.diseaseId,
      this.cropId,
      this.diseaseLanguage,
      this.disesTitle,
      this.disease_title_hindi,
      this.disesImage,
      this.disesDescription,
      this.disease_dis_hindi,
      this.disesStatus,
      this.disesAddedBy,
      this.createdAt,
      this.updatedAt,
      this.trashStatus});

  CropDesaesesResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    diseaseId = json['disease_id'];
    cropId = json['crop_id'];
    diseaseLanguage = json['disease_language'];
    disesTitle = json['dises_title'];
    disease_title_hindi = json['disease_title_hindi'];
    disesImage = json['dises_image'];

    disesDescription = json['dises_description'];
    disease_dis_hindi = json['disease_dis_hindi'];
    disesStatus = json['dises_status'];
    disesAddedBy = json['dises_added_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    trashStatus = json['trash_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['disease_id'] = this.diseaseId;
    data['crop_id'] = this.cropId;
    data['disease_language'] = this.diseaseLanguage;
    data['dises_title'] = this.disesTitle;
    data['disease_title_hindi'] = this.disease_title_hindi;
    data['dises_image'] = this.disesImage;
    data['dises_description'] = this.disesDescription;
    data['disease_dis_hindi'] = this.disease_dis_hindi;
    data['dises_status'] = this.disesStatus;
    data['dises_added_by'] = this.disesAddedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['trash_status'] = this.trashStatus;
    return data;
  }
}
