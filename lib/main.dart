import 'dart:io';

import 'package:anchored_popups/anchored_popups.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:context_menus/context_menus.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:maple_daily_tracker/components/profile_button.dart';
import 'package:maple_daily_tracker/extensions/color_extensions.dart';
import 'package:maple_daily_tracker/providers/theme_settings.dart';
import 'package:maple_daily_tracker/screens/home_screen.dart';
import 'package:maple_daily_tracker/screens/login_screen.dart';
import 'package:maple_daily_tracker/services/authentication_service.dart';
import 'package:maple_daily_tracker/services/database_service.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/providers/tracker.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:uni_links_desktop/uni_links_desktop.dart';

import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SUPABASE_URL,
    anonKey: SUPABASE_ANNON_KEY,
  );

  if (Platform.isWindows) {
    registerProtocol('io.mapledailytracker');
  }

  List<SingleChildWidget> providers = [
    ChangeNotifierProvider<TrackerModel>(
      create: (_) => TrackerModel(
        dbService: DatabaseService(supabase),
      ),
    ),
    ChangeNotifierProvider<AuthenticationService>(
      create: (_) => AuthenticationService(Supabase.instance.client.auth),
    ),
    StreamProvider<AuthState?>(
      create: (context) => supabase.auth.onAuthStateChange,
      initialData: null,
    ),
    ChangeNotifierProvider<ThemeSettings>(
      create: (_) => ThemeSettings(),
    )
  ];

  runApp(
    MultiProvider(
      providers: providers,
      child: const MyApp(),
    ),
  );

  doWhenWindowReady(() {
    final initialSize = Size(1000, 700);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.title = 'Maple Tracker';
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeSettings theme = context.watch<ThemeSettings>();

    return AnchoredPopups(
      child: MaterialApp(
        title: 'Maple Tracker',
        theme: theme.currentTheme,
        themeMode: ThemeMode.dark,
        home: ContextMenuOverlay(
          child: const MyHomePage(title: 'Maple Daily Tracker'),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    getProfile();

    FlutterWindowClose.setWindowShouldCloseHandler(() async {
      print('closing and saving reset times...');
      context.read<TrackerModel>().saveResetTimes(supabase.auth.currentUser?.id);
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
        actions: [
          ProfileButton(invertRow: true,)
        ],
      ),
      body: AuthenticationWrapper(),
    );
  }

  Future<void> getProfile() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      context.read<TrackerModel>().fetchProfileInfo(userId);
    } on PostgrestException catch (error) {
    } catch (error) {}
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState?>();

    if (supabase.auth.currentUser != null) {
      return HomeScreen();
    }

    return LoginScreen();
  }
}
