class Coupon{
  int id;
  String name;
  String message;
  String image;
  String action;
  String actionValue;
  String createdDate;

  Coupon({this.image, this.action, this.actionValue, this.name});

  Coupon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    message = json['message'];
    image = json['image'];
    action = json['action'];
    actionValue = json['actionValue'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['message'] = this.message;
    data['image'] = this.image;
    data['action'] = this.action;
    data['actionValue'] = this.actionValue;
    data['createdDate'] = this.createdDate;
    return data;
  }
}