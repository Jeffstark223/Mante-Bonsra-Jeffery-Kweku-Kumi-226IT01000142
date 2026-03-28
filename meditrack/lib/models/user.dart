class User {
  String username;
  String password;

  User({required this.username, required this.password});

  Map<String, String> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, String> map) {
    return User(
      username: map['username']!,
      password: map['password']!,
    );
  }
}