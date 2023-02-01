import 'package:origami_structure/imports.dart';
import 'dart:ui';

class QuickContactWS extends StatelessWidget
{
  const QuickContactWS(
  {
    Key? key,
    required Size media,
  })  : _media = media, super(key: key);

  final Size _media;

  @override
  Widget build(BuildContext context)
  {
  final _formKey = GlobalKey<FormState>();
    void _showDialog()
    {
      showDialog(
        context: context,
        builder: (BuildContext context)
        {
          // return object of type Dialog
          return AlertDialog(
            title: const Text(
              'Successfully',
              style: TextStyle(
                color: Colors.greenAccent,
              ),
            ),
            content: const Text('Your Message has been sent.'),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
               TextButton(
                child:  const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Material(
      elevation: 10,
      shadowColor: Colors.grey,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        height: _media.height / 1.38 - 5,
        width: _media.width / 5 - 12,
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Quick Contact',
                style: cardTitleTextStyle,
              ),
              const SizedBox(height: 50),
              Material(
                elevation: 8.0,
                shadowColor: Colors.grey,
                borderRadius: BorderRadius.circular(4),
                child: TextFormField(
                  decoration: InputDecoration(
                      icon: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.person, color: Color(0xff224597)),
                      ),
                      hintText: 'Your name',
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 15.0),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(color: Colors.white, width: 0.0),),),
                ),
              ),
              const SizedBox(height: 20),
              Material(
                elevation: 8.0,
                shadowColor: Colors.grey,
                borderRadius: BorderRadius.circular(4),
                child: TextFormField(
                  decoration: InputDecoration(
                      icon: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.email, color: Color(0xff224597)),
                      ),
                      hintText: 'Your E-mail',
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding:
                          const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide:
                              const BorderSide(color: Colors.white, width: 0.0))),
                ),
              ),
              const SizedBox(height: 20),
              Material(
                elevation: 8.0,
                shadowColor: Colors.grey,
                borderRadius: BorderRadius.circular(4),
                child: TextFormField(
                  decoration: InputDecoration(
                      icon: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.lock, color: Color(0xff224597)),
                      ),
                      hintText: 'Your Subject',
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: const BorderSide(color: Colors.white, width: 0.0))),
                ),
              ),
              const SizedBox(height: 20),
              Material(
                elevation: 8.0,
                shadowColor: Colors.grey,
                borderRadius: BorderRadius.circular(4),
                child: TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: 'Message',
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 0.0,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomLeft,
                child: InkWell(
                  onTap: _showDialog,
                  child: Material(
                    shadowColor: Colors.grey,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    color: Colors.greenAccent,
                    child: Container(
                      alignment: Alignment.center,
                      height: 35,
                      width: 80,
                      child: const Text(
                        'Send',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}