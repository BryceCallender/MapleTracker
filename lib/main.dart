import 'dart:io';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:context_menus/context_menus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:maple_daily_tracker/components/locked_popup_item.dart';
import 'package:maple_daily_tracker/extensions/color_extensions.dart';
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
import 'package:mime/mime.dart';
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
    )
  ];

  runApp(
    MultiProvider(
      providers: providers,
      child: const MyApp(),
    ),
  );

  doWhenWindowReady(() {
    final initialSize = Size(1000, 650);
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
        checkboxTheme: CheckboxThemeData(
          fillColor: MaterialStateProperty.all<Color>(accentColor),
          checkColor: MaterialStateProperty.all<Color>(accentColor.toLuminanceColor()),
          side: BorderSide(
            width: 2.0,
            color: Colors.white70
          )
        )
      ),
      themeMode: ThemeMode.dark,
      home: ContextMenuOverlay(
        child: const MyHomePage(title: 'Maple Daily Tracker'),
      ),
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
          Consumer<AuthState?>(
            builder: (context, authState, child) {
              if (supabase.auth.currentUser == null) return Container();

              final user = authState?.session?.user;
              final profile = context.watch<TrackerModel>().profile;

              String username = profile?.username ??
                  user?.userMetadata?["username"] ??
                  "Account";

              String? avatar_url = profile?.avatarUrl ??
                  user?.userMetadata?['avatar_url'] ??
                  _avatarUrl;

              final email =
                  user?.email ?? supabase.auth.currentUser?.email ?? '';

              return PopupMenuButton(
                position: PopupMenuPosition.under,
                icon: (avatar_url != null)
                    ? CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: kAvatarSize + 1,
                        child: CircleAvatar(
                          radius: kAvatarSize,
                          backgroundImage: NetworkImage(avatar_url),
                        ),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.tealAccent,
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.black,
                        ),
                      ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          SizedBox(
                            height: 4.0,
                          ),
                          Text(email)
                        ],
                      ),
                    ),
                    LockedPopupItem(
                      child: Center(
                        child: (avatar_url != null)
                            ? CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: kAvatarSizeLarge + 1,
                                child: CircleAvatar(
                                  radius: kAvatarSizeLarge,
                                  backgroundImage: NetworkImage(avatar_url),
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.tealAccent,
                                child: const Icon(
                                  Icons.person_rounded,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                      onTap: () async {
                        _handleImageUpload();
                      },
                    ),
                    LockedPopupItem(
                      child: Center(
                        child: FilledButton(
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
                        context.read<TrackerModel>().clear();
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
        _avatarUrl = data['avatar_url'] as String?;
      });
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
