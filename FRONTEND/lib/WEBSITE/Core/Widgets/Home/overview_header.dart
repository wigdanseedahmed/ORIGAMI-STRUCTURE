import 'package:origami_structure/imports.dart';

class OverviewHeaderWS extends StatelessWidget {
  const OverviewHeaderWS({
    Key? key,
    required this.onSelected,
    required this.isSelected,
    required this.isSelectedChanged,
    this.axis = Axis.horizontal,
  }) : super(key: key);

  final ValueChanged<String> isSelectedChanged;

  final Function(TaskModel? task) onSelected;
  final String? isSelected;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final TaskModel task = TaskModel();

    return ResponsiveWidget.isLargeScreen(context)
          ? Row(
              children: [
                 Text(
                  "Task Overview",
                  style: TextStyle(fontSize:MediaQuery.of(context).size.width * 0.015, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                ..._listButton(
                  context: context,
                  task: task,
                  onSelected: (value) {
                    onSelected(task);

                    isSelectedChanged(value!);
                  },
                  taskStatus: task.status,
                )
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  "Task Overview",
                  style: TextStyle(fontSize:MediaQuery.of(context).size.width * 0.015, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: _listButton(
                      context: context,
                      task: task,
                      onSelected: (value) {
                        onSelected(task);

                        isSelectedChanged(value!);
                      },
                      taskStatus: task.status,
                    ),
                  ),
                ),
              ],

    );
  }

  List<Widget> _listButton({
    required BuildContext context,
    required TaskModel? task,
    required String? taskStatus,
    required Function(String? value) onSelected,
  }) {
    return [
      _button(
        context: context,
        selected: isSelected == "All",
        label: "All",
        onPressed: () {
          taskStatus = "All";
          onSelected("All");
        },
      ),
      _button(
        context: context,
        selected: isSelected == "Today",
        label: "Today",
        onPressed: () {
          taskStatus == "Today";
          onSelected("Today");
        },
      ),
      _button(
        context: context,
        selected: isSelected == "Week",
        label: "Week",
        onPressed: () {
          taskStatus = "Week";
          onSelected("Week");
        },
      ),
      _button(
        context: context,
        selected: isSelected == "Month",
        label: "Month",
        onPressed: () {
          taskStatus = "Month";
          onSelected("Month");
        },
      ),
    ];
  }

  Widget _button({
    required BuildContext context,
    required bool selected,
    required String label,
    required Function() onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: selected
              ? kViolet // Theme.of(context).cardColor
              : Theme.of(context).canvasColor,
          onPrimary: const Color.fromRGBO(170, 170, 170, 1), // selected ? Colors.deepPurple : const Color.fromRGBO(170, 170, 170, 1)
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          label,
        ),
      ),
    );
  }
}
