import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/auth/auth_heading.dart';
import '../components/auth/footer.dart';
import '../components/auth/input_box.dart';
import '../components/auth/logo.dart';
import '../components/auth/square_tile.dart';
import '../components/auth/submit_button.dart';
import '../providers/auth_provider.dart';
import '../utils/utils.dart';
import 'bottom_bar_page.dart';
import 'signup_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showSnackBar(context, 'All Fields are required!');
      return;
    }

    // Get the AuthProvider instance from the provider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Call the sign-in method from the provider
    final response = await authProvider.signIn(email, password);

    if (response.statusCode == 200) {
      // Navigate to the BottomBarPage upon successful sign-in
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const BottomBarPage(),
        ),
      );
    } else {
      showSnackBar(context, response.message);
    }
  }

  void googleSignIn(BuildContext context) async {
    // Get the AuthProvider instance from the provider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Call the Google sign-in method from the provider
    final response = await authProvider.googleSignIn();

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

  void navigateToSignUp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignupPage(),
      ),
    );
  }

  void navigateToForgotPassword(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    print(user);
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

              // Password text field
              InputBox(
                controller: passwordController,
                labelText: 'Password',
                obscureText: true,
              ),

              const SizedBox(height: 15),

              // Forgot password?
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

              // Sign-in button
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

              // Google sign-in button
              SquareTile(
                onTap: () => googleSignIn(context),
                imagePath: 'assets/google.png',
              ),

              const SizedBox(height: 15),

              // Don't have an account? Sign up
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
