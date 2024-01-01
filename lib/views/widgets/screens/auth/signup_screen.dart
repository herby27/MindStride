import 'package:flutter/material.dart';
import 'package:mind_stride/views/widgets/input_text_field.dart';
import '../../../../controllers/auth_controller.dart';
import 'login_screen.dart';

///****************************************************************************
///MATTHEW HERBERT 2024
///This file defines a SignupScreen widget that creates the user registration screen for this MindStride flutter appllication
///It constructs the UI for the registration screen.
///It has a title,text input fields for username, email, and password, a registration button, and a link to the login screen
///****************************************************************************

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

///These are the controllers for handling user input
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold( ///This is a scaffold for overall screen structure
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text( ///This is the screen's title
              'MindStride',
              style: TextStyle(
                fontSize: 35.0,
                color: Colors.blue,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Text(
              'Sign Up',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 25.0,
            ),
            ///Username Input
            Container( ///This is the username input field
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 400),
              child: TextInputField(
                controller: _usernameController,
                labelText: 'Username',
                icon: Icons.person,
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),
            Container( ///This is the email input field
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 400),
              ///Calls the TextInputField Function
              child: TextInputField(
                controller: _emailController,
                labelText: 'Email',
                icon: Icons.email,
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),
            Container( ///This is the password input field
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 400),
              child: TextInputField(
                controller: _passwordController,
                labelText: 'Password',
                icon: Icons.lock,
                isObscure: true,
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),
            Container( ///This is the registration button
              width: MediaQuery.of(context).size.width - 800,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
              ),
              child: InkWell(
                onTap: () { //Here we call the AuthController to register a new user
                  AuthController.instance.registerNewUser(
                    _usernameController.text,
                    _emailController.text,
                    _passwordController.text,
                  );
                },
                child: const Center(
                  child: Text(
                    'Register',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),
            ///Login Button (bc the user already has an account)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Already have an account? ',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
