import 'package:origami_structure/imports.dart';
import 'package:http/http.dart' as http;

class TaskNetworkHepler{
  Future<List<TaskModel>> readTasksFromJsonFile( List<TaskModel> allTasks) async {
    /// Read Local Json File Directly
    /*String jsonString = await DefaultAssetBundle.of(context)
        .loadString('jsonFile/task_data.json');*/
    //print(jsonString);

    /// String to URI, using the same url used in the nodejs code
    var uri = Uri.parse(AppUrl.tasks);

    /// Create Request to get data and response to read data
    final response = await http.get(
      uri,
      headers: {
        //"Accept": "application/json",
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        //"Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers": "Content-Type, Access-Control-Allow-Origin, Accept",
        "Access-Control-Allow-Methods": "POST, DELETE, GET, PUT"
      },
    );
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');

    if (response.statusCode == 200) {
        allTasks = taskModelFromJson(response.body);
        //print("ALL  tasks: allTasks");

      return allTasks;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }
}