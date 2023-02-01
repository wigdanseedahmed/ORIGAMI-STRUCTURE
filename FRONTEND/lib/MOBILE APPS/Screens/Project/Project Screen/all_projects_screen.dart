import 'package:origami_structure/imports.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:unicorndial/unicorndial.dart';
import 'package:http/http.dart' as http;

class ProjectScreenMA extends StatefulWidget {
  static const String id = 'project_screen';


  const ProjectScreenMA({
    Key? key,
  }) : super(key: key);

  @override
  _ProjectScreenMAState createState() => _ProjectScreenMAState();
}

class _ProjectScreenMAState extends State<ProjectScreenMA> {
  late String searchProject;

  List<Widget> _tabTwoParameters() => [
        const Tab(
          child: Text(
            "All",
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Tab(
          child: Text(
            "Open",
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Tab(
          child: Text(
            "Closed",
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Tab(
          child: Text(
            "Expired",
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Tab(
          child: Text(
            "Future",
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Tab(
          child: Text(
            "Suggested",
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ];

  TabBar _projectTabBarLabel() => TabBar(
        isScrollable: true,
        indicatorColor: primaryColour,
        tabs: _tabTwoParameters(),
        labelColor: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.black
            : Colors.white,
        labelStyle: const TextStyle(
          fontSize: 18,
          fontFamily: "Montserrat",
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelColor:
            DynamicTheme.of(context)?.brightness == Brightness.light
                ? Colors.black12
                : Colors.white12,
        unselectedLabelStyle: const TextStyle(fontSize: 18),
        onTap: (index) {
          var content = "";
          switch (index) {
            case 0:
              content = "All";
              break;
            case 1:
              content = "Open";
              break;
            case 2:
              content = "Closed";
              break;
            case 3:
              content = "Expired";
              break;
            case 4:
              content = "Future";
              break;
            case 5:
              content = "Suggested";
              break;
            default:
              content = "Other";
              break;
          }
          if (kDebugMode) {
            print("You are clicking the $content");
          }
        },
      );

  /// Variable used to get RESTful-API
  NetworkHandler networkHandler = NetworkHandler();

  /// User Model information Variables
  getUserInfo() async {
    UserProfile.email =
        await CheckSharedPreferences.getUserEmailSharedPreference();
    UserProfile.email =
        await CheckSharedPreferences.getUserEmailSharedPreference();
    var userInfo = await networkHandler
        .get("${AppUrl.getUserUsingEmail}${UserProfile.email}");

    //print(userInfo);
    setState(() {
      UserProfile.email = userInfo['data']['email'];
      UserProfile.username = userInfo['data']['username'];
      UserProfile.firstName = userInfo['data']['firstName'];
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

  /// VARIABLES USED FOR FLOATING APP BAR
  late String? selectedMenuItem = "Add New Project";

  @override
  initState() {
    /// VARIABLES USED TO SCROLL THROUGH SCREEN
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    getUserInfo();
    readingUserJsonData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition < screenSize.height * 0.40
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;

    /// VARIABLES USED FOR FLOATING APP BAR
    var childButtons = <UnicornButton>[];

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelBackgroundColor: Colors.transparent,
        labelHasShadow: false,
        labelText: "Add New Project",
        currentButton: FloatingActionButton(
          heroTag: "Add New Project",
          backgroundColor: primaryColour,
          mini: true,
          child: const Icon(Icons.library_books_outlined),
          onPressed: () {
            setState(() {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const AddNewProjectDetailScreenMA(
                      navigationMenu: NavigationMenu.projectScreen,
                    );
                  });
              selectedMenuItem = "Add New Project";
            });
          },
        ),
      ),
    );

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelBackgroundColor: Colors.transparent,
        labelHasShadow: false,
        labelText: "Suggest New Project",
        currentButton: FloatingActionButton(
          heroTag: "Suggest New Project",
          backgroundColor: primaryColour,
          mini: true,
          onPressed: () {
            setState(() {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const AddNewSuggestedProjectDetailScreenMA(
                      navigationMenu: NavigationMenu.projectScreen,
                    );
                  });
              selectedMenuItem = "Suggest New Project";
            });
          },
          child: const Icon(Icons.question_mark_outlined),
        ),
      ),
    );

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
                floatingActionButton: buildFloatingActionButton(childButtons),
                bottomNavigationBar: buildBottomNavigationBar(),
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
      child: DefaultTabController(
        length: 6,
        child: NestedScrollView(
          scrollDirection: Axis.vertical,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              //headerSilverBuilder only accepts slivers
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 22,
                    ),
                    ListTile(
                      leading: const Text(
                        "My projects",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: SizedBox(
                        height: 40,
                        width: 40,
                        child: DottedBorder(
                          borderType: BorderType.rrect,
                          radius: const Radius.circular(8),
                          color: Colors.grey,
                          strokeWidth: 1,
                          dashPattern: const [3, 4],
                          customPath: Path(),
                          child: Center(
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AllProjectsDashboardScreenMA(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.dashboard_outlined,
                                size: 32.0,
                                color: primaryColour,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: DynamicTheme.of(context)?.brightness ==
                                Brightness.light
                            ? Colors.white
                            : Colors.white12,
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.search,
                          color: primaryColour,
                          size: 28,
                        ),
                        title: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search project',
                            hintStyle: TextStyle(
                              color: DynamicTheme.of(context)?.brightness ==
                                      Brightness.light
                                  ? Colors.black12
                                  : Colors.white12,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                        trailing: Icon(
                          Icons.mic,
                          color: primaryColour,
                          size: 28,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    Container(
                      child: _projectTabBarLabel(),
                    ),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            children: <Widget>[
              AllProjectScreenMA(username: readUserJsonFileContent.username!),
              OpenProjectScreenWS(username: readUserJsonFileContent.username!),
              ClosedProjectScreenMA(username: readUserJsonFileContent.username!),
              ExpiredProjectScreenMA(username: readUserJsonFileContent.username!),
              FutureProjectScreenMA(username: readUserJsonFileContent.username!),
              SuggestedProjectScreenMA(
                  username: readUserJsonFileContent.username!),
            ],
          ),
        ),
      ),
    );
  }

  buildFloatingActionButton(List<UnicornButton> childButtons) {
    return UnicornDialer(
      backgroundColor: DynamicTheme.of(context)?.brightness == Brightness.light
          ? const Color.fromRGBO(255, 255, 255, 0.6)
          : const Color(0XFF323232),
      parentButtonBackground: primaryColour,
      orientation: UnicornOrientation.VERTICAL,
      parentButton: const Icon(Icons.filter_list_sharp),
      childButtons: childButtons,
    );
  }

  buildBottomNavigationBar() {
    return CustomBottomNavBarMA(
      selectedMenu: MenuState.projectScreen,
    );
  }
}
