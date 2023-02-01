import 'package:origami_structure/imports.dart';

// ignore: must_be_immutable
class RoundedButton extends StatelessWidget {
  const RoundedButton({Key? key, required this.colour, required this.buttonTitle, required this.onPressed}) : super(key: key);

  final Color colour;
  final String buttonTitle;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            buttonTitle,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

