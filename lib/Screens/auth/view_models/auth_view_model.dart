import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_media_app/Models/user.dart';
import 'package:social_media_app/Utils/const.dart';

class authViewModel {
  String message = Empty;
  Future<bool> signUpUser(
      {required String email,
      required String username,
      required String password}) async {
    bool isUserRegister = false;
    try {
      final UsernameApplicableQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username.toLowerCase())
          .get();
      if (UsernameApplicableQuery.docs.isEmpty) {
        final UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(UserModel(
                    username: username,
                    email: email,
                    usernameForQuery: username.toLowerCase())
                .toMap());
        isUserRegister = UserCredential != null;
      } else {
        message = 'Username already exists';
        return isUserRegister;
      }
    } on FirebaseAuthException catch (firebaseAuthError) {
      message = firebaseAuthError.message.toString();
    } catch (error) {
      message = 'Something went wrong';
    }
    return isUserRegister;
  }

  Future<bool> sendVerificationEmail() async {
    bool isSendEmailVerificationDone = false;
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      isSendEmailVerificationDone = true;
      message = 'A verification email has been sent to you';
    } on FirebaseAuthException catch (firebaseAuthError) {
      message = firebaseAuthError.message.toString();
      isSendEmailVerificationDone = false;
    } catch (error) {
      message = 'Something went wrong';
      isSendEmailVerificationDone = false;
    }
    return isSendEmailVerificationDone;
  }

  Future<bool> loginUser(
      {required String email, required String password}) async {
    bool isUserLoggedIn = false;
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      isUserLoggedIn = UserCredential != null;
    } on FirebaseAuthException catch (firebaseAuthError) {
      message = firebaseAuthError.message.toString();
    } catch (error) {
      message = 'Something went wrong';
    }
    return isUserLoggedIn;
  }

  Future<bool> resetPassword({required String email}) async {
    bool isSendPasswordResetEmail = false;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      isSendPasswordResetEmail = true;
      message = 'Password reset email sent';
    } on FirebaseAuthException catch (firebaseAuthError) {
      message = firebaseAuthError.message.toString();
      isSendPasswordResetEmail = false;
    } catch (error) {
      message = 'Something went wrong';
      isSendPasswordResetEmail = false;
    }
    return isSendPasswordResetEmail;
  }
}
