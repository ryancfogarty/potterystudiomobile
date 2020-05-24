import 'package:apple_sign_in/apple_sign_in.dart';

class SupportsAppleLogin {
  static final SupportsAppleLogin _supportsAppleLogin =
      SupportsAppleLogin._internal();

  factory SupportsAppleLogin() {
    return _supportsAppleLogin;
  }

  SupportsAppleLogin._internal();

  static bool _supported;

  bool get supported => _supported;

  static init() async {
    _supported = await AppleSignIn.isAvailable();
  }
}
