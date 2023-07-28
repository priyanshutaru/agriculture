class Edit_Profile {
  int? statusCode;
  List<Data>? data;

  Edit_Profile({this.statusCode, this.data});

  Edit_Profile.fromJson(Map<String, dynamic> json) {
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
  int? stateId;
  String? countryId;
  String? stateTitle;
  String? stateDescription;
  String? status;

  Data(
      {this.stateId,
        this.countryId,
        this.stateTitle,
        this.stateDescription,
        this.status});

  Data.fromJson(Map<String, dynamic> json) {
    stateId = json['state_id'];
    countryId = json['country_id'];
    stateTitle = json['state_title'];
    stateDescription = json['state_description'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['state_id'] = this.stateId;
    data['country_id'] = this.countryId;
    data['state_title'] = this.stateTitle;
    data['state_description'] = this.stateDescription;
    data['status'] = this.status;
    return data;
  }
}
