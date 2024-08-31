import 'package:flutter/material.dart';
import 'package:study_sync/components/auth/auth_heading.dart';
import 'package:study_sync/components/auth/footer.dart';
import 'package:study_sync/components/auth/input_box.dart';
import 'package:study_sync/components/auth/logo.dart';
import 'package:study_sync/components/auth/square_tile.dart';
import 'package:study_sync/components/auth/submit_button.dart';
import 'package:study_sync/pages/signup_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() {
    // TODO: Implement login logic here
    print('User logged in');
  }

  void navigateToSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignupPage(),
      ),
    );
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
                    Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // sign in button
              SubmitButton(
                label: 'Sign In',
                onTap: signUserIn,
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
              const SquareTile(
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
