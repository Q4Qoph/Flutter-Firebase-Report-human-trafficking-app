import 'package:flutter/material.dart';
import 'package:project_app1/auth/sign_in.dart';
import 'package:project_app1/auth/sign_up.dart';

class ToggleAuth extends StatefulWidget {
  const ToggleAuth({super.key});

  @override
  State<ToggleAuth> createState() => _ToggleAuthState();
}

class _ToggleAuthState extends State<ToggleAuth> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignInWrapper(toggleView: toggleView);
    } else {
      return SignUpWrapper(toggleView: toggleView);
    }
  }
}
