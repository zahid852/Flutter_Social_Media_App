import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:social_media_app/Models/profile.dart';
import 'package:social_media_app/Screens/home/view_models/post_view_model.dart';
import 'package:social_media_app/Screens/profile/profile_Setup/profile_model_view_state.dart';
import 'package:social_media_app/Screens/search/view_model/search_profile_model_viewstate.dart';
import 'package:social_media_app/Utils/const.dart';

class SearchViewModel {
  String message = Empty;
  final StreamController<List<searchProfileModelViewState>>
      searchStreamController = StreamController();
  SearchViewModel() {
    getSearchedUsers(search: Empty);
  }

  Future<void> getSearchedUsers({required String search}) async {
    try {
      if (search.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('profiles')
            .where('usernameForQuery',
                isGreaterThanOrEqualTo: search.toLowerCase(),
                isLessThan: search.toLowerCase() + 'z')
            .snapshots()
            .listen((data) {
          final List<ProfileModel> ProfileModels =
              data.docs.map((post) => ProfileModel.fromSnapshot(post)).toList();

          final List<searchProfileModelViewState> searchProfileViewModels =
              ProfileModels.map((profileModel) => searchProfileModelViewState(
                  userId: profileModel.profileId!,
                  username: profileModel.username,
                  name: profileModel.name,
                  about: profileModel.about,
                  date: profileModel.date,
                  imageUrl: profileModel.imageUrl)).toList();
          searchStreamController.sink.add(searchProfileViewModels);
        });
      } else {
        searchStreamController.sink.add([]);
      }
    } on FirebaseException catch (error) {
      message = error.message.toString();
    } catch (error) {
      message = 'Something went wrong';
    }
  }
}
