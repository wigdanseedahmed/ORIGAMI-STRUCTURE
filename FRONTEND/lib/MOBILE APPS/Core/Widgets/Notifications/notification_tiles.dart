import 'package:origami_structure/imports.dart';

class NotificationTiles extends StatelessWidget {
  final String? title, subtitle;
  final Function()? onTap;
  final bool? enable;

  const NotificationTiles({
    Key? key,
    this.title,
    this.subtitle,
    this.onTap,
    this.enable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 50.0,
        width: 50.0,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/user_profile.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        title!,
        style: const TextStyle(color: kDarkNotificationColor),
      ),
      subtitle: Text(
        subtitle!,
        style: const TextStyle(color: kLightNotificationColor),
      ),
      onTap: onTap,
      enabled: enable!,
    );
  }
}
