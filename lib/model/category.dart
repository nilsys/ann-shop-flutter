class Category {
  String icon;
  String title;
  String code;

  Category({this.icon, this.title, this.code});

  Category.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    title = json['title'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['title'] = this.title;
    data['code'] = this.code;
    return data;
  }
}