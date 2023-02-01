import 'package:origami_structure/imports.dart';

import 'package:unicorndial/unicorndial.dart';

class ProjectDetailScreenFloatingMenuWS extends StatefulWidget {
  const ProjectDetailScreenFloatingMenuWS({Key? key}) : super(key: key);

  @override
  State<ProjectDetailScreenFloatingMenuWS> createState() =>
      _ProjectDetailScreenFloatingMenuWSState();
}

class _ProjectDetailScreenFloatingMenuWSState
    extends State<ProjectDetailScreenFloatingMenuWS> {
  @override
  Widget build(BuildContext context) {
    var childButtons = <UnicornButton>[];

    childButtons.add(
      UnicornButton(
        hasLabel: true,
        labelBackgroundColor: Colors.transparent,
        labelHasShadow: false,
        labelText: "Choo choo",
        currentButton: FloatingActionButton(
          heroTag: "train",
          backgroundColor: primaryColour,
          mini: true,
          child: Icon(Icons.train),
          onPressed: () {},
        ),
      ),
    );

    childButtons.add(
      UnicornButton(
        currentButton: FloatingActionButton(
          heroTag: "airplane",
          backgroundColor: primaryColour,
          mini: true,
          onPressed: () {},
          child: Icon(Icons.airplanemode_active),
        ),
      ),
    );

    childButtons.add(
      UnicornButton(
        currentButton: FloatingActionButton(
          heroTag: "directions",
          backgroundColor: primaryColour,
          mini: true,
          onPressed: () {},
          child: Icon(Icons.directions_car),
        ),
      ),
    );

    return Scaffold(
      floatingActionButton: buildFloatingActionButton(childButtons),
    );
  }

  buildFloatingActionButton(List<UnicornButton> childButtons) {
    return UnicornDialer(
        backgroundColor:DynamicTheme.of(context)?.brightness ==
            Brightness.light
            ? const Color.fromRGBO(255, 255, 255, 0.6)
            : const Color(0XFF323232),
        parentButtonBackground: primaryColour,
        orientation: UnicornOrientation.VERTICAL,
        parentButton: Icon(Icons.add),
        childButtons: childButtons);
  }
}
