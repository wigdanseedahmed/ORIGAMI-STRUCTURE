import 'package:origami_structure/imports.dart';

class ProgressReportCardWS extends StatelessWidget {
  const ProgressReportCardWS({
    Key? key,
    required this.selectedUser, required this.openProjects, required this.closedProjects,
  }) : super(key: key);

  final UserModel selectedUser;
  final int openProjects;
  final int closedProjects;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 200,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(111, 88, 255, 1),
            Color.fromRGBO(157, 86, 248, 1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Projects",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              ProgressReportCardRichTextWS(value1: "${selectedUser.numberOfProjectsAssignedToUser == null ? 0 : selectedUser.numberOfProjectsAssignedToUser!} ", value2: "Projects"),
              const SizedBox(height: 3),
              ProgressReportCardRichTextWS(value1: "$openProjects ", value2: "Open Projects"),
              const SizedBox(height: 3),
              ProgressReportCardRichTextWS(value1: "$closedProjects ", value2: "Closed Projects"),
            ],
          ),
          const Spacer(),
          ProgressReportCardIndicatorWS(percent: selectedUser.projectProgressPercentage == null ? 0 : selectedUser.projectProgressPercentage!),
        ],
      ),
    );
  }
}

class ProgressReportCardRichTextWS extends StatelessWidget {
  const ProgressReportCardRichTextWS({
    required this.value1,
    required this.value2,
    Key? key,
  }) : super(key: key);

  final String value1;
  final String value2;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        children: [
          TextSpan(text: value1),
          TextSpan(
            text: value2,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w100,
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressReportCardIndicatorWS extends StatelessWidget {
  const ProgressReportCardIndicatorWS({required this.percent, Key? key}) : super(key: key);

  final double percent;

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 90,
      lineWidth: 15,
      percent: percent / 100,
      circularStrokeCap: CircularStrokeCap.round,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${double.parse((percent).toStringAsFixed(2))} %",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text(
            "Completed",
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
          ),
        ],
      ),
      progressColor: Colors.white,
      backgroundColor: Colors.white.withOpacity(.3),
    );
  }
}
