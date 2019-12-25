class Cover {
  String name;
  String image;
  String type;
  String value;
  String message;

  Cover({this.image, this.type, this.value, this.name});

  Cover.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    type = json['type'];
    value = json['value'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['type'] = this.type;
    data['value'] = this.value;
    data['message'] = this.message;
    return data;
  }
}