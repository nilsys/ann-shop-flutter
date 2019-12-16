class CopySetting {
  bool productCode;
  bool productName;
  int bonusPrice;
  String phoneNumber;
  String address;

  CopySetting(
      {this.productCode = true,
      this.productName = true,
      this.bonusPrice = 50000,
      this.phoneNumber = '',
      this.address = ''});

  CopySetting.fromJson(Map<String, dynamic> json) {
    productCode = json['productCode'];
    productName = json['productName'];
    bonusPrice = json['bonusPrice'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productCode'] = this.productCode;
    data['productName'] = this.productName;
    data['bonusPrice'] = this.bonusPrice;
    data['phoneNumber'] = this.phoneNumber;
    data['address'] = this.address;
    return data;
  }
}
