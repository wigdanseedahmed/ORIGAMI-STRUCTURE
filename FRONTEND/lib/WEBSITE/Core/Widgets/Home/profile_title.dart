import 'package:origami_structure/imports.dart';

class ProfileTileWS extends StatelessWidget {
  const ProfileTileWS(
      {Key? key, required this.userData, required this.onPressedNotification, })
      : super(key: key);

  final UserModel userData;
  final Function() onPressedNotification;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: userData.userPhotoFile == null ? Container() :
      CircleAvatar(backgroundImage: MemoryImage(base64Decode(userData.userPhotoFile!))),
      title: Text(
        "${userData.firstName} ${userData.lastName}",
        style: const TextStyle(fontSize: 14, color: Colors.white),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        userData.email!,
        style: const TextStyle(fontSize: 12, color:Color.fromRGBO(170, 170, 170, 1)),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        onPressed: onPressedNotification,
        icon: const Icon(EvaIcons.bellOutline),
        tooltip: "notification",
      ),
    );
  }
}