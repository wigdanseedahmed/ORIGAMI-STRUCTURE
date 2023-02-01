import 'package:origami_structure/imports.dart';

Widget taskTextField(
    {
      String? hint,
      required TextEditingController controller,
      String? Function(String?)? validator,
    }) {
  return TextFormField(
    controller: controller,
    validator: validator,
    textCapitalization: TextCapitalization.words,
    decoration: InputDecoration(
      labelText: hint ?? '',
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: kDeepCove, width: 1.5),
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: kDeepCove, width: 1.5),
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),
    ),
  );
}

Widget taskTextField2(
    {
      String? hint,
      required Function()? onTap,
      String? Function(String?)? validator,
    }) {
  return TextFormField(
    onTap: onTap,
    validator: validator,
    textCapitalization: TextCapitalization.words,
    decoration: InputDecoration(
      labelText: hint ?? '',
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: kDeepCove, width: 1.5),
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: kDeepCove, width: 1.5),
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),
    ),
  );
}