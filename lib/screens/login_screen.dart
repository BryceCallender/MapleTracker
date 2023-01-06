import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/components/logo_typer.dart';
import 'package:maple_daily_tracker/screens/forgot_password_screen.dart';
import 'package:maple_daily_tracker/screens/signin_screen.dart';
import 'package:maple_daily_tracker/screens/signup_screen.dart';
import 'package:maple_daily_tracker/styles.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  SupaAuthAction action = SupaAuthAction.signIn;
  bool forgotPassword = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Padding(
          padding: EdgeInsets.all(Insets.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: LogoTyper(),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (forgotPassword) ... [
                      ForgotPasswordScreen(
                        onSignIn: _onSignInClicked,
                      ),
                    ] else... [
                      if (action == SupaAuthAction.signIn)
                        SignInScreen(
                          onSignUp: _onSignUpClicked,
                          onForgotPassword: _onForgotPasswordClicked,
                        )
                      else
                        SignUpScreen(
                          onSignIn: _onSignInClicked,
                        )
                    ]
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onSignUpClicked() {
    _updateAction(SupaAuthAction.signUp);
  }

  void _onSignInClicked() {
    _updateAction(SupaAuthAction.signIn);
  }

  void _onForgotPasswordClicked() {
    setState(() {
      forgotPassword = true;
    });
  }

  void _updateAction(SupaAuthAction authAction) {
    setState(() {
      forgotPassword = false;
      action = authAction;
    });
  }
}
