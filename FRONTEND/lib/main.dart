import 'package:origami_structure/imports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // NotificationServiceImpl();
  //await Hive.initFlutter();
  runApp(const OrigamiStructureApp());
}

class OrigamiStructureApp extends StatelessWidget {
  const OrigamiStructureApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }),
        fontFamily: "Nunito",
        primaryColor: Colors.red,
        // ignore: deprecated_member_use
        accentColor: Colors.redAccent,
        primaryColorDark: const Color(0xff0029cb),
        brightness: brightness,
      ),
      themedWidgetBuilder: (context, theme) => OrigamiStructure(
        theme: theme,
      ),
    );
  }
}

class OrigamiStructure extends StatefulWidget {
  const OrigamiStructure({
    Key? key,
    required this.theme,
  }) : super(key: key);

  final ThemeData theme;

  @override
  State<OrigamiStructure> createState() => _OrigamiStructureState();
}

class _OrigamiStructureState extends State<OrigamiStructure> {
/*

  static final String oneSignalAppId = "4a61a5d7-fa5c-435d-beb4-a4c6bb224950";

  Future<void> initPlatformState() async {
    OneSignal.shared.setAppId(oneSignalAppId);
    OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((accepted) {});
  }
*/

  late bool userIsLoggedIn = false;

  @override
  void initState() {
    // getUserInfo();
    //initPlatformState();
    getLoggedInState();
    super.initState();
    WidgetsBinding.instance.renderView.automaticSystemUiAdjustment =
        false; //<--
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF1f1e30),
        systemNavigationBarColor: Color(0xFF1f1e30),
      ),
    );
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInPreference().then((value) {
      setState(() {
        userIsLoggedIn = value!;
      });
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Origami Structure',
      theme: widget.theme,
      debugShowCheckedModeBanner: false,
      home: Builder(
        builder: (BuildContext context) {
          return userIsLoggedIn != null
              ? userIsLoggedIn
                  ? ResponsiveWidget.isSmallScreen(context)
                      ? const HomeScreenMA()
                      : const HomeScreenWS()
                  : const Authenticate()
              : const Center(
                  child: Authenticate(),
                );
        },
      ),
    );
  }
}
