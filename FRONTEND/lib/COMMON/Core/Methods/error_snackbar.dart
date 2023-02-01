import 'package:origami_structure/imports.dart';

SnackBar errorSnackBar(PlatformException e) {
  return SnackBar(
    action: SnackBarAction(
      label: 'Error',
      onPressed: () {
        //TODO: Code to execute when error found
      },
    ),
    content:
    Text(
      RegistrationOrLogInErrors.show(e.code),
    ),
    duration: const Duration(milliseconds: 3000),
    width: 320.0, // Width of the SnackBar.
    padding: const EdgeInsets.symmetric(
      horizontal: 8.0, // Inner padding for SnackBar content.
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),

  );
}

SnackBar passwordsMatchErrorSnackBar() {
  return SnackBar(
    action: SnackBarAction(
      label: 'Error',
      onPressed: () {
        // Code to execute.
      },
    ),
    content:
    const Text(
      'Passwords do not match.',
    ),
    duration: const Duration(milliseconds: 3000),
    width: 320.0, // Width of the SnackBar.
    padding: const EdgeInsets.symmetric(
      horizontal: 8.0, // Inner padding for SnackBar content.
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),

  );
}