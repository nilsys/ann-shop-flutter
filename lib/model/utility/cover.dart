class Cover {
  String title;
  String body;
  String image;
  String action;
  String actionValue;
  String createdDate;

  Cover({this.image, this.action, this.actionValue, this.title});

  Cover.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    image = json['image'];
    action = json['action'];
    actionValue = json['actionValue'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.title;
    data['body'] = this.body;
    data['image'] = this.image;
    data['action'] = this.action;
    data['actionValue'] = this.actionValue;
    data['createdDate'] = this.createdDate;
    return data;
  }
}