import 'package:origami_structure/imports.dart';


class CustomBottomNavBarMA extends StatelessWidget {
  const CustomBottomNavBarMA({
    Key? key,
    required this.selectedMenu
  }) : super(key: key);

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(
              EvaIcons.homeOutline,
              size: 30.0,
              color: MenuState.dashboardScreen == selectedMenu
                  ? primaryColour
                  : Colors.grey,
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const HomeScreenMA(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              FontAwesomeIcons.calendarWeek,
              color: MenuState.weeklyMeetingReportScreen == selectedMenu
                  ? primaryColour
                  : Colors.grey,
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const WeeklyTaskReportScreenMA(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 9.0),
            child: IconButton(
              icon: Icon(
                FontAwesomeIcons.trello,
                color: primaryColour,
                size: 45.0,
              ),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProjectScreenMA(),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              EvaIcons.bellOutline,
              size: 30.0,
              color: MenuState.navigatorScreen == selectedMenu
                  ? primaryColour
                  : Colors.grey,
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>  const TestingScreen(),//NotificationScreen(), MainExample()
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              EvaIcons.optionsOutline,
              size: 30.0,
              color: MenuState.settingsScreen == selectedMenu
                  ? primaryColour
                  : Colors.grey,
            ),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SettingsScreenMA(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
