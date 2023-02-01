import 'package:origami_structure/imports.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:modal_progress_hud/modal_progress_hud.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flushbar/flushbar.dart';

class LoginScreenMA extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreenMA({Key? key}) : super(key: key);

  @override
  State<LoginScreenMA> createState() => _LoginScreenMAState();
}

class _LoginScreenMAState extends State<LoginScreenMA>
    with TickerProviderStateMixin {
  ///VARIABLES USED TO DETERMINE SCREEN SIZE
  late ScrollController _scrollController;
  double _scrollPosition = 0;
  double _opacity = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    /// VARIABLES USED TO SCROLL THROUGH SCREEN
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  /// Variable used to get RESTful-API
  NetworkHandler networkHandler = NetworkHandler();

  late String uid;
  late String email;
  late String password;

  bool _showPassword = true;
  bool showSpinner = false;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /// Variables used to store login parameters
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition < screenSize.height * 0.40
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;

    SizedBox logInButton = SizedBox(
      height: 50,
      width: double.infinity,
      // ignore: deprecated_member_use
      child: TextButton(
        onPressed: () async {
          setState(() {
            showSpinner = true;
          });

          //Login Logic start here
          Map<String, String> data = {
            //"username": usernameController.text,
            "email": emailController.text,
            "password": passwordController.text,
          };

          var response = await networkHandler.post(AppUrl.login, data);

          var userInfo = await networkHandler.get(
              "${AppUrl.getUserUsingEmail}${emailController.text.toLowerCase()}");

          // print(userInfo);

          try {
            if (response.statusCode == 200 || response.statusCode == 201) {
              Map<String, dynamic> output = json.decode(response.body);
              var data = UserModel.fromJson(output);
              //print(output["token"]);

              await storage.write(key: "token", value: output["token"]);
              setState(() {
                showSpinner = false;
              });

              /// Store and save string data Using SharedPreference
              CheckSharedPreferences.saveUserLoggedInSharedPreference(true);
              CheckSharedPreferences.saveNameSharedPreference(
                  userInfo['data']['username']);
              CheckSharedPreferences.saveUserEmailSharedPreference(
                  emailController.text);

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreenMA(),
                  ),
                  (route) => false);
            } else {
              // String output = json.decode(response.body);
              setState(() {
                showSpinner = false;
                toast('Incorrect email or password');
              });
            }
          } on SocketException {
            setState(() {
              showSpinner = false;
              toast('Connection Problems');
            });
            response.printError();
            toast(response.body);
          } on Exception {
            setState(() {
              showSpinner = false;
              toast('Error Occurred');
            });
            response.printError();
            toast(response.body);
          }

          // login logic End here
        },
        style: TextButton.styleFrom(padding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),),
        child: const SignInSignUpInk(
          text: "Login",
        ),
      ),
    );

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Sign In\nto continue',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width / 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Image.asset(
                              'assets/images/illustration-1.png',
                              width: MediaQuery.of(context).size.width / 4.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                  SizedBox(
                    height: screenSize.height * 0.075,
                  ),
                  Column(
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => EmailValidator.validate(value!)
                            ? null
                            : "Please enter a valid email",
                        onChanged: (value) => email = value,
                        controller: emailController,
                        decoration: kTextFieldDecorationLogIn.copyWith(
                          hintText: 'Email',
                          labelText: "Email",
                        ),
                      ),
                      SizedBox(
                        height: screenSize.height * 0.025,
                      ),
                      TextFormField(
                        obscureText: _showPassword,
                        validator: (value) =>
                            PasswordValidator.validate(value!),
                        onChanged: (value) => password = value,
                        controller: passwordController,
                        decoration: kTextFieldDecorationLogIn.copyWith(
                          hintText: "Password",
                          labelText: "Password",
                          suffixIcon: GestureDetector(
                            onTap: _togglePasswordVisibility,
                            child: _showPassword
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenSize.height * 0.035,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreenMA(),
                              ),
                            );
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenSize.height * 0.05,
                      ),
                      logInButton,
                      SizedBox(
                        height: screenSize.height * 0.035,
                      ),
                    ],
                  ),
                  const Center(
                    child: Text(
                      "If you don't have an account,",
                      style: TextStyle(
                          // fontSize: MediaQuery.of(context).size.width / 90,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "you can ",
                          style: TextStyle(

                              // fontSize: MediaQuery.of(context).size.width / 90,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return const RegistrationScreenMA();
                                },
                              ),
                            );
                          },
                          child: const Text(
                            "register here!",
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/illustration-2.png',
                      width: 300,
                      height: 200,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _togglePasswordVisibility() {
    setState(
      () {
        _showPassword = !_showPassword;
      },
    );
  }
}
