import 'package:origami_structure/imports.dart';

class TeamMemberWS extends StatelessWidget {
  const TeamMemberWS({
    Key? key,
    required this.totalMember,
    required this.onPressedAdd,
  }) : super(key: key);

  final int totalMember;
  final Function() onPressedAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            children: [
              const TextSpan(text: "Team Member "),
              TextSpan(
                text: "($totalMember)",
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(170, 170, 170, 1),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: onPressedAdd,
          icon: const Icon(EvaIcons.plus),
          tooltip: "add member",
        )
      ],
    );
  }
}
