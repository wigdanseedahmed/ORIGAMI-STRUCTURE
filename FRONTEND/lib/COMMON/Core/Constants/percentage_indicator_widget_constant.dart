import 'package:origami_structure/imports.dart';

getPercentageIndicator(context, double? percent) {
  return LayoutBuilder(builder: (context, constraints) {
    return LinearPercentIndicator(
      //Linear progress bar
      animation: true,
      animationDuration: 1000,
      lineHeight: 20.0,
      percent: percent == null? 0:percent/100,
      center: Text(
        "${percent!.toStringAsFixed(2)}%",
        style: const TextStyle(
            fontSize: 10.0, fontWeight: FontWeight.bold),
      ),
      barRadius: const Radius.circular(16),
      progressColor: primaryColour.withOpacity(0.7),
      backgroundColor: Colors.grey[300],
    );
  });
}

getProjectPercentageIndicator(context, percent) {
  return LayoutBuilder(builder: (context, constraints) {
    return LinearPercentIndicator(
      //leaner progress bar
      animation: true,
      animationDuration: 1000,
      lineHeight: 10.0,
      percent: percent / 100,
      linearStrokeCap: LinearStrokeCap.roundAll,
      progressColor: Colors.red,
      backgroundColor: Colors.grey[300],
    );
  });
}
