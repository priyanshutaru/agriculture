class get_search_list {
  int? statusCode;
  String? statusMessage;
  List<SearchResponse>? response;

  get_search_list({this.statusCode, this.statusMessage, this.response});

  get_search_list.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    if (json['response'] != null) {
      response = <SearchResponse>[];
      json['response'].forEach((v) {
        response!.add(new SearchResponse.fromJson(v));
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

class SearchResponse {
int? id;
  String? userId;
  String? mobile;
  String? otp;
  String? name;
  String? img;
  String? imgName;
  String? address;
  String? thana;
  String? tehsil;
  String? district;
  String? pin;
  String? state;
  String? landsize;
  String? unitId;
  String? haveTractor;
  String? haveTubewell;
  String? profileStatus;
  String? status;
  String? trashStatus;
  String? createdAt;
  String? updatedAt;
  String? paymentDetails;
  String? paymentName;
  String? paymentUpiId;
  String? paymentAddedOn;
  String? paymentStatus;

  SearchResponse(
      {this.id,
      this.userId,
      this.mobile,
      this.otp,
      this.name,
      this.img,
      this.imgName,
      this.address,
      this.thana,
      this.tehsil,
      this.district,
      this.pin,
      this.state,
      this.landsize,
      this.unitId,
      this.haveTractor,
      this.haveTubewell,
      this.profileStatus,
      this.status,
      this.trashStatus,
      this.createdAt,
      this.updatedAt,
      this.paymentDetails,
      this.paymentName,
      this.paymentUpiId,
      this.paymentAddedOn,
      this.paymentStatus});

  SearchResponse.fromJson(Map<String, dynamic> json) {
   id = json['id'];
    userId = json['user_id'];
    mobile = json['mobile'];
    otp = json['otp'];
    name = json['name'];
    img = json['img'];
    imgName = json['img_name'];
    address = json['address'];
    thana = json['thana'];
    tehsil = json['tehsil'];
    district = json['district'];
    pin = json['pin'];
    state = json['state'];
    landsize = json['landsize'];
    unitId = json['unit_id'];
    haveTractor = json['have_tractor'];
    haveTubewell = json['have_tubewell'];
    profileStatus = json['profile_status'];
    status = json['status'];
    trashStatus = json['trash_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    paymentDetails = json['payment_details'];
    paymentName = json['payment_name'];
    paymentUpiId = json['payment_upi_id'];
    paymentAddedOn = json['payment_added_on'];
    paymentStatus = json['payment_status'];
  }

  Map<String, dynamic> toJson() {
   final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['mobile'] = this.mobile;
    data['otp'] = this.otp;
    data['name'] = this.name;
    data['img'] = this.img;
    data['img_name'] = this.imgName;
    data['address'] = this.address;
    data['thana'] = this.thana;
    data['tehsil'] = this.tehsil;
    data['district'] = this.district;
    data['pin'] = this.pin;
    data['state'] = this.state;
    data['landsize'] = this.landsize;
    data['unit_id'] = this.unitId;
    data['have_tractor'] = this.haveTractor;
    data['have_tubewell'] = this.haveTubewell;
    data['profile_status'] = this.profileStatus;
    data['status'] = this.status;
    data['trash_status'] = this.trashStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['payment_details'] = this.paymentDetails;
    data['payment_name'] = this.paymentName;
    data['payment_upi_id'] = this.paymentUpiId;
    data['payment_added_on'] = this.paymentAddedOn;
    data['payment_status'] = this.paymentStatus;
    return data;
  }
}