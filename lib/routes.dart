import 'package:smart_home/views/auth/forgot_password.dart';
import 'package:smart_home/views/auth/login.dart';
import 'package:smart_home/views/home.dart';
import 'package:smart_home/views/room.dart';
import 'package:smart_home/views/splash.dart';

class PageNames {
  static const splash = "/splash";
  static const login = "/login";
  static const register = "/register";
  static const forgotPassword = '/forgotPassword';
  static const home = "/home";
  static const room = "/room";
}

dynamic getPages(context) {
  return {
    PageNames.splash: (context) => const Splash(),
    PageNames.login: (context) => const Login(),
    PageNames.forgotPassword: (context) => const ForgotPassword(),
    PageNames.home: (context) => Home(),
    PageNames.room: (context) => const Room(),
  };
}
