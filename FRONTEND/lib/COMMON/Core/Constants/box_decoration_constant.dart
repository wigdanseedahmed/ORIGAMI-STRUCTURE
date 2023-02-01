import 'package:origami_structure/imports.dart';

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.purple, width: 2.0),
  ),
);

BoxDecoration kSignInSignUpContainerDecoration = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: logInAndRegistrationButtonColour,
  ),
  borderRadius: BorderRadius.circular(6),
);
