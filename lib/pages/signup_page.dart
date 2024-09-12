import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/auth/auth_heading.dart';
import '../components/auth/footer.dart';
import '../components/auth/input_box.dart';
import '../components/auth/logo.dart';
import '../components/auth/submit_button.dart';
import '../providers/auth_provider.dart';
import '../utils/utils.dart';
import './bottom_bar_page.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp(BuildContext context) async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showSnackBar(context, 'All fields are required!');
      return;
    }

    if (password != confirmPassword) {
      showSnackBar(context, 'Passwords do not match');
      return;
    }

    // Access AuthProvider for signup functionality
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final response = await authProvider.signUp(name, email, password);

    if (response.statusCode == 200) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const BottomBarPage(),
        ),
      );
    } else {
      showSnackBar(context, response.message);
    }
  }

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

              // sign up button
              SubmitButton(
                label: 'Sign Up',
                onTap: () => signUserUp(context),
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
