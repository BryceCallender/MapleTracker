import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthenticationService with ChangeNotifier {
  final GoTrueClient _supabaseAuth;
  String errorMessage = "";

  bool showOtpScreen = false;
  bool showResetPasswordScreen = false;

  AuthenticationService(this._supabaseAuth);

  Stream<AuthState?> get authStateChanges => _supabaseAuth.onAuthStateChange;

  Future<void> signIn({ required String email, required String password }) async {
    try {
      //sign in
      errorMessage = "";
      await _supabaseAuth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      errorMessage = e.message;
    } catch (error) {
      errorMessage = "Unexpected error occurred";
    }

    notifyListeners();
  }

  Future<void> signInWithOtp({ required String email, required String otpCode }) async {
    await _supabaseAuth.verifyOTP(
        email: email,
        token: otpCode,
        type: OtpType.recovery,
    );

    setResetPassword();
    notifyListeners();
  }

  Future<void> signOut() async {
    await _supabaseAuth.signOut();
    notifyListeners();
  }

  Future<void> signUp({ required String email, required String password }) async {
    try {
      errorMessage = "";
      await _supabaseAuth.signUp(email: email, password: password);
    } on AuthException catch (e) {
      errorMessage = e.message;
    } catch (error) {
      errorMessage = "Unexpected error occurred";
    }

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

  setOTP({bool? value}) {
    showOtpScreen = value ?? true;
    notifyListeners();
  }
}