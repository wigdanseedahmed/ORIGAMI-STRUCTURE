import 'package:origami_structure/imports.dart';

class ChattingCardWS extends StatelessWidget {
  const ChattingCardWS({required this.data, required this.onPressed, Key? key})
      : super(key: key);

  final CommentModel data;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          leading: Stack(
            children: [
              CircleAvatar(backgroundImage: MemoryImage(base64Decode(data.image!))),
              CircleAvatar(
                backgroundColor: data.isOnline! ? Colors.green : Colors.grey,
                radius: 5,
              ),
            ],
          ),
          title: Text(
            data.taskTitle!,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            data.content!,
            style: const TextStyle(
              fontSize: 11,
              color: Color.fromRGBO(170, 170, 170, 1),
            ),
          ),
          onTap: onPressed,
          trailing: (!data.focus!)  //&& data.totalUnread > 1)
              ? _notification(2) //data.totalUnread
              : Icon(
                  Icons.check,
                  color: data.focus! ? Colors.grey : Colors.green,
                ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _notification(int total) {
    return Container(
      width: 30,
      height: 30,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: Text(
        (total >= 100) ? "99+" : "$total",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
