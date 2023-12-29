import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [_usernameField(), _passwordField(), _loginButton()],
          )),
    );
  }

  Widget _usernameField() {
    return TextFormField(
      decoration: const InputDecoration(
          icon: Icon(Icons.person), hintText: "Tài Khoản"),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      decoration: const InputDecoration(
          icon: Icon(
            Icons.security,
          ),
          hintText: "Mật Khẩu"),
    );
  }

  Widget _loginButton() {
    return ElevatedButton(
        onPressed: () {}, child: const Text("Đăng Nhập Với Google"));
  }
}
