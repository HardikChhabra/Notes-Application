import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_list/auth/auth_service.dart';
import 'package:todo_list/components/button.dart';
import 'package:todo_list/components/textfield.dart';

class LoginPage extends StatelessWidget {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  //routing to register page
  final void Function()? routeToRegisterPage;

  LoginPage({super.key, required this.routeToRegisterPage});

  //login authentication
  void login(context) async {
    //auth service
    final authService = AuthService();

    //try login
    try{
      await authService.loginWithEmailPassword(_emailController.text, _pwController.text);
    }
    catch (e) {
      showDialog(context: context, builder: (context) => AlertDialog(
        title: Text(e.toString()),
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //logo
              Icon(
                Icons.notes_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 100,
              ),
              const SizedBox(height: 32,),

              //welcome back message
              Text(
                "Welcome back you have been missed",
                style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 18,
                    )
                ),
              ),
              const SizedBox(height: 16,),

              //email textfield
              MyTextField(
                hint: "Email",
                obscureText: false,
                controller: _emailController,
              ),
              const SizedBox(height: 16,),

              //pw textfield
              MyTextField(
                hint: "Password",
                obscureText: true,
                controller: _pwController,
              ),
              const SizedBox(height: 16,),

              //login button
              Button(
                text: "Login",
                onTap: () => login(context),
              ),
              const SizedBox(height: 32,),

              //register route
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member?",
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary
                        )
                    ),
                  ),
                  const SizedBox(width: 8,),
                  GestureDetector(
                    onTap: routeToRegisterPage,
                    child: Text(
                      "Register Now",
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary
                          )
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
