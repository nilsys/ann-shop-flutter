class InApp {
  int id;
  String name;
  String image;
  String type;
  String value;
  String message;
  int status;
  String createdDate;

  InApp({this.image, this.type, this.value, this.name});

  InApp.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'] ?? 0;
    name = json['name'] ?? '';
    image = json['image'];
    type = json['type'];
    value = json['value'];
    message = json['message'] ?? '';
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['name'] = this.name;
    data['image'] = this.image;
    data['type'] = this.type;
    data['value'] = this.value;
    data['message'] = this.message;
    data['createdDate'] = this.createdDate;
    return data;
  }
}