import 'package:origami_structure/imports.dart';

import 'package:date_utils/date_utils.dart' as Utils;


class MembersProjectsGanttChart extends StatelessWidget {
  final AnimationController? animationController;
  final DateTime? fromDate;
  final DateTime? toDate;
  final List<ProjectModel>? projectsData;
  final List<UserModel>? usersInChart;

  int? viewRange;
  int viewRangeToFitScreen = 6;
  Animation<double>? width;

  MembersProjectsGanttChart({
    Key? key,
    this.animationController,
    this.fromDate,
    this.toDate,
    this.projectsData,
    this.usersInChart,
  }) : super(key: key) {
    viewRange = calculateNumberOfMonthsBetween(fromDate!, toDate!);
  }

  Color randomColorGenerator() {
    var r = Random();
    return Color.fromRGBO(r.nextInt(256), r.nextInt(256), r.nextInt(256), 0.75);
  }

  int calculateNumberOfMonthsBetween(DateTime from, DateTime to) {
    return to.month - from.month + 12 * (to.year - from.year) + 1;
  }

  int calculateDistanceToLeftBorder(DateTime projectStartedAt) {
    if (projectStartedAt.compareTo(fromDate!) <= 0) {
      return 0;
    } else {
      return calculateNumberOfMonthsBetween(fromDate!, projectStartedAt) - 1;
    }
  }

  int calculateRemainingWidth(
      DateTime projectStartedAt, DateTime projectEndedAt) {
    int projectLength =
    calculateNumberOfMonthsBetween(projectStartedAt, projectEndedAt);
    if (projectStartedAt.compareTo(fromDate!) >= 0 &&
        projectStartedAt.compareTo(toDate!) <= 0) {
      if (projectLength <= viewRange!) {
        return projectLength;
      } else {
        return viewRange! -
            calculateNumberOfMonthsBetween(fromDate!, projectStartedAt);
      }
    } else if (projectStartedAt.isBefore(fromDate!) &&
        projectEndedAt.isBefore(fromDate!)) {
      return 0;
    } else if (projectStartedAt.isBefore(fromDate!) &&
        projectEndedAt.isBefore(toDate!)) {
      return projectLength -
          calculateNumberOfMonthsBetween(projectStartedAt, fromDate!);
    } else if (projectStartedAt.isBefore(fromDate!) &&
        projectEndedAt.isAfter(toDate!)) {
      return viewRange!;
    }
    return 0;
  }

  List<Widget> buildChartBars(
      List<ProjectModel> data, double chartViewWidth, Color color) {
    List<Widget> chartBars = [];

    for (int i = 0; i < data.length; i++) {
      var remainingWidth =
      calculateRemainingWidth(DateTime.parse(data[i].startDate!), DateTime.parse(data[i].dueDate!));
      if (remainingWidth > 0) {
        chartBars.add(Container(
          decoration: BoxDecoration(
              color: color.withAlpha(100),
              borderRadius: BorderRadius.circular(10.0)),
          height: 25.0,
          width: remainingWidth * chartViewWidth / viewRangeToFitScreen,
          margin: EdgeInsets.only(
              left: calculateDistanceToLeftBorder(DateTime.parse(data[i].startDate!)) *
                  chartViewWidth /
                  viewRangeToFitScreen,
              top: i == 0 ? 4.0 : 2.0,
              bottom: i == data.length - 1 ? 4.0 : 2.0),
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              data[i].projectName!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10.0),
            ),
          ),
        ));
      }
    }

    return chartBars;
  }

  Widget buildHeader(double chartViewWidth, Color color) {
    List<Widget> headerItems = [];

    DateTime tempDate = fromDate!;

    headerItems.add(SizedBox(
      width: chartViewWidth / viewRangeToFitScreen,
      child: const Text(
        'NAME',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10.0,
        ),
      ),
    ));

    for (int i = 0; i < viewRange!; i++) {
      headerItems.add(SizedBox(
        width: chartViewWidth / viewRangeToFitScreen,
        child: Text(
          '${tempDate.month}/${tempDate.year}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 10.0,
          ),
        ),
      ));
      tempDate = Utils.DateUtils.nextMonth(tempDate);
    }

    return Container(
      height: 25.0,
      color: color.withAlpha(100),
      child: Row(
        children: headerItems,
      ),
    );
  }

  Widget buildGrid(double chartViewWidth) {
    List<Widget> gridColumns = [];

    for (int i = 0; i <= viewRange!; i++) {
      gridColumns.add(Container(
        decoration: BoxDecoration(
            border: Border(
                right:
                BorderSide(color: Colors.grey.withAlpha(100), width: 1.0))),
        width: chartViewWidth / viewRangeToFitScreen,
        //height: 300.0,
      ));
    }

    return Row(
      children: gridColumns,
    );
  }

  Widget buildChartForEachUser(
      List<ProjectModel> userData, double chartViewWidth, UserModel user) {
    Color color = randomColorGenerator();
    var chartBars = buildChartBars(userData, chartViewWidth, color);
    return SizedBox(
      height: chartBars.length * 29.0 + 25.0 + 4.0,
      child: ListView(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Stack(
            fit: StackFit.loose, children: <Widget>[
            buildGrid(chartViewWidth),
            buildHeader(chartViewWidth, color),
            Container(
                margin: const EdgeInsets.only(top: 25.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                            width: chartViewWidth / viewRangeToFitScreen,
                            height: chartBars.length * 29.0 + 4.0,
                            color: color.withAlpha(100),
                            child: Center(
                              child: RotatedBox(
                                quarterTurns:
                                chartBars.length * 29.0 + 4.0 > 50
                                    ? 0
                                    : 0,
                                child: Text(
                                  "${user.firstName!} ${user.lastName!}",
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: chartBars,
                        ),
                      ],
                    ),
                  ],
                )),
          ],
          ),
        ],
      ),
    );
  }

  List<Widget> buildChartContent(double chartViewWidth) {
    List<Widget> chartContent = [];

    usersInChart!.forEach((user) {
      List<ProjectModel> projectsOfUser = [];

      projectsOfUser = projectsData!.where((project) => project.members!.where((element) => element.memberUsername == user.username!).isNotEmpty)
          .toList();

      if (projectsOfUser.isNotEmpty) {
        chartContent
            .add(buildChartForEachUser(projectsOfUser, chartViewWidth, user));
      }
    });

    return chartContent;
  }

  @override
  Widget build(BuildContext context) {
    var chartViewWidth = MediaQuery.of(context).size.width;
    var screenOrientation = MediaQuery.of(context).orientation;

    screenOrientation == Orientation.landscape
        ? viewRangeToFitScreen = 12
        : viewRangeToFitScreen = 6;

    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: ListView(
          physics: const NeverScrollableScrollPhysics(),
        children: buildChartContent(chartViewWidth),
      ),
    );
  }
}