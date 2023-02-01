import 'package:origami_structure/imports.dart';

class RoundCheckList extends StatefulWidget {
  const RoundCheckList({Key? key}) : super(key: key);

  @override
  _RoundCheckListState createState() => _RoundCheckListState();
}

class _RoundCheckListState extends State<RoundCheckList> {
  bool _value = false;
  String taskStatus = "Undone";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
          child: InkWell(
            onTap: () {
              setState(() {
                _value = !_value;
                if(_value == true){
                  taskStatus = "Done";
                }else{
                  taskStatus = "Undone";
                }
                if (kDebugMode) {
                  print(taskStatus);
                }
              }
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 50.0,),
              child: Container(
                child: _value
                    ? const Icon(
                  Icons.check,
                  size: 30.0,
                )
                    : const Icon(
                  Icons.check_box_outline_blank,
                  size: 30.0,
                ),
              ),
            ),
        ),
      ),
    );
  }
}
