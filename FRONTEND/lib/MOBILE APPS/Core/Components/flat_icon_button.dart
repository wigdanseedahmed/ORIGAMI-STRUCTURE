import 'package:origami_structure/imports.dart';

class FlatIconButton extends StatelessWidget {
   const FlatIconButton({Key? key,
    required this.size,
    required this.icon,
    required this.onPress,
    required this.colour,
  }) : super(key: key);

  final double size;
  final IconData icon;
  final VoidCallback? onPress;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPress,
      child: Icon(
        icon,
        color: colour,
        size: 25.0,
      ),
    );
  }
}
