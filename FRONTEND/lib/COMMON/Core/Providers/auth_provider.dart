import 'package:http/src/response.dart' show Response;
import 'package:origami_structure/imports.dart';

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.notLoggedIn;
  final Status _registeredInStatus = Status.notRegistered;

  Status get loggedInStatus => _loggedInStatus;

  Status get registeredInStatus => _registeredInStatus;

  Future<Map<String, dynamic>> login(String email, String password) async {
    var result;

    final Map<String, dynamic> loginData = {
      'user': {
        'email': email,
        'password': password,
      }
    };

    _loggedInStatus = Status.authenticating;
    notifyListeners();

    Response response = await post(
      Uri.parse(AppLocalPath.login),
      body: json.encode(loginData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      var userData = responseData['data'];

      UserModel authUser = UserModel.fromJson(userData);

      //TODO: UserPreferences().saveUser(authUser);

      _loggedInStatus = Status.loggedIn;
      notifyListeners();

      result = {
        'status': true,
        'message': 'Successful',
        'user': authUser,
      };
    } else {
      _loggedInStatus = Status.notLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String passwordConfirmation,
    String username,
    String firstName,
    String lastName,
    String userID,
  ) async {
    final Map<String, dynamic> registrationData = {
      'user': {
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation
      }
    };
    if (kDebugMode) {
      print(registrationData);
    }

    var response = await post(Uri.parse(AppLocalPath.register),
      body: json.encode(registrationData),
      headers: {'Content-Type': 'application/json'},
    );

    if (kDebugMode) {
      print(response.body);
      print(response.statusCode);
    }

    var result;
    final Map<String, dynamic> responseData = json.decode(response.body);

    if (kDebugMode) {
      print(response.statusCode);
    }
    if (response.statusCode == 200) {
      var userData = responseData['data'];

      UserModel authUser = UserModel.fromJson(userData);

      //TODO:  UserPreferences().saveUser(authUser);
      result = {
        'status': true,
        'message': 'Successfully registered',
        'data': authUser
      };
    } else {
//      if (response.statusCode == 401) Get.toNamed("/login");
      result = {
        'status': false,
        'message': 'Registration failed',
        'data': responseData
      };
    }

    return await result.catchError(onError);
  }

  static Future<FutureOr> onValue(Response response) async {
    var result;

    final Map<String, dynamic> responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      var userData = responseData['data'];

      UserModel authUser = UserModel.fromJson(userData);

      //TODO: UserPreferences().saveUser(authUser);
      result = {
        'status': true,
        'message': 'Successfully registered',
        'data': authUser
      };
    } else {
      result = {
        'status': false,
        'message': 'Registration failed',
        'data': responseData
      };
    }

    return result;
  }

  static onError(error) {
    if (kDebugMode) {
      print("the error is $error.detail");
    }
    return {
      'status': false,
      'message': 'Unsuccessful Request',
      'data': error,
    };
  }
}
