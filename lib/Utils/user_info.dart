import 'package:social_media_app/Models/profile.dart';
import 'package:social_media_app/Utils/logedin_user_info.dart';

class userInfo {
  final ProfileModel user;
  userInfo({required this.user});
  String get UserId {
    return user.profileId!;
  }

  String get Username {
    return user.username;
  }

  String get Name {
    return user.name;
  }

  String get Email {
    return user.email;
  }

  String get About {
    return user.about;
  }

  String get BirthDate {
    return user.date;
  }

  String get imageUrl {
    return user.imageUrl;
  }

  String get usernameForQuery {
    return user.usernameForQuery;
  }
}
