class User {
  int id;
  String name;
  String avatar;
  String phone;
  String token;

  User({this.id, this.name, this.avatar, this.phone, this.token});

  User.fromMap(Map<String, dynamic> data) {
    token = data['accessToken'].toString();

    final userData = data['User'] ?? data['user'];
    name = userData['name'];
    avatar = userData['avatar'];
    phone = userData['phone'];
    id = userData['id'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'phone': this.phone,
      'avatar': this.avatar,
      'token': this.token,
    };
  }

  String toString() {
    return this.toMap().toString();
  }
}
