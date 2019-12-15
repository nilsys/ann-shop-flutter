class Cover {
  String image;
  String type;
  String value;

  Cover({this.image, this.type, this.value});

  Cover.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}