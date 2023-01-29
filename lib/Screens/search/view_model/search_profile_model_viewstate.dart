class searchProfileModelViewState {
  final String userId;
  final String username;
  final String name;
  final String about;
  final String date;
  final String imageUrl;
  searchProfileModelViewState(
      {required this.userId,
      required this.username,
      required this.name,
      required this.about,
      required this.date,
      required this.imageUrl});
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'name': name,
      'about': about,
      'date': date,
      'imageUrl': imageUrl
    };
  }
}
