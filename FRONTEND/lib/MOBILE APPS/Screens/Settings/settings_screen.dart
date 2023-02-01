import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class SettingsScreenMA extends StatefulWidget {
  static const String id = 'settings_screen';

  const SettingsScreenMA({Key? key}) : super(key: key);

  @override
  _SettingsScreenMAState createState() => _SettingsScreenMAState();
}

class _SettingsScreenMAState extends State<SettingsScreenMA> {
  void changeBrightness() {
    DynamicTheme.of(context)!.setBrightness(
        Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark);
  }

  /// Variable used to get RESTful-API
  NetworkHandler networkHandler = NetworkHandler();

  ///VARIABLES USED FOR RETRIEVING USER INFORMATION
  getUserInfo() async {
    UserProfile.email =
        await CheckSharedPreferences.getUserEmailSharedPreference();
    UserProfile.email =
        await CheckSharedPreferences.getUserEmailSharedPreference();
    var userInfo = await networkHandler
        .get("${AppUrl.getUserUsingEmail}${UserProfile.email}");

    //print(userInfo);
    setState(() {
      UserProfile.username = userInfo['data']['username'];
      UserProfile.firstName = userInfo['data']['firstName'];
      UserProfile.lastName = userInfo['data']['lastName'];
      UserProfile.userPhotoURL = userInfo['data']["userPhotoURL"];
    });
  }

  UserModel readUserJsonFileContent = UserModel();
  Future<UserModel>? futureUserInformation;

  Future<UserModel> readingUserJsonData() async {
    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(AppUrl.users);

    /// Create Request to get data and response to read data
    final response = await http.get(
      uri,
      headers: {
        "Access-Control-Allow-Origin": "*",
        // Required for CORS support to work
        "Access-Control-Allow-Headers":
            "Content-Type, Access-Control-Allow-Origin, Accept",
        //'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Methods": "POST, DELETE, GET, PUT"
      },
    );
    // print('Response status: ${response.statusCode}');
    // print('Response Enter body: ${response.body}');

    if (response.statusCode == 200) {
      readUserJsonFileContent = userModelListFromJson(response.body)
          .where((element) => element.email == UserProfile.email)
          .toList()[0];
      //print("User Model Info : ${readUserJsonFileContent.firstName}");

      return readUserJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  ///VARIABLES USED TO DETERMINE SCREEN SIZE
  late ScrollController _scrollController;
  double _scrollPosition = 0;
  double _opacity = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    /// VARIABLES USED TO SCROLL THROUGH SCREEN
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    /// User Model information Variables
    getUserInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition < screenSize.height * 0.40
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1.0),
      child: FutureBuilder<UserModel>(
        future: readingUserJsonData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Scaffold(
                body: buildBody(),
                bottomNavigationBar: buildBottomNavigatorBar(),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }

  buildBody(){
    return SafeArea(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  top: 30.0, left: 16, right: 16, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      readUserJsonFileContent.userPhotoFile == null
                          ? Padding(
                        padding:
                        const EdgeInsets.only(top: 6),
                        child: Container(

                          height: 125,
                          width: 125,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(
                                202, 202, 202, 1),
                            borderRadius: BorderRadius.all(
                                Radius.circular(125)),
                          ),
                          child: Center(
                            child: Text(
                              "${readUserJsonFileContent.firstName![0]}${readUserJsonFileContent.lastName![0]}",
                              style: TextStyle(
                                fontSize:
                                MediaQuery.of(context).size.width * 0.1,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromRGBO(
                                    76, 75, 75, 1),
                              ),
                            ),
                          ),
                        ),
                      )
                          : Padding(
                        padding:
                        const EdgeInsets.only(top: 6),
                        child: Container(
                          height: 125,
                          width: 125,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(
                                202, 202, 202, 1),
                            borderRadius: BorderRadius.all(
                                Radius.circular(125)),
                          ),
                          child: CircleAvatar(
                            backgroundImage: MemoryImage(
                                base64Decode(
                                    readUserJsonFileContent
                                        .userPhotoFile!)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 13,
                      ),
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${readUserJsonFileContent.firstName!} ${readUserJsonFileContent.lastName!}",
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 21),
                          ),
                          Text(
                            readUserJsonFileContent.jobTitle!,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            settingTilesMA(
              context: context,
              title: "Profile",
              subtitle: "Change profile information",
              icon: FontAwesomeIcons.user,
              //EvaIcons.personOutline
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const ProfileScreenMA(),
                  ),
                );
              },
            ),
            settingTilesMA(
              context: context,
              title: "Dashboard",
              subtitle: "See user dashboard",
              icon: Icons.dashboard,
              //EvaIcons.personOutline
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const UserDashboardScreenMA(),
                  ),
                );
              },
            ),
            settingTilesMA(
              context: context,
              title: "Application Theme",
              subtitle: DynamicTheme.of(context)?.brightness == Brightness.light
                  ? "Light Mode"
                  : "Dark Mode",
              icon: DynamicTheme.of(context)?.brightness == Brightness.light
                  ? FontAwesomeIcons.solidSun
                  : FontAwesomeIcons.solidMoon,
              onTap: changeBrightness,
            ),
            settingTilesMA(
              context: context,
              title: "Forgot Password",
              subtitle: "Send recovery mail",
              icon: Icons.restore,
              onTap: () async {},
            ),
            settingListTilesMA(
              title: "Notifications",
              context: context,
              subtitle: "On",
              onChanged: (val) {},
              value: true,
            ),
            settingTilesMA(
              context: context,
              title: "About",
              subtitle: "Contact us",
              icon: Icons.contact_mail,
              onTap: () {},
            ),
            settingTilesMA(
              context: context,
              title: "Log Out",
              subtitle: "Tap here to log out",
              icon: FontAwesomeIcons.signOutAlt,
              onTap: () async {
                SharedPreferences prefs =
                await SharedPreferences.getInstance();
                prefs.remove('email');
                prefs.clear();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                    const Authenticate(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  buildBottomNavigatorBar() {
    return const CustomBottomNavBarMA(
      selectedMenu: MenuState.settingsScreen,
    );
  }
}
