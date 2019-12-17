class AppFilter {
  int sort;
  double priceMin;
  double priceMax;
  List<int> badge;
  static const maxOfMax = 50;

  int get min {
    if (priceMin <= 0) {
      return null;
    } else {
      return (priceMin * 10000).round();
    }
  }

  int get max {
    if (priceMax > maxOfMax) {
      return null;
    } else {
      return (priceMax * 10000).round();
    }
  }

  AppFilter(
      {this.sort = 4, this.priceMin = 0, this.priceMax = 51, this.badge}) {
    if (badge == null) {
      badge = [];
    }
  }

  AppFilter.fromJson(Map<String, dynamic> json) {
    sort = json['sort'];
    priceMin = json['priceMin'];
    priceMax = json['priceMax'];
    badge = json['badge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sort'] = this.sort;
    data['priceMin'] = this.priceMin;
    data['priceMax'] = this.priceMax;
    data['badge'] = this.badge;
    return data;
  }
}
