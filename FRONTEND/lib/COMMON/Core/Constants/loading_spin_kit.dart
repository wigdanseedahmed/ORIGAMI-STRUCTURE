import 'package:origami_structure/imports.dart';

const rotatingCircleSpinKit = SpinKitRotatingCircle(
  color: Colors.white,
  size: 50.0,
);

final fadingCircleSpinKit = SpinKitFadingCircle(
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: index.isEven ? Colors.red : Colors.green,
      ),
    );
  },
);

final fadingFourSpinKit = SpinKitFadingFour(
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: index.isEven ? Colors.red : Colors.green,
      ),
    );
  },
);