import 'package:origami_structure/imports.dart';

import 'package:unicorndial/unicorndial.dart';

class ProjectDetailScreenFloatingMenuMA extends StatefulWidget {
  const ProjectDetailScreenFloatingMenuMA({Key? key}) : super(key: key);

  @override
  State<ProjectDetailScreenFloatingMenuMA> createState() =>
      _ProjectDetailScreenFloatingMenuMAState();
}

class _ProjectDetailScreenFloatingMenuMAState
    extends State<ProjectDetailScreenFloatingMenuMA> {
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
        // backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
        childPadding: 0.0,
        backgroundColor:DynamicTheme.of(context)?.brightness ==
            Brightness.light
            ? const Color.fromRGBO(255, 255, 255, 0.6)
            : const Color(0XFF323232),
        parentButtonBackground: primaryColour,
        orientation: UnicornOrientation.VERTICAL,
        parentButton: const Icon(Icons.add),
        childButtons: childButtons);
  }
}
