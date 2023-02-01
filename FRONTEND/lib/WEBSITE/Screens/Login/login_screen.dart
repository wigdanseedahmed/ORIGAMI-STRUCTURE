import 'package:origami_structure/imports.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:modal_progress_hud/modal_progress_hud.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flushbar/flushbar.dart';

class LoginScreenWS extends StatefulWidget {
  static const String id = 'login_screen';

  const LoginScreenWS({Key? key}) : super(key: key);

  @override
  State<LoginScreenWS> createState() => _LoginScreenWSState();
}

class _LoginScreenWSState extends State<LoginScreenWS>
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

    Container logInButton = Container(
      width: MediaQuery.of(context).size.width / 4,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: logInAndRegistrationButtonColour,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: kViolet.withOpacity(0.1),
            spreadRadius: 10,
            blurRadius: 20,
          ),
        ],
      ),
      child: ElevatedButton(
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

          try {
            if (response.statusCode == 200 || response.statusCode == 201) {
              Map<String, dynamic> output = json.decode(response.body);
              //var data = UserModel.fromJson(output);
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

              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('email', emailController.text);
              prefs.setString('password', passwordController.text);
              prefs.setBool("isLoggedIn", true);

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreenWS(),
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
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,//Colors.deepPurple,
          onPrimary: Colors.transparent,//Colors.white,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const SizedBox(
          width: double.infinity,
          height: 50,
          child: Center(
            child: Text("Sign In", style: TextStyle(color: Colors.white),),
          ),
        ),
      ),
    );

    Row logInWithSocialMedia = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        loginWithSocialMediaButton(
            context: context, image: 'images/google.png'),
        loginWithSocialMediaButton(
            context: context, image: 'images/github.png'),
        loginWithSocialMediaButton(
            context: context, image: 'images/facebook.png'),
      ],
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
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 8),
                child: Column(
                  // padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 8),
                  children: [
                    const TopBarMenuWS(
                      isLoginOrRegistration: 'Login',
                      isSelectedPage: '',
                    ),
                    // MediaQuery.of(context).size.width >= 980
                    //     ? Menu()
                    //     : SizedBox(), // Responsive
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sign In \nto continue',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width / 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 30),
                              const Text(
                                "If you don't have an account",
                                style: TextStyle(
                                    // fontSize: MediaQuery.of(context).size.width / 90,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Text(
                                    "You can",
                                    style: TextStyle(
                                        // fontSize: MediaQuery.of(context).size.width / 90,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          180),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return const RegistrationScreenWS();
                                          },
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "register here!",
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                90,
                                        color: kViolet,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Image.asset(
                                'images/illustration-2.png',
                                width: 300,
                                height: 200,
                              ),
                            ],
                          ),
                        ),
                        ResponsiveWidget.isLargeScreen(context) //Responsive
                            ? Image.asset(
                                'images/illustration-1.png',
                                width: MediaQuery.of(context).size.width / 4.5,
                              )
                            : const SizedBox(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height / 6),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 4,
                            child: buildLogInBody(
                              logInButton,
                              logInWithSocialMedia,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildLogInBody(Container logInButton, Row logInWithSocialMedia) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            validator: (value) => EmailValidator.validate(value!)
                ? null
                : "Please enter a valid email",
            onChanged: (value) => email = value,
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'Enter email or Phone number',
              filled: true,
              fillColor: Colors.blueGrey[50],
              labelStyle: const TextStyle(fontSize: 12),
              contentPadding: const EdgeInsets.only(left: 30),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey.shade50),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey.shade50),
                borderRadius: BorderRadius.circular(15),
              ),
              errorBorder:  OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey.shade50),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedErrorBorder:  OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey.shade50),
                borderRadius: BorderRadius.circular(15),
              ),
              border:  OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey.shade50),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: MediaQuery.of(context).size.width / 4,
          child: TextFormField(
            obscureText: _showPassword,
            validator: (value) => PasswordValidator.validate(value!),
            onChanged: (value) => password = value,
            controller: passwordController,
            decoration: InputDecoration(
              hintText: 'Password',
              counterText: 'Forgot password?',
              suffixIcon: GestureDetector(
                onTap: _togglePasswordVisibility,
                child: _showPassword
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off),
              ),
              filled: true,
              fillColor: Colors.blueGrey[50],
              labelStyle: const TextStyle(fontSize: 12),
              contentPadding: const EdgeInsets.only(left: 30),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey.shade50),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey.shade50),
                borderRadius: BorderRadius.circular(15),
              ),
              errorBorder:  OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey.shade50),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedErrorBorder:  OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey.shade50),
                borderRadius: BorderRadius.circular(15),
              ),
              border:  OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueGrey.shade50),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
        logInButton,
        const SizedBox(height: 40),
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.grey[300],
                height: 50,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text("Or continue with"),
            ),
            Expanded(
              child: Divider(
                color: Colors.grey[400],
                height: 50,
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        logInWithSocialMedia,
      ],
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
