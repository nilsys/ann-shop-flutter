class Account {
  String phone;
  String fullName;
  int gender;
  String address;

  Account({this.phone, this.fullName, this.gender, this.address});

  Account.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    fullName = json['fullName'];
    gender = json['gender'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['fullName'] = this.fullName;
    data['gender'] = this.gender;
    data['address'] = this.address;
    return data;
  }
}