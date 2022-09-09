import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:maple_daily_tracker/screens/login_screen.dart';
import 'package:maple_daily_tracker/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_size/window_size.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/models/tracker.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    setWindowTitle('Maple Tracker');
    setWindowMinSize(const Size(800, 600));
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  List<SingleChildWidget> providers = [
    ChangeNotifierProvider<TrackerModel>(
      create: (_) => TrackerModel(),
    ),
    StreamProvider<User?>(
        create: (_) => FirebaseAuth.instance.authStateChanges(),
        initialData: null)
  ];

  runApp(
    MultiProvider(
      providers: providers,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
        dividerColor: Colors.transparent,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
              const EdgeInsets.all(24),
            ),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          ),
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(title: 'Maple Daily Tracker'),
      debugShowCheckedModeBanner: false,
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
  bool _showWelcome = true;

  @override
  void initState() {
    super.initState();
    getSharedPrefWelcomeState();
  }

  Future getSharedPrefWelcomeState() async {
    var prefs = await SharedPreferences.getInstance();
    var showWelcome = prefs.getBool("show_welcome_screen") ?? true;
    setState(() {
      _showWelcome = showWelcome;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: _showWelcome ? WelcomeScreen() : LoginScreen());
  }
}
