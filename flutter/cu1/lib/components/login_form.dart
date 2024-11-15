import 'package:cu1/components/button.dart';
import 'package:cu1/models/auth_model.dart';
import 'package:cu1/providers/dio_provider.dart';
import 'package:cu1/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:cu1/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool obsecurePass = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // Email TextFormField
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              hintText: 'Email Address',
              labelText: 'Email',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.email_outlined),
              prefixIconColor: Config.primaryColor,
            ),
          ),
          Config.spaceSmall,

          // Password TextFormField
          TextFormField(
            controller: _passController,
            obscureText: obsecurePass, // Hide the password text
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Config.primaryColor,
            decoration: InputDecoration(
              hintText: 'Password',
              labelText: 'Password',
              alignLabelWithHint: true,
              prefixIcon: const Icon(Icons.lock_outline),
              prefixIconColor: Config.primaryColor,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obsecurePass = !obsecurePass; // Toggle visibility
                  });
                },
                icon: obsecurePass
                    ? const Icon(
                        Icons.visibility_off_outlined,
                        color: Colors.black38,
                      )
                    : const Icon(
                        Icons.visibility_outlined,
                        color: Config.primaryColor,
                      ),
              ),
            ),
          ),
          Config.spaceSmall,

          // Login button and handling
          Consumer<AuthModel>(
            builder: (context, auth, child) {
              return Button(
                width: double.infinity,
                title: 'Sign In',
                onPressed: () async {
                  // Fetch the token from DioProvider
                  final token = await DioProvider().getToken(
                    _emailController.text,
                    _passController.text,
                  );

                  // Check if token is not null or empty
                  if (token != null && token.isNotEmpty) {
                    // Store the token in SharedPreferences
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('token', token);

                    auth.loginSuccess(); // Update login status
                    MyApp.navigatorKey.currentState!
                        .pushNamed('main'); // Navigate to main page
                  } else {
                    // Handle login failure (e.g., show a snackbar with an error message)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login failed!')),
                    );
                  }
                },
                disable: false,
              );
            },
          )
        ],
      ),
    );
  }
}
