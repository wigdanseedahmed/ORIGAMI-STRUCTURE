import 'package:origami_structure/imports.dart';

Widget topBarMenuItemsWS(
    {required BuildContext context,String title = 'Title Menu', isActive = false, Function()? onTap}) {
  return Padding(
    padding: EdgeInsets.only(right: MediaQuery.of(context).size.width / 19),
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isActive ? kViolet : Colors.grey,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            isActive
                ? Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      color: kViolet,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    ),
  );
}
