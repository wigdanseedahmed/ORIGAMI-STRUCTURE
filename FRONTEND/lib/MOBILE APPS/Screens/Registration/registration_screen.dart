import 'package:origami_structure/imports.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:modal_progress_hud/modal_progress_hud.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flushbar/flushbar.dart';

class RegistrationScreenMA extends StatefulWidget {
  static const String id = 'registration_screen';

  const RegistrationScreenMA({Key? key}) : super(key: key);

  @override
  State<RegistrationScreenMA> createState() => _RegistrationScreenMAState();
}

class _RegistrationScreenMAState extends State<RegistrationScreenMA> {
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
      if (usernameController.text.isEmpty) {
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
      if (emailController.text.isEmpty) {
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

    SizedBox registrationButton = SizedBox(
      height: 50,
      // ignore: deprecated_member_use
      child: TextButton(
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
        style: TextButton.styleFrom(padding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),),
        child: const SignInSignUpInk(
          text: "Sign Up",
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sign Up\nto get started',
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
                    const SizedBox(height: 16),
                    TextFormField(
                      validator: (value) => UserIDValidator.validate(value!),
                      onChanged: (value) => userID = value,
                      //controller: emailController,
                      decoration: kTextFieldDecorationRegistration.copyWith(
                        hintText: 'User Model ID',
                        labelText: "User Model ID",
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      validator: (value) => NameValidator.validate(value!),
                      onChanged: (value) => username = value,
                      controller: usernameController,
                      decoration: kTextFieldDecorationRegistration.copyWith(
                        //errorText: validate ? null : errorText,
                        hintText: 'Username',
                        labelText: "Username",
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      validator: (value) => NameValidator.validate(value!),
                      onChanged: (value) => firstName = value,
                      controller: firstNameController,
                      decoration: kTextFieldDecorationRegistration.copyWith(
                        hintText: 'First Name',
                        labelText: "First Name",
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      validator: (value) => NameValidator.validate(value!),
                      onChanged: (value) => lastName = value,
                      controller: lastNameController,
                      decoration: kTextFieldDecorationRegistration.copyWith(
                        hintText: 'Last Name',
                        labelText: "Last Name",
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
                      decoration: kTextFieldDecorationRegistration.copyWith(
                        //errorText: validate ? null : errorText,
                        hintText: 'Email',
                        labelText: "Email",
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      obscureText: _showPassword,
                      validator: (value) => PasswordValidator.validate(value!),
                      onChanged: (value) => password = value,
                      controller: passwordController,
                      decoration: kTextFieldDecorationRegistration.copyWith(
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
                    const SizedBox(height: 10.0),
                    TextFormField(
                      obscureText: _showConfirmPassword,
                      validator: (value) => PasswordValidator.validate(value!),
                      controller: confirmedPasswordController,
                      decoration: kTextFieldDecorationRegistration.copyWith(
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
                    const SizedBox(height: 30),
                    registrationButton,
                    const SizedBox(height: 16),
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
                                    return const LoginScreenMA();
                                  },
                                ),
                              );
                            },
                            child: const Text(
                              "Sign in.",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
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
      ),
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
class CustomWidgets {
  CustomWidgets._();

  static buildErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
