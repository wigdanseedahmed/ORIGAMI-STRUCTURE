import 'package:origami_structure/imports.dart';

class UserProvider with ChangeNotifier {
  UserModel _user = UserModel();

  UserModel get user => _user;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }
}
