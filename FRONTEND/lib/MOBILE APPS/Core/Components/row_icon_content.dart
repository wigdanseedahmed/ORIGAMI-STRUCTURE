import 'package:origami_structure/imports.dart';

class RowIconContent extends StatelessWidget {
  const RowIconContent({Key? key, required this.icon, required this.label}) : super(key: key);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 60.0,
        ),
        const SizedBox(
          width: 50.0,
        ),
        Text(
          label,
          style: kContentLabelTextStyle,
        ),
        const SizedBox(
          width: 60.0,
        ),
        const Icon(
          FontAwesomeIcons.greaterThan,
          size: 40.0,
        ),
      ],
    );
  }
}
