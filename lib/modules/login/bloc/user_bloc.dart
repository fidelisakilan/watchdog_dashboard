import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:flutter/cupertino.dart';

import '../model/user_model.dart';

class UserBloc extends ValueNotifier<UserModel> {
  UserBloc(super.value);

  static UserBloc get instance => _instance ??= UserBloc(UserModel());

  static UserBloc? _instance;

  final Auth0Web auth0 = Auth0Web(
    'dev-f3fgvasvr0owwxw6.us.auth0.com',
    'vBAJBGhdJySCuFfjCklSzHmeM57NX6YA',
  );

  UserType get userType => value.type;

  Future<void> loadUser() async {
    final cred = await auth0.onLoad();
    if (cred != null) {
      value = UserModel(
        id: cred.idToken,
        token: cred.accessToken,
        type: UserType.loggedIn,
      );
    }
  }

  Future<void> logIn() async {
    await auth0.loginWithRedirect(
        redirectUrl: 'https://watchdog-camera.firebaseapp.com');
    await loadUser();
  }

  Future<void> logOut() async {
    await auth0.logout();
    value = UserModel();
  }
}
