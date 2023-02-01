import 'package:origami_structure/imports.dart';

class ResponsiveWidgetV2 extends StatelessWidget
{
  final Widget? largeScreen;
  final Widget? mediumScreen;
  final Widget? smallScreen;

  const ResponsiveWidgetV2(
      {Key? key,
      required this.largeScreen,
      this.mediumScreen,
      this.smallScreen})
      : super(key: key);

  static bool isSmallScreen(BuildContext context)
  {
    return MediaQuery.of(context).size.width < 800;
  }

  static bool isLargeScreen(BuildContext context)
  {
    return MediaQuery.of(context).size.width > 800;
  }

  static bool isMediumScreen(BuildContext context)
  {
    return MediaQuery.of(context).size.width > 800 &&
        MediaQuery.of(context).size.width < 1200;
  }

  @override
  Widget build(BuildContext context)
  {
    return LayoutBuilder(
      builder: (context, constraints)
      {
        if(constraints.maxWidth > 800) {
          return largeScreen!;
        } else if(constraints.maxWidth < 1200 && constraints.maxWidth > 800) {
          return mediumScreen ?? largeScreen!;
        } else {
          return smallScreen ?? largeScreen!;
        }
      },
    );
  }
}