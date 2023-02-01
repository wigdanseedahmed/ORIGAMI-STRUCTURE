import 'package:origami_structure/imports.dart';

class ProjectFiltersWidget extends StatefulWidget {
  const ProjectFiltersWidget({Key? key, required this.updateFilter}) : super(key: key);

  final Function updateFilter;

  @override
  State<StatefulWidget> createState() {
    return ProjectFiltersWidgetState();
  }
}

class ProjectFiltersWidgetState extends State<ProjectFiltersWidget> {
  Widget _buildBadge(title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: GestureDetector(
        onTap: () {
          selectedFilter = title.toLowerCase();
          widget.updateFilter(title.toLowerCase());
        },
        child: RawChip(
          padding: const EdgeInsets.all(16),
          label: Text(
            title,
            style: const TextStyle(
                fontFamily: "Montserrat", fontWeight: FontWeight.bold),
          ),
          labelStyle: TextStyle(
              color: selectedFilter == title.toLowerCase()
                  ? Colors.white
                  : Colors.black,
              fontSize: 14.0),
          backgroundColor: selectedFilter == title.toLowerCase()
              ? Colors.redAccent
              : Colors.grey[300],
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }

  String selectedFilter = "all";

  final List filters = [
    "All",
    "Open",
    "Closed",
    "Expired",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      padding: const EdgeInsets.only(left: 8.0, top: 8, bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildBadge(filters[index]);
        },
      ),
    );
  }
}