import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meme_gen/themeBuilder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
    return ThemeBuilder(
      defaultBrighness: Brightness.light,
      builder: (context, _brightness) {
        return MaterialApp(
          title: 'Creator',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.pink,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              brightness: _brightness),
          home: MyHomePage(title: 'Memeneka™'),
        );
      },
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
  //global key for repaint boundary
  final GlobalKey _globalKey = new GlobalKey();
  //variables...
  String headerTxt = " ";
  String footertxt = " ";
  File _image;
  Random _randomNumber = new Random();
  bool _isImageSelected = false;
  final _snackBarKey = GlobalKey<ScaffoldState>();

  Future getImage() async {
    var image;
    try {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    } catch (platformException) {
      print("not allowing " + platformException);
    }
    setState(() {
      if (image != null) {
        _isImageSelected = true;
      } else {}
      _image = image;
    });
    new Directory('storage/emulated/0/' + 'Memeneka').create(recursive: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _snackBarKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              //toggle pop-up...
            },
            icon: Icon(Icons.sort_outlined),
            color: Colors.white,
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.brightness_2_outlined, color: Colors.white),
                onPressed: () {
                  //toggle dark theme...
                  ThemeBuilder.of(context).changeAppTheme();
                })
          ],
          title: Center(
              child: Text(
            widget.title,
          )),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Picking an image..
            getImage();
          },
          child: Icon(Icons.add_a_photo_outlined),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              new SingleChildScrollView(
                // physics: NeverScrollableScrollPhysics(),
                child: RepaintBoundary(
                  //assigning the key...
                  key: _globalKey,
                  child: Stack(
                    children: <Widget>[
                      _image != null
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.file(
                                _image,
                                fit: BoxFit.cover,
                                height: 350.0,
                                width: MediaQuery.of(context).size.width,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                height: 350.0,
                                decoration: new BoxDecoration(
                                    color: Colors.black.withOpacity(.3),
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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: new BoxDecoration(
                              //container of image...
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(10.0)),
                          height: 350.0,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //header Text...
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    headerTxt.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: new TextStyle(
                                      fontSize: 25.0,
                                      color: Colors.white,
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(2.0, 1.0),
                                          blurRadius: 1.0,
                                          color: Colors.black87,
                                        ),
                                        Shadow(
                                          offset: Offset(1.0, 1.0),
                                          blurRadius: 1.0,
                                          color: Colors.black87,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                Spacer(),
                                //footer Text...
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    //converting text to uppercase...
                                    footertxt.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: new TextStyle(
                                      fontSize: 25.0,
                                      color: Colors.white,
                                      shadows: <Shadow>[
                                        Shadow(
                                          offset: Offset(2.0, 1.0),
                                          blurRadius: 1.0,
                                          color: Colors.black87,
                                        ),
                                        Shadow(
                                          offset: Offset(1.0, 1.0),
                                          blurRadius: 1.0,
                                          color: Colors.black87,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              _isImageSelected
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5, left: 16.0, right: 16.0, bottom: 16.0),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                headerTxt = value;
                              });
                            },
                            decoration: InputDecoration(hintText: "Text 1"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 5.0),
                          child: new TextField(
                            onChanged: (value) {
                              //using setstate to update test on real-time...
                              setState(() {
                                footertxt = value;
                              });
                            },
                            decoration: InputDecoration(hintText: "Text 2"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              new ElevatedButton(
                                onPressed: () {
                                  //do something..
                                  setState(() {
                                    generateMeme();
                                  });
                                },
                                child: new Icon(Icons.save_alt_outlined),
                              ),
                              SizedBox(width: 20.0),
                              new ElevatedButton(
                                  onPressed: () {
                                    //do something..
                                    print("Share to media..");
                                  },
                                  child: new Icon(Icons.share_outlined)),
                              SizedBox(height: 100.0),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container(
                      child: new Center(
                        child: new Text(
                          "Pick an Image to Get Started!😉",
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                      ),
                    ),
              // _createdMeme != null ? Image.file(_createdMeme): Container(),
            ],
          ),
        ));

    // This trailing comma makes auto-formatting nicer for build methods.
  }

  Future<void> generateMeme() async {
    //taking screenshot from a render Boundary...
    RenderRepaintBoundary _boundary =
        _globalKey.currentContext.findRenderObject();
    ui.Image _image = await _boundary.toImage();

    ByteData _byteData =
        await _image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = _byteData.buffer.asUint8List();

    var _storageStatus = await Permission.storage.status;
    print(_storageStatus);
    if (!_storageStatus.isGranted) await Permission.storage.request();

    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(pngBytes),
        quality: 60,
        name: "_generatedMemes");
    print(result);

    String _timestamp = new Random().toString();
    print(_timestamp);

    final snackBar = SnackBar(
      backgroundColor: Colors.pink,
      content: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.sentiment_satisfied,
              size: 25.0, color: Colors.greenAccent),
          SizedBox(width: 3.0),
          Text('Successfully Created a Meme!',
              style: TextStyle(
                color: Colors.white,
              )),
        ],
      ),
    );

//
  }
}
