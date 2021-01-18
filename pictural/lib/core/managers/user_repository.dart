import 'package:google_sign_in/google_sign_in.dart';
import 'package:pictural/core/models/user.dart';
import 'package:pictural/core/services/pictural_api.dart';
import 'package:pictural/locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as fAuth;

class UserRepository {
  final PicturalApi _picturalApi = locator<PicturalApi>();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );
  final fAuth.FirebaseAuth _auth = fAuth.FirebaseAuth.instance;

  User _user;
  User get user => _user;

  /// Log in the user using google sign in, if [silent] is true, will try to connect silently
  Future<bool> logIn({bool silent = false}) async {
    try {
      final fAuth.User fUser = await _signInWithGoogle(silent: silent);
      if (fUser != null) {
        final cred = await _googleSignIn.currentUser.authentication;
        final String idToken = cred.idToken;

        var user = await _picturalApi.login(idToken);

        if(user == null)
          return false;

        _user = user;
        _user.pictureUrl = fUser.photoURL;

        return true;
      }
    } catch (error) {
      print(error);
    }

    return false;
  }

  /// Log out the user from google/firebase and the pictural api
  Future<bool> logout() async {
    await _auth.signOut();
    return await _picturalApi.logout();
  }

  Future<fAuth.User> _signInWithGoogle({bool silent = false}) async {
    await Firebase.initializeApp();

    GoogleSignInAccount googleSignInAccount;

    if (silent) {
      googleSignInAccount = await _googleSignIn.signInSilently();

      if (googleSignInAccount == null) return null;
    } else {
      googleSignInAccount = await _googleSignIn.signIn();
    }

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final fAuth.AuthCredential credential = fAuth.GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final fAuth.UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    if (userCredential.user != null) {
      return userCredential.user;
    }
    return null;
  }
}
