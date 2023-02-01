import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

//function to pick file from system
Future<void> takeOrGetPhoto(
    {ImageSource? source,
    ImagePicker? picker,
    File? image,
    String? uriString}) async {
  final pickedFile = await picker!.pickImage(source: source!);

    if (pickedFile != null) {
      //imageFile = pickedFile;
      image = File(pickedFile.path);
      //readJsonFileContent.projectPhotoUrl = _image.path;
      imageUpload(imageFile: image, uriString: uriString);
      print('Image selected: $image');
    } else {
      print('No image selected.');
    }
}

void imageUpload({File? imageFile, String? uriString}) async {
  if (imageFile == null) return;
  String base64Image = base64Encode(imageFile.readAsBytesSync());
  String fileName = imageFile.path.split("/").last;

  Map map = {
    "projectPhotoFile": base64Image,
    "projectPhotoName": fileName,
  };

  String body = json.encode(map);

  http.post(Uri.parse(uriString!), body: body).then((res) {
    print(res.statusCode);
  }).catchError((err) {
    print(err);
  });

  try {
    final response = await http.post(
      Uri.parse(uriString),
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (200 == response.statusCode) {
      return print('Successfully uploaded file');
    } else {
      return print(response.statusCode);
    }
  } catch (e) {
    return print(e);
  }
}
