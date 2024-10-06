class ProfileModel {
  String? name;
  String? bloodGroup;
  String? dob;
  String? phoneNo;
  String? email;
  String? address;
  String? aadharNo;
  String? panNo;
  String? drivingLisence;
  String? electionCard;

  ProfileModel({
    this.name,
    this.bloodGroup,
    this.dob,
    this.phoneNo,
    this.email,
    this.address,
    this.aadharNo,
    this.panNo,
    this.drivingLisence,
    this.electionCard,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'bloodGroup': bloodGroup,
        'dob': dob,
        'phoneNo': phoneNo,
        'email': email,
        'address': address,
        'aadharNo': aadharNo,
        'panNo': panNo,
        'drivingLisence': drivingLisence,
        'electionCard': electionCard,
      };

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        name: json['name'] as String?,
        bloodGroup: json['bloodGroup'] as String?,
        dob: json['dob'] as String?,
        phoneNo: json['phoneNo'] as String?,
        email: json['email'] as String?,
        address: json['address'] as String?,
        aadharNo: json['aadharNo'] as String?,
        panNo: json['panNo'] as String?,
        drivingLisence: json['drivingLisence'] as String?,
        electionCard: json['electionCard'] as String?,
      );
}
