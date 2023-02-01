import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

// ignore: import_of_legacy_library_into_null_safe
import 'package:logger/logger.dart';

class NetworkHandler  with ChangeNotifier {
  var log = Logger();
  FlutterSecureStorage storage = const FlutterSecureStorage();

  Future get(String url) async {
    String? token = await storage.read(key: "token");


    var response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        //"Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        // Required for CORS support to work
        //"Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Content-Type, Access-Control-Allow-Origin, Accept",
        "Access-Control-Allow-Methods": "POST, DELETE, GET, PUT, PATCH"
      },

    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      // log.i(response.body);

      //UserModel authUser = UserModel.fromJson(json.decode(response.body));
      //UserPreferences().saveUser(authUser);

      return json.decode(response.body);
    }
    // log.i(response.body);
    // log.i(response.statusCode);
  }

  Future<http.Response> post(String url, Map<String, String> body) async {
    String? token = await storage.read(key: "token");

    // log.d(body);
    var response = await http.post(
      Uri.parse(url),
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
      body: json.encode(body),
    );
    return response;
  }

  Future<http.Response> patch(String url, Map<String, String> body) async {
    String? token = await storage.read(key: "token");

    log.d(body);
    var response = await http.patch(
      Uri.parse(url),
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
      body: json.encode(body),
    );
    return response;
  }

  Future<http.Response> post1(String url, var body) async {
    String? token = await storage.read(key: "token");


    log.d(body);
    var response = await http.post(
      Uri.parse(url),
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
      body: json.encode(body),
    );
    return response;
  }

  Future<http.StreamedResponse> patchImage(String url, String filepath) async {

    String? token = await storage.read(key: "token");
    var request = http.MultipartRequest('PATCH', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath("img", filepath));
    request.headers.addAll({
      "Content-type": "multipart/form-data",
      "Authorization": "Bearer $token",
      //"Accept": "application/json",
      "Access-Control-Allow-Origin": "*",
      // Required for CORS support to work
      //"Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
      "Access-Control-Allow-Headers":
          "Content-Type, Access-Control-Allow-Origin, Accept",
      "Access-Control-Allow-Methods": "POST, DELETE, GET, PUT, PATCH"
    });
    var response = request.send();
    return response;
  }

  String formater(String url) {
    return AppUrl.baseURL + url;
  }

  NetworkImage getImage(String imageName) {
    String url = formater("/uploads//$imageName.jpg");
    return NetworkImage(url);
  }
}

class HelperFunctions {
  static String sharedPreferenceUserKey = "ISLOGGEDIN";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAILKEY";

  static Future<bool> saveUserLoggedInPreference(bool userLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedPreferenceUserKey, userLoggedIn);
  }

  static Future<bool> saveUserNamePreference(String userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> saveUserEmailPreference(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  static Future<bool?> getUserLoggedInPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(sharedPreferenceUserKey);
  }

  static Future<String?> getUserNamePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserNameKey);
  }

  static Future<String?> getUserEmailPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserEmailKey);
  }

  static Future<bool> removeUserLogoutSharedPreference(String userEmail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.remove(userEmail);
  }
}
