import 'package:origami_structure/imports.dart';

kopenPage(BuildContext context, Widget page) {
  return Navigator.push(
    context,
    MaterialPageRoute(
      builder: (BuildContext context) => page,
    ),
  );
}

