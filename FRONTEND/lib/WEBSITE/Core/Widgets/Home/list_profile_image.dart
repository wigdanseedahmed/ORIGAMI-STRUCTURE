import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class ListProfileImageWS extends StatelessWidget {

  ListProfileImageWS({
    Key? key,
    required this.assignedTo,
    required this.allUserData,
     this.onPressed,
  }) : super(key: key);

  final List<UserModel> allUserData;

  final List<String> assignedTo;
  final Function()? onPressed;



  /// VARIABLES USED FOR RETRIEVING ALL USER
  late List<String> _assignedToInitials = <String>[];
  late List<String> _assignedToImage = <String>[];


  @override
  Widget build(BuildContext context) {

    for(int i = 0; i< assignedTo.length; i++){
      _assignedToInitials.add("${allUserData.where((element) => element.username == assignedTo[i]).toList()[0].firstName![0]}${allUserData..where((element) => element.username == assignedTo[i]).toList()[0].lastName![0]}");
      _assignedToImage.add(allUserData.where((element) => element.username == assignedTo[i]).toList()[0].userPhotoFile!);
    }

    return buildBody(context);
  }

  SizedBox buildBody(BuildContext context) {
    return SizedBox(
    height: 40,
    width: (_assignedToImage.length + 1) * 25,
    child: Stack(
      alignment: Alignment.centerRight,
      children: _getLimitImage(_assignedToImage, assignedTo.length)
          .asMap()
          .entries
          .map(
            (e) => Padding(
              padding: EdgeInsets.only(right: (e.key * 20.0)),
              child: _image(
                context,
                e.value,
                _assignedToInitials[e.key],
                onPressed: onPressed,
              ),
            ),
          )
          .toList(),
    ),
  );
  }

  List<String> _getLimitImage(List<String> images, int limit) {
    if (images.length <= limit) {
      return images;
    } else {
      List<String> result = [];
      for (int i = 0; i < limit; i++) {
        result.add(images[i]);
      }
      return result;
    }
  }

  Widget _image(BuildContext context, String? image, String initials, {Function()? onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(40),
      child: image == null ? Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Theme.of(context).cardColor,
        ),
        child: Text(initials),
      ) : Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: Theme.of(context).cardColor,
        ),
        child: CircleAvatar(
          backgroundImage: MemoryImage(base64Decode(image)),
          radius: 40,
        ),
      ),
    );
  }
}
