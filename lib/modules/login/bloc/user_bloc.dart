// import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:flutter/cupertino.dart';

import '../model/user_model.dart';

class UserBloc extends ValueNotifier<UserModel> {
  UserBloc(super.value);

  static UserBloc get instance => _instance ??= UserBloc(UserModel());

  static UserBloc? _instance;

  // final Auth0Web auth0 = Auth0Web(
  //   'dev-f3fgvasvr0owwxw6.us.auth0.com',
  //   'vBAJBGhdJySCuFfjCklSzHmeM57NX6YA',
  // );

  UserType get userType => value.type;

  Future<void> loadUser(UserType type) async {
    //TODO:
    // final cred = await auth0.onLoad();
    // if (cred != null) {
    value = UserModel(
      id: '',
      token: '',
      type: type,
    );
    // }
  }

  Future<void> logIn(UserType type) async {
    // auth0.loginWithRedirect(redirectUrl: 'http://localhost:5000/').then((value) {
    //
    // },);
    loadUser(type);
  }

  Future<void> logOut() async {
    // await auth0.logout();
    value = UserModel();
  }
}
