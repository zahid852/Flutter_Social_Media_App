import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_media_app/Models/post.dart';
import 'package:social_media_app/Screens/home/view_models/post_view_model.dart';

class ProfilePostsData {
  Future<List<PostViewModel>> getProfilePosts({required String userId}) async {
    bool isDataSaved = false;
    List<PostViewModel> postViewModels = [];
    try {
      final profilePosts = await FirebaseFirestore.instance
          .collection('Posts')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .get();
      final List<PostModel> PostsModels = profilePosts.docs
          .map((post) => PostModel.fromSnapshot(post))
          .toList();

      postViewModels =
          PostsModels.map((postModel) => PostViewModel(post: postModel))
              .toList();
    } on FirebaseException catch (firebaseError) {
      throw firebaseError.message.toString();
    } catch (error) {
      throw 'Something went wrong';
    }
    return postViewModels;
  }
}
