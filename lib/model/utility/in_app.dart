class InApp {
  int id;
  String category;
  String title;
  String action;
  String actionValue;
  String body;
  String createdDate;

  InApp.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'] ?? 'other';
    title = json['title'] ?? '';
    action = json['action'];
    actionValue = json['actionValue'];
    body = json['body'] ?? '';
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['category'] = this.category;
    data['action'] = this.action;
    data['actionValue'] = this.actionValue;
    data['body'] = this.body;
    data['createdDate'] = this.createdDate;
    return data;
  }
}