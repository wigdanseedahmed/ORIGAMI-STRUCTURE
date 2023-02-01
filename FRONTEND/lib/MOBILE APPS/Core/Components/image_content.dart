import 'package:origami_structure/imports.dart';

class ImageContent extends StatelessWidget {
  const ImageContent({
    Key? key,
    required this.imageName,
    required this.label
  }) : super(key: key);

  final String imageName;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          imageName,
          height: 60.0,
          fit: BoxFit.cover,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          label,
          style: kContentLabelTextStyle,
        ),
      ],
    );
  }
}
