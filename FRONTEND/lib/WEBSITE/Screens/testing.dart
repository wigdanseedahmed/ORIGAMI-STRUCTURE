import 'package:origami_structure/imports.dart';

import 'dart:ui';

class CardScreen extends StatefulWidget {
  late TaskModel? card;
  late String? cardName;

  CardScreen({Key? key, this.cardName, this.card, }) : super(key: key);

  @override
  State<CardScreen> createState() =>
      _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  late ProjectModel boards;

  var descriptionTxtCtrl = TextEditingController();

  List<UserModel> users = [
    UserModel(
      userID: "12345",
      username: "name1",
      firstName: "Name 1",
      email: '123456@gmail.com',
      userPhotoFile: 'assets/images/BlueBG.png',
    ),
    UserModel(
      userID: "12345",
      username: "name2",
      firstName: "Name 2",
      email: '123456@gmail.com',
      userPhotoFile: 'assets/images/BlueBG.png',
    ),
    UserModel(
      userID: "12345",
      username: "name3",
      firstName: "Name 3",
      email: '123456@gmail.com',
      userPhotoFile: 'assets/images/BlueBG.png',
    ),
    UserModel(
      userID: "12345",
      username: "Test4",
      firstName: "Cun cun cute",
      email: '123456@gmail.com',
      userPhotoFile: 'assets/images/BlueBG.png',
    ),
  ];
  List<UserModel> pickedUsers = [];

  ///TODO: Load users from database to pickedUsers
  List<bool> flagPickedUsers = [];

  ///StartDate picker
  ///TODO: Load selectedStartDate from database, if = null, assign Datetime now to it
  var startDateTxtCtrl = TextEditingController();
  DateTime selectedStartDate = DateTime.now();

