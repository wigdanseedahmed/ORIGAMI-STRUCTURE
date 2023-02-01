import 'dart:ui';

import 'package:origami_structure/imports.dart';

class NewTaskInputFieldMA extends StatelessWidget {
  final TextEditingController? controller;
  final String? title;
  final String? initialValue;
  final String? hint;
  final Widget? widget;
  final Function()? onTap;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;

  const NewTaskInputFieldMA({
    Key? key,
    this.initialValue,
    this.title,
    this.controller,
    this.hint,
    this.widget,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      height: 52,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget == null
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: widget,
                    ),
              const SizedBox(
                width: 8.0,
              ),
              title == null
                  ? Container()
                  : SizedBox(
                      width: 50.0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          title!,
                          style: titleTextStyleMA,
                        ),
                      ),
                    ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: SizedBox(
              width: screenSize.width * 0.75,
              child: TextFormField(
                initialValue: initialValue,
                minLines: 1,
                maxLines: 250,
                autofocus: false,
                cursorColor:
                    DynamicTheme.of(context)?.brightness == Brightness.light
                        ? Colors.grey[100]
                        : Colors.grey[600],
                style: subTitleTextStyleMA,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: subTitleTextStyleMA,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: primaryColour,
                      width: 0.5,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: primaryColour,
                      width: 0.5,
                    ),
                  ),
                ),
                onChanged: onChanged,
                onTap: onTap,
                onFieldSubmitted: onFieldSubmitted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NewTaskInputFieldWS extends StatelessWidget {
  final TextEditingController? controller;
  final String? title;
  final String? initialValue;
  final String? hint;
  final Widget? widget;
  final Function()? onTap;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;

  const NewTaskInputFieldWS({
    Key? key,
    this.initialValue,
    this.title,
    this.controller,
    this.hint,
    this.widget,
    this.onTap,
    this.onChanged,
    this.onFieldSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      height: screenSize.height * 0.05,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget == null
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: widget,
                    ),
              const SizedBox(
                width: 8.0,
              ),
              title == null
                  ? Container()
                  : SizedBox(
                      width: screenSize.width * 0.05,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text(
                          title!,
                          style: titleTextStyleWS,
                        ),
                      ),
                    ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: SizedBox(
              width: screenSize.width * 0.2,
              child: TextFormField(
                initialValue: initialValue,
                minLines: 1,
                maxLines: 250,
                autofocus: false,
                cursorColor:
                    DynamicTheme.of(context)?.brightness == Brightness.light
                        ? Colors.grey[100]
                        : Colors.grey[600],
                style: subTitleTextStyleWS,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: subTitleTextStyleWS,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: primaryColour,
                      width: 0.5,
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: primaryColour,
                      width: 0.5,
                    ),
                  ),
                ),
                onChanged: onChanged,
                onTap: onTap,
                onFieldSubmitted: onFieldSubmitted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
