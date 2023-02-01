import 'package:origami_structure/imports.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as Io;

//function to pick file from system
Future<void> getOrUploadFile(
    {ImageSource? source,
    ImagePicker? picker,
    File? image,
    String? uriString}) async {
  FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(allowMultiple: true);

  if (pickedFile != null) {
    PlatformFile file = pickedFile.files.first;
    fileUploadGen(
        file: file,
        uriString: uriString,
        base64FileKey: "taskBase64File",
        fileNameKey:
            "taskFileName"); //base64Encode used to convert bytes in base64URL
    print(file.name);
    print(base64Encode(Io.File(file.path!).readAsBytesSync()));
    print(file.size);
    print(file.extension);
    print(file.path);

    print('Image selected: $image');
  } else {
    print('No image selected.');
  }
}

void fileUploadGen({PlatformFile? file, String? uriString, String? base64FileKey, String? fileNameKey}) async {
  if (file == null) return;
  String base64File = base64Encode(Io.File(file.path!).readAsBytesSync());
  String fileName = file.path!.split("/").last;

  Map map = {
    base64FileKey: base64File,
    fileNameKey: fileName,
    // "taskBase64File": base64File,
    // "taskFileName": fileName,
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

class FilePickerDemo extends StatefulWidget {
  const FilePickerDemo({Key? key}) : super(key: key);

  @override
  _FilePickerDemoState createState() => _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String? _fileName;
  String? _saveAsFileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _isLoading = false;
  bool _userAborted = false;
  FileType _pickingType = FileType.any;
  final TextEditingController _controller = TextEditingController();

  void fileUpload({PlatformFile? file, TaskModel? selectedTask}) {
    if (file == null) return;

    FileModel newFile = FileModel()
      ..taskBase64File = base64Encode(Io.File(file.path!).readAsBytesSync())
      ..taskFileName = file.name;//Io.File(file.path!).path.split("/").last;

    selectedTask!.taskFiles!.add(newFile);

    /// string to uri
    var uri = Uri.parse("${AppUrl.updateTaskByTaskName}/${selectedTask.taskName}");

    http.post(uri, body: json.encode(selectedTask.toJson()),).then((res) {
      print(res.statusCode);
    }).catchError((err) {
      print(err);
    });
  }

  void _pickFiles() async {
    _resetState();
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: true,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false) ? _extension?.replaceAll(' ', '').split(',') : null,
      ))?.files;

      for (var i=0; i<_paths!.length;i++) {
        fileUpload(file: _paths![i]);
      }//base64Encode used to convert bytes in base64URL
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _fileName = _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      _userAborted = _paths == null;
      //_saveFile();
    });
  }

  void _selectFolder() async {
    _resetState();
    try {
      String? path = await FilePicker.platform.getDirectoryPath();



      setState(() {
        _directoryPath = path;
        _userAborted = path == null;
        //_saveFile();
      });
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveFile() async {
    _resetState();

    try {
      String? fileName = await FilePicker.platform.saveFile(
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
        type: _pickingType,
      );

      setState(() {
        _saveAsFileName = fileName;
        _userAborted = fileName == null;
      });
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearCachedFiles(context) async {
    _resetState();
    try {
      bool? result = await FilePicker.platform.clearTemporaryFiles();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: result! ? Colors.green : Colors.red,
          content: Text((result
              ? 'Temporary files removed with success.'
              : 'Failed to clean temporary files')),
        ),
      );
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }

  bottomSheet(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 20,
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: DropdownButton<FileType>(
                            hint: const Text('LOAD PATH FROM'),
                            value: _pickingType,
                            items: FileType.values
                                .map((fileType) => DropdownMenuItem<FileType>(
                              child: Text(fileType.toString()),
                              value: fileType,
                            ))
                                .toList(),
                            onChanged: (value) => setState(() {
                              _pickingType = value!;
                              if (_pickingType != FileType.custom) {
                                _controller.text = _extension = '';
                              }
                            })),
                      ),
                      ConstrainedBox(
                        constraints:
                        const BoxConstraints.tightFor(width: 100.0),
                        child: _pickingType == FileType.custom
                            ? TextFormField(
                          maxLength: 15,
                          autovalidateMode: AutovalidateMode.always,
                          controller: _controller,
                          decoration: const InputDecoration(
                            labelText: 'File extension',
                          ),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.none,
                        )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                child: Row(
                  children: <Widget>[
                    TextButton.icon(
                      icon: Icon(Icons.insert_drive_file, color: primaryColour),
                      onPressed: () => _pickFiles(),
                      label: Text('Pick file(s)',
                          style: TextStyle(color: primaryColour)),
                    ),
                    const SizedBox(width: 5),
                    TextButton.icon(
                      icon: Icon(Icons.folder, color: primaryColour),
                      onPressed: () => _selectFolder(),
                      label: Text('Pick folder',
                          style: TextStyle(color: primaryColour)),
                    ),
                    /*
                    const SizedBox(width: 5),
                    TextButton.icon(
                      icon: Icon(Icons.save, color: primaryColour),
                      onPressed: () => _saveFile(),
                      label:
                          Text('Save', style: TextStyle(color: primaryColour)),
                    ),
                    const SizedBox(width: 5),
                    */
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      home: Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: [
            Builder(
              builder: (BuildContext context) => _isLoading
                  ? const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: CircularProgressIndicator(),
                    )
                  : _userAborted
                      ? const Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            'User Model has aborted the dialog',
                          ),
                        )
                      : _directoryPath != null
                          ? ListTile(
                              title: const Text('Directory path'),
                              subtitle: Text(_directoryPath!),
                            )
                          : _paths != null
                              ? Container(
                                  padding: const EdgeInsets.only(bottom: 30.0),
                                  height: MediaQuery.of(context).size.height * 0.50,
                                width: MediaQuery.of(context).size.width,
                                  child: Scrollbar(
                                      child: ListView.separated(
                                        itemCount: _paths != null && _paths!.isNotEmpty ? _paths!.length : 1,
                                        itemBuilder:(BuildContext context, int index) {
                                          final bool isMultiPath = _paths != null && _paths!.isNotEmpty;
                                          final String name = 'File $index: ' + (isMultiPath ? _paths!.map((e) => e.name).toList()[index] : _fileName ?? '...');
                                          final path = kIsWeb ? null : _paths!.map((e) => e.path).toList()[index].toString();
                                          return Row(
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width * 0.85,
                                                child: ListTile(
                                                  title: Text(name),
                                                  subtitle: Text(path ?? ''),
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.clear, color: primaryColour),
                                                onPressed: () => _clearCachedFiles(context),
                                              ),
                                            ],
                                          );
                                        },
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                const Divider(),
                                      ),
                                  ),
                                )
                              : _saveAsFileName != null
                                  ? Row(
                                    children: [
                                      SizedBox(
                                        width: 500,
                                        child: ListTile(
                                            title: const Text('Save file'),
                                            subtitle: Text(_saveAsFileName!),
                                          ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.clear, color: primaryColour),
                                        onPressed: () => _clearCachedFiles(context),
                                      ),
                                    ],
                                  )
                                  : const SizedBox(),
            ),
            SizedBox(height: 100),
            Center(
              child: InkWell(
                child: const Icon(Icons.attach_file),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: ((builder) => bottomSheet(context)),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: const CustomBottomNavBarMA(
          selectedMenu: MenuState.navigatorScreen,
        ),
      ),
    );
  }
}
