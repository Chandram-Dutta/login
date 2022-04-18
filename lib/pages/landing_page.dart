import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login/responsive/responsive.dart';
import 'package:validators/validators.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
            ),
          ),
          SizedBox(
            height: 400,
            width: isDesktop(context, 800) ? 500 : 300,
            child: Column(
              children: [
                Text(
                  "Login/Signup",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30,
                ),
                const EmailPart(),
                const SizedBox(
                  height: 20,
                ),
                const Text("Social Logins"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoButton(
                      child: const FaIcon(FontAwesomeIcons.google),
                      onPressed: () {},
                    ),
                    CupertinoButton(
                      child: const FaIcon(FontAwesomeIcons.apple),
                      onPressed: () {},
                    ),
                    CupertinoButton(
                      child: const FaIcon(FontAwesomeIcons.facebook),
                      onPressed: () {},
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EmailPart extends StatefulWidget {
  const EmailPart({
    Key? key,
  }) : super(key: key);

  @override
  State<EmailPart> createState() => _EmailPartState();
}

class _EmailPartState extends State<EmailPart> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // late bool _success;
  late String _userEmail;

  _register() async {
    try {
      final User? user =
          (await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
              .user;
      await FirebaseFirestore.instance.collection('users').doc().set({
        'uid': user!.uid,
        'email': user.email,
        'isEmailVerified': user.emailVerified, // will also be false
        'photoUrl': user.photoURL, // will always be null
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            validator: (val) => !isEmail(val!) ? "Invalid Email" : null,
            autocorrect: false,
            decoration: InputDecoration(
              focusColor: Colors.black,
              floatingLabelStyle: const TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: 'Email ID',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text';
              }
              if (value.length < 5) {
                return 'Must be more than 5 charater';
              }
              return null;
            },
            obscureText: true,
            autocorrect: false,
            decoration: InputDecoration(
              focusColor: Colors.black,
              floatingLabelStyle: const TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: 'Password',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 40,
            width: isDesktop(context, 800) ? 500 : 300,
            child: MaterialButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                  _register();
                }
              },
              color: Theme.of(context).colorScheme.onPrimary,
              shape: const StadiumBorder(),
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
