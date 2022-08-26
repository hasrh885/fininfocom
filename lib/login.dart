// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  late bool isButtonDisabled;

  @override
  void initState() {
    super.initState();
    isButtonDisabled = false;
    setval();
  }

  setval() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('email')!.isNotEmpty) {
      setState(() {
        emailController.text = prefs.getString('email')!;
      });
    }
    if (prefs.getString('number')!.isNotEmpty) {
      setState(() {
        numberController.text = prefs.getString('number')!;
      });
    }
  }

  Future<String> saver(email, number) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', '$email');
    prefs.setString('number', '$number');
    return 'saved';
  }

  retriever() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';
    final number = prefs.getString('number') ?? '';

    print(email);
    print(number);
  }

  void validateAndSave() {
    final FormState form = formKey.currentState!;
    if (form.validate()) {
      print('Form is valid');
      saver(emailController.text, numberController.text);
      retriever();
    } else {
      print('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      // Check if this field is empty
                      if (value == null || value.isEmpty) {
                        return 'email cannot be blank';
                      }

                      // using regular expression
                      if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                        return "Please enter a valid email address";
                      }

                      // the email is valid
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                    // obscureText: true,
                    controller: numberController,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'Password cannot be blank' : null,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text('Login'),
                      onPressed: () => validateAndSave(),
                    )),
              ],
            ),
          )),
    );
  }
}
