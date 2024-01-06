import 'package:flutter/material.dart';
import 'package:mind_stride/views/widgets/input_text_field.dart';
import 'package:mind_stride/views/widgets/screens/auth/signup_screen.dart';

import '../../../../controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget{
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
        body: Container(
        alignment: Alignment.center,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'MindStride',
            style: TextStyle(
              fontSize: 35.0,
              color: Colors.blue,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Text(
            'Login',
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 25.0,
          ),
          //Email Input
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 400),
            //CALLS THE TEXTINPUTFIELD FUNCTION
            child: TextInputField(
              controller: _emailController,
              labelText: 'Email',
              icon: Icons.email,
            ),
          ),
          const SizedBox(
            height: 25.0,
          ),
          //Password Input
          Container(
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
          //Login Button
          Container(
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
                AuthController.instance.loginUser(
                  _emailController.text,
                  _passwordController.text,
                );
              },
              child: const Center(
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 25.0,
          ),
          //Signup Button (bc the user doesn't have an account)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Don\'t have an account? ',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SignupScreen(),
                  ),
                ),
                child: Text(
                  'Sign Up',
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
