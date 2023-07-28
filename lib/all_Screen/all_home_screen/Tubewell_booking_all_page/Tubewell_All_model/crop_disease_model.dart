class all_disease_list {
  int? statusCode;
  String? statusMessage;
  List<DiseaseResponse>? response;

  all_disease_list({this.statusCode, this.statusMessage, this.response});

  all_disease_list.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    if (json['response'] != null) {
      response = <DiseaseResponse>[];
      json['response'].forEach((v) {
        response!.add(new DiseaseResponse.fromJson(v));
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

class DiseaseResponse {
  int? id;
  String? diseaseId;
  String? cropId;
  String? diseaseLanguage;
  String? disesTitle;
  String? diseaseTitleHindi;
  String? disesImage;
  String? disesDescription;
  String? diseaseDisHindi;
  String? disesStatus;
  String? disesAddedBy;
  String? createdAt;
  String? updatedAt;
  String? trashStatus;
  List<String>? diseaseImages;

  DiseaseResponse(
      {this.id,
      this.diseaseId,
      this.cropId,
      this.diseaseLanguage,
      this.disesTitle,
      this.diseaseTitleHindi,
      this.disesImage,
      this.disesDescription,
      this.diseaseDisHindi,
      this.disesStatus,
      this.disesAddedBy,
      this.createdAt,
      this.updatedAt,
      this.trashStatus,
      this.diseaseImages});

  DiseaseResponse.fromJson(Map<String, dynamic> json) {
 id = json['id'];
    diseaseId = json['disease_id'];
    cropId = json['crop_id'];
    diseaseLanguage = json['disease_language'];
    disesTitle = json['dises_title'];
    diseaseTitleHindi = json['disease_title_hindi'];
    disesImage = json['dises_image'];
    disesDescription = json['dises_description'];
    diseaseDisHindi = json['disease_dis_hindi'];
    disesStatus = json['dises_status'];
    disesAddedBy = json['dises_added_by'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    trashStatus = json['trash_status'];
    diseaseImages = json['disease_images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
   final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['disease_id'] = this.diseaseId;
    data['crop_id'] = this.cropId;
    data['disease_language'] = this.diseaseLanguage;
    data['dises_title'] = this.disesTitle;
    data['disease_title_hindi'] = this.diseaseTitleHindi;
    data['dises_image'] = this.disesImage;
    data['dises_description'] = this.disesDescription;
    data['disease_dis_hindi'] = this.diseaseDisHindi;
    data['dises_status'] = this.disesStatus;
    data['dises_added_by'] = this.disesAddedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['trash_status'] = this.trashStatus;
    data['disease_images'] = this.diseaseImages;
    return data;
  }
}
