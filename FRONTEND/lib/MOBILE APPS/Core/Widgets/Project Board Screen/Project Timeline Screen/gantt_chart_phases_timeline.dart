import 'dart:ui';

import 'package:origami_structure/imports.dart';

import 'package:date_utils/date_utils.dart' as Utils;

class PhasesGanttChartMA extends StatelessWidget {
  final AnimationController? animationController;
  final DateTime? projectStartDate;
  final DateTime? projectEndDate;
  final List<PhasesModel>? phasesInProject;

  double? projectDurationInDayRange;
  double? projectDurationInWeekRange;
  double? projectDurationInMonthRange;
  int viewRangeToFitScreen = 6;
  Animation<double>? width;

  PhasesGanttChartMA({
    Key? key,
    this.animationController,
    this.projectStartDate,
    this.projectEndDate,
    this.phasesInProject,
  }) : super(key: key) {
    projectDurationInDayRange =
        calculateNumberOfDaysBetween(projectStartDate!, projectEndDate!);
    projectDurationInWeekRange =
        calculateNumberOfWeeksBetween(projectStartDate!, projectEndDate!);
    projectDurationInMonthRange =
        calculateNumberOfMonthsBetween(projectStartDate!, projectEndDate!);
  }

  ///------------- FUNCTIONS -------------///

  Color randomColorGenerator() {
    var r = Random();
    return Color.fromRGBO(r.nextInt(106), r.nextInt(106), r.nextInt(106), 0.75);
  }

  double calculateNumberOfMonthsBetween(DateTime from, DateTime to) {
    return to.month - from.month + 12 * (to.year - from.year) + 1;
  }

  double calculateNumberOfWeeksBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return ((to.difference(from).inHours / 24) / 7).toDouble();
  }

  double calculateNumberOfDaysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).toDouble();
  }

  double calculateDistanceToLeftBorder(DateTime phaseStartDate) {
    if (phaseStartDate.compareTo(projectStartDate!) <= 0) {
      return 0;
    } else {
      return calculateNumberOfDaysBetween(projectStartDate!, phaseStartDate);
    }
  }

  double calculateRemainingWidth(
      DateTime phaseStartedAt, DateTime phaseEndedAt) {
    double phaseDurationLength =
        calculateNumberOfDaysBetween(phaseStartedAt, phaseEndedAt);

    if (phaseStartedAt.compareTo(projectStartDate!) >= 0 &&
        phaseStartedAt.compareTo(projectEndDate!) <= 0) {
      if (phaseDurationLength <= projectDurationInDayRange!) {
        return phaseDurationLength.toDouble();
      } else {
        return (projectDurationInDayRange! -
                calculateNumberOfDaysBetween(projectStartDate!, phaseStartedAt))
            .toDouble();
      }
    } else if (phaseStartedAt.isBefore(projectStartDate!) &&
        phaseEndedAt.isBefore(projectStartDate!)) {
      return 0;
    } else if (phaseStartedAt.isBefore(projectStartDate!) &&
        phaseEndedAt.isBefore(projectEndDate!)) {
      return (phaseDurationLength -
              calculateNumberOfDaysBetween(phaseStartedAt, projectStartDate!))
          .toDouble();
    } else if (phaseStartedAt.isBefore(projectStartDate!) &&
        phaseEndedAt.isAfter(projectEndDate!)) {
      return projectDurationInDayRange!.toDouble();
    }
    return 0;
  }

  ///------------- WIDGETS -------------///

  Widget buildHeader(Size screenSize, Color color) {
    List<Widget> headerItems = [];

    DateTime tempDate = projectStartDate!;

    for (int i = 0; i < projectDurationInWeekRange!; i++) {
      headerItems.add(
        SizedBox(
          width: screenSize.width * 0.024 * 7,
          child: Align(
            alignment: Alignment.centerLeft,
            child: RotatedBox(
              quarterTurns: 1,
              child: Text(
                '${tempDate.day}/${tempDate.month}/${tempDate.year}',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: screenSize.width * 0.024,
                ),
              ),
            ),
          ),
        ),
      );

      tempDate = Utils.DateUtils.nextWeek(tempDate);
    }

    return Container(
      height: screenSize.height * 0.078,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: headerItems,
      ),
    );
  }

  Widget buildGrid(Size screenSize) {
    List<Widget> gridColumns = [];

    for (int i = 0; i <= projectDurationInDayRange!  / 7; i++) {
      gridColumns.add(
        Container(
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Colors.grey.withAlpha(100),
                width: 1.0,
              ),
            ),
          ),
          width: screenSize.width * 0.024 * 7,
        ),
      );
    }

    return Row(
      children: gridColumns,
    );
  }

  Widget buildTodayMarker(Size screenSize) {
    List<Widget> gridColumns = [];

    gridColumns.add(
      Padding(
        padding: EdgeInsets.only(
            left: calculateDistanceToLeftBorder(DateTime.now())) * screenSize.width * 0.024,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Colors.red.withAlpha(400),
                width: 3.0,
              ),
            ),
          ),
          width: 3,
        ),
      ),
    );

    return Row(
      children: gridColumns,
    );
  }

  List<Widget> buildChartBars(
      List<PhasesModel> phasesData, Size screenSize, Color color) {
    List<Widget> chartBars = [];

    for (int i = 0; i < phasesData.length; i++) {
      var remainingWidth = calculateRemainingWidth(
        DateTime.parse(phasesData[i].startDate!),
        DateTime.parse(phasesData[i].endDate!),
      );

      if (remainingWidth > 0) {
        chartBars.add(
          Container(
            width: (calculateDistanceToLeftBorder(
                        DateTime.parse(phasesData[i].startDate!)) *
                screenSize.width * 0.024) +
                ((DateTime.parse(phasesData[i].endDate!)
                            .difference(
                                DateTime.parse(phasesData[i].startDate!))
                            .inDays)
                        .toDouble()) *
                    screenSize.width * 0.024,
            alignment: Alignment.centerLeft,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: screenSize.height * 0.008,
                    left: (calculateDistanceToLeftBorder(
                            DateTime.parse(phasesData[i].startDate!)) *
                        screenSize.width * 0.024)),
                child: LinearPercentIndicator(
                  width: ((DateTime.parse(phasesData[i].endDate!)
                              .difference(
                                  DateTime.parse(phasesData[i].startDate!))
                              .inDays)
                          .toDouble()) *
                      screenSize.width * 0.024,
                  animation: true,
                  animationDuration: 1000,
                  lineHeight: screenSize.height * 0.022,
                  percent: phasesData[i].progressPercentage == null
                      ? 0.0
                      : phasesData[i].progressPercentage! / 100,
                  center: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(phasesData[i].phase!),
                  ),
                  barRadius: const Radius.circular(6),
                  progressColor: phasesData[i].progressPercentage == null ||
                          phasesData[i].progressPercentage == 0.0
                      ? Colors.grey
                      : phasesData[i].progressPercentage! < 20.0
                          ? Colors.lightGreenAccent
                          : phasesData[i].progressPercentage! < 40.0
                              ? Colors.tealAccent
                              : phasesData[i].progressPercentage! < 60.0
                                  ? Colors.deepPurpleAccent
                                  : phasesData[i].progressPercentage! < 80.0
                                      ? Colors.lime
                                      : primaryColour,
                  backgroundColor: Colors.grey.shade200,
                ),
              ),
            ),
          ),
        );
      }
    }

    return chartBars;
  }

  Widget buildChartForEachPhase(List<PhasesModel> phaseData, Size screenSize) {
    Color color = randomColorGenerator();

    var chartBars = buildChartBars(phaseData, screenSize, color);

    return SizedBox(
      height: chartBars.length * screenSize.height * 0.0328 +
          screenSize.height * 0.078 +
          screenSize.height * 0.0008 +
          screenSize.height * 0.0034,
      child: ListView(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Stack(
            fit: StackFit.loose,
            children: <Widget>[
              buildGrid(screenSize),
              buildHeader(screenSize, color),
              Container(
                margin: EdgeInsets.only(top: screenSize.height * 0.09),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: chartBars,
                ),
              ),
              DateTime.now().isBefore(projectEndDate!)
                  ? buildTodayMarker(screenSize)
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> buildChartContent(Size screenSize) {
    List<Widget> chartContent = [];

    if (phasesInProject != null || phasesInProject!.isNotEmpty) {
      chartContent.add(buildChartForEachPhase(phasesInProject!, screenSize));
    }

    return chartContent;
  }

  @override
  Widget build(BuildContext context) {
    var screenOrientation = MediaQuery.of(context).orientation;

    var screenSize = MediaQuery.of(context).size;

    screenOrientation == Orientation.landscape
        ? viewRangeToFitScreen = 12
        : viewRangeToFitScreen = 6;

    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: buildChartContent(screenSize),
      ),
    );
  }
}
