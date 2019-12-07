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

class CategoryGroup {
  String title;
  String description;
  String icon;
  String code;
  List<String> children;

  CategoryGroup({this.title, this.description, this.icon, this.children});

  CategoryGroup.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    icon = json['icon'];
    code = json['code'];
    children = json['children']!= null?json['children'].cast<String>():null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['icon'] = this.icon;
    data['code'] = this.code;
    data['children'] = this.children;
    return data;
  }
}