import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:maple_daily_tracker/components/locked_popup_item.dart';
import 'package:maple_daily_tracker/screens/login_screen.dart';
import 'package:maple_daily_tracker/screens/splash_screen.dart';
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
    setWindowMinSize(const Size(1000, 600));
  }

  runApp(SplashScreen());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  List<SingleChildWidget> providers = [
    ChangeNotifierProvider<TrackerModel>(
      create: (_) => TrackerModel(),
    ),
    StreamProvider<User?>(
      create: (_) => FirebaseAuth.instance.userChanges(),
      initialData: null,
    )
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
      title: 'Maple Tracker',
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
        dividerColor: Colors.transparent,
        appBarTheme: AppBarTheme(backgroundColor: Colors.blue),
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
  final double kAvatarSize = 20;
  final double kAvatarSizeLarge = 40;

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
        automaticallyImplyLeading: false,
        actions: [
          Consumer<User?>(
            builder: (context, user, child) {
              return PopupMenuButton(
                position: PopupMenuPosition.under,
                icon: (user != null && user.photoURL != null)
                    ? CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: kAvatarSize + 1,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user.photoURL!),
                        ))
                    : CircleAvatar(
                        backgroundColor: Colors.tealAccent,
                        child: const Icon(Icons.person_rounded),
                      ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Account",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(height: 4.0,),
                          Text(user?.email ?? "")
                        ],
                      ),
                    ),
                    LockedPopupItem(
                      child: Center(
                        child: CircleAvatar(
                          radius: kAvatarSizeLarge + 1,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: kAvatarSizeLarge,
                            backgroundImage: NetworkImage(user?.photoURL ?? ""),
                          ),
                        ),
                      ),
                      onTap: () async {
                        _handleImageUpload(user);
                      },
                    ),
                    LockedPopupItem(
                      child: Center(
                        child: TextButton(
                          onPressed: () async {
                            _handleImageUpload(user);
                          },
                          child: Text("Upload Image"),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.logout),
                        title: Text("Logout"),
                      ),
                      onTap: () {},
                    )
                  ];
                },
              );
            },
          )
        ],
      ),
      body: _showWelcome ? WelcomeScreen() : LoginScreen(),
    );
  }

  Future<Null> _handleImageUpload(User? user) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.length > 0) {
      PlatformFile file = result.files.first;
      String? extension = result.files.first.extension;

      // Upload file
      var task = await FirebaseStorage.instance
          .ref('ProfilePictures/${user?.uid}/${user?.uid}.${extension}')
          .putFile(File(file.path!));

      task.ref.getDownloadURL().then((url) => user?.updatePhotoURL(url));
    }
  }
}
