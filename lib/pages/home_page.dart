import 'package:flutter/material.dart';
import 'package:todo_list/auth/auth_service.dart';
import 'package:todo_list/components/drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void logout() {
    AuthService authService = AuthService();
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("H O M E"),
      ),
      drawer: HomeDrawer(
        onTap: logout,
      ),
    );
  }
}
