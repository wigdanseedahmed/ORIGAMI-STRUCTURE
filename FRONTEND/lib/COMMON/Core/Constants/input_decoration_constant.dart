import 'package:origami_structure/imports.dart';

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.yellow, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.yellow, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

InputDecoration kTextFieldDecorationLogIn = InputDecoration(
  hintText: 'Enter a value',
  labelStyle: TextStyle(fontSize: 14,color: kGreyShade400),
  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kGreyShade300,),
    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red,),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);

InputDecoration kTextFieldDecorationRegistration = InputDecoration(
  hintText: 'Enter a value',
  labelStyle: TextStyle(fontSize: 14,color: kGreyShade400),
  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kGreyShade300,),
    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
  ),
  focusedBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red,),
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
  ),
);

InputDecoration commentTaskTextFieldInputDecoration({String? hintText, Color color = Colors.white, EdgeInsetsGeometry? padding}) {
  return InputDecoration(
    contentPadding: padding,
    hintText: hintText,
    labelStyle: TextStyle(color: color),
    errorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red),
    ),
    errorMaxLines: 2,
    errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: color),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: color),
    ),
    border: UnderlineInputBorder(
      borderSide: BorderSide(color: color),
    ),
  );
}
