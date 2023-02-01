import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class HomeScreenMA extends StatefulWidget {
  static const String id = 'dashboard_screen';

  final UserModel? user;

  const HomeScreenMA({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  _HomeScreenMAState createState() => _HomeScreenMAState();
}

class _HomeScreenMAState extends State<HomeScreenMA> {
  /// Task Bar Navigator Variables
  List<Widget> _tabTwoParameters() => [
        const Tab(
          child: Text(
            "Today",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        const Tab(
          child: Text(
            "Week",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        const Tab(
          child: Text(
            "Month",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
      ];

  TabBar _tabBarLabel() => TabBar(
        indicatorColor: primaryColour,
        tabs: _tabTwoParameters(),
        labelColor: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.black
            : Colors.white,
        labelStyle: const TextStyle(fontSize: 14),
        unselectedLabelColor:
            DynamicTheme.of(context)?.brightness == Brightness.light
                ? Colors.black12
                : Colors.white12,
        unselectedLabelStyle: const TextStyle(fontSize: 14),
        onTap: (index) {
          var content = "";
          switch (index) {
            case 0:
              content = "Today";
              break;
            case 1:
              content = "Week";
              break;
            case 2:
              content = "Month";
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

  ///VARIABLES USED FOR RETRIEVING TASKS FOR USER
  late List<TaskModel> readTaskJsonFileContent = <TaskModel>[];

  Future<List<TaskModel>> readingTasksJsonData() async {
    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(AppUrl.tasks);

    /// Create Request to get data and response to read data
    final response = await http.get(
      uri,
      headers: {
        //"Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        // Required for CORS support to work
        //"Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Content-Type, Access-Control-Allow-Origin, Accept",
        "Access-Control-Allow-Methods": "POST, DELETE, GET, PUT"
      },
    );
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      readTaskJsonFileContent = taskModelFromJson(response.body);
      //print("ALL  tasks: allTasks");

      return readTaskJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  /// Search Bar Variables
  List<TaskModel> searchData = <TaskModel>[];

  TextEditingController taskSearchBarTextEditingController = TextEditingController();


  onSearchTextChanged(String? text) async {
    searchData.clear();
    if (text!.isEmpty) {
      // Check textfield is empty or not
      setState(() {});
      return;
    }

    readTaskJsonFileContent.forEach((data) {
      if (data.taskName
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase().toString())) {
        searchData.add(data);
        // If not empty then add search data into search data list
      }
    });

    setState(() {});
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
  initState() {
    super.initState();

    /// VARIABLES USED TO SCROLL THROUGH SCREEN
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    /// User Model information Variables
    getUserInfo();

    /// Task information Variables
    readingTasksJsonData();
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
              return FutureBuilder<List<TaskModel>>(
                future: readingTasksJsonData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return Scaffold(
                        appBar: appBar(),
                        body: searchBarUI(),
                        bottomNavigationBar: buildBottomNavigationBar(),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                  }

                  return const CircularProgressIndicator();
                },
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

  appBar() {
    return AppBar(
      toolbarHeight: 140.0,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Hi ${readUserJsonFileContent.firstName},",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Today your task list",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
                readUserJsonFileContent.userPhotoFile == null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(202, 202, 202, 1),
                            borderRadius: BorderRadius.all(Radius.circular(
                                MediaQuery.of(context).size.width * 0.2)),
                          ),
                          child: Center(
                            child: Text(
                              "${readUserJsonFileContent.firstName![0]}${readUserJsonFileContent.lastName![0]}",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.1,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromRGBO(76, 75, 75, 1),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(202, 202, 202, 1),
                            borderRadius: BorderRadius.all(Radius.circular(
                                MediaQuery.of(context).size.width * 0.2)),
                          ),
                          child: CircleAvatar(
                            backgroundImage: MemoryImage(
                              base64Decode(
                                  readUserJsonFileContent.userPhotoFile!),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
            const SizedBox(
              height: 40.0,
            ),
          ],
        ),
      ),
    );
  }

  searchBarUI() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return SafeArea(
      child: FloatingSearchBar(
        axisAlignment: isPortrait ? 0.0 : -1.0,
        hint: 'Search task',
        hintStyle: TextStyle(
          color: DynamicTheme.of(context)?.brightness == Brightness.light
              ? Colors.black12
              : Colors.white12,
          fontSize: 18,
          fontStyle: FontStyle.italic,
        ),
        iconColor: primaryColour,
        openAxisAlignment: 0.0,
        width: isPortrait ? 600 : 500,
        scrollPadding: const EdgeInsets.only(top: 16, bottom: 20),
        borderRadius: BorderRadius.circular(50.0),
        elevation: 4.0,
        physics: const BouncingScrollPhysics(),
        onQueryChanged: onSearchTextChanged,
        automaticallyImplyDrawerHamburger: false,
        transitionCurve: Curves.easeInOut,
        transitionDuration: const Duration(milliseconds: 500),
        transition: CircularFloatingSearchBarTransition(),
        debounceDelay: const Duration(milliseconds: 500),
        actions: [
          FloatingSearchBarAction(
            showIfOpened: false,
            child: CircularButton(
              icon: Icon(
                Icons.mic,
                color: primaryColour,
                size: 28,
              ),
              onPressed: () {
                if (kDebugMode) {
                  print('Places Pressed');
                }
              },
            ),
          ),
          FloatingSearchBarAction.searchToClear(
            showIfClosed: false,
          ),
        ],
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Material(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: ListView.builder(
                    itemCount: searchData.length,
                    itemBuilder: (context, int index) {
                      return Column(
                        children: [
                          /*ListTile(
                            title: Text(searchData[index].projectName!),
                            subtitle: Text(searchData[index].taskName!),
                          ),*/
                          TaskCardMA(
                            taskTitle: searchData[index].taskName!,
                            taskProjectName: searchData[index].projectName!,
                            taskDueDateTime: searchData[index].deadlineDate!,
                            colour: labelColours![
                                searchData[index].criticalityColour!],
                            taskStatus: searchData[index].status == null
                                ? ""
                                : searchData[index].status!,
                            navigationMenu: NavigationMenu.dashboardScreen,
                            taskProgressPercentage:
                                searchData[index].percentageDone == null
                                    ? 0.0
                                    : searchData[index].percentageDone!,
                          )
                        ],
                      );
                    }),
              ),
            ),
          );
        },
        body: buildBody(),
      ),
    );
  }

  buildBody() {
    return DefaultTabController(
      length: 3,
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
                    height: 75.0,
                  ),
                  const Text(
                    "Projects",
                    style: TextStyle(
                      letterSpacing: 3,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  SizedBox(
                    height: 250.0,
                    child: readUserJsonFileContent.username == null
                        ? const Text("No Projects found!")
                        : ProjectListViewBuilder(
                            username: readUserJsonFileContent.username!),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Tasks",
                        style: TextStyle(
                          letterSpacing: 3,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const TaskCalendarScreenMA(),
                          ),
                        ),
                        icon: const Icon(Icons.calendar_month, size: 32),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    child: _tabBarLabel(),
                  ),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          children: <Widget>[
            TodayTaskDashboardOverviewScreen(
              username: readUserJsonFileContent.username == null
                  ? ""
                  : readUserJsonFileContent.username!,
            ),
            WeekTaskDashboardOverviewScreen(
              username: readUserJsonFileContent.username == null
                  ? ""
                  : readUserJsonFileContent.username!,
            ),
            MonthTaskDashboardOverviewScreen(
              username: readUserJsonFileContent.username == null
                  ? ""
                  : readUserJsonFileContent.username!,
            ),
          ],
        ),
      ),
    );
  }

  buildBottomNavigationBar() {
    return const CustomBottomNavBarMA(
      selectedMenu: MenuState.dashboardScreen,
    );
  }
}
