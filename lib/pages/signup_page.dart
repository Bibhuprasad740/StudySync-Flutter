import 'package:flutter/material.dart';
import 'package:study_sync/components/auth/auth_heading.dart';
import 'package:study_sync/components/auth/footer.dart';
import 'package:study_sync/components/auth/input_box.dart';
import 'package:study_sync/components/auth/logo.dart';
import 'package:study_sync/components/auth/submit_button.dart';
import 'package:study_sync/pages/login_page.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() {}

  void navigateToLogin(BuildContext context) {
    Navigator.pop(context);
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

              // Signup Text
              const AuthHeading(heading: 'SIGN UP'),

              const SizedBox(height: 25),

              // Name text field
              InputBox(
                controller: nameController,
                labelText: 'Name',
              ),

              const SizedBox(height: 15),

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

              // confirm password
              InputBox(
                controller: confirmPasswordController,
                labelText: 'Confirm Password',
                obscureText: true,
              ),

              const SizedBox(height: 15),

              // sign in button
              SubmitButton(
                label: 'Sign Up',
                onTap: signUserUp,
              ),

              const SizedBox(height: 50),

              // Already have account ? Sign In
              Footer(
                text1: 'Already have an account?',
                text2: 'Sign In',
                onTap: () => navigateToLogin(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
