import 'package:origami_structure/imports.dart';

class CommentComponent extends StatefulWidget {
  final String? name;

  const CommentComponent({Key? key, this.name}) : super(key: key);

  @override
  _CommentComponentState createState() => _CommentComponentState();
}

class _CommentComponentState extends State<CommentComponent> {
  List<CommentModel> commentList = [];
  String selectedEmoji = '';

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
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        children: [
          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              CommentModel data = commentList[index];
              return Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: CircleAvatar(
                          radius: 25,
                          backgroundImage: Image.network(data.image!).image),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                data.username!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              PopupMenuButton(
                                itemBuilder: (context) {
                                  List<PopupMenuEntry<Object>> list = [];
                                  list.add(
                                    const PopupMenuItem(
                                        child: Text('Edit'), value: 'Edit'),
                                  );
                                  list.add(
                                    const PopupMenuItem(
                                        child: Text('Delete'), value: 'Delete'),
                                  );
                                  return list;
                                },
                                onSelected: (dynamic v) {
                                  if (v == 'Edit') {
                                    data.focus = true;
                                  } else {
                                    commentList.remove(data);
                                  }
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                          TextField(
                            controller:
                                TextEditingController(text: data.content),
                            maxLines: 6,
                            minLines: 1,
                            keyboardType: TextInputType.text,
                            autofocus: data.focus!,
                            onSubmitted: (v) {
                              data.content = v;
                              data.focus = false;
                              setState(() {});
                            },
                            style: const TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              isDense: true,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(top: 5),
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 4, 12, 4),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.emoji_emotions_sharp,
                                    ),
                                    onPressed: () {
                                      // showDialog(
                                      //   useSafeArea: true,
                                      //   builder: (_) => EmojiPicker(
                                      //     buttonMode: ButtonMode.CUPERTINO,
                                      //     rows: 3,
                                      //     columns: 7,
                                      //     recommendKeywords: ["racing", "horse"],
                                      //     numRecommended: 5,
                                      //     onEmojiSelected: (Emoji emoji, Category category) {
                                      //       data.selectedEmoji = emoji.emoji;
                                      //       setState(() {});
                                      //       finish(context);
                                      //     },
                                      //   ),
                                      //   context: context,
                                      // );
                                    },
                                  )).visible(
                                data.selectedEmoji == null || data.selectedEmoji!.isEmpty,
                                defaultWidget: Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    padding:
                                        const EdgeInsets.fromLTRB(12, 4, 12, 4),
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        /*    showDialog(
                                        useSafeArea: true,
                                        builder: (_) => EmojiPicker(
                                          buttonMode: ButtonMode.CUPERTINO,
                                          rows: 3,
                                          columns: 7,
                                          recommendKeywords: ["racing", "horse"],
                                          numRecommended: 5,
                                          onEmojiSelected: (Emoji emoji, Category category) {
                                            data.selectedEmoji = emoji.emoji;
                                            setState(() {});
                                            finish(context);
                                          },
                                        ),
                                        context: context,
                                      );*/
                                      },
                                      child: Text(
                                        data.selectedEmoji!,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(data.time!),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
            itemCount: commentList.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              const Icon(
                Icons.messenger_outline_outlined,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: TextFormField(
                  controller: TextEditingController(
                    text: '',
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  cursorColor: Colors.grey,
                  minLines: 1,
                  decoration: commentTaskTextFieldInputDecoration(
                      color: Colors.grey,
                      hintText: 'Add comment',
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8)),
                  onFieldSubmitted: (v) {
                    commentList.add(
                      CommentModel(
                          image:
                              'https://images.unsplash.com/photo-1532074205216-d0e1f4b87368?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
                          content: v,
                          focus: false,
                          selectedEmoji: selectedEmoji,
                          username: widget.name,
                          time: 'Just now'),
                    );
                    selectedEmoji = '';
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              const Icon(
                Icons.attach_file_outlined,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
