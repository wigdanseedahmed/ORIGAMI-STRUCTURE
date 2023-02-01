import 'dart:ui';

import 'package:origami_structure/imports.dart';

import 'package:date_utils/date_utils.dart' as Utils;

class PhasesTasksGanttChartMA extends StatelessWidget {
  final AnimationController? animationController;
  final DateTime? projectStartDate;
  final DateTime? projectEndDate;
  final List<TaskModel>? projectTaskData;
  final List<PhasesModel>? phasesInProject;

  double? projectDurationInDayRange;
  double? projectDurationInWeekRange;
  double? projectDurationInMonthRange;
  int viewRangeToFitScreen = 6;
  Animation<double>? width;

  PhasesTasksGanttChartMA({
    Key? key,
    this.animationController,
    this.projectStartDate,
    this.projectEndDate,
    this.projectTaskData,
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

    headerItems.add(
      SizedBox(
        width: screenSize.width / viewRangeToFitScreen,
        child: const Align(
          alignment: Alignment.center,
          child: Text(
            'NAME',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );

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
      color: color.withAlpha(100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: headerItems,
      ),
    );
  }

  Widget buildGrid(Size screenSize) {
    List<Widget> gridColumns = [];

    for (int i = 0; i <= projectDurationInDayRange! / 7; i++) {
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
            left: (screenSize.width / viewRangeToFitScreen) +
                calculateDistanceToLeftBorder(DateTime.now())* screenSize.width * 0.024,
        ) ,
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
      List<TaskModel> tasksData, Size screenSize, Color color) {
    List<Widget> chartBars = [];

    for (int i = 0; i < tasksData.length; i++) {
      var remainingWidth = calculateRemainingWidth(
        DateTime.parse(tasksData[i].startDate!),
        DateTime.parse(tasksData[i].deadlineDate!),
      );

      if (remainingWidth > 0) {
        chartBars.add(
          Container(
            width: (calculateDistanceToLeftBorder(
                        DateTime.parse(tasksData[i].startDate!)) *
                screenSize.width * 0.024) +
                ((DateTime.parse(tasksData[i].deadlineDate!)
                            .difference(
                                DateTime.parse(tasksData[i].startDate!))
                            .inDays)
                        .toDouble()) *
                    screenSize.width * 0.024,
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: screenSize.height * 0.008,
                  left: (calculateDistanceToLeftBorder(
                          DateTime.parse(tasksData[i].startDate!)) *
                      screenSize.width * 0.024)),
              child: LinearPercentIndicator(
                width: ((DateTime.parse(tasksData[i].deadlineDate!)
                            .difference(
                                DateTime.parse(tasksData[i].startDate!))
                            .inDays)
                        .toDouble()) *
                    screenSize.width * 0.024,
                animation: true,
                animationDuration: 1000,
                lineHeight: screenSize.height * 0.022,
                percent: tasksData[i].percentageDone == null
                    ? 0.0
                    : tasksData[i].percentageDone! / 100,
                center: Padding(
                  padding: const EdgeInsets.only(left: 1, right: 1),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text(tasksData[i].taskName!),
                  ),
                ),
                barRadius: const Radius.circular(6),
                progressColor: tasksData[i].percentageDone == null ||
                        tasksData[i].percentageDone == 0.0
                    ? Colors.grey
                    : tasksData[i].percentageDone! < 20.0
                        ? Colors.lightGreenAccent
                        : tasksData[i].percentageDone! < 40.0
                            ? Colors.tealAccent
                            : tasksData[i].percentageDone! < 60.0
                                ? Colors.deepPurpleAccent
                                : tasksData[i].percentageDone! < 80.0
                                    ? Colors.lime
                                    : primaryColour,
                backgroundColor: Colors.grey.shade200,
              ),
            ),
          ),
        );
      }
    }

    return chartBars;
  }

  Widget buildChartForEachPhase(
      List<TaskModel> taskData, Size screenSize, PhasesModel phase) {
    Color color = randomColorGenerator();

    var chartBars = buildChartBars(taskData, screenSize, color);

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
                margin: EdgeInsets.only(top: screenSize.height * 0.078),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: screenSize.width / viewRangeToFitScreen,
                          height:
                              chartBars.length * screenSize.height * 0.0328 +
                                  screenSize.height * 0.004,
                          color: color.withAlpha(100),
                          child: Center(
                            child: RotatedBox(
                              quarterTurns: chartBars.length *
                                              screenSize.height *
                                              0.0328 +
                                          screenSize.height * 0.004 >
                                      50
                                  ? 0
                                  : 0,
                              child: Text(
                                phase.phase!,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(top: screenSize.height * 0.001),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: chartBars,
                          ),
                        ),
                      ],
                    ),
                  ],
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

    phasesInProject!.forEach((phase) {
      List<TaskModel> tasksOfPhase = [];

      tasksOfPhase = projectTaskData!
          .where((task) => task.projectPhase == phase.phase)
          .toList();

      if (tasksOfPhase.isNotEmpty) {
        chartContent
            .add(buildChartForEachPhase(tasksOfPhase, screenSize, phase));
      }
    });

    return chartContent;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenOrientation = MediaQuery.of(context).orientation;

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
