import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';


class ImageUpload extends StatefulWidget {
  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  late File _image;
  final picker = ImagePicker();

  Future<void> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  upload(File imageFile) async {
    // open a bytestream
    var stream =
    http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("http://192.168.0.8:3000/upload");

    // create multipart request
    var request = http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = http.MultipartFile('myFile', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  bool isloaded = false;
  var result;
  fetch() async {
    var response = await http.get(Uri.parse(AppUrl.imageBaseURL));
    result = jsonDecode(response.body);
    print(result[0]['image']);
    setState(() {
      isloaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    fetch();
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Text("Select an image"),
          TextButton.icon(
              onPressed: () async => await getImage(),
              icon: const Icon(Icons.upload_file),
              label: const Text("Browse")),
          const SizedBox(
            height: 20,
          ),
          TextButton.icon(
              onPressed: () => upload(_image),
              icon: const Icon(Icons.upload_rounded),
              label: const Text("Upload now")),
          isloaded
              ? Image.network('${AppUrl.baseURL}/${result[0]['image']}')
              : const CircularProgressIndicator(),
        ],
      ),
    );
  }
}