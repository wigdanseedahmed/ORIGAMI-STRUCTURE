import 'package:origami_structure/imports.dart';

Widget registrationWithSocialMediaButton({required String image, bool isActive = false}) {
  return Container(
    width: 90,
    height: 70,
    decoration: isActive
        ? BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade300,
          spreadRadius: 10,
          blurRadius: 30,
        )
      ],
      borderRadius: BorderRadius.circular(15),
    )
        : BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      border: Border.all(color: Colors.grey.shade400),
    ),
    child: Center(
        child: Container(
          decoration: isActive
              ? BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                spreadRadius: 2,
                blurRadius: 15,
              )
            ],
          )
              : const BoxDecoration(),
          child: Image.asset(
            '$image',
            width: 35,
          ),
        )),
  );
}