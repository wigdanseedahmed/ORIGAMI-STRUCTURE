import 'package:origami_structure/imports.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ForgotPasswordScreenMA extends StatefulWidget {
  const ForgotPasswordScreenMA({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenMAState createState() => _ForgotPasswordScreenMAState();
}

class _ForgotPasswordScreenMAState extends State<ForgotPasswordScreenMA> {
  final _globalkey = GlobalKey<FormState>();

  /// Variable used to get RESTful-API
  NetworkHandler networkHandler = NetworkHandler();

  bool _showPassword = true;
  bool _showConfirmPassword = true;
  bool showSpinner = false;

  /// Variables used to store password parameters
  final storage = const FlutterSecureStorage();

  /// Variables used to control password parameters
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmedPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizedBox updatePasswordButton = SizedBox(
      height: 50,
      width: double.infinity,
      // ignore: deprecated_member_use
      child: TextButton(
        onPressed: () async {
          Map<String, String> data = {"password": passwordController.text};
          if (kDebugMode) {
            print(
                "${AppUrl.forgotPasswordUpdateWithEmail}${emailController.text}");
          }
          var response = await networkHandler.patch(
              "${AppUrl.forgotPasswordUpdateWithEmail}${emailController.text}",
              data); //"/users/update/${_usernameController.text}"

          if (response.statusCode == 200 || response.statusCode == 201) {
            if (kDebugMode) {
              print(
                  "${AppUrl.forgotPasswordUpdateWithEmail}${emailController.text}");
            }
            SharedPreferences prefs = await SharedPreferences.getInstance();

            //Save string data
            prefs.setString('email', emailController.text);
            prefs.setString('password', passwordController.text);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreenMA()),
                //TODO: WelcomePage()
                (route) => false);
          }

          // login logic End here
        },
        style: TextButton.styleFrom(padding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),),
        child: const SignInSignUpInk(
          text: "Update Password",
        ),
      ),
    );

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        /*appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.deepPurple,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),*/
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              // height: MediaQuery.of(context).size.height,
              // width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Form(
                key: _globalkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Change your password\nto continue',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width / 18,
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
                    const SizedBox(height: 16),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => EmailValidator.validate(value!)
                          ? null
                          : "Please enter a valid email",
                      //controller: emailController,
                      decoration: kTextFieldDecorationLogIn.copyWith(
                        hintText: 'Email', //TODO: Save email to database
                        labelText: "Email",
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      obscureText: _showPassword,
                      validator: (value) => PasswordValidator.validate(value!),
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
                    const SizedBox(height: 16),
                    TextFormField(
                      obscureText: _showConfirmPassword,
                      validator: (value) => PasswordValidator.validate(value!),
                      controller: confirmedPasswordController,
                      decoration: kTextFieldDecorationLogIn.copyWith(
                        hintText: "Re-enter Password",
                        labelText: "Re-enter Password",
                        suffixIcon: GestureDetector(
                          onTap: _toggleConfirmPasswordVisibility,
                          child: _showConfirmPassword
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    updatePasswordButton,
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        "If you remember your password,",
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
                                    return const LoginScreenMA();
                                  },
                                ),
                              );
                            },
                            child: const Text(
                              "sign in!",
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
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

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _showConfirmPassword = !_showConfirmPassword;
    });
  }
}
