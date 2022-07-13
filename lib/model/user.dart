class User {
  String? id;
  String? name;
  String? email;
  String? password;
  String? address;
  String? phone;
  String? home;
  String? logtime;
  String? cart;

  User(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.address,
      this.phone,
      this.home,
      this.logtime,
      this.cart});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    address = json['address'];
    phone = json['phone'];
    home = json['home'];
    logtime = json['logtime'];
    cart = json['cart'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['address'] = address;
    data['phone'] = phone;
    data['home'] = home;
    data['logtime'] = logtime;
    data['cart'] = cart.toString();
    return data;
  }
}
