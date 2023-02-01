import 'package:origami_structure/imports.dart';

class SelectionButtonData {
  final IconData activeIcon;
  final IconData icon;
  final String title;
  final String? subtitle;
  final int? totalNotification;


  SelectionButtonData({
    required this.activeIcon,
    required this.icon,
    required this.title,
    this.subtitle,
    this.totalNotification,
  });
}

class SelectionButtonWS extends StatefulWidget {
  const SelectionButtonWS({
    required this.initialSelected,
    required this.data,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  final int initialSelected;
  final List<SelectionButtonData> data;
  final Function(int index, SelectionButtonData value) onSelected;

  @override
  State<SelectionButtonWS> createState() => _SelectionButtonWSState();
}

class _SelectionButtonWSState extends State<SelectionButtonWS> {
  late int selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.data.asMap().entries.map((e) {
        final index = e.key;
        final data = e.value;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: _Button(
            selected: selected == index,
            onPressed: () {
              widget.onSelected(index, data);
              setState(() {
                selected = index;
              });
            },
            data: data,
          ),
        );
      }).toList(),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    Key? key,
    required this.selected,
    required this.data,
    required this.onPressed,
  }) : super(key: key);

  final bool selected;
  final SelectionButtonData data;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: (!selected)
          ? Theme.of(context).cardColor
          : kDeepSapphire.withOpacity(.1), //Theme.of(context).primaryColor.withOpacity(.1)
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              _icon(context, (!selected) ? data.icon : data.activeIcon),
              const SizedBox(width: 20 / 2),
              Expanded(child: _labelText(context, data.title)),
              /*data.totalNotification != null ?
                Padding(
                  padding: const EdgeInsets.only(left: 20 / 2),
                  child: _notifications(data.totalNotification!),
                ) : Container(),*/
            ],
          ),
        ),
      ),
    );
  }

  Widget _icon(BuildContext context, IconData iconData) {
    return Icon(
      iconData,
      size: 20,
      color: (!selected)
          ? const Color.fromRGBO(210, 210, 210, 1)
          : kDeepSapphire,
    );
  }

  Widget _labelText(BuildContext context, String data) {
    return Text(
      data,
      style: TextStyle(
        color: (!selected)
            ? const Color.fromRGBO(210, 210, 210, 1)
            : kDeepSapphire,
        fontWeight: FontWeight.w600,
        letterSpacing: .8,
        fontSize: 13,
      ),
    );
  }

  Widget _notifications(int total) {
    return (total <= 0)
        ? Container()
        : Container(
            width: 30,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color:   const Color.fromRGBO(74, 177, 120, 1),
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


class SettingsSelectionButtonWS extends StatefulWidget {
  const SettingsSelectionButtonWS({
    required this.initialSelected,
    required this.data,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  final int initialSelected;
  final List<SelectionButtonData> data;
  final Function(int index, SelectionButtonData value) onSelected;

  @override
  State<SettingsSelectionButtonWS> createState() => _SettingsSelectionButtonWSState();
}

class _SettingsSelectionButtonWSState extends State<SettingsSelectionButtonWS> {
  late int selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialSelected;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.data.asMap().entries.map((e) {
        final index = e.key;
        final data = e.value;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: _SettingsButton(
            selected: selected == index,
            onPressed: () {
              widget.onSelected(index, data);
              setState(() {
                selected = index;
              });
            },
            data: data,
          ),
        );
      }).toList(),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton({
    Key? key,
    required this.selected,
    required this.data,
    required this.onPressed,
  }) : super(key: key);

  final bool selected;
  final SelectionButtonData data;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: (!selected)
          ? Theme.of(context).cardColor
          : kDeepSapphire.withOpacity(.1), //Theme.of(context).primaryColor.withOpacity(.1)
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListTile(
            trailing: _icon(context, (!selected) ? data.icon : data.activeIcon),
            title: Text(
              data.title,
              style: const TextStyle(
                fontFamily: 'Fira Sans',
                fontWeight: FontWeight.bold,
                // fontFamily: 'Ninto',
              ),
            ),
            subtitle: Text(
              data.subtitle!,
              style: const TextStyle(
                fontFamily: 'Fira Sans',
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ),
      ),
    );
  }

  Widget _icon(BuildContext context, IconData iconData) {
    return Icon(
      iconData,
      size: 20,
      color: (!selected)
          ? const Color.fromRGBO(210, 210, 210, 1)
          : kDeepSapphire,
    );
  }

}
