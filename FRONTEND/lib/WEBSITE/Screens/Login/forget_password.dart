import 'package:origami_structure/imports.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ForgotPasswordScreenWS extends StatefulWidget {
  const ForgotPasswordScreenWS({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenWSState createState() => _ForgotPasswordScreenWSState();
}

class _ForgotPasswordScreenWSState extends State<ForgotPasswordScreenWS> {
  final _globalKey = GlobalKey<FormState>();

  /// Variable used to get RESTful-API
  NetworkHandler networkHandler = NetworkHandler();

  late String email;
  late String password;
  late String confirmedPassword;

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

    Container updatePasswordButton = Container(
      decoration: BoxDecoration(
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
                MaterialPageRoute(builder: (context) => const HomeScreenWS()),
                //TODO: WelcomePage()
                    (route) => false);
          }

          // login logic End here
        },
        style: ElevatedButton.styleFrom(
          primary: kViolet,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: const SizedBox(
          width: double.infinity,
          height: 50,
          child: Center(
            child: Text("Update Password"),
          ),
        ),
      ),
    );

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        body: Container(
          // height: MediaQuery.of(context).size.height,
          // width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Form(
            key: _globalKey,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TopBarMenuWS(
                    isLoginOrRegistration: 'Registration',
                    isSelectedPage: '',
                  ),
                  // MediaQuery.of(context).size.width >= 980
                  //     ? Menu()
                  //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 360,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Change your \nPassword',
                              style: TextStyle(
                                fontSize: 45,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              "If you remember your password",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Text(
                                  "You can",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 15),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const LoginScreenWS();
                                        },
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Login here!",
                                    style: TextStyle(
                                        color: kViolet,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Image.asset(
                              'images/illustration-2.png',
                              width: 300,
                            ),
                          ],
                        ),
                      ),

                      Image.asset(
                        'images/illustration-1.png',
                        width: 300,
                      ),
                      // MediaQuery.of(context).size.width >= 1300 //Responsive
                      //     ? Image.asset(
                      //         'images/illustration-1.png',
                      //         width: 300,
                      //       )
                      //     : SizedBox(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height / 6),
                        child: SizedBox(
                          width: 320,
                          child: buildForgetPasswordBody(updatePasswordButton),
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
    );
  }

  buildForgetPasswordBody(Container updatePasswordButton) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
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
        const SizedBox(height: 16),
        TextFormField(
          obscureText: _showPassword,
          validator: (value) => PasswordValidator.validate(value!),
          onChanged: (value) => password = value,
          controller: passwordController,
          decoration: InputDecoration(
            hintText: 'Password',
            labelText: "Password",
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
        const SizedBox(height: 16),
        TextFormField(
          obscureText: _showConfirmPassword,
          validator: (value) => PasswordValidator.validate(value!),
          onChanged: (value) => confirmedPassword = value,
          controller: confirmedPasswordController,
          decoration: InputDecoration(
            hintText: 'Re-enter Password',
            labelText: "Re-enter Password",
            suffixIcon: GestureDetector(
              onTap: _toggleConfirmPasswordVisibility,
              child: _showConfirmPassword
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
        const SizedBox(height: 50),
        updatePasswordButton,
        const SizedBox(height: 50),
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

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _showConfirmPassword = !_showConfirmPassword;
    });
  }
}
