import 'package:origami_structure/imports.dart';

class ProjectDetailHeaderMA extends StatelessWidget {
  const ProjectDetailHeaderMA({
    Key? key,
    required this.headerTitle,
  }) : super(key: key);

  final String headerTitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              headerTitle,
              textAlign: TextAlign.left,
              style: TextStyle(
                //letterSpacing: 8,
                fontFamily: 'Electrolize',
                fontSize: MediaQuery.of(context).size.width * 0.05,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
