import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class SettingsScreenWS extends StatefulWidget {
  static const String id = 'settings_screen';

  const SettingsScreenWS({Key? key}) : super(key: key);

  @override
  _SettingsScreenWSState createState() => _SettingsScreenWSState();
}

class _SettingsScreenWSState extends State<SettingsScreenWS> {
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

  UserModel readUserContent = UserModel();
  Future<UserModel>? futureUserInformation;

  Future<UserModel> readingUserData() async {
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
      readUserContent = userModelListFromJson(response.body)
          .where((element) => element.email == UserProfile.email)
          .toList()[0];
      //print("User Model Info : ${readUserJsonFileContent.firstName}");

      return readUserContent;
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
        future: readingUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Scaffold(
                body: buildBody(),
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

  buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 10),
          child: Column(
            children: [
              TopBarMenuAfterLoginWS(
                isSelectedPage: 'Settings',
                user: readUserContent,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: (MediaQuery.of(context).size.width < 1360) ? 4 : 3,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: buildSideMenu(),
                    ),
                  ),
                  Flexible(
                    flex: 9,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.01,
                        right: MediaQuery.of(context).size.width * 0.01,
                        bottom: MediaQuery.of(context).size.width * 0.05,
                      ),
                      child: selectedSideMenuItemInt == 0
                          ? ProfileScreenWS(
                              readUserContent: readUserContent,
                              selectedProfileSideMenuItemInt:
                                  selectedProfileSideMenuItemInt,
                            )
                          : selectedSideMenuItemInt == 1
                              ? EditProfileScreenWS(
                                  selectedEditProfileSideMenuItemInt:
                                      selectedEditProfileSideMenuItemInt,
                                )
                              : Container(),
                    ),
                  ),
                  selectedSideMenuItemInt == 0
                      ? Flexible(
                          flex: (MediaQuery.of(context).size.width < 1360)
                              ? 4
                              : 3,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            child: buildProfileSideMenu(),
                          ),
                        )
                      : selectedSideMenuItemInt == 1
                          ? Flexible(
                              flex: (MediaQuery.of(context).size.width < 1360)
                                  ? 4
                                  : 3,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                child: buildEditProfileSideMenu(),
                              ),
                            )
                          : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  late String selectedSideMenuItem = "Profile";
  late int selectedSideMenuItemInt = 0;

  buildSideMenu() {
    return Container(
      color: Theme.of(context).cardColor,
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Divider(thickness: 1),
            SettingsSelectionButtonWS(
              data: [
                SelectionButtonData(
                  activeIcon: EvaIcons.person,
                  icon: EvaIcons.personOutline,
                  title: "Profile",
                  subtitle: "View profile information",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.info,
                  icon: EvaIcons.infoOutline,
                  title: "Edit Profile",
                  subtitle: "Change profile information",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.grid,
                  icon: EvaIcons.gridOutline,
                  title: "Dashboard",
                  subtitle: "See user dashboard",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.moon,
                  icon: EvaIcons.moonOutline,
                  title: "Dark Theme",
                  subtitle: "Tap to change Theme",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: Icons.restore,
                  icon: Icons.restore,
                  title: "Forgot Password",
                  subtitle: "Send recovery mail",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.bell,
                  icon: EvaIcons.bellOutline,
                  title: "Notifications",
                  subtitle: "On",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: Icons.contact_mail,
                  icon: Icons.contact_mail_outlined,
                  title: "About",
                  subtitle: "Contact us",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.logOut,
                  icon: EvaIcons.logOutOutline,
                  title: "Log Out",
                  subtitle: "Tap here to log out",
                  totalNotification: null,
                ),
              ],
              onSelected: (index, value) async {
                if (index == 7) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('email');
                  prefs.clear();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const Authenticate(),
                    ),
                  );
                }
                setState(() {
                  selectedSideMenuItem = value.title;
                  selectedSideMenuItemInt = index;
                  if (index == 3) {
                    changeBrightness;
                  }
                  // print("index : $index | label : ${value.label}");
                });
                // log("index : $index | label : ${value.label}");
              },
              initialSelected: selectedSideMenuItemInt,
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  buildSideMenuOld() {
    return Container(
      color: Theme.of(context).cardColor,
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Divider(thickness: 1),
            settingTilesWS(
              context: context,
              title: "Profile",
              subtitle: "View profile information",
              icon: FontAwesomeIcons.user,
              //EvaIcons.personOutline
              onTap: () {
                setState(() {
                  selectedProfileSideMenuItem = "Profile";
                  selectedSideMenuItemInt = 0;
                });
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const ProfileScreenWS(),
                  ),
                );*/
              },
            ),
            settingTilesWS(
              context: context,
              title: " Edit Profile",
              subtitle: "Change profile information",
              icon: FontAwesomeIcons.user,
              //EvaIcons.personOutline
              onTap: () {
                setState(() {
                  selectedProfileSideMenuItem = "Edit Profile";
                  selectedSideMenuItemInt = 1;
                });
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const ProfileScreenWS(),
                  ),
                );*/
              },
            ),
            settingTilesWS(
              context: context,
              title: "Dashboard",
              subtitle: "See user dashboard",
              icon: Icons.dashboard,
              //EvaIcons.personOutline
              onTap: () {
                setState(() {
                  selectedProfileSideMenuItem = "Dashboard";
                  selectedSideMenuItemInt = 2;
                });
                /* Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                    const UserDashboardScreenWS(),
                  ),
                );*/
              },
            ),
            settingTilesWS(
              context: context,
              title: "Dark Theme",
              subtitle: "Tap to change Theme",
              icon: FontAwesomeIcons.solidMoon,
              onTap: changeBrightness,
            ),
            settingTilesWS(
              context: context,
              title: "Forgot Password",
              subtitle: "Send recovery mail",
              icon: Icons.restore,
              onTap: () async {
                setState(() {
                  selectedProfileSideMenuItem = "Forgot Password";
                  selectedSideMenuItemInt = 3;
                });
              },
            ),
            settingListTilesWS(
              context: context,
              title: "Notifications",
              subtitle: "On",
              onChanged: (val) {},
              value: true,
            ),
            settingTilesWS(
              context: context,
              title: "About",
              subtitle: "Contact us",
              icon: Icons.contact_mail,
              onTap: () {
                setState(() {
                  selectedProfileSideMenuItem = "About";
                  selectedSideMenuItemInt = 4;
                });
              },
            ),
            settingTilesWS(
              context: context,
              title: "Log Out",
              subtitle: "Tap here to log out",
              icon: FontAwesomeIcons.signOutAlt,
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('email');
                prefs.clear();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const Authenticate(),
                  ),
                );
              },
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  late String selectedProfileSideMenuItem = "Personal Information";
  late int selectedProfileSideMenuItemInt = 0;

  buildProfileSideMenu() {
    return Container(
      color: Theme.of(context).cardColor,
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Divider(thickness: 1),
            SelectionButtonWS(
              data: [
                SelectionButtonData(
                  activeIcon: EvaIcons.person,
                  icon: EvaIcons.personOutline,
                  title: "Personal Information",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.info,
                  icon: EvaIcons.infoOutline,
                  title: "General",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.globe2,
                  icon: EvaIcons.globe2Outline,
                  title: "Languages",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.bulb,
                  icon: EvaIcons.bulbOutline,
                  title: "Education",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.bookOpen,
                  icon: EvaIcons.bookOpenOutline,
                  title: "Experience",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.award,
                  icon: EvaIcons.awardOutline,
                  title: "Qualifications",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.settings,
                  icon: EvaIcons.settingsOutline,
                  title: "Soft Skills",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.settings2,
                  icon: EvaIcons.settings2Outline,
                  title: "Hard Skills",
                  totalNotification: null,
                ),
              ],
              onSelected: (index, value) {
                setState(() {
                  selectedProfileSideMenuItem = value.title;
                  selectedProfileSideMenuItemInt = index;
                  // print("index : $index | label : ${value.label}");
                });
                // log("index : $index | label : ${value.label}");
              },
              initialSelected: selectedProfileSideMenuItemInt,
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  late String selectedEditProfileSideMenuItem = "Personal Information";
  late int selectedEditProfileSideMenuItemInt = 0;

  buildEditProfileSideMenu() {
    return Container(
      color: Theme.of(context).cardColor,
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Divider(thickness: 1),
            SelectionButtonWS(
              data: [
                SelectionButtonData(
                  activeIcon: EvaIcons.person,
                  icon: EvaIcons.personOutline,
                  title: "Personal Information",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.info,
                  icon: EvaIcons.infoOutline,
                  title: "General",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.globe2,
                  icon: EvaIcons.globe2Outline,
                  title: "Languages",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.bulb,
                  icon: EvaIcons.bulbOutline,
                  title: "Education",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.bookOpen,
                  icon: EvaIcons.bookOpenOutline,
                  title: "Experience",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.award,
                  icon: EvaIcons.awardOutline,
                  title: "Qualifications",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.settings,
                  icon: EvaIcons.settingsOutline,
                  title: "Soft Skills",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.settings2,
                  icon: EvaIcons.settings2Outline,
                  title: "Hard Skills",
                  totalNotification: null,
                ),
              ],
              onSelected: (index, value) {
                setState(() {
                  selectedEditProfileSideMenuItem = value.title;
                  selectedEditProfileSideMenuItemInt = index;
                  // print("index : $index | label : ${value.label}");
                });
                // log("index : $index | label : ${value.label}");
              },
              initialSelected: selectedEditProfileSideMenuItemInt,
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
