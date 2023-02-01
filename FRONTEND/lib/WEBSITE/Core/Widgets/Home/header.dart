import 'package:origami_structure/imports.dart';

class HeaderWS extends StatelessWidget {
  const HeaderWS({
    Key? key,
    required this.showTaskCalendar,
    this.user,
    this.taskList,
    this.allUsers,
    this.allProjectsData,
    required this.pageName,
    this.onSearch,
  }) : super(key: key);

  final bool showTaskCalendar;
  final UserModel? user;
  final List<UserModel>? allUsers;
  final List<ProjectModel>? allProjectsData;
  final Function(String value)? onSearch;

  final String pageName;

  final List<TaskModel>? taskList;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const TodayText(),
        const SizedBox(width: 20),
        Expanded(
          child: pageName == "Home"
              ? HomeSearchBar(
                  taskList: taskList!,
                  allProjectsData: allProjectsData,
                  allUsersData: allUsers,
                )
              : AllProjectsSearchBar(
                  allProjectsData: allProjectsData,
                  allUsersData: allUsers,
                ),
        ),
        showTaskCalendar == false ? Container() : const SizedBox(width: 20),
        showTaskCalendar == false
            ? Container()
            : IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TaskCalendarScreenWS(
                        user: user!,
                        allUsers: allUsers!,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.calendar_month_outlined),
              )
      ],
    );
  }
}
