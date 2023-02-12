import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/constants.dart';
import 'package:maple_daily_tracker/providers/tracker.dart';
import 'package:maple_daily_tracker/services/authentication_service.dart';
import 'package:maple_daily_tracker/styles.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  OtpFieldController otpController = OtpFieldController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'OTP Code',
            style: TextStyles.h2,
          ),
          Text(
            'An OTP code has been sent to the email. Enter in the code here to login and go to the reset password screen.',
            style: TextStyles.body1,
          ),
          SizedBox(
            height: Insets.xl,
          ),
          OTPTextField(
            width: MediaQuery.of(context).size.width,
            controller: otpController,
            length: 6,
            fieldWidth: 50,
            fieldStyle: FieldStyle.box,
            onChanged: (pin) {},
            onCompleted: (pin) async {
              await context.read<AuthenticationService>().signInWithOtp(
                    email: 'team.affinity.cpp@gmail.com',
                    otpCode: pin,
                  );

              final userId = supabase.auth.currentUser!.id;
              await Future.wait([
                context.read<TrackerModel>().fetchProfileInfo(userId),
                context.read<TrackerModel>().fetchUserInfo(userId)
              ]);
            },
          ),
        ],
      ),
    );
  }
}
