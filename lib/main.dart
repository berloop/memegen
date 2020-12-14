import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  //fixing async issue on main()..
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final Color darken = Color(0XFF121212);

    return MaterialApp(
      title: 'Creator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Meme Creator v1.0'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;
  File _createdMeme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(
            widget.title,
          )),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Respond to button press
          },
          icon: Icon(Icons.add_a_photo_outlined),
          label: Text('Add an Image'),
        ),
        body: new SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Stack(children: <Widget>[
            _image != null
                ? Image.file(_image)
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 350.0,
                      decoration: new BoxDecoration(
                          color: Colors.black.withOpacity(.2),
                          // borderRadius: BorderRadius.only(
                          //   // topRight: Radius.circular(30.0),
                          //   // bottomLeft: Radius.circular(30.0),
                          // ),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Center(
                        child: Icon(
                          Icons.photo_camera,
                          color: Colors.black26,
                          size: 38.0,
                        ),
                      ),
                    ),
                  ),
          ]),
        ));

    // This trailing comma makes auto-formatting nicer for build methods.
  }
}
