// import 'package:flutter/material.dart';
// import 'package:watchdog_dashboard/modules/home/ui/home_page.dart';
// import 'package:watchdog_dashboard/modules/login/bloc/user_bloc.dart';
// import 'package:watchdog_dashboard/modules/login/model/user_model.dart';
//
// import '../../../widgets/loading_widget.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({
//     super.key,
//     required this.child,
//   });
//
//   final Widget child;
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   bool loading = false;
//
//   @override
//   void initState() {
//     UserBloc.instance.loadUser();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (loading) {
//       return const Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [LoadingWidget()],
//       );
//     }
//     return ValueListenableBuilder<UserModel>(
//       valueListenable: UserBloc.instance,
//       builder: (context, value, child) {
//         final loggedIn = value.type == UserType.loggedIn;
//         if (loggedIn) return const HomePage();
//         return Center(
//           child: ElevatedButton(
//             onPressed: () async {
//               setState(() => loading = true);
//               await UserBloc.instance.logIn();
//               setState(() => loading = false);
//             },
//             child: Text(
//               loggedIn ? "Log out" : "Log in",
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
