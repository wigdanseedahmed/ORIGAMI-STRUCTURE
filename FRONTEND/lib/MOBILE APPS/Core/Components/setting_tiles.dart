import 'package:origami_structure/imports.dart';

InkWell settingTilesMA(
    {required BuildContext context,
      required VoidCallback? onTap,
      required String title,
      required String subtitle,
      required IconData icon}) {
  return InkWell(
    splashColor: primaryColour,
    onTap: onTap,
    child: ListTile(
      trailing: Icon(
        icon,
        color: primaryColour,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Fira Sans',
          fontWeight: FontWeight.bold,
          // fontFamily: 'Ninto',
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
            fontFamily: 'Fira Sans',
            fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}


InkWell settingListTilesMA(
    {required BuildContext context,
      required void Function(bool)? onChanged,
      required String title,
      required String subtitle,
      required bool value}) {
  return InkWell(
    splashColor: primaryColour,
    child: SwitchListTile(
      activeColor: primaryColour,//Theme.of(context).primaryColor,
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Fira Sans',
          fontWeight: FontWeight.bold,
          // fontFamily: 'Ninto',
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontFamily: 'Fira Sans',
          fontWeight: FontWeight.w500,
        ),
      ),
      value: value,
      onChanged: onChanged,
    ),
  );
}

InkWell settingTilesWS(
    {required BuildContext context,
      required VoidCallback? onTap,
      required String title,
      required String subtitle,
      required IconData icon,
    }) {
  return InkWell(
    splashColor: primaryColour,
    onTap: onTap,
    child: ListTile(
      trailing: Icon(
        icon,
        color: primaryColour,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Fira Sans',
          fontWeight: FontWeight.bold,
          // fontFamily: 'Ninto',
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontFamily: 'Fira Sans',
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}


InkWell settingListTilesWS(
    {required BuildContext context,
      required void Function(bool)? onChanged,
      required String title,
      required String subtitle,
      required bool value}) {
  return InkWell(
    splashColor: primaryColour,
    child: SwitchListTile(
      activeColor: primaryColour,//Theme.of(context).primaryColor,
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Fira Sans',
          fontWeight: FontWeight.bold,
          // fontFamily: 'Ninto',
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontFamily: 'Fira Sans',
          fontWeight: FontWeight.w500,
        ),
      ),
      value: value,
      onChanged: onChanged,
    ),
  );
}

