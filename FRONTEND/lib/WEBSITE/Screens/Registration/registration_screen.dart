import 'package:origami_structure/imports.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:modal_progress_hud/modal_progress_hud.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flushbar/flushbar.dart';

class RegistrationScreenWS extends StatefulWidget {
  static const String id = 'registration_screen';

  const RegistrationScreenWS({Key? key}) : super(key: key);

  @override
  State<RegistrationScreenWS> createState() => _RegistrationScreenWSState();
}

class _RegistrationScreenWSState extends State<RegistrationScreenWS> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Variable used to get RESTful-API
  NetworkHandler networkHandler = NetworkHandler();

  /// Variables used to store registration parameters
  final storage = const FlutterSecureStorage();

  late String email;
  late String password;
  late String confirmedPassword;
  late String username;
  late String firstName;
  late String lastName;
  late String userID;

  late String errorText = "Error Text";
  late String msg = "";

  //bool validate = false;
  bool emailExists = false;
  bool _showPassword = true;
  bool _showConfirmPassword = true;
  bool showSpinner = false;

  UserType selectedUserType = UserType.unknown;

  final usernameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final confirmedPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    showSnackbarWithFlushbar(BuildContext context, String message) {
      Flushbar(
        // There is also a messageText property for when you want to
        // use a Text widget and not just a simple String
        message: message,

        duration: const Duration(seconds: 3),

        // Show it with a cascading operator
      ).show(context);
    }

    checkUser() async {
      if (usernameController.text == null || usernameController.text.isEmpty) {
        setState(() {
          // circular = false;
          errorText = "Username Can't be empty";
        });
      } else {
        var response = await networkHandler
            .get("${AppUrl.checkUsername}${usernameController.text}");
        if (response['Status'] == true) {
          setState(() {
            // circular = false;
            errorText = "Username already taken";
            toast(errorText);
          });
        } else {
          setState(() {
            // circular = false;
          });
        }
      }
    }

    checkEmail() async {
      if (emailController.text == null || emailController.text.isEmpty) {
        setState(() {
          // circular = false;
          // print("Username Can't be empty");
        });
      } else {
        var response = await networkHandler
            .get("${AppUrl.checkEmail}${emailController.text}");
        if (response['Status'] == true) {
          setState(() {
            errorText = "Email already taken";
            toast(errorText);
            showSpinner = false;
          });
        } else {
          setState(() {
            // showSpinner = false;
            emailExists = false;
            // print('Success');
          });
        }
      }
    }


    Container registrationButton = Container(
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
          await checkUser();
          await checkEmail();

          if (formKey.currentState!.validate()) {
            // we will send the data to rest server
            Map<String, String> data = {
              "username": usernameController.text,
              "firstName": firstNameController.text,
              "lastName": lastNameController.text,
              "email": emailController.text.toLowerCase(),
              "password": passwordController.text,
              "confirmedPassword": confirmedPasswordController.text,
            };
            //print(data);
            var responseRegister = await networkHandler.post(
                AppUrl.register, data); //"/user/register", data);

            //Login Logic added here
            if (responseRegister.statusCode == 200 ||
                responseRegister.statusCode == 201) {
              Map<String, String> data = {
                "email": emailController.text,
                "password": passwordController.text,
              };
              var response = await networkHandler.post(AppUrl.login, data);

              if (response.statusCode == 200 || response.statusCode == 201) {
                Map<String, dynamic> output = json.decode(response.body);
                // print(output["token"]);
                await storage.write(key: "token", value: output["token"]);
                setState(() {
                  showSpinner = false;
                });
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreenMA(),
                    ),
                        (route) => false);
              } else {
                toast("Network Error");
                //Scaffold.of(context).showSnackBar(const SnackBar(content: Text("Network Error")));
              }
            }

            //Login Logic end here

            setState(() {
              showSpinner = false;
            });
          } else {
            setState(() {
              showSpinner = false;
            });
          }
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
            child: Text("Sign Up", style: TextStyle(color: Colors.white),),
          ),
        ),
      ),
    );

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const TopBarMenuWS(
                        isLoginOrRegistration: 'Registration',
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
                                  'Sign Up \nto get started',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width / 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                 Text(
                                  "If you have an account",
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width / 90,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                     Text(
                                      "You can",
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width / 90,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width / 180),
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
                                      child: Text(
                                        "login here!",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context).size.width / 90,
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
                              child: buildRegistrationBody(registrationButton),
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
      ),
    );
  }

  buildRegistrationBody(Container registrationButton) {
    return Column(
      children: <Widget>[
        TextFormField(
          validator: (value) => UserIDValidator.validate(value!),
          onChanged: (value) => userID = value,
          decoration: InputDecoration(
            hintText: 'User Model ID',
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
          validator: (value) => NameValidator.validate(value!),
          onChanged: (value) => username = value,
          controller: usernameController,
          decoration: InputDecoration(
            hintText: 'Username',
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
          validator: (value) => NameValidator.validate(value!),
          onChanged: (value) => firstName = value,
          controller: firstNameController,
          decoration: InputDecoration(
            hintText: 'First Name',
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
          validator: (value) => NameValidator.validate(value!),
          onChanged: (value) => lastName = value,
          controller: lastNameController,
          decoration: InputDecoration(
            hintText: 'Last Name',
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
        const SizedBox(height: 10.0),
        TextFormField(
          obscureText: _showConfirmPassword,
          validator: (value) => PasswordValidator.validate(value!),
          onChanged: (value) => confirmedPassword = value,
          controller: confirmedPasswordController,
          decoration: InputDecoration(
            hintText: 'Re-enter Password',
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
        const SizedBox(height: 30),
        registrationButton,
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
        // logInWithSocialMedia,
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "I'm already a member. ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                  "Sign in.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _showConfirmPassword = !_showConfirmPassword;
    });
  }
}

//Custom class in project directory
class CustomWidgetsWS {
  CustomWidgetsWS._();

  static buildErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
