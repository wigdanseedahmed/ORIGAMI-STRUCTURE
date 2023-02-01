import 'package:origami_structure/imports.dart';

class SignInSignUpInk extends StatelessWidget {
  final String text;
  const SignInSignUpInk({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: kSignInSignUpContainerDecoration,
      child: Container(
        alignment: Alignment.center,
        constraints: const BoxConstraints(
          maxWidth: double.infinity,
          minHeight: 50,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}