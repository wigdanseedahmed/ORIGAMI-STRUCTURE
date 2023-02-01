import 'package:origami_structure/imports.dart';

class TaskCardMA extends StatelessWidget {

  final String? taskTitle;
  final String? taskProjectName;
  final String? taskDueDateTime;
  final String? taskStatus;
  final double? taskProgressPercentage;
  final List<String>? taskAssignedTo;
  final Color? colour;
  final NavigationMenu navigationMenu;


   const TaskCardMA({
    Key? key,
    required this.taskTitle,
    required this.taskProjectName,
    required this.taskDueDateTime,
    required this.taskStatus,
    required this.colour,
     required this.navigationMenu, this.taskAssignedTo, required this.taskProgressPercentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, right: 16, left: 16),
      child: GestureDetector(
        onTap:(){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return EditTaskScreenMA(
                  projectName: taskProjectName,
                  taskTitle: taskTitle,
                  listStatus: taskStatus,
                  navigationMenu: navigationMenu,
                );
              },
            ),
          );
        },
        child: Container(
          constraints: const BoxConstraints(maxWidth: 350),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            elevation: 0.0,
            //shadowColor: colour,
            color: DynamicTheme.of(context)?.brightness == Brightness.light
                ? Colors.white : Colors.grey.shade800,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              height: MediaQuery.of(context).size.height * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      taskProjectName!,
                      style: TextStyle(
                        fontSize: 20,
                        color: DynamicTheme.of(context)?.brightness == Brightness.light
                            ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: _Tile(
                      dotColor: colour == null? Colors.transparent : colour!,
                      title: taskTitle!,
                      subtitle: taskDueDateTime == null ? "":(DateTime.parse(taskDueDateTime!).difference(DateTime.now()).inDays < 0)
                          ? "Late ${( DateTime.parse(taskDueDateTime!).difference(DateTime.now()).inDays) * -1} days"
                          : "Due ${DateTime.parse(taskDueDateTime!).difference(DateTime.now()).inDays > 0 ? "in ${( DateTime.parse(taskDueDateTime!).difference(DateTime.now()).inDays)} days" : "today"}",

                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: statusColours![taskStatus! == "Todo" ? 0 : taskStatus! == "On Hold" ? 1  : taskStatus! == "In Progress" ? 2 : taskStatus! == "Done" ? 3 : 4 ],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: (){},
                          child: Text(
                            taskStatus == null ? "" : taskStatus!,
                          ),
                        ),
                        taskAssignedTo == null ? Container() :
                        TaskCardListProfileImage(
                          assignedTo: taskAssignedTo!,
                          onPressed: (){},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Container(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: LinearPercentIndicator(
                            //leaner progress bar
                            animation: true,
                            animationDuration: 1000,
                            lineHeight: 16.0,
                            percent:  taskProgressPercentage == null? 0: taskProgressPercentage!/100,
                              backgroundColor: Colors.transparent,
                            progressColor: colour,
                            barRadius: const Radius.circular(16),
                            center: Text(
                              taskProgressPercentage == null? "0.0%" : "$taskProgressPercentage%",
                              style: const TextStyle(
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        /*const SizedBox(width:10),
                        _IconButton(
                          iconData: EvaIcons.peopleOutline,
                          onPressed:(){},
                          totalContributors: taskAssignedTo!.length,
                        ),*/
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


/* -----------------------------> COMPONENTS <------------------------------ */
class _Tile extends StatelessWidget {
  const _Tile({
    required this.dotColor,
    required this.title,
    required this.subtitle,
    Key? key,
  }) : super(key: key);

  final Color dotColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _dot(dotColor),
              const SizedBox(width: 8),
              Expanded(child: _title(title)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _subtitle(subtitle, context),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _dot(Color color) {
    return CircleAvatar(
      radius: 4,
      backgroundColor: color,
    );
  }

  Widget _title(String data) {
    return Text(
      data,
      textAlign: TextAlign.left,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _subtitle(String data, BuildContext context) {
    return Text(
      data,
      style: Theme.of(context).textTheme.caption,
      textAlign: TextAlign.left,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}



