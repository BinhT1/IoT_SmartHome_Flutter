import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:smart_home/repositories/auth..dart';
import 'dart:async';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static const channel = MethodChannel('samples.flutter.dev/battery');
  String? errorMessage = "";
  bool isLogin = true;
  late String haskey;
  @override
  void initState() {
    // getHashKey();
    super.initState();
  }

  Future<void> getHashKey() async {
    String key = await channel.invokeMethod("getHashKey");
    setState(() {
      haskey = key;
    });
  }

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
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
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _hashKey(),
              _usernameField(_controllerEmail),
              _passwordField(_controllerPassword),
              _loginZalo()
              // _loginButton(),
              // _loginOrRegisterButton()
            ],
          )),
    );
  }

  Widget _hashKey() {
    return Text(haskey);
  }

  Widget _usernameField(TextEditingController textEditingController) {
    return TextFormField(
      controller: _controllerEmail,
      decoration: const InputDecoration(
          label: Text("Email"), icon: Icon(Icons.person), hintText: "Email"),
    );
  }

  Widget _passwordField(TextEditingController textEditingController) {
    return TextFormField(
      controller: textEditingController,
      decoration: const InputDecoration(
          label: Text("Password"),
          icon: Icon(
            Icons.security,
          ),
          hintText: "Mật Khẩu"),
    );
  }

  Widget _loginButton() {
    return ElevatedButton(
        onPressed: () {
          // isLogin
          //     ? signInWithEmailAndPassword()
          //     : createUserWithEmailAndPassword();
          Future<void> signInWithGoogle() async {
            GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

            GoogleSignInAuthentication? googleAuth =
                await googleUser?.authentication;

            AuthCredential credential = GoogleAuthProvider.credential(
                accessToken: googleAuth?.accessToken,
                idToken: googleAuth?.idToken);

            UserCredential userCredential =
                await FirebaseAuth.instance.signInWithCredential(credential);

            print(userCredential.user?.displayName ?? "");
          }

          signInWithGoogle();
        },
        child: Text(isLogin ? "Đăng Nhập" : "Đăng Ký"));
  }

  Widget _loginZalo() {
    return ElevatedButton(onPressed: () {}, child: Text("Login Zalo"));
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
        onPressed: () {
          setState(() {
            isLogin = !isLogin;
          });
        },
        child: Text(isLogin ? "Register" : "Login"));
  }
}
