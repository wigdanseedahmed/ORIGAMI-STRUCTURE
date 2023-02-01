import 'package:origami_structure/imports.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({Key? key,}) : super(key: key);

  

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: 12,
          itemBuilder: (context, index) {
            return Slidable(
              child: NotificationScreenTiles(
                title: 'Origami Structure',
                //TODO: Project Name
                subtitle: 'Thanks ',
                //TODO: Task assigned/ task due/ project assigned
                assignedBy: "usrename",
                //TODO: Task assigned/ task due/ project assigned
                assignedByInitials: "FL",
                assignedByImage: null,
                //TODO: Task assigned by/ project created by
                enable: true,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                ), //TODO: Go to task/ project
                
              ),
              endActionPane: const ActionPane(
                // A motion is a widget used to control how the pane animates.
                motion: ScrollMotion(),

                // All actions are defined in the children parameter.
                children: [
                  SlidableAction(
                    // An action can be bigger than the others.
                    flex: 2,
                    onPressed: null,
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    icon: Icons.info_outline,
                    label: 'Information',
                  ),
                  SlidableAction(
                    onPressed: null,
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.red,
                    icon: Icons.delete_outline_sharp,
                    label: 'Delete',
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          }),
    );
  }
}

/*
ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: notificationItem(notifications[index]),
              secondaryActions: <Widget>[
                Container(
                  height: 60,
                  color: Colors.grey.shade500,
                  child: Icon(Icons.info_outline, color: Colors.white,)
                ),
                Container(
                  height: 60,
                  color: Colors.red,
                  child: Icon(Icons.delete_outline_sharp, color: Colors.white,)
                ),
              ],
            );
        }
      ) 
 */
