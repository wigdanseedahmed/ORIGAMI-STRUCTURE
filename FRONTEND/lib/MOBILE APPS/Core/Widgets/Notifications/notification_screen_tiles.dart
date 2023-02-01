import 'package:origami_structure/imports.dart';

class NotificationScreenTiles extends StatelessWidget {
  
  final String? title;
  final String? subtitle;
  final String? name;
  final String? assignedBy;
  final String? assignedByInitials;
  final String? assignedByImage;
  final String? content;
  final String? timeAgo;
  final Function()? onTap;
  final bool? enable;

  const NotificationScreenTiles({
    Key? key,
    this.title,
    this.subtitle,
    this.assignedBy,
    this.assignedByInitials,
    this.assignedByImage,
    this.timeAgo,
    this.onTap,
    this.enable,
    this.name,
    this.content,
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                assignedByImage == null
                    ? Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(202, 202, 202, 1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            assignedByInitials!,
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * 0.05,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromRGBO(76, 75, 75, 1),
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(assignedByImage!),
                        ),
                      ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: title,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                        ),
                        const TextSpan(text: " "),
                        TextSpan(
                            text: subtitle,
                            style: const TextStyle(color: Colors.black),
                        ),
                        const TextSpan(text: " "),
                        TextSpan(
                          text: timeAgo,
                          style: TextStyle(color: Colors.grey.shade500),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          /*
          postImage != null
              ? SizedBox(
                  width: 50,
                  height: 50,
                  child: ClipRRect(child: Image.network(postImage!)),
                )
              : Container(
                  height: 35,
                  width: 110,
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(
                    child: Text(
                      'Follow',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                */
        ],
      ),
    );
  }
}
