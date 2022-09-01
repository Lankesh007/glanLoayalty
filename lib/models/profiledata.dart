class ProfileData {
  int errorCode;
  String errorMessage;
  List<ProfileResponse> profileresponse;

  ProfileData({this.errorCode, this.errorMessage, this.profileresponse});

  ProfileData.fromJson(Map<String, dynamic> json) {
    errorCode = json['ErrorCode'];
    errorMessage = json['ErrorMessage'];
    if (json['Response'] != null) {
      profileresponse = <ProfileResponse>[];
      json['Response'].forEach((v) {
        profileresponse.add(new ProfileResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ErrorCode'] = this.errorCode;
    data['ErrorMessage'] = this.errorMessage;
    if (this.profileresponse != null) {
      data['Response'] = this.profileresponse.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProfileResponse {
  int id;
  String username;
  String email;
  String landmark;
  String latitude;
  String longitude;
  String mobile;
  String clinicName;
  String gstin;
  String address;
  String pincode;
  String profileImage;
  String panNo;
  String referralCode;
  String agentCode;
  String uploadPhoto;
  String uploadGstCertificate;
  String uploadPancard;
  String uploadAgricultureLicense;
  String myReferralCode;
  String userWallet;

  ProfileResponse(
      {
        this.id,
        this.username,
        this.email,
        this.landmark,
        this.latitude,
        this.longitude,
        this.mobile,
        this.clinicName,
        this.gstin,
        this.address,
        this.pincode,
        this.profileImage,
        this.panNo,
        this.referralCode,
        this.agentCode,
        this.uploadPhoto,
        this.uploadGstCertificate,
        this.uploadPancard,
        this.uploadAgricultureLicense,
        this.myReferralCode,
        this.userWallet
      });

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    landmark = json['landmark'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    mobile = json['mobile'];
    clinicName = json['clinic_name'];
    gstin = json['gstin'];
    address = json['address'];
    pincode = json['pincode'];
    profileImage = json['profile_image'];
    panNo = json['pan_no'];
    referralCode = json['referral_code'];
    agentCode = json['agent_code'];
    uploadPhoto = json['upload_photo'];
    uploadGstCertificate = json['upload_gst_certificate'];
    uploadPancard = json['upload_pancard'];
    uploadAgricultureLicense = json['upload_agriculture_license'];
    myReferralCode = json['my_referral_code'];
    userWallet = json['user_wallet'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['landmark'] = this.landmark;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['mobile'] = this.mobile;
    data['clinic_name'] = this.clinicName;
    data['gstin'] = this.gstin;
    data['address'] = this.address;
    data['pincode'] = this.pincode;
    data['profile_image'] = this.profileImage;
    data['pan_no'] = this.panNo;
    data['referral_code'] = this.referralCode;
    data['agent_code'] = this.agentCode;
    data['upload_photo'] = this.uploadPhoto;
    data['upload_gst_certificate'] = this.uploadGstCertificate;
    data['upload_pancard'] = this.uploadPancard;
    data['upload_agriculture_license'] = this.uploadAgricultureLicense;
    data['my_referral_code'] = this.myReferralCode;
    data['user_wallet'] = this.userWallet;
    return data;
  }
}