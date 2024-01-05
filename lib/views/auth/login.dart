import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_home/repositories/auth..dart';
import 'dart:async';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? errorMessage = "";
  bool isLogin = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null ||
        value.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter correct email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty || value.length < 6) {
      return 'Password at least 6 character';
    }
    return null;
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      setState(() {
        errorMessage = e.message;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _usernameField(_controllerEmail),
                _passwordField(_controllerPassword),
                if (isLogin) ...[
                  _registerText(),
                  _loginEmailPassword(),
                  _loginGoogle(),
                ] else ...[
                  _registerText(),
                  _registerEmailPassword()
                ]
              ],
            ),
          )),
    );
  }

  Widget _usernameField(TextEditingController textEditingController) {
    return TextFormField(
      controller: _controllerEmail,
      validator: (value) => _validateEmail(value),
      decoration: const InputDecoration(
          label: Text("Email"), icon: Icon(Icons.person), hintText: "Email"),
    );
  }

  Widget _passwordField(TextEditingController textEditingController) {
    return TextFormField(
      controller: textEditingController,
      validator: (value) => _validatePassword(value),
      decoration: const InputDecoration(
          label: Text("Mật Khẩu"),
          icon: Icon(
            Icons.security,
          ),
          hintText: "Mật Khẩu"),
    );
  }

  Widget _registerText() {
    return TextButton(
        onPressed: () {
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: Text(isLogin
            ? "Bạn chưa có tài khoản? Đăng Ký"
            : "Bạn đã có tài khoản? Đăng Nhập"));
  }

  Widget _registerEmailPassword() {
    return Container(
      margin: EdgeInsets.all(10),
      child: SizedBox(
        height: 36,
        width: 180,
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              createUserWithEmailAndPassword();
            }
          },
          child: Text("Đăng Ký"),
        ),
      ),
    );
  }

  Widget _loginEmailPassword() {
    return Container(
      margin: EdgeInsets.all(10),
      child: SizedBox(
        height: 36,
        width: 180,
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              signInWithEmailAndPassword();
            }
          },
          child: Text("Đăng Nhập"),
        ),
      ),
    );
  }

  Widget _loginGoogle() {
    return SizedBox(
      height: 36,
      width: 180,
      child: ElevatedButton(
          onPressed: () {
            Future<void> signInWithGoogle() async {
              GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

              GoogleSignInAuthentication? googleAuth =
                  await googleUser?.authentication;

              AuthCredential credential = GoogleAuthProvider.credential(
                  accessToken: googleAuth?.accessToken,
                  idToken: googleAuth?.idToken);

              UserCredential userCredential =
                  await FirebaseAuth.instance.signInWithCredential(credential);

              print(userCredential);
            }

            signInWithGoogle();
          },
          child: Text("Đăng Nhập Với Goole")),
    );
  }
}
