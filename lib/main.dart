import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:maple_daily_tracker/components/locked_popup_item.dart';
import 'package:maple_daily_tracker/screens/home_screen.dart';
import 'package:maple_daily_tracker/screens/login_screen.dart';
import 'package:maple_daily_tracker/services/authentication_service.dart';
import 'package:maple_daily_tracker/services/database_service.dart';
import 'package:menubar/menubar.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:window_size/window_size.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/providers/tracker.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:mime/mime.dart';

import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    setWindowTitle('Maple Tracker');
    setWindowMinSize(const Size(1000, 600));
  }

  if (!kIsWeb) {
    final menu = <NativeSubmenu>[
      NativeSubmenu(
        label: 'File',
        children: [
          NativeMenuItem(
            label: 'Exit',
            onSelected: () => FlutterWindowClose.closeWindow(),
          ),
        ],
      ),
      NativeSubmenu(label: 'Help', children: [
        NativeMenuItem(
          label: 'About',
          onSelected: () => {},
        ),
      ]),
    ];
    setApplicationMenu(menu);
  }

  await Supabase.initialize(
    url: SUPABASE_URL,
    anonKey: SUPABASE_ANNON_KEY,
  );

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
      create: (context) =>
          context.read<AuthenticationService>().authStateChanges,
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
    const mainColor = Colors.blue;
    const accentColor = Colors.tealAccent;

    return MaterialApp(
      title: 'Maple Tracker',
      theme: ThemeData.dark().copyWith(
        colorScheme: ThemeData.dark()
            .colorScheme
            .copyWith(primary: mainColor, secondary: accentColor),
        useMaterial3: true,
        dividerColor: Colors.transparent,
        appBarTheme: AppBarTheme(backgroundColor: mainColor),
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
            backgroundColor: MaterialStateProperty.all<Color>(mainColor),
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
  final double kAvatarSize = 20;
  final double kAvatarSizeLarge = 40;
  DatabaseService dbService = DatabaseService(supabase);
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: false,
        actions: [
          Consumer<AuthState?>(
            builder: (context, authState, child) {
              if (supabase.auth.currentUser == null) return Container();

              return PopupMenuButton(
                position: PopupMenuPosition.under,
                icon: (_avatarUrl != null)
                    ? CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: kAvatarSize + 1,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(_avatarUrl!),
                        ),
                      )
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
                          SizedBox(
                            height: 4.0,
                          ),
                          Text(supabase.auth.currentUser?.email ?? "")
                        ],
                      ),
                    ),
                    LockedPopupItem(
                      child: Center(
                        child: (_avatarUrl != null)
                            ? CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: kAvatarSizeLarge + 1,
                                child: CircleAvatar(
                                  radius: kAvatarSizeLarge,
                                  backgroundImage: NetworkImage(_avatarUrl!),
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.tealAccent,
                                child: const Icon(Icons.person_rounded),
                              ),
                      ),
                      onTap: () async {
                        _handleImageUpload();
                      },
                    ),
                    LockedPopupItem(
                      child: Center(
                        child: TextButton(
                          onPressed: () async {
                            _handleImageUpload();
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
                      onTap: () async {
                        await context.read<AuthenticationService>().signOut();
                      },
                    )
                  ];
                },
              );
            },
          )
        ],
      ),
      body: AuthenticationWrapper(),
    );
  }

  Future<Null> _handleImageUpload() async {
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

      await dbService.uploadBinary(fileName, bytes, mimeType);
      final imageUrlResponse = await dbService.createdSignedImageUrl(fileName);

      setState(() {
        _avatarUrl = imageUrlResponse;
      });

      final userId = supabase.auth.currentUser!.id;
      await dbService.upsertProfile(userId, _avatarUrl);
    }
  }

  Future<void> getProfile() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final data = await dbService.getProfile(userId);

      setState(() {
        _avatarUrl = (data['avatar_url'] ?? '') as String;
      });
    } on PostgrestException catch (error) {
      print(error);
    } catch (error) {}
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (supabase.auth.currentUser != null) {
      return HomeScreen();
    }

    return LoginScreen();
  }
}