  Future<Null> _selectedStartDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
        context: context,
        initialDate: selectedStartDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101)))!;
    setState(() {
      selectedStartDate = picked;
      if (selectedStartDate.year != DateTime
          .now()
          .year) {
        startDateTxtCtrl.text =
        "${selectedStartDate.day} thg ${selectedStartDate
            .month}, ${selectedStartDate.year}";
      } else {
        startDateTxtCtrl.text =
        "${selectedStartDate.day} thg ${selectedStartDate.month}";
      }
    });
  }

  ///EndDate picker
  ///TODO: Load selectedEndDate from database, if = null, assign Datetime now to it
  var endDateTxtCtrl = TextEditingController();
  DateTime selectedEndDate = DateTime.now();

  Future<Null> _selectedEndDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
        context: context,
        initialDate: selectedEndDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101)))!;
    setState(() {
      selectedEndDate = picked;
      if (selectedEndDate.year != DateTime
          .now()
          .year) {
        endDateTxtCtrl.text =
        "${selectedEndDate.day} thg ${selectedEndDate.month}, ${selectedEndDate
            .year}";
      } else {
        endDateTxtCtrl.text =
        "${selectedEndDate.day} thg ${selectedEndDate.month}";
      }
    });
  }

  ///StartTime Picker
  ///TODO: Load selectedStartTime from database, if = null, assign TimeOfDay(hour: 9, minute: 0) to it
  TimeOfDay selectedStartTime = const TimeOfDay(hour: 9, minute: 0);
  var startTimeTxtCtrl = TextEditingController();

  Future<Null> _selectedStartTime(BuildContext context) async {
    final TimeOfDay picked = (await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    ))!;
    setState(() {
      selectedStartTime = picked;
      startTimeTxtCtrl.text = "${selectedStartTime.hour}:";
      if (selectedStartTime.minute >= 10) {
        startTimeTxtCtrl.text =
            startTimeTxtCtrl.text + selectedStartTime.minute.toString();
      } else {
        startTimeTxtCtrl.text =
        "${startTimeTxtCtrl.text}0${selectedStartTime.minute}";
      }
    });
  }

  ///EndTime Picker
  ///TODO: Load selectedEndTime from database, if = null, assign TimeOfDay(hour: 9, minute: 0) to it
  TimeOfDay selectedEndTime = const TimeOfDay(hour: 9, minute: 0);
  var endTimeTxtCtrl = TextEditingController();

  Future<Null> _selectedEndTime(BuildContext context) async {
    final TimeOfDay picked = (await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
    ))!;
    setState(() {
      selectedEndTime = picked;
      endTimeTxtCtrl.text = "${selectedEndTime.hour}:";
      if (selectedEndTime.minute >= 10) {
        endTimeTxtCtrl.text =
            endTimeTxtCtrl.text + selectedEndTime.minute.toString();
      } else {
        endTimeTxtCtrl.text =
        "${endTimeTxtCtrl.text}0${selectedEndTime.minute}";
      }
    });
  }

  String? selectedNotiTime = "Không nhắc nhở";
  List<String> notificationTimeList = [
    "Không nhắc nhở",
    "Vào ngày hết hạn",
    "5 phút trước",
    "10 phút trước",
    "15 phút trước",
    "1 giờ trước",
    "2 giờ trước",
    "1 ngày trước",
    "2 ngày trước"
  ];

  ///String value to set for startDate, endDate TextButton
  ///TODO: if startDate (timestamp type) from database = null, then string = null
  ///TODO: else startDateStr = "Start on $selectedDay month $selectedMonth, year $selectedYear at the time $selectedTimeStr"
  String startDateStr = "";

  ///TODO: if endDate (timestamp type) from database = null, then string = null
  ///TODO: else endDateStr = "Expires on $selectedDay month $selectedMonth, year $selectedYear at the time $selectedTimeStr";
  String endDateStr = "";
  bool? status = false;

  ///TODO: Load status from database

  bool isHaveTaskList = true;
  List<String> taskListNames = [
    "Name 1",
    "Name 2",
    "Name 3",
  ];
  bool isAddTask = false;
  bool isChangeTaskListName = false;
  bool isChangeListName = false;
  int xChangeTaskListName = -1;
  int yChangeTaskListName = -1;
  List<List<String>> tasks = [
    [
      "Name 11",
      "Name 12",
      "Name 13",
    ],
    [
      "Name 21",
      "Name 22",
    ],
    [
      "Name 31",
      "Name 32",
      "Name 33",
    ],
  ];
  List<List<bool>> isTaskDone = [
    [
      true,
      true,
      true,
    ],
    [
      true,
      true,
    ],
    [
      true,
      false,
      true,
    ],
  ];
  List<bool> isShow = [
    true,
    true,
    true,
  ];
  List<List<TextEditingController>> controllers = [];
  List<TextEditingController> controllersList = [];

  ///For comment
  var commentEnterTxtCtrl = TextEditingController();

  ///TODO: Load currentUser data
  ///UserModel currentUser = ...;
  ///TODO: Delete this when load current data
  String currentUserID = "12345";
  String currentUserName = "Test4";
  String currentUserAvatar = "assets/images/BlueBG.png";

  ///TODO: Load comment list
  List<CommentModel> commentList = [];

  ///TODO: Delete these when comment list is loaded
  ///TODO: in UI, change the commentUserIDList to commentList and match suitable values
  List<String> commentUserIDList = ["12345", "1234", "1234"];
  List<String> commentUserNameList = ["Test4", "name1", "name1"];
  List<String> commentUserAvatarList = [
    "assets/images/BlueBG.png",
    "assets/images/BlueBG.png",
    "assets/images/BlueBG.png"
  ];
  List<String> commentContentList = [
    "Test comment for Test4",
    "Test comment for name1",
    "Test test test test test comment 2 for name1"
  ];
  List<DateTime> commentDateList = [
    DateTime(2021, 7, 7, 8, 30),
    DateTime(2021, 7, 4, 9, 30),
    DateTime(2021, 6, 30, 10, 30)
  ];

  List<TextEditingController> commentContentTxtCtrlList = [];

  @override
  void initState() {
    super.initState();
    descriptionTxtCtrl.value = TextEditingValue(text: widget.card!.taskDetail!);
    for (UserModel user in users) {
      var foundUser = pickedUsers.where((element) =>
      element.userID == user.userID);
      if (foundUser.isNotEmpty) {
        flagPickedUsers.add(true);
      } else {
        flagPickedUsers.add(false);
      }
    }

    for (int index = 0; index < commentUserIDList.length; index++) {
      commentContentTxtCtrlList.add(TextEditingController());
      commentContentTxtCtrlList[index].text = commentContentList[index];
    }

    if (widget.card!.startDate != "") {
      selectedStartDate = DateFormat("yyyy-MM-dd").parse(widget.card!.startDate!);
      var selectedDay = selectedStartDate.day;
      var selectedMonth = selectedStartDate.month;
      var selectedYear = selectedStartDate.year;
      startDateStr =
      "Start on $selectedDay month $selectedMonth, year $selectedYear ";
    }

    if (widget.card!.deadlineDate != "") {
      selectedEndDate = DateFormat("yyyy-MM-dd").parse(widget.card!.deadlineDate!);
      var selectedDay = selectedEndDate.day;
      var selectedMonth = selectedEndDate.month;
      var selectedYear = selectedEndDate.year;
      endDateStr =
      "Expires on $selectedDay month $selectedMonth, year $selectedYear ";
    }

    tasks = [
      [
        "Name 11",
        "Name 12",
        "Name 13",
      ],
      [
        "Name 21",
        "Name 22",
      ],
      [
        "Name 31",
        "Name 32",
        "Name 33",
      ],
    ];
    controllers = [];
    for (int i = 0; i < tasks.length; i++) {
      controllersList.add(TextEditingController.fromValue(
          TextEditingValue(text: taskListNames[i])));
      controllers.add([]);
      for (int j = 0; j < tasks[i].length; j++) {
        controllers[i].add(TextEditingController.fromValue(
            TextEditingValue(text: tasks[i][j])));
      }
    }
  }

  void addPickedMember(UserModel pickedUser) {
    setState(() {
      pickedUsers.add(pickedUser);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromRGBO(244, 245, 247, 1.0),
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            isAddTask
                ? "New item"
                : isChangeTaskListName
                ? "Edit item"
                : isChangeListName
                ? "Edit to-do list"
                : "",
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () {
              if (isAddTask) {
                isAddTask = false;
                FocusScope.of(context).unfocus();
              } else if (isChangeTaskListName) {
                isChangeTaskListName = false;
                xChangeTaskListName = -1;
                yChangeTaskListName = -1;
                FocusScope.of(context).unfocus();
              } else if (isChangeListName) {
                isChangeListName = false;
                xChangeTaskListName = -1;
                FocusScope.of(context).unfocus();
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          elevation: 0.0,
          actions: [
            isAddTask || isChangeTaskListName || isChangeListName
                ? IconButton(
              icon: const Icon(
                Icons.check,
                color: Colors.black,
              ),
              onPressed: () {
                if (isAddTask) {
                  ///TODO: Add new task
                  isAddTask = false;
                  FocusScope.of(context).unfocus();
                } else if (isChangeTaskListName) {
                  ///TODO: Change value at [xChangeTaskListName][yChangeTaskListName]
                  isChangeTaskListName = false;
                  xChangeTaskListName = -1;
                  yChangeTaskListName = -1;
                  FocusScope.of(context).unfocus();
                } else if (isChangeListName) {
                  ///TODO: Change name at [xChangeTaskListName]
                  isChangeListName = false;
                  xChangeTaskListName = -1;
                  FocusScope.of(context).unfocus();
                }
              },
            )
                : PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
                onSelected: (value) {
                  switch (value) {
                    case "Move card":
                    /*Route route = MaterialPageRoute(
                                builder: (context) => MoveCardScreen());
                                Navigator.push(context, route);
                                */

                      break;
                    case "Remove Card":
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) =>
                            AlertDialog(
                              title: const Text(
                                'Remove Card',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              content: SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.8,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                        "All actions will be removed from the activity notification. Cannot undo."),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .end,
                                      children: [
                                        TextButton(
                                          child: const Text(
                                            'CANCEL',
                                            style: TextStyle(
                                                fontWeight: FontWeight
                                                    .bold),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: const Text(
                                            'ERASE',
                                            style: TextStyle(
                                                fontWeight: FontWeight
                                                    .bold),
                                          ),
                                          onPressed: () {
                                            setState(() async {
                                              /* DatabaseService
                                                        .reduceCardNumberInBoard(
                                                        card.id);
                                                    await DatabaseService
                                                        .deleteCard(
                                                        card.id);*/
                                            });
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      );
                      break;
                  }
                },
                itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: "Move card",
                    child: Text('Move card'),
                  ),
                  const PopupMenuItem<String>(
                    value: "Remove Card",
                    child: Text('Remove Card'),
                  ),
                ])
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [

            ///Card name
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 30.0),

                ///TODO: Change Tên thẻ to $cardName when data is loaded
                child: Text(
                    widget.card!.taskName!, style: const TextStyle(fontSize: 30)),
              ),
            ),

            ///Card auto-description (user cannot change this description)
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              color: Colors.white,
              child: const Padding(
                padding: EdgeInsets.only(
                    left: 25.0, top: 15.0, bottom: 20.0),

                ///TODO: Change Tên danh sách to $cardlistName
                ///TODO: Change Tên bảng to $boardName
                child: Text("List List Name in Table Name",
                    style: TextStyle(fontSize: 20)),
              ),
            ),

            ///Card Description (user can change this description)
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              padding: const EdgeInsets.only(
                left: 25,
                right: 25,
                top: 5.0,
                bottom: 5.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: Colors.grey.shade400),
                    bottom: BorderSide(color: Colors.grey.shade400)),
              ),
              child: TextField(

                ///TODO: load data from database to descriptionTxtCtrl.text
                controller: descriptionTxtCtrl,
                style: const TextStyle(fontSize: 20),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "Add tag description...",
                  hintStyle: TextStyle(fontSize: 20),
                  contentPadding: EdgeInsets.only(bottom: 0.0),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            ///Label
            InkWell(

              ///TODO: Add Label list to show
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                  top: 20.0,
                  bottom: 20.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey
                      .shade400), bottom: BorderSide(color: Colors.grey
                      .shade400)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.tag),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Labels...",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
              onTap: () {
                ///TODO: Event to open Label list here
              },
            ),

            const SizedBox(
              height: 10,
            ),

            ///Member
            StreamBuilder(
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Container(alignment: FractionalOffset.center,
                        child: const CircularProgressIndicator());
                  } else {
                    users.clear();
                    for (var item in snapshot.data) {
                      UserModel temp = UserModel.fromJson(item);
                      users.add(temp);
                    }
                  }
                  return InkWell(
                    child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      padding: const EdgeInsets.only(
                        left: 25,
                        right: 25,
                        top: 20.0,
                        bottom: 20.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            top: BorderSide(color: Colors.grey.shade400),
                            bottom: BorderSide(
                                color: Colors.grey.shade400)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.person_outline),
                          const SizedBox(
                            width: 20,
                          ),
                          pickedUsers.isEmpty
                              ? const Text(
                            "Member...",
                            style: TextStyle(fontSize: 20),
                          )
                              : SizedBox(
                            height: 50,
                            child: SizedBox(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.5,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: pickedUsers.length,
                                  itemBuilder: (context, index) {
                                    return CircleAvatar(
                                      radius: 25,
                                      backgroundImage: NetworkImage(
                                          pickedUsers[index]
                                              .userPhotoFile!),
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Member of cards',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SingleChildScrollView(
                                              child: Column(
                                                children: List.generate(
                                                  users.length,
                                                      (int index) {
                                                    return Column(
                                                      children: [
                                                        InkWell(
                                                          child: Padding(
                                                            padding: const EdgeInsets
                                                                .fromLTRB(
                                                                16.0,
                                                                14.0, 0,
                                                                14.0),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment
                                                                  .spaceBetween,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    CircleAvatar( radius: 40, backgroundColor: Colors.grey,
                                                                      backgroundImage: MemoryImage(
                                                                          base64Decode(users[index]
                                                                              .userPhotoFile!)
                                                                      ),),

                                                                    const SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment: CrossAxisAlignment
                                                                          .start,
                                                                      children: <
                                                                          Widget>[
                                                                        Align(
                                                                          alignment: Alignment
                                                                              .centerLeft,
                                                                          child: Text(
                                                                              users[index]
                                                                                  .firstName!,
                                                                              textAlign: TextAlign
                                                                                  .left,
                                                                              style: const TextStyle(
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight
                                                                                      .bold)),
                                                                        ),
                                                                        Align(
                                                                          alignment: Alignment
                                                                              .centerLeft,
                                                                          child: Text(
                                                                            '@${users[index]
                                                                                .username!}',
                                                                            textAlign: TextAlign
                                                                                .left,
                                                                            style: const TextStyle(
                                                                                fontSize: 16,
                                                                                fontStyle: FontStyle
                                                                                    .italic),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                flagPickedUsers[index] ==
                                                                    false
                                                                    ? const SizedBox(
                                                                  width: 24,
                                                                )
                                                                    : const Icon(
                                                                    Icons
                                                                        .check),
                                                              ],
                                                            ),
                                                          ),
                                                          onTap: () {
                                                            setState(() {
                                                              if (flagPickedUsers[index] ==
                                                                  true) {
                                                                flagPickedUsers[index] =
                                                                false;
                                                              } else {
                                                                flagPickedUsers[index] =
                                                                true;
                                                              }
                                                            });
                                                          },
                                                        ),
                                                        const Padding(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                              70, 0, 0,
                                                              0),
                                                          child: Divider(
                                                            height: 1,
                                                            color: Colors
                                                                .black,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .end,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    for (int index = 0; index <
                                                        users
                                                            .length; index++) {
                                                      var foundUser = pickedUsers
                                                          .where((
                                                          element) =>
                                                      element.userID ==
                                                          users[index]
                                                              .userID);
                                                      if (foundUser
                                                          .isNotEmpty) {
                                                        flagPickedUsers[index] =
                                                        true;
                                                      } else {
                                                        flagPickedUsers[index] =
                                                        false;
                                                      }
                                                    }
                                                    Navigator.of(
                                                        context,
                                                        rootNavigator: true)
                                                        .pop('dialog');
                                                  },
                                                  child: const Text(
                                                      "CANCEL"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      pickedUsers = [];

                                                      ///Save new picked users
                                                      for (int index = 0; index <
                                                          flagPickedUsers
                                                              .length; index++) {
                                                        if (flagPickedUsers[index]) {
                                                          addPickedMember(
                                                              users[index]);
                                                        }
                                                      }
                                                    });
                                                    Navigator.of(
                                                        context,
                                                        rootNavigator: true)
                                                        .pop('dialog');
                                                  },
                                                  child: const Text(
                                                      "COMPLETED"),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }));
                    },
                  );
                }),

            const SizedBox(
              height: 10,
            ),

            ///DateStart
            InkWell(
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                  top: 20.0,
                  bottom: 13.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time_filled_rounded,
                        color: endDateStr == ""
                            ? Colors.black
                            : (DateTime.now().isBefore(DateTime(
                            selectedEndDate.year, selectedEndDate.month,
                            selectedEndDate.day, selectedEndTime.hour,
                            selectedEndTime.minute)))
                            ? status == true
                            ? Colors.blue
                            : Colors.black
                            : status == true
                            ? Colors.blue
                            : Colors.red),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - 94,
                      child: Text(
                        startDateStr == ""
                            ? "Start day..."
                            : startDateStr,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                startDateTxtCtrl.text =
                "${selectedStartDate.day} thg ${selectedStartDate.month}";
                startTimeTxtCtrl.text = "${selectedStartTime.hour}:";
                if (selectedStartTime.minute >= 10) {
                  startTimeTxtCtrl.text = startTimeTxtCtrl.text +
                      selectedStartTime.minute.toString();
                } else {
                  startTimeTxtCtrl.text =
                  "${startTimeTxtCtrl.text}0${selectedStartTime.minute}";
                }
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      AlertDialog(
                        title: const Text(
                          'Start day',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: SizedBox(
                          height: 120,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width / 3.7,
                                    child: TextField(
                                      controller: startDateTxtCtrl,
                                      readOnly: true,
                                      showCursor: true,
                                      onTap: () {
                                        _selectedStartDate(context);
                                      },
                                      decoration: const InputDecoration(
                                        hintText: "Choose a date",
                                        contentPadding: EdgeInsets.only(
                                            bottom: 0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width / 3.7,
                                    child: TextField(
                                      controller: startTimeTxtCtrl,
                                      readOnly: true,
                                      showCursor: true,
                                      onTap: () {
                                        _selectedStartTime(context);
                                      },
                                      decoration: const InputDecoration(
                                        hintText: "Choose time",
                                        contentPadding: EdgeInsets.only(
                                            bottom: 0),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      startDateTxtCtrl.text = "";
                                      startTimeTxtCtrl.text = "";
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      ///Reset start date, if from database not null, reset it by the data
                                      ///else reset it by DateTime.now()
                                      selectedStartDate =
                                          DateTime.now();

                                      ///Reset start time, if from database not null, reset it by the data
                                      ///else reset it by TimeOfDay(hour: 9, minute: 0)
                                      selectedStartTime =
                                      const TimeOfDay(
                                          hour: 9, minute: 0);
                                      Navigator.of(
                                          context, rootNavigator: true)
                                          .pop('dialog');
                                    },
                                    child: const Text("CANCEL"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (startDateTxtCtrl.text == "" &&
                                          startTimeTxtCtrl.text == "") {
                                        setState(() {
                                          startDateStr = "";
                                        });

                                        ///Save null to database
                                      } else {
                                        setState(() {
                                          String selectedDay = selectedStartDate
                                              .day.toString();
                                          String selectedMonth = selectedStartDate
                                              .month.toString();
                                          String selectedYear = selectedStartDate
                                              .year.toString();
                                          String selectedTimeStr = selectedStartTime
                                              .hour.toString() +
                                              (selectedStartTime.minute >=
                                                  10
                                                  ? ":0${selectedStartTime
                                                  .minute}"
                                                  : ":0${selectedStartTime
                                                  .minute}");
                                          startDateStr =
                                          "Start on $selectedDay month $selectedMonth, year $selectedYear at the time $selectedTimeStr";
                                        });

                                        ///save selected Date and selected time to database. This condition means:
                                        ///date null, time not null => save date now + time value
                                        ///date not null, time null => save date value + time default at 9:00
                                        ///date, time not null => save normally
                                      }
                                      Navigator.of(
                                          context, rootNavigator: true)
                                          .pop('dialog');
                                    },
                                    child: const Text("COMPLETED"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                );
              },
            ),

            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(70, 0, 0, 0),
              child: Divider(color: Colors.grey.shade400),
            ),

            ///DateEnd
            InkWell(
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                  top: 13.0,
                  bottom: 20.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: Colors.grey
                      .shade400)),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 44,
                    ),
                    endDateStr == ""
                        ? const Text(
                      "Expiration date...",
                      style: TextStyle(fontSize: 20),
                    )
                        : SizedBox(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width - 94,
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 142,
                            child: Text(
                              endDateStr,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          Checkbox(
                              value: status,
                              onChanged: (value) {
                                setState(() {
                                  status = value;
                                });
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                endDateTxtCtrl.text =
                "${selectedEndDate.day} thg ${selectedEndDate.month}";
                endTimeTxtCtrl.text = "${selectedEndTime.hour}:";
                if (selectedEndTime.minute >= 10) {
                  endTimeTxtCtrl.text = endTimeTxtCtrl.text +
                      selectedEndTime.minute.toString();
                } else {
                  endTimeTxtCtrl.text =
                  "${endTimeTxtCtrl.text}0${selectedEndTime.minute}";
                }
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      AlertDialog(
                        title: const Text(
                          'Expiration date',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: SizedBox(
                          height: 285,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width / 3.7,
                                    child: TextField(
                                      controller: endDateTxtCtrl,
                                      readOnly: true,
                                      showCursor: true,
                                      onTap: () {
                                        _selectedEndDate(context);
                                      },
                                      decoration: const InputDecoration(
                                        hintText: "Choose a date",
                                        contentPadding: EdgeInsets.only(
                                            bottom: 0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SizedBox(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width / 3.7,
                                    child: TextField(
                                      controller: endTimeTxtCtrl,
                                      readOnly: true,
                                      showCursor: true,
                                      onTap: () {
                                        _selectedEndTime(context);
                                      },
                                      decoration: const InputDecoration(
                                        hintText: "Choose time",
                                        contentPadding: EdgeInsets.only(
                                            bottom: 0),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      endDateTxtCtrl.text = "";
                                      endTimeTxtCtrl.text = "";
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Set up reminders",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                child: DropdownButtonFormField<String>(
                                  value: selectedNotiTime,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        bottom: 0),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedNotiTime = value;
                                    });
                                  },
                                  items: notificationTimeList.map((
                                      String item) {
                                    return DropdownMenuItem<String>(
                                        value: item,
                                        child: Row(
                                          children: [
                                            Text(
                                              item,
                                            ),
                                          ],
                                        ));
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                    "Reminders are only sent to card members and followers."),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      ///Reset end date, if from database not null, reset it by the data
                                      ///else reset it by DateTime.now()
                                      selectedEndDate = DateTime.now();

                                      ///Reset end time, if from database not null, reset it by the data
                                      ///else reset it by TimeOfDay(hour: 9, minute: 0)
                                      selectedEndTime =
                                      const TimeOfDay(hour: 9, minute: 0);
                                      Navigator.of(
                                          context, rootNavigator: true)
                                          .pop('dialog');
                                    },
                                    child: const Text("CANCEL"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (endDateTxtCtrl.text == "" &&
                                          endDateTxtCtrl.text == "") {
                                        setState(() {
                                          endDateStr = "";
                                        });

                                        ///Save null to database
                                      } else {
                                        setState(() {
                                          String selectedDay = selectedEndDate
                                              .day.toString();
                                          String selectedMonth = selectedEndDate
                                              .month.toString();
                                          String selectedYear = selectedEndDate
                                              .year.toString();
                                          String selectedTimeStr = selectedEndTime
                                              .hour.toString() +
                                              (selectedEndTime.minute >=
                                                  10
                                                  ? ":0${selectedEndTime
                                                  .minute}"
                                                  : ":0${selectedEndTime
                                                  .minute}");
                                          endDateStr =
                                          "Expires on $selectedDay month $selectedMonth, year $selectedYear at the time $selectedTimeStr";
                                        });

                                        ///save selected Date and selected time to database. This condition means:
                                        ///date null, time not null => save date now + time value
                                        ///date not null, time null => save date value + time default at 9:00
                                        ///date, time not null => save normally
                                      }
                                      Navigator.of(
                                          context, rootNavigator: true)
                                          .pop('dialog');
                                    },
                                    child: const Text("COMPLETED"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                );
              },
            ),

            const SizedBox(
              height: 10,
            ),

            ///Checklist
            InkWell(
              onTap: () {
                ///TODO: Add new task list
              },
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                padding: const EdgeInsets.only(
                  left: 25,
                  right: 25,
                  top: 20.0,
                  bottom: 20.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey
                      .shade400), bottom: BorderSide(color: Colors.grey
                      .shade400)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.check),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Work list...",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            isHaveTaskList
                ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.check),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "WORK LIST",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          ///TODO: Add new task list
                        },
                        icon: const Icon(Icons.add),
                        color: Colors.blue,
                        iconSize: 30,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: List.generate(
                      taskListNames.length,
                          (index) =>
                          Column(
                            children: [

                              ///Header
                              InkWell(
                                onTap: () {
                                  setState(() {});
                                },
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(
                                      20, 8, 20, 8),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border(
                                        top: BorderSide(
                                            color: Colors.grey.shade400),
                                        bottom: BorderSide(
                                            color: Colors.grey.shade400),
                                      )),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      //Text(
                                      //  taskListNames[index],
                                      //  style: TextStyle(
                                      //    fontSize: 20,
                                      //  ),
                                      //),
                                      SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width - 140,
                                        child: Focus(
                                          child: TextField(
                                            controller: controllersList[index],
                                            style: const TextStyle(
                                                fontSize: 20),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder
                                                  .none,
                                              enabledBorder: InputBorder
                                                  .none,
                                              errorBorder: InputBorder
                                                  .none,
                                              disabledBorder: InputBorder
                                                  .none,
                                              hintStyle: TextStyle(
                                                  fontSize: 20),
                                            ),
                                          ),
                                          onFocusChange: (hasFocus) {
                                            if (hasFocus) {
                                              setState(() {
                                                isChangeListName = true;
                                                xChangeTaskListName =
                                                    index;
                                              });
                                            } else {
                                              setState(() {
                                                isChangeListName = false;
                                                xChangeTaskListName = -1;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.black,
                                              size: 25,
                                            ), onPressed: () {
                                            setState(() {
                                              isShow[index] =
                                              !isShow[index];
                                            });
                                          },
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.keyboard_arrow_up,
                                              color: Colors.black,
                                              size: 25,
                                            ), onPressed: () {
                                            setState(() {
                                              isShow[index] =
                                              !isShow[index];
                                            });
                                          },
                                          ),
                                          PopupMenuButton(
                                            iconSize: 30,
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(
                                                Icons.more_horiz),
                                            onSelected: (value) {
                                              ///TODO: Delete task list
                                            },
                                            itemBuilder: (context) =>
                                            [
                                              const PopupMenuItem(
                                                value: 1,
                                                child: Text(
                                                  'Erase',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 5,
                                decoration: const BoxDecoration(
                                    color: Color.fromRGBO(
                                        188, 217, 234, 1)),
                                child: Row(),
                              ),
                              isShow[index]
                                  ? Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    Column(
                                      children: List.generate(
                                        tasks[index].length,
                                            (innerIndex) =>
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Transform.scale(
                                                      scale: 1.2,
                                                      child: Checkbox(
                                                        value: isTaskDone[index][innerIndex],
                                                        onChanged: (
                                                            value) {
                                                          setState(() {
                                                            isTaskDone[index][innerIndex] =
                                                            !isTaskDone[index][innerIndex];

                                                            ///TODO: Change state of task
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: MediaQuery
                                                          .of(context)
                                                          .size
                                                          .width - 100,
                                                      child: Focus(
                                                        child: TextField(
                                                          controller: controllers[index][innerIndex],
                                                          style: const TextStyle(
                                                              fontSize: 20),
                                                          decoration: const InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            focusedBorder: InputBorder
                                                                .none,
                                                            enabledBorder: InputBorder
                                                                .none,
                                                            errorBorder: InputBorder
                                                                .none,
                                                            disabledBorder: InputBorder
                                                                .none,
                                                            hintStyle: TextStyle(
                                                                fontSize: 20),
                                                          ),
                                                        ),
                                                        onFocusChange: (
                                                            hasFocus) {
                                                          if (hasFocus) {
                                                            setState(() {
                                                              isChangeTaskListName =
                                                              true;
                                                              xChangeTaskListName =
                                                                  index;
                                                              yChangeTaskListName =
                                                                  innerIndex;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              isChangeTaskListName =
                                                              false;
                                                              xChangeTaskListName =
                                                              -1;
                                                              yChangeTaskListName =
                                                              -1;
                                                            });
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    isChangeTaskListName &&
                                                        index ==
                                                            xChangeTaskListName &&
                                                        innerIndex ==
                                                            yChangeTaskListName
                                                        ? IconButton(
                                                        onPressed: () {},
                                                        icon: const Icon(
                                                            Icons.delete))
                                                        : const SizedBox(
                                                      width: 0,
                                                    ),
                                                  ],
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets
                                                      .fromLTRB(
                                                      50, 0, 0, 0),
                                                  child: Divider(),
                                                ),
                                              ],
                                            ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 2, 0, 8),
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 50,
                                          ),
                                          SizedBox(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width - 70,
                                            child: Focus(
                                              child: const TextField(
                                                style: TextStyle(
                                                    fontSize: 20),
                                                cursorColor: Colors.blue,
                                                decoration: InputDecoration(
                                                  border: InputBorder
                                                      .none,
                                                  focusedBorder: InputBorder
                                                      .none,
                                                  enabledBorder: InputBorder
                                                      .none,
                                                  errorBorder: InputBorder
                                                      .none,
                                                  disabledBorder: InputBorder
                                                      .none,
                                                  hintText: "Add item…",
                                                  hintStyle: TextStyle(
                                                      fontSize: 20),
                                                ),
                                              ),
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                  setState(() {
                                                    isAddTask = true;
                                                  });
                                                } else {
                                                  setState(() {
                                                    isAddTask = false;
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  : const SizedBox(
                                height: 0,
                              ),
                            ],
                          )),
                ),
              ],
            )
                : const SizedBox(
              height: 0,
            ),

            ///Comment display here
            ///TODO: remember to change list to the loaded commentList
            commentUserIDList.isEmpty
                ? const SizedBox(height: 30)
                : Column(
                children: List.generate(
                  commentUserIDList.length,
                      (index) =>
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25, right: 20, top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: CircleAvatar(
                                radius: 25,

                                ///TODO: Load Avatar
                                backgroundImage: AssetImage(
                                    commentUserAvatarList[index]),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                                ///User Name
                                SizedBox(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width - 115,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [

                                      ///TODO: Load User Name who comments this
                                      Text(
                                        commentUserNameList[index],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),

                                      PopupMenuButton(
                                          icon: const Icon(
                                              Icons.more_horiz),
                                          itemBuilder: (
                                              BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                            const PopupMenuItem<String>(
                                              value: "Edit",
                                              child: Text('Edit'),
                                            ),
                                            const PopupMenuItem<String>(
                                              value: "Erase",
                                              child: Text('Erase'),
                                            ),
                                          ]),
                                    ],
                                  ),
                                ),

                                ///Comment content
                                Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width - 115,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: TextField(
                                    controller: commentContentTxtCtrlList[index],
                                    readOnly: true,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.all(5),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 10),

                                ///Load date comment
                                ///TODO: change suitable variable to the
                                ///Format hh:mm dd/mm/yyyy if year is different from current year
                                ///Format hh:mm dd/mm if year is equal to current year
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width - 115,
                                  child: commentDateList[index].year ==
                                      DateTime
                                          .now()
                                          .year
                                      ? Text("${commentDateList[index]
                                      .hour}:${commentDateList[index]
                                      .minute >= 10
                                      ? commentDateList[index].minute
                                      .toString()
                                      : "0${commentDateList[index].minute}"} ${commentDateList[index]
                                      .day}/${commentDateList[index]
                                      .month}")
                                      : Text("${commentDateList[index]
                                      .hour}:${commentDateList[index]
                                      .minute >= 10
                                      ? commentDateList[index].minute
                                      .toString()
                                      : "0${commentDateList[index].minute}"} ${commentDateList[index]
                                      .day}/${commentDateList[index]
                                      .month}/${commentDateList[index]
                                      .year}"),
                                ),

                                const SizedBox(height: 20),
                              ],
                            ),
                          ],
                        ),
                      ),
                )),

            ///for bottom sheet not cover last element
            const SizedBox(
              height: 69,
            )
          ],
        ),
      ),

      ///comment
      bottomSheet: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              const CircleAvatar( radius: 50, backgroundColor: Colors.grey,
                  backgroundImage: AssetImage('assets/images/BlueBG.png')),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: commentEnterTxtCtrl,
                  decoration: InputDecoration(
                    hintText: 'Enter a message',
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.send,
                        size: 30,
                      ),
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
