import 'package:cu1/components/button.dart';
import 'package:cu1/models/auth_model.dart';
import 'package:cu1/providers/dio_provider.dart';
import 'package:cu1/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:cu1/main.dart';
import 'package:provider/provider.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
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
          TextFormField(
            controller: _nameController,
            keyboardType: TextInputType.text,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              hintText: 'Username',
              labelText: 'Username',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.person_outlined),
              prefixIconColor: Config.primaryColor,
            ),
          ),
          Config.spaceSmall,
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

          Consumer<AuthModel>(
            builder: (context, auth, child) {
              return Button(
                width: double.infinity,
                title: 'Register Account',
                onPressed: () async {
                  // Call the registration method
                  final bool userRegistration =
                      await DioProvider().registerUser(
                    _nameController.text,
                    _emailController.text,
                    _passController.text,
                  );

                  // Check registration success
                  if (userRegistration) {
                    final token = await DioProvider()
                        .getToken(_emailController.text, _passController.text);

                    if (token != null) {
                      auth.loginSuccess(); // Update login status
                      MyApp.navigatorKey.currentState!
                          .pushNamed('main'); // Navigate to main page
                    } else {
                      print('Register unsuccessful: Unable to get token');
                    }
                  } else {
                    print('Register unsuccessful: Registration failed');
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
