enum UserType { guest, loggedIn }

class UserBloc {
  static UserBloc get instance => _instance ??= UserBloc._();

  static UserBloc? _instance;

  UserBloc._();

  void initializeUser() {}
}
