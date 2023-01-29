import 'package:social_media_app/Models/profile.dart';
import 'package:social_media_app/Screens/profile/profile_Setup/profile_model_view_state.dart';
import 'package:social_media_app/Utils/logedin_user_info.dart';
import 'package:social_media_app/Utils/user_info.dart';
import 'package:social_media_app/Utils/user_info_viewstate.dart';

class UpdateUserInfo {
  static void updateUserInfoData({required userInfoViewState user}) {
    final ProfileModel model = ProfileModel(
        profileId: user.userId,
        username: user.username,
        usernameForQuery: logedinUserInfo.usernameForQuery,
        email: user.email,
        name: user.name,
        about: user.about,
        date: user.b_date,
        imageUrl: user.image_url);
    logedinUserInfo = userInfo(user: model);
  }
}
