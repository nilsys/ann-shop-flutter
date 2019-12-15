class Category {
  String icon;
  String name;
  String slug;
  String description;
  List<Category> children;

  Category({this.icon, this.name, this.slug, this.description, this.children});

  Category.fromJson(Map<String, dynamic> json) {
    icon = json['icon'] ?? 'assets/images/categories/sale-product.png';
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    if (json['children'] != null) {
      children = new List<Category>();
      json['children'].forEach((v) {
        children.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['icon'] = this.icon;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['description'] = this.description;
    data['children'] = this.children;
    if (this.children != null) {
      data['children'] = this.children.map((v) => v.toJson()).toList();
    }
    return data;
  }
}