import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key, required this.onSignIn}) : super(key: key);

  final void Function() onSignIn;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(24.0),
      children: [
        SupaEmailAuth(
          authAction: SupaAuthAction.signUp,
          onSuccess: (response) {
            print(response.user);
            print(response.session);
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
