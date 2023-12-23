import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';

import '../../components/myButton.dart';
import '../../components/myTextfield.dart';
import '../../services/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailAndPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())));
    }
  }

  void signInWithGoogle() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signInWithGoogleProvider();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.message, size: 100,),
                  const SizedBox(height: 25),
                  const Text("Welcome back. You\'ve been missed.", style: TextStyle(fontSize: 16),),
                  const SizedBox(height: 25),
                  MyTextField(controller: emailController, hintText: 'Email', obscureText: false),
                  const SizedBox(height: 25),
                  MyTextField(controller: passwordController, hintText: 'Password', obscureText: true),
                  const SizedBox(height: 25),
                  SignInButton(
                      padding: const EdgeInsets.symmetric(vertical: 23, horizontal: 15),
                      mini: false,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                      Buttons.Email,onPressed: signIn, text: "Sign In with Email"),
                  const SizedBox(height: 25),
                  SignInButton(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      mini: false,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(25))),
                      Buttons.Google,onPressed: signInWithGoogle, text: "Continue with Google"),                const SizedBox(height: 25),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Not a member?"),
                        const SizedBox(width: 4,),
                        GestureDetector(
                            onTap: widget.onTap,
                            child: const Text("Register Now", style: TextStyle(fontWeight: FontWeight.bold))
                        ),
                      ]
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}