import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class AddNewProjectDetailScreenMA extends StatefulWidget {
  static const String id = 'project_board_edit_detail_screen';

  final ProjectModel? selectedProject;
  final NavigationMenu navigationMenu;

  const AddNewProjectDetailScreenMA({
    Key? key,
    this.selectedProject, required this.navigationMenu,
  }) : super(key: key);

  @override
  _AddNewProjectDetailScreenMAState createState() =>
      _AddNewProjectDetailScreenMAState();
}

class _AddNewProjectDetailScreenMAState
    extends State<AddNewProjectDetailScreenMA>
    with TickerProviderStateMixin {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// VARIABLES FOR PROJECT
  ProjectModel readJsonFileContent = ProjectModel();
  Future<ProjectModel>? _futureProjectInformation;

  bool showSpinner = false;

  late String errorText = "Error Text";
  late String msg = "";

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
      UserProfile.personalEmail = userInfo['data']["personalEmail"];
      UserProfile.username = userInfo['data']['username'];
      UserProfile.firstName = userInfo['data']['firstName'];
      UserProfile.lastName = userInfo['data']['lastName'];
      UserProfile.phoneNumber = userInfo['data']["phoneNumber"];
      UserProfile.userPhotoURL = userInfo['data']["userPhotoURL"];
      UserProfile.jobContractType = userInfo['data']["contractType"];
      UserProfile.hardSkills = userInfo['data']["skills"];
    });
  }

  /// Variables used to store registration parameters
  final storage = const FlutterSecureStorage();

  checkProject() async {
    if (readJsonFileContent.projectName == null || readJsonFileContent.projectName!.isEmpty) {
      setState(() {
        // circular = false;
        errorText = "Project name can't be empty";
      });
    } else {
      var response = await networkHandler.get(
          "${AppUrl.checkProjectExistsByProjectName}${readJsonFileContent.projectName!}");
      if (response['Status'] == true) {
        setState(() {
          // circular = false;
          errorText = "Project name already taken";
          toast(errorText);
        });
      } else {
        setState(() {
          errorText = "Project name available";
          // circular = false;
        });
      }
    }
  }

  Future<ProjectModel> createProjectToJsonData(
      ProjectModel selectedProjectInformation) async {
    String? token = await storage.read(key: "token");

    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(AppUrl.createProject);
    //print(selectedProjectInformation);

    /// Create Request to get data and response to read data
    final response = await http.post(
      uri,
      headers: {
        "Content-type": "application/json",
        "Authorization": "Bearer $token",
        //"Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        // Required for CORS support to work
        //"Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Content-Type, Access-Control-Allow-Origin, Accept",
        "Access-Control-Allow-Methods": "POST, DELETE, GET, PUT, PATCH"
      },
      body: json.encode(selectedProjectInformation.toJson()),
    );
    //print(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      readJsonFileContent = projectFromJson(response.body);
      //print(readJsonFileContent);
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
  late String? selectedMenuItem = "General Information";

  @override
  void initState() {
    /// VARIABLES USED TO SCROLL THROUGH SCREEN
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition < screenSize.height * 0.40
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;


    return AlertDialog(
      title: const Text('Create New Project'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "NAME",
                style: TextStyle(
                  //letterSpacing: 8,
                  fontFamily: 'Electrolize',
                  fontSize: screenSize.width * 0.045,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                width: screenSize.width * 0.43,
                child: TextFormField(
                  minLines: 1,
                  maxLines: 250,
                  autofocus: false,
                  //validator: errorText,
                  cursorColor:
                      DynamicTheme.of(context)?.brightness == Brightness.light
                          ? Colors.grey[100]
                          : Colors.grey[600],
                  initialValue: readJsonFileContent.projectName == null
                      ? ""
                      : readJsonFileContent.projectName!,
                  style: subTitleTextStyleMA,
                  decoration: InputDecoration(
                    //hintText: "Description",
                    //hintStyle: subTitleTextStyle,
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: primaryColour,
                        width: 0,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: primaryColour,
                        width: 0,
                      ),
                    ),
                  ),
                  onChanged: (newName) {
                    readJsonFileContent.projectName = newName;
                  },
                  onFieldSubmitted: (newName) {
                    readJsonFileContent.projectName = newName;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "STATUS     ",
                style: TextStyle(
                  //letterSpacing: 8,
                  fontFamily: 'Electrolize',
                  fontSize: screenSize.width * 0.045,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                width: screenSize.width * 0.43,
                height: screenSize.height * 0.075,
                child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter dropDownState) {
                  return DropdownSearch<String>(
                    popupElevation: 0.0,
                    dropdownSearchDecoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: primaryColour,
                          width: 0.5,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: primaryColour,
                          width: 0.5,
                        ),
                      ),
                      labelStyle: subTitleTextStyleMA,
                    ),
                    //mode of dropdown
                    mode: Mode.MENU,
                    //to show search box
                    showSearchBox: true,
                    //list of dropdown items
                    items: projectStatusLabel,
                    onChanged: (String? newValue) {
                      dropDownState(() {
                        readJsonFileContent.status = newValue;
                      });
                    },
                    //show selected item
                    selectedItem: readJsonFileContent.status == null
                        ? "Status"
                        : readJsonFileContent.status!,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Create'),
          onPressed: () async {
            if (readJsonFileContent.projectName!.isNotEmpty ||
                readJsonFileContent.projectName != null) {
              await checkProject();

              if (errorText == "Project name available"){
                var newMember = MembersModel()
                  ..memberName =
                      "${UserProfile.firstName} ${UserProfile.lastName}"
                  ..memberUsername = UserProfile.username
                  ..jobTitle = UserProfile.jobTitle
                  ..workEmail = UserProfile.email
                  ..personalEmail = UserProfile.personalEmail
                  ..contractType = UserProfile.jobContractType
                  ..phoneNumber = UserProfile.phoneNumber
                  ..skills = UserProfile.hardSkills
                  ..projectJobPosition = "Project Leader";

                var newProject = ProjectModel()
                  ..projectName = readJsonFileContent.projectName
                  //..id =
                  ..dateCreate = DateTime.now().toIso8601String()
                  ..status = readJsonFileContent.status
                  ..tasksStatusList = ["Todo", "On Hold", "In Progress", "Done"]
                  ..projectLeader = UserProfile.username
                  ..members = [newMember]
                  ..progressPercentage = 0.0
                  ..criticalityColour = 3;

                // Hive.box<ProjectModel>('todos').add(todo);
                await createProjectToJsonData(newProject);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProjectDetailScreenMA(
                          selectedProject: readJsonFileContent, navigationMenu: widget.navigationMenu,),
                    ),
                    (route) => false);
              }
              else if (errorText == "Project name already taken"){

                toast(errorText);
              }
            }
            //Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
