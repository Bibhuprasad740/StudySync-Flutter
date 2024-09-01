import 'package:flutter/material.dart';

import '../components/auth/auth_heading.dart';
import '../components/auth/footer.dart';
import '../components/auth/input_box.dart';
import '../components/auth/logo.dart';
import '../components/auth/square_tile.dart';
import '../components/auth/submit_button.dart';
import '../controllers/auth_controller.dart';
import './home_page.dart';
import './signup_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _authController = AuthController();

  void signUserIn(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      // TODO: Add a snackbar
      print('Please enter both fields');
      return;
    }
    await _authController.signIn(
      emailController.text,
      passwordController.text,
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  void googleSignIn(BuildContext context) async {
    await _authController.googleSignIn();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  void navigateToSignUp(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignupPage(),
      ),
    );
  }

  void navigateToForgotPassword(BuildContext context) async {
    final authValue = await _authController.getAuth();

    print(authValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              // Logo
              const Logo(height: 100),

              const SizedBox(height: 30),

              // Login Text
              const AuthHeading(heading: 'LOGIN'),

              const SizedBox(height: 25),

              // Email text field
              InputBox(
                controller: emailController,
                labelText: 'Email',
              ),

              const SizedBox(height: 15),

              // password
              InputBox(
                controller: passwordController,
                labelText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 15),

              // forgot password?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => navigateToForgotPassword(context),
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // sign in button
              SubmitButton(
                label: 'Sign In',
                onTap: () => signUserIn(context),
              ),

              const SizedBox(height: 50),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Or Login With',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // sign in with google button
              SquareTile(
                onTap: () => googleSignIn(context),
                imagePath: 'assets/google.png',
              ),

              const SizedBox(height: 15),

              // Don't have account ? sign up
              Footer(
                text1: 'Don\'t have an account?',
                text2: 'Sign Up',
                onTap: () => navigateToSignUp(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
