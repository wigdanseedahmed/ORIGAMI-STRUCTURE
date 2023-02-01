import 'package:origami_structure/imports.dart';

class ProjectDetailHeaderWS extends StatelessWidget {
  const ProjectDetailHeaderWS(
      {Key? key, required this.headerTitle, this.onPressed, this.icon})
      : super(key: key);

  final String headerTitle;
  final Function()? onPressed;
  final Icon? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          headerTitle.toUpperCase(),
          textAlign: TextAlign.left,
          style: TextStyle(
            letterSpacing: 1,
            fontFamily: 'Electrolize',
            fontSize: MediaQuery.of(context).size.width / 75,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        icon != null
            ?
        IconButton(
          onPressed: onPressed,
          icon: icon!,
        )
            : Container()
      ],
    );
  }
}
