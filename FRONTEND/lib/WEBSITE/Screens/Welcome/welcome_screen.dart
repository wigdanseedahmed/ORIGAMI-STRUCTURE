import 'package:origami_structure/imports.dart';

class WelcomeScreenWS extends StatefulWidget {
  const WelcomeScreenWS({Key? key}) : super(key: key);

  @override
  _WelcomeScreenWSState createState() => _WelcomeScreenWSState();
}

class _WelcomeScreenWSState extends State<WelcomeScreenWS> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // //show signed in user data
              // Text('Name: ${box1?.get('WelPage_name')}'),
              // Text('Email:  ${box1?.get('WelPage_email')}'),
              // Text('Phone No:  ${box1?.get('WelPage_phone')}'),

              //logged out delete all the data from hive db
              ElevatedButton(onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>const LoginScreenWS()));
              }, child: const Text('LogOut'))
            ],
          ),
        )
    );
  }
}