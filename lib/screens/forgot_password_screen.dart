import 'package:email_validator/email_validator.dart';
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
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !EmailValidator.validate(_emailController.text)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    label: Text('Enter your email'),
                  ),
                  controller: _emailController,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  child: (_isLoading)
                      ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 1.5,
                    ),
                  )
                      : const Text(
                    'Send Reset Email',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    setState(() {
                      _isLoading = true;
                    });

                    try {
                      await supabase.auth.resetPasswordForEmail(
                        _emailController.text,
                        redirectTo: SUPABASE_FORGOT_PASSWORD_REDIRECT_URL,
                      );

                      context.showSnackBar(message: 'Password email sent');
                      context.read<AuthenticationService>().setOTP(_emailController.text);
                    } on AuthException catch (error) {
                        context.showErrorSnackBar(message: '${error.message}');
                    } catch (error) {
                        context.showErrorSnackBar(
                            message: 'Unexpected error has occurred: $error');
                    }

                    setState(() {
                      _isLoading = false;
                    });
                  },
                ),
                SizedBox(height: 10),
              ],
            ),
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

// Form(
// key: _formKey,
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.stretch,
// children: [
// TextFormField(
// validator: (value) {
// if (value == null ||
// value.isEmpty ||
// !EmailValidator.validate(_email.text)) {
// return 'Please enter a valid email address';
// }
// return null;
// },
// decoration: const InputDecoration(
// prefixIcon: Icon(Icons.email),
// label: Text('Enter your email'),
// ),
// controller: _email,
// ),
// spacer(16),
// ElevatedButton(
// child: (_isLoading)
// ? const SizedBox(
// height: 16,
// width: 16,
// child: CircularProgressIndicator(
// color: Colors.white,
// strokeWidth: 1.5,
// ),
// )
//     : const Text(
// 'Send Reset Email',
// style: TextStyle(fontWeight: FontWeight.bold),
// ),
// onPressed: () async {
// if (!_formKey.currentState!.validate()) {
// return;
// }
// setState(() {
// _isLoading = true;
// });
// try {
// await supaClient.auth.resetPasswordForEmail(
// _email.text,
// redirectTo: widget.redirectUrl,
// );
// widget.onSuccess.call();
// } on AuthException catch (error) {
// if (widget.onError == null) {
// context.showErrorSnackBar(error.message);
// } else {
// widget.onError?.call(error);
// }
// } catch (error) {
// if (widget.onError == null) {
// context.showErrorSnackBar(
// 'Unexpected error has occurred: $error');
// } else {
// widget.onError?.call(error);
// }
// }
// if (mounted) {
// setState(() {
// _isLoading = false;
// });
// }
// },
// ),
// spacer(10),
// ],
// ),
// );
