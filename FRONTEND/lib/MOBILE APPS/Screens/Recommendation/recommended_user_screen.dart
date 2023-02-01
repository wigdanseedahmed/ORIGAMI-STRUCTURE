import 'package:flutter/cupertino.dart';
import 'package:origami_structure/imports.dart';
import 'package:line_icons/line_icons.dart' as lineIcons;

import 'package:http/http.dart' as http;

class RecommendedUserScreenMA extends StatefulWidget {

  final ProjectModel? selectedProject;
  final SkillsRequiredPerMemberModel selectedSkill;
  final UserModel selectedRecommendedUserInformation;
  final RecommendedUserModel selectedRecommendedUserResultDetails;
  final List<RecommendedUserModel> allRecommendedUsers;
  final NavigationMenu navigationMenu;

  const RecommendedUserScreenMA({
    Key? key,
    required this.selectedProject,
    required this.selectedSkill,
    required this.selectedRecommendedUserInformation,
    required this.selectedRecommendedUserResultDetails,
    required this.allRecommendedUsers, required this.navigationMenu,
  }) : super(key: key);

  @override
  _RecommendedUserScreenMAState createState() =>
      _RecommendedUserScreenMAState();
}

class _RecommendedUserScreenMAState extends State<RecommendedUserScreenMA>
    with TickerProviderStateMixin {
  /// Variable used to get RESTful-API
  NetworkHandler networkHandler = NetworkHandler();

  UserModel readUserJsonFileContent = UserModel();

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
          .where((element) =>
              element.username ==
              widget.selectedRecommendedUserResultDetails.username)
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

    tabBarController = TabController(vsync: this, length: 3);

    super.initState();
  }

  @override
  void dispose() {
    tabBarController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _opacity = _scrollPosition < MediaQuery.of(context).size.height * 0.40
        ? _scrollPosition / (MediaQuery.of(context).size.height * 0.40)
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
                appBar: appBar(),
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

  appBar() {
    return AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return AllRecommendedUsersScreen(
                    allRecommendedUsers: widget.allRecommendedUsers,
                    selectedSkill: widget.selectedSkill,
                      selectedProject: widget.selectedProject, navigationMenu: widget.navigationMenu,
                  );
                },
              ),
            );
          },
          child: Icon(
            Icons.clear,
            size: 24,
            color: primaryColour,
          ),
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
                children: [
                  readUserJsonFileContent.userPhotoFile == null
                      ? ClipOval(
                    child: Material(
                      color: Colors.grey,
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: Center(
                          child: Text(
                            "${readUserJsonFileContent.firstName![0]}${readUserJsonFileContent.lastName![0]}",
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * 0.1,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromRGBO(76, 75, 75, 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                      : ClipOval(
                    child: Material(
                      color: Colors.transparent,
                      child: Ink.image(
                        image: MemoryImage(
                            base64Decode(readUserJsonFileContent.userPhotoFile!)),
                        fit: BoxFit.cover,
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  buildName(),
                  const SizedBox(height: 24),
                  TabBar(
                    controller: tabBarController,
                    indicatorColor: primaryColour,
                    labelColor: DynamicTheme.of(context)?.brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                    labelStyle: const TextStyle(fontSize: 14),
                    unselectedLabelColor:
                    DynamicTheme.of(context)?.brightness == Brightness.light
                        ? Colors.black12
                        : Colors.white12,
                    unselectedLabelStyle: const TextStyle(fontSize: 14),
                    tabs: const [
                      Tab(
                        icon: Icon(lineIcons.LineIcons.userCircle),
                      ),
                      Tab(
                        icon: Icon(lineIcons.LineIcons.lightbulb),
                      ),
                      Tab(
                        icon: Icon(lineIcons.LineIcons.history),
                      ),
                    ],
                    onTap: (index) {
                      var content = "";
                      switch (index) {
                        case 0:
                          content = "Profile";
                          break;
                        case 1:
                          content = "Skills";
                          break;
                        case 2:
                          content = "History";
                          break;
                        default:
                          content = "Others";
                          break;
                      }
                      if (kDebugMode) {
                        print("You are clicking the $content");
                      }
                    },
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: tabBarController,
          children: <Widget>[
            RecommendedUserProfileScreenMA(
              selectedRecommendedUserResultDetails:
              widget.selectedRecommendedUserResultDetails,
              selectedRecommendedUserInformation:
              readUserJsonFileContent,
              allRecommendedUsers: widget.allRecommendedUsers,
            ),
            RecommendedUserSkillsScreenMA(
              selectedRecommendedUserResultDetails:
                  widget.selectedRecommendedUserResultDetails,
              selectedRecommendedUserInformation: readUserJsonFileContent,
              allRecommendedUsers: widget.allRecommendedUsers,
            ),
            RecommendedUserHistoryScreenMA(
              selectedRecommendedUserResultDetails:
                  widget.selectedRecommendedUserResultDetails,
              selectedRecommendedUserInformation: readUserJsonFileContent,
              allRecommendedUsers: widget.allRecommendedUsers,
            ),
          ],
        ),
      ),
    );
  }

  TabController? tabBarController;

  buildName() => Column(
        children: [
          Text(
            "${readUserJsonFileContent.firstName} ${readUserJsonFileContent.lastName}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            readUserJsonFileContent.jobTitle!,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 4),
        ],
      );
}
