class ProfileModel {
  final String? profileId;
  final String name;
  final String about;
  final String date;
  final String imageUrl;
  ProfileModel(
      {this.profileId,
      required this.name,
      required this.about,
      required this.date,
      required this.imageUrl});
  Map<String, dynamic> toMap() {
    return {'name': name, 'about': about, 'date': date, 'imageUrl': imageUrl};
  }
}
