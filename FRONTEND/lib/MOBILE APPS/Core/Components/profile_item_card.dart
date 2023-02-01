import 'package:origami_structure/imports.dart';

class ProfileItemCardMA extends StatelessWidget {
  const ProfileItemCardMA(
      {Key? key,
      required this.title,
      required this.rightWidget,
      required this.callback,
      required this.textStyle})
      : super(key: key);

  final String? title;
  final Widget? rightWidget;
  final Function()? callback;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: const EdgeInsets.only(
          left: 24,
          top: 6,
          bottom: 6,
        ),
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  title!,
                  style: textStyle,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 4),
              child: rightWidget,
            )
          ],
        ),
      ),
    );
  }
}

class EditProfileItemCardMA extends StatelessWidget {
  const EditProfileItemCardMA({
    Key? key,
    required this.rightWidget,
    required this.callback,
    required this.text,
    required this.onChanged,
    required this.textStyle,
  }) : super(key: key);

  final Widget? rightWidget;
  final Function()? callback;
  final String text;
  final TextStyle? textStyle;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: const EdgeInsets.only(left: 24, right: 8, bottom: 18),
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: TextFieldWidget(
                text: text,
                onChanged: onChanged,
                textStyle: textStyle,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 24),
              child: rightWidget,
            )
          ],
        ),
      ),
    );
  }
}

class ProfileCardWS extends StatelessWidget {
  const ProfileCardWS({
    Key? key,
    this.title,
    this.initialValue,
    this.rightWidget,
    this.onChanged,
    this.onFieldSubmitted,
    this.textStyle,
  }) : super(key: key);

  final String? title;
  final String? initialValue;
  final Widget? rightWidget;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        right: 24,
        left: 24,
        top: 6,
        bottom: 6,
      ),
      color: DynamicTheme.of(context)?.brightness == Brightness.light
          ? Colors.white
          : Colors.black12,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title!,
            textAlign: TextAlign.left,
            style: kProfileSubHeaderTextStyle,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: TextFormField(
              minLines: 1,
              maxLines: 250,
              autofocus: false,
              initialValue: initialValue,
              cursorColor:
                  DynamicTheme.of(context)?.brightness == Brightness.light
                      ? Colors.grey[100]
                      : Colors.grey[600],
              onChanged: onChanged,
              onFieldSubmitted: onFieldSubmitted,
              style: kProfileBodyTextStyle,
              decoration:  InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: primaryColour,
                    width: 0.3,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: primaryColour,
                    width: 0.3,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileItemCardWS extends StatelessWidget {
  const ProfileItemCardWS(
      {Key? key,
      required this.title,
      required this.rightWidget,
      required this.callback,
      required this.textStyle})
      : super(key: key);

  final String? title;
  final Widget? rightWidget;
  final Function()? callback;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: const EdgeInsets.only(
          right: 24,
          left: 24,
          top: 6,
          bottom: 6,
        ),
        color: DynamicTheme.of(context)?.brightness == Brightness.light
            ? Colors.white
            : Colors.black12,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  title!,
                  style: textStyle,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 4),
              child: rightWidget,
            )
          ],
        ),
      ),
    );
  }
}

class EditProfileTitleCardWS extends StatelessWidget {
  const EditProfileTitleCardWS({
    Key? key,
    required this.rightWidget,
    required this.onPressedSave,
    required this.title,
  }) : super(key: key);

  final Widget? rightWidget;
  final Function()? onPressedSave;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                padding: const EdgeInsets.only(top: 7.0),
                child: rightWidget,
            ),
             Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  height: 1.4,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8, top: 2.5),
          child: IconButton(
            icon: Icon(Icons.save_outlined, size: 28, color: primaryColour),
            onPressed: onPressedSave,
          ),
        ),
      ],
    );
  }
}
