import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/providers/tracker.dart';
import 'package:provider/provider.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen(
      {Key? key, required this.onSignUp, required this.onForgotPassword})
      : super(key: key);

  final void Function() onSignUp;
  final void Function() onForgotPassword;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(24.0),
      children: [
        SupaEmailAuth(
          authAction: SupaAuthAction.signIn,
          onSuccess: (authResponse) {
            context.read<TrackerModel>().fetchProfileInfo(authResponse.user!.id);
          },
        ),
        TextButton(
            child: const Text(
              'Forgot Password? Click here',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: onForgotPassword),
        TextButton(
            child: const Text(
              'Don\'t have an account? Sign Up',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: onSignUp),
      ],
    );
  }
}
