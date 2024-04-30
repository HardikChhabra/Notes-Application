import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_list/components/button.dart';
import 'package:todo_list/components/textfield.dart';

import '../auth/auth_service.dart';

class RegisterPage extends StatelessWidget {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  final void Function()? routeToLoginPage;

  RegisterPage({super.key, required this.routeToLoginPage});

  //register authorization
  void register(context) async {
    //auth service
    final authService = AuthService();

    //try login
    try{
      //passwords match -> create user
      if(_pwController.text == _confirmPwController.text) {
        await authService.registerWithEmailAndPassword(_emailController.text, _pwController.text);
      }
      else{
        showDialog(context: context, builder: (context) => const AlertDialog(
          title: Text("Passwords don't match"),
        ));
      }
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
                "Let's create an Account for you",
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

              //confirm pw textfield
              MyTextField(
                hint: "Confirm Password",
                obscureText: true,
                controller: _confirmPwController,
              ),
              const SizedBox(height: 16,),

              //login button
              Button(
                text: "Register",
                onTap: () => register(context),
              ),
              const SizedBox(height: 32,),

              //register route
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already a member?",
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary
                        )
                    ),
                  ),
                  const SizedBox(width: 8,),
                  GestureDetector(
                    onTap: routeToLoginPage,
                    child: Text(
                      "Log In",
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



