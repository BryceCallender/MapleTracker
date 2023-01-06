import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key, required this.onSignIn}) : super(key: key);

  final void Function() onSignIn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          SupaSendEmail(
            onSuccess: () {
            },
          ),
          TextButton(
            child: const Text(
              'Take me back to Sign Up',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: onSignIn
          )
        ],
      ),
    );
  }
}
