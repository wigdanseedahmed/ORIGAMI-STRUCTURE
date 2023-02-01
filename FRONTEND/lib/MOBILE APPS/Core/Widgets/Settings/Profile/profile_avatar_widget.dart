import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as Io;

class ProfileAvatarWidget extends StatefulWidget {
  final String? email;
  final bool isEdit;
  final VoidCallback? onClicked;

  const ProfileAvatarWidget({
    Key? key,
    this.isEdit = false,
     this.onClicked,
    this.email,
  }) : super(key: key);

  @override
  State<ProfileAvatarWidget> createState() => _ProfileAvatarWidgetState();
}

class _ProfileAvatarWidgetState extends State<ProfileAvatarWidget> {
  final bool circular = false;

  final ImagePicker _picker = ImagePicker();

  late PickedFile? imageFile;
  late File _image;

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
      UserProfile.username = userInfo['data']['username'];
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
          .where((element) => element.email == widget.email)
          .toList()[0];
      //print("User Model Info : ${readUserJsonFileContent.firstName}");

      return readUserJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  Future<UserModel> updateUserJsonData(UserModel selectedTaskInformation) async {
    /// String to URI, using the same url used in the nodejs code
    var uri =
    Uri.parse("${AppUrl.updateUserInformationByEmail}${UserProfile.email}");

    // print(selectedTaskInformation);

    /// Create Request to get data and response to read data
    final response = await http.put(
      uri,
      headers: {
        "Access-Control-Allow-Origin": "*",
        // Required for CORS support to work
        "Access-Control-Allow-Headers":
        "Content-Type, Access-Control-Allow-Origin, Accept",
        'Content-Type': 'application/json; charset=UTF-8',
        "Access-Control-Allow-Methods": "POST, DELETE, GET, PUT"
      },
      body: json.encode(selectedTaskInformation.toJson()),
    );
    //print(response.body);

    if (response.statusCode == 200) {
      readUserJsonFileContent = userModelFromJson(response.body);
      //print(readJsonFileContent);
      return readUserJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  @override
  void initState() {
    /// User Model information Variables
    futureUserInformation = readingUserJsonData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var color = primaryColour;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1.0),
      child: FutureBuilder<UserModel>(
        future: futureUserInformation,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Center(
                child: Stack(
                  children: [
                    readUserJsonFileContent.userPhotoFile == null ? buildInitial() : buildImage(),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: InkWell(
                        child: buildEditIcon(context, color),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: ((builder) => bottomSheet(context)),
                          );
                        },
                      ),
                    ),
                  ],
                ),
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

  Widget buildInitial() {
    return ClipOval(
      child: Material(
        color: Colors.grey,
        child: SizedBox(
          width: 200,
          height: 200,
          child: Center(
            child: Text(
              "${readUserJsonFileContent.firstName![0]}${readUserJsonFileContent.lastName![0]}",
              style: TextStyle(
                fontSize:  MediaQuery.of(context).size.width * 0.1,
                fontWeight: FontWeight.bold,
                color: const Color.fromRGBO(76, 75, 75, 1),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImage() {
    final image = MemoryImage(base64Decode(readUserJsonFileContent.userPhotoFile!));

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 200,
          height: 200,
          child: InkWell(onTap: widget.onClicked),
        ),
      ),
    );
  }

  Widget buildEditIcon(context, Color color) => buildCircle(
    color: widget.isEdit ? DynamicTheme.of(context)?.brightness == Brightness.light
        ? Colors.white : Colors.grey.shade800 : Colors.transparent,
    all: 3,
    child: buildCircle(
      color: widget.isEdit ? color : Colors.transparent,
      all: 8,
      child: Icon(
        widget.isEdit ? Icons.add_a_photo : null,
        color: Colors.white,
        size: 20,
      ),
    ),
  );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

  Widget bottomSheet(context) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
              color: primaryColour,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.camera, color: primaryColour),
              onPressed: () async {
                await takeOrGetPhoto(ImageSource.camera);
                Navigator.pop(context);
                /*takeOrGetPhoto(source: ImageSource.camera,  picker: _picker,
                  image: _image,
                  uriString:"${AppUrl.addAndUpdateProjectImage}/${widget.projectName}",
                );*/
              },
              label: Text("Camera", style: TextStyle(color: primaryColour)),
            ),
            TextButton.icon(
              icon: Icon(Icons.image, color: primaryColour),
              onPressed: () async {
                await takeOrGetPhoto(ImageSource.gallery);
                Navigator.pop(context);
              },
              label: Text("Gallery", style: TextStyle(color: primaryColour)),
            ),
          ])
        ],
      ),
    );
  }

  Future<void> takeOrGetPhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        //imageFile = pickedFile;
        _image = File(pickedFile.path);
        readUserJsonFileContent.userPhotoFile = base64Encode(_image.readAsBytesSync()); //base64Encode(_image.readAsBytesSync())
        readUserJsonFileContent.userPhotoName = _image.path.split("/").last;
        _upload(_image);

        // print('Image name selected: ${_image.path.split("/").last}');
      } else {
        // print('No image selected.');
      }
    });
  }

  void _upload(File imageFile) {
    if (imageFile == null) return;
    String base64Image = base64Encode(imageFile.readAsBytesSync());
    String fileName = imageFile.path.split("/").last;

    /// string to uri
    var uri = Uri.parse("${AppUrl.addAndUpdateProfileImage}${UserProfile.email}");

    http.post(uri, body: {
      "userPhotoFile": base64Image,
      "userPhotoName": fileName,
    }).then((res) {
      // print(res.statusCode);
      // print(res.body);
    }).catchError((err) {
      // print(err);
    });


  }
}