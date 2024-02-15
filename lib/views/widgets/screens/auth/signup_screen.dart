import 'package:flutter/material.dart';
import 'package:mind_stride/views/widgets/input_text_field.dart';
import '../../../../controllers/auth_controller.dart';
import 'login_screen.dart';

///****************************************************************************
///MATTHEW HERBERT 2024
///This file defines a SignupScreen widget that creates the user registration screen for this MindStride flutter application
///It constructs the UI for the registration screen.
///It has a title, text input fields for username, email, and password, a registration button, and a link to the login screen
///****************************************************************************

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  // Controllers for handling user input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _confirmUsernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 30), // Margin between the boxes and the edge of the screen
        child: SingleChildScrollView( // Added to enable scrolling when keyboard is open
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'MindStride',
                style: TextStyle(fontSize: 35.0, color: Colors.blue, fontWeight: FontWeight.w900),
              ),
              const Text('Sign Up', style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w700)),
              const SizedBox(height: 25.0),
              // Username Input
              TextInputField(
                controller: _usernameController,
                labelText: 'Username',
                icon: Icons.person,
              ),
              TextInputField(
                controller: _confirmUsernameController,
                labelText: 'Confirm Username',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 10),
              // Email Input
              TextInputField(
                controller: _emailController,
                labelText: 'Email',
                icon: Icons.email,
              ),
              TextInputField(
                controller: _confirmEmailController,
                labelText: 'Confirm Email',
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 10),
              // Password Input
              TextInputField(
                controller: _passwordController,
                labelText: 'Password',
                icon: Icons.lock,
                isObscure: true,
              ),
              TextInputField(
                controller: _confirmPasswordController,
                labelText: 'Confirm Password',
                icon: Icons.lock_outline,
                isObscure: true,
              ),
              const SizedBox(height: 25.0),
              // Registration Button
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.all(Radius.circular(5))),
                child: InkWell(
                  onTap: () {
                    if (_usernameController.text.length < 6) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Username must be at least 6 characters long')));
                      return;
                    }

                    if (!_emailController.text.endsWith("@newarka.edu") || _emailController.text != _confirmEmailController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email must end with "@newarka.edu" and match')));
                      return;
                    }

                    bool hasDigits = _passwordController.text.contains(new RegExp(r'\d'));
                    if (_passwordController.text.length < 7 || !hasDigits || _passwordController.text != _confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password must be at least 7 characters long including 1 number and match')));
                      return;
                    }

                    AuthController.instance.registerNewUser(
                      _usernameController.text,
                      _emailController.text,
                      _passwordController.text,
                    );
                  },
                  child: const Center(
                    child: Text(
                      'Register',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25.0),
              // Login Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? ', style: TextStyle(fontSize: 20)),
                  InkWell(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen())),
                    child: Text('Login', style: TextStyle(fontSize: 20, color: Colors.blue)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
