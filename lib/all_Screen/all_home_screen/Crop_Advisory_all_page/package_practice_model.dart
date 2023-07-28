class get_all_practices {
  int? statusCode;
  String? statusMessage;
  List<AllPracticesResponse>? response;

  get_all_practices({this.statusCode, this.statusMessage, this.response});

  get_all_practices.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    if (json['response'] != null) {
      response = <AllPracticesResponse>[];
      json['response'].forEach((v) {
        response!.add(new AllPracticesResponse.fromJson(v));
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

class AllPracticesResponse {
  int? id;
  String? advisryId;
  String? advisryCropId;
  String? advisryCAdvisryId;
  String? advisryOrderNumber;
  String? advisoryLanguage;
  String? advisryTitle;
  String? advisary_title_hindi;
  String? advisary_des_hindi;
  String? advisryDescription;
  String? advisryImage;
  String? status;
  String? trashStatus;
  String? createdAt;
  String? updatedAt;

  AllPracticesResponse(
      {this.id,
      this.advisryId,
      this.advisryCropId,
      this.advisryCAdvisryId,
      this.advisryOrderNumber,
      this.advisoryLanguage,
      this.advisryTitle,
      this.advisary_title_hindi,
      this.advisary_des_hindi,
      this.advisryDescription,
      this.advisryImage,
      this.status,
      this.trashStatus,
      this.createdAt,
      this.updatedAt});

  AllPracticesResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    advisryId = json['advisry_id'];
    advisryCropId = json['advisry_crop_id'];
    advisryCAdvisryId = json['advisry_c_advisry_id'];
    advisryOrderNumber = json['advisry_order_number'];
    advisoryLanguage = json['advisory_language'];
    advisryTitle = json['advisry_title'];
    advisary_title_hindi = json['advisary_title_hindi'];
    advisary_des_hindi = json['advisary_des_hindi'];
    advisryDescription = json['advisry_description'];
    advisryImage = json['advisry_image'];
    status = json['status'];
    trashStatus = json['trash_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['advisry_id'] = this.advisryId;
    data['advisry_crop_id'] = this.advisryCropId;
    data['advisry_c_advisry_id'] = this.advisryCAdvisryId;
    data['advisry_order_number'] = this.advisryOrderNumber;
    data['advisory_language'] = this.advisoryLanguage;
    data['advisry_title'] = this.advisryTitle;
    data['advisary_title_hindi'] = this.advisary_title_hindi;
    data['advisary_des_hindi'] = this.advisary_des_hindi;
    data['advisry_description'] = this.advisryDescription;
    data['advisry_image'] = this.advisryImage;
    data['status'] = this.status;
    data['trash_status'] = this.trashStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
