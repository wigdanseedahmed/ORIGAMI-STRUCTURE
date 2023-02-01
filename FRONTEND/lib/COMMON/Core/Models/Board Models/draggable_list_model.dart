import 'package:origami_structure/imports.dart';

class DraggableList {
  String? header;
  List<DraggableListItem>? items;
  List<TaskModel>? tasks;
  bool? isSelected;
  bool isToggle = false;

  DraggableList({
    this.header,
    this.items,
    this.tasks,
    this.isSelected,
  });
}

class DraggableListItem {
  String? title;
  String? checkListItem;
  bool? isSelected;

  DraggableListItem({
    this.title,
    this.checkListItem,
    this.isSelected,
  });
}
