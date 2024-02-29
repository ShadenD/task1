class Users {
  String username;
  String email;
  String pass;
  String bod;
  String photo;

  Users(
      {required this.username,
      required this.email,
      required this.pass,
      required this.bod,
      required this.photo});
  Map<String, dynamic> toMap() => {
        'username': username,
        'email': email,
        'pass': pass,
        'bod': bod,
        'photo': photo
      };
}
