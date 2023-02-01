import 'package:origami_structure/imports.dart';

class ProgressCardWS extends StatelessWidget {
  const ProgressCardWS({
    required this.userData,
    required this.onPressedCheck,
    Key? key,
  }) : super(key: key);

  final UserModel userData;
  final Function() onPressedCheck;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Transform.translate(
                offset: const Offset(10, 30),
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: SvgPicture.asset(
                    ImageVectorPath.happy2,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              top: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "You Have ${userData.onHoldTasksCount! + userData.inProgressTasksCount!} Undone Tasks",
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  "${userData.inProgressTasksCount} Tasks are in progress",
                  style: const TextStyle(color: Color.fromRGBO(210, 210, 210, 1)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: onPressedCheck,
                  child: const Text("Check"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImageVectorPath {
  static const _folderPath = "assets/vector";
  static const happy = "$_folderPath/happy.svg";
  static const happy2 = "$_folderPath/happy-2.svg";
  static const wavyBus = "$_folderPath/wavy-bus.svg";
}