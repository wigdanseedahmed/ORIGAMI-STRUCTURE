import 'package:origami_structure/imports.dart';

class FireBase_Messaging extends StatefulWidget {
  const FireBase_Messaging({Key? key}) : super(key: key);

  @override
  State<FireBase_Messaging> createState() => _FireBase_MessagingState();
}

class _FireBase_MessagingState extends State<FireBase_Messaging> {
   //final FirebaseMessaging _fc = FirebaseMessaging.instance;

  void configureCallbacks(){
    /*_fc.configure(
      onMessage: (message)async{},
      onResume: (message)async{},
      onLanch: (message)async{},
    );*/
  }

   void subscribeToEvent(){
     //_fc.subscribeToTopic("Event");
   }

  @override
  Widget build(BuildContext context) {
    return Container();
  }


}
