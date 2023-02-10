import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/constants.dart';
import 'package:maple_daily_tracker/extensions/snackbar_extensions.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key, required this.onSignIn, required this.onSignUpSuccess}) : super(key: key);

  final void Function() onSignUpSuccess;
  final void Function() onSignIn;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(24.0),
      children: [
        SupaEmailAuth(
          authAction: SupaAuthAction.signUp,
          redirectUrl: SUPABASE_LOGIN_REDIRECT_URL,
          onSuccess: (response) {
            context.showSnackBar(
                message: 'Account registered! Check email for confirmation link.'
            );
            onSignUpSuccess();
          },
          metadataFields: [
            MetaDataField(
              prefixIcon: const Icon(Icons.person),
              label: 'Username',
              key: 'username',
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Please enter something';
                }
                return null;
              },
            ),
          ],
        ),
        TextButton(
          child: const Text(
            'Already have an account? Sign In',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: onSignIn
        ),
      ],
    );
  }
}
