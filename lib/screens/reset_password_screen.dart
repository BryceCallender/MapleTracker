import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/extensions/snackbar_extensions.dart';
import 'package:maple_daily_tracker/services/authentication_service.dart';
import 'package:maple_daily_tracker/styles.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool? loading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Reset Password', style: TextStyles.h1,),
              SizedBox(height: Insets.lg,),
              TextFormField(
                controller: _newPasswordController,
                decoration: InputDecoration(
                  labelText: 'New password',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return 'Please enter a password that is at least 6 characters long';
                  }

                  return null;
                },
              ),
              SizedBox(height: Insets.lg),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm password',
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return 'Please enter a password that is at least 6 characters long';
                  }

                  if (_newPasswordController.text != value) {
                    return 'The password does not match.';
                  }

                  return null;
                },
              ),
              SizedBox(height: Insets.lg),
              ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    try {
                      await context.read<AuthenticationService>().resetPassword(password: _newPasswordController.text);
                    } on AuthException catch (error) {
                        context.showErrorSnackBar(message: error.message);
                    } catch (error) {
                      context.showErrorSnackBar(message:
                          'Unexpected error has occurred: $error');
                    }
                  },
                  child: Text('Update password')
              ),
              SizedBox(height: Insets.sm)
            ],
          ),
        ),
      ),
    );
  }
}
