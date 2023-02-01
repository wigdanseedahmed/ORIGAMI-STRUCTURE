import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
      UserProfile.lastName = userInfo['data']['lastName'];
      UserProfile.userPhotoURL = userInfo['data']["userPhotoURL"];
    });
  }

  /// Task information Variables
  late List<TaskModel> readJsonFileContent = <TaskModel>[];

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
      readJsonFileContent = taskModelFromJson(response.body);
      //print("ALL  tasks: allTasks");

      return readJsonFileContent;
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

    var buildTitle = Padding(
      padding: const EdgeInsets.all(16.0),
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
                    "${UserProfile.firstName},",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Your notification list",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
              UserProfile.userPhotoURL == null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Container(
                        height: screenSize.height * 0.1,
                        width: screenSize.width * 0.23,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(202, 202, 202, 1),
                          borderRadius: BorderRadius.all(Radius.circular(screenSize.width * 0.2)),
                        ),
                        child: Center(
                          child: Text(
                            "${UserProfile.firstName![0]}${UserProfile.lastName![0]}",
                            style: TextStyle(
                              fontSize: screenSize.width * 0.1,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromRGBO(76, 75, 75, 1),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(screenSize.width * 0.2),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          height: screenSize.height * 0.1,
                          width: screenSize.width * 0.23,
                          placeholder: (context, url) => Image.asset("assets/images/user_profile.png"),
                          imageUrl: UserProfile.userPhotoURL!,
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
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 140.0,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: buildTitle,
      ),
      body: NotificationList(),
      bottomNavigationBar: const CustomBottomNavBarMA(
        selectedMenu: MenuState.navigatorScreen,
      ),
    );
  }
}

/*
FittedBox(
        child: Container(
          // height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
              color: kWhiteNotificationColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: const [
                BoxShadow(color: kLightNotificationColor, blurRadius: 2.0)
              ]),
          child: Column(
            children: const [
              Text(
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                style: kDarkNotificationTextStyle,
              ),
              SizedBox(height: 16.0),
              Image(
                image: AssetImage("assets/images/user_profile.png"),
              ),
              SizedBox(height: 16.0),
              Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.",
                style: TextStyle(color: kLightNotificationColor),
              ),
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '11/Feb/2021 04:42 PM',
                  style: TextStyle(color: kLightNotificationColor),
                ),
              )
            ],
          ),
        ),
      )
 */
