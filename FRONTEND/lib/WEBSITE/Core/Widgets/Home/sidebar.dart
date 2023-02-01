import 'package:origami_structure/imports.dart';

class SidebarWS extends StatelessWidget {
  const SidebarWS({
    Key? key,
    required this.userData,
    this.projectData,
  }) : super(key: key);

  final UserModel userData;
  final ProjectModel? projectData;

  @override
  Widget build(BuildContext context) {

    String selectedSideMenuItem = "Dashboard";

    return Container(
      color: Theme.of(context).cardColor,
      child: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Divider(thickness: 1),
            SelectionButtonWS(
              data: [
                SelectionButtonData(
                  activeIcon: EvaIcons.grid,
                  icon: EvaIcons.gridOutline,
                  title: "Dashboard",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.archive,
                  icon: EvaIcons.archiveOutline,
                  title: "Weekly Report",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.calendar,
                  icon: EvaIcons.calendarOutline,
                  title: "Projects",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.email,
                  icon: EvaIcons.emailOutline,
                  title: "Notification",
                  totalNotification: null,
                ),
                SelectionButtonData(
                  activeIcon: EvaIcons.settings,
                  icon: EvaIcons.settingsOutline,
                  title: "Setting",
                  totalNotification: null,
                ),
              ],
              onSelected: (index, value) {
                selectedSideMenuItem = value.title;
                // log("index : $index | label : ${value.label}");
              }, initialSelected: selectedSideMenuItem == "Dashboard" ? 0 : selectedSideMenuItem == "Weekly Report" ? 1 : selectedSideMenuItem == "Projects" ? 2 : selectedSideMenuItem == "Notification" ? 3 : 4,
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
