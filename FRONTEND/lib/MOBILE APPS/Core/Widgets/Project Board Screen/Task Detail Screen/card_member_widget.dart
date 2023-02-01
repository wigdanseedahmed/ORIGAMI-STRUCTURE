import 'package:origami_structure/imports.dart';

class CardMemberWidget extends StatefulWidget {
  final List<CardMembersModel>? cardMembersModel;

  const CardMemberWidget({
    Key? key,
    this.cardMembersModel,
  }) : super(key: key);

  @override
  _CardMemberWidgetState createState() => _CardMemberWidgetState();
}

class _CardMemberWidgetState extends State<CardMemberWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          CardMembersModel data = widget.cardMembersModel![index];

          return GestureDetector(
            onTap: () {
              data.isActive = !data.isActive;
              setState(() {});
            },
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                Image.network(data.profileImg!).image,
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.name!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                data.userName!,
                              ),
                            ],
                          ),
                        ],
                      ),
                      data.isActive
                          ? const Positioned(
                              right: 0,
                              top: 10,
                              child: Icon(
                                Icons.done,
                                color: Colors.red,
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: widget.cardMembersModel?.length ?? 0,
      ),
    );
  }
}
