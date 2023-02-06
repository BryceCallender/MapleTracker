import 'package:anchored_popups/anchored_popups.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/components/styled_circle_image.dart';
import 'package:maple_daily_tracker/providers/theme_settings.dart';
import 'package:maple_daily_tracker/providers/tracker.dart';
import 'package:maple_daily_tracker/services/authentication_service.dart';
import 'package:maple_daily_tracker/spacers.dart';
import 'package:maple_daily_tracker/styled_buttons.dart';
import 'package:maple_daily_tracker/styles.dart';
import 'package:mime/mime.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class UserProfileForm extends StatefulWidget {
  const UserProfileForm({Key? key}) : super(key: key);

  @override
  State<UserProfileForm> createState() => _UserProfileFormState();
}

class _UserProfileFormState extends State<UserProfileForm> {
  String appVersion = '';

  @override
  void initState() {
    super.initState();
    getAppVersion();
  }

  void getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.read<TrackerModel>().profile;
    final themeData = context.watch<ThemeSettings>();

    return Stack(
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: Text('v$appVersion', style: TextStyles.caption)),

        /// Profile
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            VSpace.med,
            SimpleBtn(
              cornerRadius: 99,
              hoverColors: BtnColors(
                fg: themeData.secondary.withOpacity(0.7),
                bg: themeData.secondary.withOpacity(0.7),
              ),
              onPressed: _handleImageUpload,
              child: SizedBox(
                height: 80 + Insets.xs * 2,
                child: Padding(
                  padding: EdgeInsets.all(Insets.xs),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: StyledCircleImage(url: profile?.avatarUrl),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: _handleImageUpload,
              child: Text('Upload Image'),
            ),
            VSpace.lg,

            /// Account
            SizedBox(
              width: double.infinity,
              child: Text("Account", style: TextStyles.body1),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'brycec848@gmail.com',
                style: TextStyles.body1,
              ),
            ),
            VSpace.lg,

            /// Logout
            FilledButton.icon(
              icon: Icon(Icons.logout),
              label: Text("LOGOUT"),
              onPressed: _handleLogoutPressed,
            ),
            VSpace.sm
          ],
        )
      ],
    );
  }

  Future<void> _handleImageUpload() async {
    var result = await FilePicker.platform
        .pickFiles(withData: true, type: FileType.image);

    if (result != null && result.files.length > 0) {
      final file = result.files.first;
      final filePath = file.path;
      final extension = result.files.first.extension;
      final bytes = file.bytes;
      final mimeType = filePath != null ? lookupMimeType(filePath) : null;

      if (bytes == null) {
        return;
      }

      final fileName = '${DateTime.now().toIso8601String()}.$extension';

      // await dbService.uploadBinary(fileName, bytes, mimeType);
      // final imageUrlResponse = await dbService.createdSignedImageUrl(fileName);

      setState(() {
        //_avatarUrl = imageUrlResponse;
      });

      // final userId = supabase.auth.currentUser!.id;
      // await dbService.upsertProfile(userId, _avatarUrl);
    }
  }

  void _handleLogoutPressed() {
    AnchoredPopups.of(context)?.hide();
    context.read<AuthenticationService>().signOut();
  }
}
