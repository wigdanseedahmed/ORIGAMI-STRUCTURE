import 'package:origami_structure/imports.dart';

class CardTileWS extends StatelessWidget
{
  final String? cardTitle;
  final IconData? icon;
  final Color? iconBgColor;
  final String? mainText;
  final String? subText;

  const CardTileWS(
  {   Key? key,
      this.cardTitle,
      this.icon,
      this.iconBgColor,
      this.mainText,
      this.subText})
      : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    final _media = MediaQuery.of(context).size;
    return FittedBox(
      child: Container(
        height: _media.height / 6,
        width: _media.width / 7,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Material(
              elevation: 10,
              color: Colors.white,
              shadowColor: Colors.grey,
              borderRadius: BorderRadius.circular(4),
              child: Container(
                height: _media.height / 6.5,
                width: _media.width / 7,
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      cardTitle!,
                      style: cardTileTitleText,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FittedBox(
                      child: Text(
                        mainText!,
                        style: cardTileMainText,
                      ),
                    ),
                    const Spacer(),
                    const Divider(),
                    Align(
                        alignment: Alignment.topLeft,
                        child: FittedBox(
                          child: Text(
                            subText!,
                            style: cardTileSubText,
                          ),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 20,
              child: Material(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(4),
                elevation: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  height: _media.height / 18,
                  width: _media.width / 20,
                  child: Icon(
                    icon,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}