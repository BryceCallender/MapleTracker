import 'package:anchored_popups/anchored_popup_region.dart';
import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/components/styled_circle_image.dart';
import 'package:maple_daily_tracker/components/tooltip.dart';
import 'package:maple_daily_tracker/components/user_profile_card.dart';
import 'package:maple_daily_tracker/providers/theme_settings.dart';
import 'package:maple_daily_tracker/providers/tracker.dart';
import 'package:maple_daily_tracker/styled_buttons.dart';
import 'package:maple_daily_tracker/styles.dart';
import 'package:provider/provider.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({Key? key, this.invertRow = false}) : super(key: key);

  final bool invertRow;

  @override
  Widget build(BuildContext context) {
    final themeData = context.watch<ThemeSettings>();
    final profile = context.watch<TrackerModel>().profile;
    Widget profileIcon = StyledCircleImage(
        padding: EdgeInsets.all(Insets.xs), url: profile?.avatarUrl);

    return AnchoredPopUpRegion.hoverWithClick(
      clickPopChild: ClipRect(child: UserProfileCard()),
      hoverPopChild: const StyledTooltip("Open Profile Menu"),
      buttonBuilder: (_, child, show) => SimpleBtn(
        onPressed: show,
        child: child,
        hoverColors: BtnColors(
          fg: themeData.secondary.withOpacity(0.5),
          bg: themeData.secondary.withOpacity(0.5),
        ),
      ),
      hoverPopAnchor: invertRow ? Alignment.topRight : Alignment.topLeft,
      clickPopAnchor: invertRow ? Alignment.topRight : Alignment.topLeft,
      clickAnchor: invertRow ? Alignment.bottomRight : Alignment.bottomLeft,
      child: profileIcon,
    );
  }
}
