import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/constants.dart';
import 'package:maple_daily_tracker/extensions/snackbar_extensions.dart';
import 'package:maple_daily_tracker/services/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key, required this.onSignIn})
      : super(key: key);

  final void Function() onSignIn;

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SupaSendEmail(
            redirectUrl: SUPABASE_FORGOT_PASSWORD_REDIRECT_URL,
            onSuccess: () {
              context.showSnackBar(message: 'Password email sent');
              context.read<AuthenticationService>().setOTP();
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
