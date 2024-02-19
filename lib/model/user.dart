class Users {
  //attributes = fields in table
  int? _id;
  String? _username;
  String? _email;
  String? _pass;
  String? _photo;

  // ignore: non_constant_identifier_names
  User(dynamic obj) {
    _id = obj['id'];
    _username = obj['username'];
    _email = obj['email'];
    _pass = obj['pass'];
    _photo = obj['photo'];
  }

  Users.fromMap(Map<String, dynamic> data) {
    _id = data['id'];
    _username = data['username'];
    _email = data['email'];
    _pass = data['pass'];
    _photo = data['photo'];
  }
  Map<String, dynamic> toMap() => {
        'id': _id,
        'username': _username,
        'email': _email,
        'pass': _pass,
        'photo': _photo
      };

  int? get id => _id;
  String? get username => _username;
  String? get email => _email;
  String? get pass => _pass;
  String? get photo => _photo;
}
