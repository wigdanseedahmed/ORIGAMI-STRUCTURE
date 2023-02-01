import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class EditProjectProfileAvatarWidgetMA extends StatefulWidget {
  final String? imagePath;
  final String? projectName;
  final VoidCallback onClicked;

  const EditProjectProfileAvatarWidgetMA({
    Key? key,
    this.imagePath,
    required this.onClicked,
    this.projectName,
  }) : super(key: key);

  @override
  State<EditProjectProfileAvatarWidgetMA> createState() =>
      _EditProjectProfileAvatarWidgetMAState();
}

class _EditProjectProfileAvatarWidgetMAState
    extends State<EditProjectProfileAvatarWidgetMA> {
  final bool circular = false;

  final ImagePicker _picker = ImagePicker();

  final networkHandler = NetworkHandler();

  late PickedFile? imageFile;
  late File _image;

  /// VARIABLES FOR PROJECT
  ProjectModel readJsonFileContent = ProjectModel();

  Future<ProjectModel> readProjectData() async {
    /// String to URI, using the same url used in the nodejs code
    var uri =
        Uri.parse("${AppUrl.getProjectByProjectName}${widget.projectName}");

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
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      readJsonFileContent = projectModelFromJson(response.body)[0];
      //print("Project Info : ${readJsonFileContent}");

      return readJsonFileContent;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    //readJsonFileContent.projectPhotoUrl == null ? _image.path = null: _image.path = readJsonFileContent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var color = primaryColour;
    //fetch();
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1.0),
      child: FutureBuilder<ProjectModel>(
        future: readProjectData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Center(
                child: Stack(
                  children: [
                    buildImage(context),
                    Positioned(
                      bottom: -4,
                      right: 2,
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

  Widget buildImage(context) {
    return readJsonFileContent.projectPhotoName == null
        ? Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                height: 250.0,
                width: MediaQuery.of(context).size.width - 40.0,
                color: const Color.fromRGBO(202, 202, 202, 1),
                child: Center(
                  child: Text(
                    widget.projectName!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 8,
                      fontFamily: 'Electrolize',
                      fontSize:  MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromRGBO(76, 75, 75, 1),
                    ),
                  ),
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.memory(
                base64Decode(readJsonFileContent.projectPhotoFile!),
                //File(readJsonFileContent.projectPhotoUrl!),
                //"${AppUrl.baseURL}/${readJsonFileContent.projectPhotoName!}",
                height: 250.0,
                width: MediaQuery.of(context).size.width - 40.0,
                fit: BoxFit.cover,
              ),
            ),
          );
  }

  Widget buildEditIcon(context, Color color) => buildCircle(
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.grey.shade800,
        all: 6,
        child: buildCircle(
          color: color,
          all: 14,
          child: const Icon(
            Icons.add_a_photo,
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
        //readJsonFileContent.projectPhotoUrl = _image.path;
        _upload(_image);
        print('Image selected: ${_image}');
      } else {
        print('No image selected.');
      }
    });
  }

  void _upload(File imageFile) {
    if (imageFile == null) return;
    String base64Image = base64Encode(imageFile.readAsBytesSync());
    String fileName = imageFile.path.split("/").last;

    /// string to uri
    var uri =
        Uri.parse("${AppUrl.addAndUpdateProjectImage}/${widget.projectName}");

    http.post(uri, body: {
      "projectPhotoFile": base64Image,
      "projectPhotoName": fileName,
    }).then((res) {
      print(res.statusCode);
    }).catchError((err) {
      print(err);
    });
  }
}
