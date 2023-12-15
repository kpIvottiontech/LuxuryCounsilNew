import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:linkedin_login/linkedin_login.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:luxury_council/colors.dart';
import 'package:luxury_council/controllers/ForgotPasswordController.dart';
import 'package:luxury_council/controllers/loginController.dart';
import 'package:luxury_council/social_login.dart';
import 'package:luxury_council/widgets/edittext.dart';
import 'package:get/get.dart';
import 'package:the_apple_sign_in/apple_id_credential.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginController loginController = Get.put(LoginController());
  late TextEditingController emailCtr = TextEditingController();
  late TextEditingController passwordCtr = TextEditingController();
  final _firebaseMessaging = FirebaseMessaging.instance;
  String firebaseToken = '';
  bool _obsecureText = true;
  bool validate = false;
  final plugin = FacebookLogin(debug: true);

     UserObject? user = null;
  void _toggleObscured() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    print('init');
    _firebaseMessaging.getToken().then((value) {
      setState(() {
        firebaseToken = value ?? '';
        print('fffff $firebaseToken');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.loginappbar,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.7),
        //   shadowColor: AppColor.loginappbar,
        centerTitle: true,
        bottomOpacity: 1.0,
        elevation: 4,
        title: Text(
          'LOGIN',
          style: TextStyle(
              color: AppColor.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        leading: Container(
          margin: EdgeInsets.only(left: 8),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset(
              "assets/logo-img.png",
              scale: 2.9,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              "assets/background.png",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
              child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 45,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 15, right: 30, left: 30),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                              child: Text(
                            "Email",
                            style: TextStyle(
                              color: AppColor.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.start,
                          )),
                        ),
                        EditText(
                          hint: "Enter Your Email",
                          controller: loginController.LoginEmailController,
                          inputformtters: [
                            LengthLimitingTextInputFormatter(254),
                            FilteringTextInputFormatter.deny(" "),
                            FilteringTextInputFormatter.deny("[]"),
                            FilteringTextInputFormatter.deny("["),
                            FilteringTextInputFormatter.deny("]"),
                            FilteringTextInputFormatter.deny("^"),
                            FilteringTextInputFormatter.deny(""),
                            FilteringTextInputFormatter.deny("`"),
                            FilteringTextInputFormatter.deny("/"),
                            // FilteringTextInputFormatter.deny("\"),
                            FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9a-zA-z._@]')),
                            FilteringTextInputFormatter.deny(RegExp(r"/"))
                          ],
                          validator: (email) {
                            if (email?.trim().isEmpty ?? true) {
                              return "Please enter email address";
                            } else if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(email ?? "")) {
                              return "Enter valid email address";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                              child: Text(
                            "Password",
                            style: TextStyle(
                              color: AppColor.white,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.start,
                          )),
                        ),
                        EditText(
                          controller: loginController.LoginPasswordController,
                          hint: "Enter Your Password",
                          obsecureText: _obsecureText,
                          textInputType: TextInputType.visiblePassword,
                          inputformtters: [
                            FilteringTextInputFormatter.deny(' '),
                            LengthLimitingTextInputFormatter(20)
                          ],
                         validator: (value) {
                           /* RegExp regex = RegExp(
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');*/
                           RegExp regex = RegExp(
                               r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,20}$');
                           if (value!.isEmpty) {
                             return "Please enter password";
                           } else if (value!.length < 8) {
                             print('password length is less than 8');
                             return "Please enter atleast 8 character password";
                           } else {
                             if (!regex.hasMatch(value)) {
                               return ("Password should contain upper,lower,digit and\nSpecial character ");
                             } else {
                               return null;
                             }
                           }
                            //return null;
                          },
                          suffixIcon: GestureDetector(
                            onTap: _toggleObscured,
                            child: Transform.scale(
                              scale: 0.5,
                              child: ImageIcon(
                                _obsecureText
                                    ? AssetImage(
                                        "assets/hide.png",
                                      )
                                    : AssetImage(
                                        "assets/view.png",
                                      ),
                                color: AppColor.white,
                                size: 12,
                                // color: AppColors.button_color,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: (() {
                                     Get.toNamed("/Forgot");
                                  }),
                                  child: Container(
                                    padding: EdgeInsets.only(top: 0.2),
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      'Forgot Password?',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              // fontFamily: KSMFontFamily.robotoRgular,
                                              color: AppColor.white,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor: AppColor.white,
                                              decorationThickness: 2),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        GestureDetector(
                          onTap: () {
                            FocusNode? focusNode =
                                FocusManager.instance.primaryFocus;
                            if (focusNode != null) {
                              if (focusNode.hasPrimaryFocus) {
                                focusNode.unfocus();
                              }
                            }
                            if (_formKey.currentState?.validate() ?? false) {
                              context.loaderOverlay.show();
                              loginController.login(
                                  context, firebaseToken, 'emai_login');
                            } else {
                              //  Get.toNamed("HomeWithoutSignUp");
                            }
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: AppColor.primarycolor,
                                borderRadius: BorderRadius.circular(15)),
                            child: Center(
                              child: Text('Login',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      ?.copyWith(
                                          color: AppColor.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 75,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don’t have an Account? ",
                              style: TextStyle(
                                  color: AppColor.white, fontSize: 12),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed("/Register");
                              },
                              child: Text(
                                "Register Instead",
                                style: TextStyle(
                                    color: AppColor.primarycolor, fontSize: 12, decoration:
                                TextDecoration.underline,
                                  decorationColor: AppColor.primarycolor,),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Container(
                                child: Text(
                              "or",
                              style: TextStyle(
                                  color: AppColor.white, fontSize: 12),
                            )),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Container(
                                child: Text(
                              "Login With",
                              style: TextStyle(
                                  color: AppColor.white, fontSize: 12),
                            )),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                SocialLogin().googleLogin(context,
                                    callBack: (User? user) {
                                  print('userGoogle::${user}');
                                  if (user != null) {
                                    context.loaderOverlay.show();
                                    loginController.login(
                                        context, firebaseToken, 'social_login',
                                        socialType: 'google', user: user);
                                  }
                                });
                              },
                              child: Image.asset(
                                "assets/google.png",
                                scale: 2.5,
                              ),
                            ),
                            
                            SizedBox(
                              width: 16,
                            ),
                            GestureDetector(
                              onTap: () {
                                SocialLogin().initiateFacebookLogin(callBack:
                                    (FacebookUserProfile facebookData,
                                        String? email) {
                                  if (facebookData != null) {
                                    Future.delayed(Duration(milliseconds: 0),
                                        () async {
                                      context.loaderOverlay.show();
                                      loginController.login(context,
                                          firebaseToken, 'social_login',
                                          facebookData: facebookData,
                                          socialType: 'facebook',
                                          facebookEmail: email);
                                    });
                                  }
                                });
                              },
                              child: Image.asset(
                                "assets/facebook.png",
                                scale: 2.5,
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            // _setLinkedin()
                            GestureDetector(
                              onTap: () {
                                Get.toNamed('/LinkedInLogin')?.then((value) => {
                                  // return UserInfo callback

                                loginController.login(
                                context, firebaseToken, 'social_login',
                                socialType: 'linkedin', linkedinUser:value)
                                });
                                /*Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (final BuildContext context) => LinkedInUserWidget(
                                      appBar: AppBar(
                                        title: const Text('OAuth User'),
                                      ),
                                      // destroySession: logoutUser,
                                      redirectUrl: redirectUrl,
                                      clientId: clientId,
                                      clientSecret: clientSecret,
                                      projection: const [
                                        // ProjectionParameters.id,
                                        ProjectionParameters.localizedFirstName,
                                        ProjectionParameters.localizedLastName,
                                        ProjectionParameters.firstName,
                                        ProjectionParameters.lastName,
                                        ProjectionParameters.profilePicture,
                                      ],
                                      scope: const [
                                        EmailScope(),
                                        OpenIdScope(),
                                        ProfileScope(),
                                      ],
                                      onError: (final UserFailedAction e) {
                                        print('___________________________________ Error: ${e.toString()}');
                                        print('_____________________________________Error: ${e.stackTrace.toString()}');
                                      },
                                      onGetUserProfile: (final UserSucceededAction linkedInUser) {
                                        print(
                                          'Access token ${linkedInUser.user.token.accessToken}',
                                        );

                                        print('User id: ${linkedInUser.user.userId}');

                                        user = UserObject(
                                          firstName:
                                          linkedInUser.user.firstName?.localized?.label,
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

                                        setState(() {
                                          // logoutUser = false;
                                        });

                                        Navigator.pop(context);
                                      },
                                    ),
                                    fullscreenDialog: true,
                                  ),
                                );*/
                              },
                              child: Image.asset(
                                "assets/linkedin.png",
                                scale: 12.1,
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            // GestureDetector(
                            //   onTap: () async {
                            //     /*final credential = await SignInWithApple.getAppleIDCredential(
                            //       scopes: [
                            //         AppleIDAuthorizationScopes.email,
                            //         AppleIDAuthorizationScopes.fullName,
                            //       ],
                            //       webAuthenticationOptions: WebAuthenticationOptions(
                            //         // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
                            //         clientId:
                            //         'de.lunaone.flutter.signinwithappleexample.service',

                            //         redirectUri:
                            //         // For web your redirect URI needs to be the host of the "current page",
                            //         // while for Android you will be using the API server that redirects back into your app via a deep link
                            //         kIsWeb
                            //             ? Uri.parse('https://${window.location.host}/')
                            //             : Uri.parse(
                            //           'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
                            //         ),
                            //       ),
                            //       // TODO: Remove these if you have no need for them
                            //       nonce: 'example-nonce',
                            //       state: 'example-state',
                            //     );

                            //     // ignore: avoid_print
                            //     print(credential);

                            //     // This is the endpoint that will convert an authorization code obtained
                            //     // via Sign in with Apple into a session in your system
                            //     final signInWithAppleEndpoint = Uri(
                            //       scheme: 'https',
                            //       host: 'flutter-sign-in-with-apple-example.glitch.me',
                            //       path: '/sign_in_with_apple',
                            //       queryParameters: <String, String>{
                            //         'code': credential.authorizationCode,
                            //         if (credential.givenName != null)
                            //           'firstName': credential.givenName!,
                            //         if (credential.familyName != null)
                            //           'lastName': credential.familyName!,
                            //         'useBundleId':
                            //         !kIsWeb && (Platform.isIOS || Platform.isMacOS)
                            //             ? 'true'
                            //             : 'false',
                            //         if (credential.state != null) 'state': credential.state!,
                            //       },
                            //     );

                            //     final session = await http.Client().post(
                            //       signInWithAppleEndpoint,
                            //     );

                            //     // If we got this far, a session based on the Apple ID credential has been created in your system,
                            //     // and you can now set this as the app's session
                            //     // ignore: avoid_print
                            //     print(session);*/
                            //     SocialLogin().appleSignIn(
                            //         callBack: (AppleIdCredential? appleUser) {
                            //           print('userGoogle::${appleUser}');
                            //           if (appleUser != null) {
                            //             print('appleUser::${appleUser.user}');
                            //             print('appleUser::${appleUser.email}');
                            //             print('appleUserName::${appleUser.fullName?.givenName}');
                            //             print('appleUser::${appleUser.fullName?.familyName}');
                            //             print('appleUser::${appleUser.fullName?.middleName}');
                            //             print('appleUser::${appleUser.fullName?.namePrefix}');
                            //             print('appleUser::${appleUser.fullName?.nameSuffix}');
                            //             print('appleUser::${appleUser.fullName?.nickname}');
                            //             print('appleUser::${appleUser.state}');
                            //             print('appleUser::${appleUser.realUserStatus}');
                            //             context.loaderOverlay.show();
                            //             loginController.login(
                            //                 context, firebaseToken, 'social_login',
                            //                 socialType: 'apple_sign_in', appleUser: appleUser);
                            //           }
                            //         });                              },
                            //   child: Image.asset(
                            //     "assets/apple.png",
                            //     scale: 2.5,
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  _setLinkedin() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          LinkedInButtonStandardWidget(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (final BuildContext context) => LinkedInUserWidget(
                    appBar: AppBar(
                      title: const Text('OAuth User'),
                    ),
                    // destroySession: logoutUser,
                    redirectUrl: redirectUrl,
                    clientId: clientId,
                    clientSecret: clientSecret,
                    projection: const [
                      // ProjectionParameters.id,
                      ProjectionParameters.localizedFirstName,
                      ProjectionParameters.localizedLastName,
                      ProjectionParameters.firstName,
                      ProjectionParameters.lastName,
                      ProjectionParameters.profilePicture,
                    ],
                    scope: const [
                      EmailScope(),
                      OpenIdScope(),
                      ProfileScope(),
                    ],
                    onError: (final UserFailedAction e) {
                      print('___________________________________ Error: ${e.toString()}');
                      print('_____________________________________Error: ${e.stackTrace.toString()}');
                    },
                    onGetUserProfile: (final UserSucceededAction linkedInUser) {
                      print(
                        'Access token ${linkedInUser.user.token.accessToken}',
                      );

                      print('User id: ${linkedInUser.user.userId}');

                      user = UserObject(
                        firstName:
                        linkedInUser.user.firstName?.localized?.label,
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

                      setState(() {
                        // logoutUser = false;
                      });

                      Navigator.pop(context);
                    },
                  ),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
          LinkedInButtonStandardWidget(
            onTap: () {
              setState(() {
                user = null;
                // logoutUser = true;
              });
            },
            buttonText: 'Logout',
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('First: ${user?.firstName} '),
              Text('Last: ${user?.lastName} '),
              Text('Email: ${user?.email}'),
              Text('Profile image: ${user?.profileImageUrl}'),
            ],
          ),
        ],
      ),
    );
  }


}
class UserObject {
  UserObject({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileImageUrl,
  });

  final String? firstName;
  final String? lastName;
  final String? email;
  final String? profileImageUrl;
}


class LinkedProfileScope extends Scope {
  const LinkedProfileScope() : super('r_basicprofile');
}

class OpenIdScope extends Scope {
  const OpenIdScope() : super('openid');
}

class ProfileScope extends Scope {
  const ProfileScope() : super('profile');
}

class EmailScope extends Scope {
  const  EmailScope() : super('email');
}