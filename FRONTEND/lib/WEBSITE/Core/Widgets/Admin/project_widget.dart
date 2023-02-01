import 'package:origami_structure/imports.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;

class ProjectWidgetWS extends StatefulWidget {
  const ProjectWidgetWS(
  {
    Key? key,
    required Size media,
  })  : _media = media,
        super(key: key);

  final Size _media;

  @override
  State<ProjectWidgetWS> createState() => _ProjectWidgetWSState();
}

class _ProjectWidgetWSState extends State<ProjectWidgetWS> {

  late List<ProjectModel> _allProjects = <ProjectModel>[];


  Future<List<ProjectModel>> readingAllProjectJsonData() async {
    /// Read Local Json File Directly
    /*String jsonString = await root_bundle.rootBundle.loadString('jsonFile/project_data.json');*/
    //print(jsonString);

    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(AppUrl.getProjects);

    /// Create Request to get data and response to read data
    final response = await http.get(
      uri,
      headers: {
        //"Accept": "application/json",
        "Access-Control-Allow-Origin": "*",
        // Required for CORS support to work
        //"Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
        "Content-Type, Access-Control-Allow-Origin, Accept",
        "Access-Control-Allow-Methods": "POST, DELETE, GET, PUT"
      },
    );
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      _allProjects = projectModelFromJson(response.body);
      // print("ALL  projects: $_allProjects");

      return _allProjects;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }


  @override
  Widget build(BuildContext context)
  {
    return Material(
      elevation: 10,
      shadowColor: Colors.grey,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        height: widget._media.height / 1.9,
        width: widget._media.width / 3 + 20,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Positioned(
                  top: 10,
                  left: 20,
                  child: Text(
                    'Projects of the Month',
                    style: cardTitleTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, left: 20, right: 20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const <Widget>[
                          SizedBox(width: 2),
                          Text(
                            'Project Leader',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            'Project Name',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            'Priority',
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            'Budget',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _allProjects.length,
                        itemBuilder: (context, index)
                        {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              textBaseline: TextBaseline.alphabetic,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      child: Text(_allProjects[index]
                                          .projectLeader!.substring(0, 2)),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(_allProjects[index].projectLeader!),
                                  ],
                                ),
                                Text(
                                  _allProjects[index].projectName!,
                                  textAlign: TextAlign.justify,
                                ),
                                Container(
                                  height: 30,
                                  width: 80,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: labelColours![_allProjects[index].criticalityColour!],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _allProjects[index].status!,
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Text(
                                    '${_allProjects[index].budget.toString()} K'),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
