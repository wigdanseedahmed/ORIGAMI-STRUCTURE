import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class TaskCardListProfileImage extends StatefulWidget {
  const TaskCardListProfileImage({
    required this.assignedTo,
    this.onPressed,
    this.maxImages = 3,
    Key? key,
  }) : super(key: key);

  final List<String>? assignedTo;

  final Function()? onPressed;
  final int maxImages;

  @override
  State<TaskCardListProfileImage> createState() => _TaskCardListProfileImageState();
}

class _TaskCardListProfileImageState extends State<TaskCardListProfileImage> {

  /// VARIABLES FOR USERS
  List<UserModel>? _allUserData = <UserModel>[];

  List<String>? _allUserImages = <String>[];

  Future<List<UserModel>?> readAllUsersJsonData() async {
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
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    _allUserImages = <String>[];

    if (response.statusCode == 200) {
      _allUserData = userModelListFromJson(response.body).where((element) => widget.assignedTo!.contains(element.username)).toList();
      // print("User Model Info : ${readJsonFileContent}");

      for(int i = 0; i< _allUserData!.length; i++){
        _allUserImages!.add(_allUserData![i].userPhotoFile!);
      }

      // print("User Model Name : ${_allUserFullNameList}");

      return _allUserData;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  @override
  void initState() {
    /// VARIABLES USED TO SCROLL THROUGH SCREEN
    readAllUsersJsonData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(1.0),
      child: FutureBuilder(
        future: readAllUsersJsonData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Align(
                alignment: Alignment.centerRight,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 200, maxHeight: 50),
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: _getLimitImage(_allUserImages!, widget.maxImages)
                        .asMap()
                        .entries
                        .map(
                          (e) => Padding(
                        padding: EdgeInsets.only(right: (e.key * 25.0)),
                        child: _image(
                          e.value,
                          context
                        ),
                      ),
                    )
                        .toList(),
                  ),
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

  List<String> _getLimitImage(List<String> assignedTo, int limit) {
    if (assignedTo.length <= limit) {
      return assignedTo;
    } else {
      List<String> result = [];
      for (int i = 0; i < limit; i++) {
        result.add(assignedTo[i]);
      }
      return result;
    }
  }

  Widget _image(String image, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).cardColor,
      ),
      child: CircleAvatar(
        backgroundImage: MemoryImage(base64Decode(image)),
        radius: 15,
      ),
    );
  }
}