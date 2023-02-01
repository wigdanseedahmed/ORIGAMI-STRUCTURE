import 'package:origami_structure/imports.dart';

Widget registerButton(BuildContext context, bool isSelected) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 50, vertical: MediaQuery.of(context).size.width / 180),
    decoration: BoxDecoration(
      color: isSelected == false ? Colors.white: kViolet,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          spreadRadius: 10,
          blurRadius: 12,
        ),
      ],
    ),
    child: const Text(
      'Register',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black54,
      ),
    ),
  );
}
