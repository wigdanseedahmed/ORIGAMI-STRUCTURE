import 'package:origami_structure/imports.dart';

class WelcomeScreenMA extends StatefulWidget {
  const WelcomeScreenMA({Key? key}) : super(key: key);

  @override
  _WelcomeScreenMAState createState() => _WelcomeScreenMAState();
}

class _WelcomeScreenMAState extends State<WelcomeScreenMA> {

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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder)=>const LoginScreenMA()));
              }, child: const Text('LogOut'))
            ],
          ),
        )
    );
  }
}