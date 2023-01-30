import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/constants.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key, required this.onSignIn})
      : super(key: key);

  final void Function() onSignIn;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool showOTP = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          SupaSendEmail(
            redirectUrl: SUPABASE_REDIRECT_URL,
            onSuccess: () {
              print('success password email sent');
              setState(() {
                showOTP = true;
              });
            },
          ),
          TextButton(
              child: const Text(
                'Take me back to Sign In',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: widget.onSignIn)
        ],
      ),
    );
  }
}
