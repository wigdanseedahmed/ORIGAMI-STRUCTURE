import 'package:origami_structure/imports.dart';

class ActiveProjectCard extends StatelessWidget {
  const ActiveProjectCard({
    required this.child,
    required this.onPressedSeeAll,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final Function() onPressedSeeAll;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _title(context, "My Projects"),
                // _seeAllButton(onPressed: onPressedSeeAll),
              ],
            ),
            const Divider(
              thickness: 1,
              height: 20,
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }

  Widget _title(BuildContext context, String value) {
    return Text(
      value,
      style: TextStyle(fontSize:MediaQuery.of(context).size.width * 0.015, fontWeight: FontWeight.bold),
    );
  }

  Widget _seeAllButton({required Function() onPressed}) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(primary: const Color.fromRGBO(210, 210, 210, 1)),
      child: const Text("See All"),
    );
  }
}
