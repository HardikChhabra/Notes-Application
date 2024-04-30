import 'package:flutter/material.dart';
import 'package:todo_list/pages/login_page.dart';
import 'package:todo_list/pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {

  bool showLoginPage = true;
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showLoginPage) {
      return LoginPage(
        routeToRegisterPage: togglePages,
      );
    }
    else {
      return RegisterPage(
        routeToLoginPage: togglePages,
      );
    }
  }
}
