class UserModel {
  final String? userId;
  final String username;
  final String email;
  final String? usernameForQuery;
  UserModel(
      {this.userId,
      required this.username,
      required this.email,
      this.usernameForQuery});

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'usernameForQuery': usernameForQuery
    };
  }
}
