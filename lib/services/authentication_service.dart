import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationService with ChangeNotifier {
  final GoTrueClient _supabaseAuth;
  String errorMessage = "";

  bool showOtpScreen = false;
  bool showResetPasswordScreen = false;
  String? emailSentTo = '';

  AuthenticationService(this._supabaseAuth);

  Stream<AuthState?> get authStateChanges => _supabaseAuth.onAuthStateChange;

  Future<void> signInWithOtp({ required String otpCode }) async {
    await _supabaseAuth.verifyOTP(
        email: emailSentTo,
        token: otpCode,
        type: OtpType.recovery,
    );

    setResetPassword();
    notifyListeners();
  }

  Future<void> signOut() async {
    await _supabaseAuth.signOut();
    showOtpScreen = false;
    showResetPasswordScreen = false;
    emailSentTo = '';
    notifyListeners();
  }

  Future<void> resetPassword({ required String password }) async {
    await _supabaseAuth.updateUser(
      UserAttributes(
        password: password
      )
    );
    showResetPasswordScreen = false;
    notifyListeners();
  }

  setResetPassword({bool? value}) {
    showResetPasswordScreen = value ?? true;
    notifyListeners();
  }

  setOTP(String email, {bool? value}) {
    emailSentTo = email;
    showOtpScreen = value ?? true;
    notifyListeners();
  }
}