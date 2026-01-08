class User {
  int? id;
  String? username;
  String? email;
  String? phone;
  String? fullName;
  bool? enabled;

  User({
    this.id,
    this.username,
    this.email,
    this.phone,
    this.fullName,
    this.enabled,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    fullName = json['fullName'];
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['fullName'] = this.fullName;
    data['enabled'] = this.enabled;
    return data;
  }
}
