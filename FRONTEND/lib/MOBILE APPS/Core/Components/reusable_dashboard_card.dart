import 'package:origami_structure/imports.dart';

class ReusableDashboardCard extends StatelessWidget {
  const ReusableDashboardCard({Key? key, required this.colour, required this.cardChild, required this.onPress}) : super(key: key);

  final Color colour;
  final Widget cardChild;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: cardChild,
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: colour,
        ),
      ),
    );
  }
}
