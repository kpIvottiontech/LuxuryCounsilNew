import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:luxury_council/config/prefrance.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


const String redirectUrl = 'https://dev.luxurycouncil.com/auth/linkedin/callback';
const String clientId = '78gm5vcnapfi6h';
const String clientSecret = 'A7ogLIV3IqGdkXzd';


class SocialLogin{

  static final SocialLogin _instance = SocialLogin._internal();

  factory SocialLogin() {
    return _instance;
  }
  SocialLogin._internal() {
    // initialization logic
  }
// creating firebase instance
  final FirebaseAuth auth = FirebaseAuth.instance;
  FacebookLogin? facebookLogin;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String? email;
  String? imageUrl;
  bool logoutUser = false;
  UserObject? user;

  Future<User?> googleLogin(BuildContext context, {Function(User)? callBack}) async {
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);
      User? user = result.user;

      if (user != null) {
        print('google login: ${user}');
        print('google login: ${user.email}');

        callBack?.call(user);
      }
      return user;

    }
    return null;
  }

  Future<FacebookUserProfile?> initiateFacebookLogin(
      {Function(FacebookUserProfile,String?)? callBack}) async {
    facebookLogin = FacebookLogin();
    FacebookUserProfile? facebookUserProfile;
    var facebookLoginResult =
    await facebookLogin?.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    print(facebookLoginResult?.status);
    switch (facebookLoginResult?.status) {
      case FacebookLoginStatus.error:
        print("Error");
        break;
      case FacebookLoginStatus.success:
        facebookUserProfile = await _updateLoginInfo();
        callBack?.call(facebookUserProfile!,email);
        log('facebookUserProfile::${facebookUserProfile}');
        break;
      case FacebookLoginStatus.cancel:
        break;
      case null:
        break;
    }
    return facebookUserProfile;
  }

  Future<FacebookUserProfile?> _updateLoginInfo() async {
    final token = await facebookLogin?.accessToken;
    FacebookUserProfile? profile;

    if (token != null) {
      profile = await facebookLogin?.getUserProfile();
      if (token.permissions.contains(FacebookPermission.email.name)) {
        email = await facebookLogin?.getUserEmail();
        log('email::${email}');

      }
      imageUrl = await facebookLogin?.getProfileImageUrl(width: 100);
      log('imageUrl::${imageUrl}');
      return profile;
    }
    return null;

  }

/*
  Future<UserSucceededAction?> linkedInSigin(BuildContext context,{Function(UserObject?)? callBack}) async {
    UserSucceededAction? userSucceededAction;

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (final BuildContext context) => LinkedInUserWidget(
          appBar: AppBar(
            title: const Text(''),
          ),
          destroySession: logoutUser,
          redirectUrl: redirectUrl,
          clientId: clientId,
          clientSecret: clientSecret,
          projection: const [
            ProjectionParameters.id,
            ProjectionParameters.localizedFirstName,
            ProjectionParameters.localizedLastName,
            ProjectionParameters.firstName,
            ProjectionParameters.lastName,
            ProjectionParameters.profilePicture,
          ],
          scope: const [
            EmailAddressScope(),
            // LiteProfileScope(),
          ],
          onError: (final UserFailedAction e) {
            print('Error: ${e.toString()}');
            print('Error: ${e.stackTrace.toString()}');
          },
          onGetUserProfile: (final UserSucceededAction linkedInUser) {
            print(
              'Access token ${linkedInUser.user.token.accessToken}',
            );
            userSucceededAction = linkedInUser;
            print('linkedInUser: ${linkedInUser}');
            print('User id: ${linkedInUser.user.userId}');

            user = UserObject(
              userId: linkedInUser.user.userId,
              firstName: linkedInUser.user.firstName?.localized?.label,
              lastName: linkedInUser.user.lastName?.localized?.label,
              email: linkedInUser.user.email?.elements
                  ?.elementAt(0)
                  .handleDeep
                  ?.emailAddress,
              profileImageUrl: linkedInUser
                  .user.profilePicture?.displayImageContent?.elements
                  ?.elementAt(0)
                  .identifiers
                  ?.elementAt(0)
                  .identifier,
            );

            callBack?.call(user);
            print('userLinkedin:${user?.email}');
            // setState(() {
            logoutUser = false;
            // });

            Navigator.pop(context);


          },
        ),
        fullscreenDialog: true,
      ),
    );
    if(userSucceededAction != null) {
      return userSucceededAction;
    }
    return null;
  }
*/


  Future<AppleIdCredential?> appleSignIn({Function(AppleIdCredential?)? callBack}) async {
    final AuthorizationResult result = await TheAppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    switch (result.status) {
      case AuthorizationStatus.authorized:

      // Store user ID
        await FlutterSecureStorage()
            .write(key: "userId", value: result.credential?.user);

        log('userId::${result.credential}');
        SetData("appleUserId", result.credential?.user ?? '');
        SetData("appleIdToken", result.credential?.identityToken.toString() ?? '');
        SetData("appleUserName", result.credential?.fullName?.givenName ?? '');
        callBack?.call(result.credential);

        // Navigate to secret page (shhh!)
/*        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => AfterLoginPage(credential: result.credential!)));*/
        break;

      case AuthorizationStatus.error:
        print("Sign in failed: ${result.error?.localizedDescription}");
        // setState(() {
        //   errorMessage = "Sign in failed";
        // });
        break;

      case AuthorizationStatus.cancelled:
        print('User cancelled');
        break;
    }
    return result.credential;
  }

}


class UserObject {
  UserObject({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileImageUrl,
  });

  final String? userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? profileImageUrl;
}

