import 'package:origami_structure/imports.dart';

class TextFieldWidget extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final ValueChanged<String> onChanged;

  const TextFieldWidget({
    Key? key,
    required this.text,
    required this.onChanged,
    required this.textStyle
  }) : super(key: key);

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    style: widget.textStyle,
    onChanged: widget.onChanged,
    decoration: InputDecoration(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: primaryColour,
          width: 0.5,
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: primaryColour,
          width: 0.5,
        ),
      ),
      labelStyle: subTitleTextStyleMA,
    ),
  );
}