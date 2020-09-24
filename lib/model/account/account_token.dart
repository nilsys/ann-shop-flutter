class AccountToken {
  String accessToken;
  String type;
  String userName;

  AccountToken({this.accessToken, this.type, this.userName});

  AccountToken.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    type = json['type'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['type'] = this.type;
    data['userName'] = this.userName;
    return data;
  }
}
