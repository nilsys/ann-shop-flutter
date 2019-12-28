class Blog {
  int id;
  String name;
  String action;
  String actionValue;
  String message;
  String createdDate;

  Blog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] ?? '';
    action = json['action'];
    actionValue = json['actionValue'];
    message = json['message'] ?? '';
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['action'] = this.action;
    data['actionValue'] = this.actionValue;
    data['message'] = this.message;
    data['createdDate'] = this.createdDate;
    return data;
  }
}