import 'package:origami_structure/imports.dart';

class ColumnIconContent extends StatelessWidget {
  const ColumnIconContent({Key? key, required this.icon, required this.label}) : super(key: key);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 80.0,
        ),
        const SizedBox(
          height: 15.0,
        ),
        Text(
          label,
          style: kContentLabelTextStyle,
        ),
      ],
    );
  }
}
