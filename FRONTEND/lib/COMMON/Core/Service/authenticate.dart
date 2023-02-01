import 'package:origami_structure/imports.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return ResponsiveWidget.isSmallScreen(context)
          ? const LoginScreenMA()
          : const LoginScreenWS();
    } else {
      return ResponsiveWidget.isSmallScreen(context)
          ? const RegistrationScreenMA()
          : const RegistrationScreenWS();
    }
  }
}
