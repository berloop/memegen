import 'dart:io';
import 'dart:math' show Random;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meme_gen/themeBuilder.dart';
import 'package:faker/faker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> main() async {
  //fixing async issue on main()..
  WidgetsFlutterBinding.ensureInitialized();
  //fixing the app potrait mode...
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
          title: 'Memeneka™',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              fontFamily: "Nexa Bold",
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                  foregroundColor: Colors.white, backgroundColor: Colors.teal),
              primarySwatch: Colors.teal,
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
  bool _isImageSelected = false;
  final _snackBarKey = GlobalKey<ScaffoldState>();
  bool isThemeChanged = false;
  final _firstController = TextEditingController();
  final _secondController = TextEditingController();

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

  void dispose() {
    // Clean up the controller when the widget is disposed.
    _firstController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _snackBarKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: [
            //changing app theme.....
            IconButton(
              icon: Icon(isThemeChanged
                  ? Icons.brightness_2_outlined
                  : Icons.wb_sunny_outlined),
              onPressed: () {
                //toggle dark theme...
                ThemeBuilder.of(context).changeAppTheme();
                setState(() {
                  isThemeChanged = !isThemeChanged;
                });

                //adding a delay before displaying a toast..
                Future.delayed(const Duration(milliseconds: 500), () {
                  setState(() {
                    Fluttertoast.showToast(
                        msg: "Theme Changed!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.teal,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  });
                });
              },
            ),
            //pop up menu...
            popUpMenuButton(),
          ],
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.title,
              style: new TextStyle(fontWeight: FontWeight.normal),
            ),
          ),
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
                                    // color: Colors.black.withOpacity(.3),
                                    color: Colors.teal.withOpacity(.3),
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
                                      fontFamily: "Impacted",
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
                                      fontFamily: "Impacted",
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
                height: 3.0,
              ),
              _isImageSelected
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 5, left: 16.0, right: 16.0, bottom: 8.0),
                          child: TextField(
                            controller: _firstController,
                            maxLength: 100,
                            maxLengthEnforced: true,
                            onChanged: (value) {
                              setState(() {
                                headerTxt = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Text 1",
                              prefixIcon:
                                  new Icon(Icons.drive_file_rename_outline),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 3.0),
                          child: new TextField(
                            controller: _secondController,
                            maxLength: 100,
                            maxLengthEnforced: true,
                            onChanged: (value) {
                              //using setstate to update test on real-time...
                              setState(() {
                                footertxt = value;
                              });
                            },
                            decoration: InputDecoration(
                                hintText: "Text 2",
                                prefixIcon:
                                    new Icon(Icons.drive_file_rename_outline)),
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
                                    setState(() {
                                      _shareMeme();
                                    });
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
                              fontSize: 20.0, fontWeight: FontWeight.bold),
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

    //try to generate random names for images...
    String _memeName = faker.internet.userName() + "_memeneka2021";
    print(_memeName);

    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(pngBytes),
                //Quality of a meme...
                quality: 70,
                name: _memeName)
            .whenComplete(() {
      final snackBar = SnackBar(
        backgroundColor: Colors.teal,
        content: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.done_all_outlined, size: 25.0, color: Colors.white),
            SizedBox(width: 3.0),
            Text('Successfully Saved to Device!',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontFamily: "Nexa Bold")),
          ],
        ),
      );

      _snackBarKey.currentState.showSnackBar(snackBar);
    });
    print(result);

//
  }

  Future<void> _shareMeme() async {
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

    //try to generate random names for images...
    String _memeName = faker.internet.userName() + "_memeneka2021";
    print(_memeName);
    //result is a map-type with filepath, isSuccess and errorMessage...
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(pngBytes),
        quality: 70,
        name: _memeName);

    //getting the path of the saved meme....
    //converting the entry to a list so I can access by index...
    var entryList = result.entries.toList();
    // var imagePath = entryList[0].value;
    print(entryList[0].value); // prints the first value which is the path....
    // List<String> imagePaths = [];
    // imagePaths.add(imagePath);

    await Share.file('Memeneka', _memeName + ".jpg", pngBytes, 'image/jpg');
  }

  Widget popUpMenuButton() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.sort_outlined,
        color: Colors.white,
        size: 24,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: "help",
          child: Row(
            children: <Widget>[
              Icon(Icons.help_outlined, color: Colors.teal),
              SizedBox(
                width: 10.0,
              ),
              Text(
                "Help",
                style: TextStyle(fontSize: 12.0),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: "about",
          child: Row(
            children: <Widget>[
              Icon(
                Icons.person_outline,
                color: Colors.teal,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                "About.",
                style: TextStyle(fontSize: 12.0),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: "rate",
          child: Row(
            children: <Widget>[
              Icon(
                Icons.rate_review_outlined,
                color: Colors.teal,
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                "Rate Us",
                style: TextStyle(fontSize: 12.0),
              ),
            ],
          ),
        ),
      ],
      onSelected: (val) async {
        if (val == "help") {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new Text("How to Use Memeneka™"),
                      )
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Okay, I Get it Now!"),
                    ),
                  ],
                );
              });

          print("Help");
        } else if (val == "about") {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Icon(Icons.person_rounded),
                            SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              "About Memeneka™",
                              style: new TextStyle(fontSize: 18.0),
                            ),
                          ],
                        ),
                      ),
                      new Text("Version 1.0"),
                      Divider(
                        color: Colors.teal,
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: new Text(
                          "'A meme creator app intended for creating memes or text-statuses, So make memes guys and together we will change the world!😂",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w100),
                        ),
                      ),
                      Divider(
                        color: Colors.teal,
                      ),
                      SizedBox(height: 15.0),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              String _devUrl = "https://egretstudios.com/";
                              _launchInBrowser(_devUrl);
                              print("Opening Developer's Website");
                            },
                            child: Text("View Developer's Site"),
                          ),
                          new IconButton(
                            icon: new Icon(Icons.share_outlined),
                            onPressed: () async => await _shareMemeneka(),
                          )
                        ],
                      )
                    ],
                  ),
                );
              });

          print("About Developer");
        } else if (val == "rate") {
          showDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assets/images/celeb.png"),
                      SizedBox(height: 15.0),
                      Text(
                        "Do you love Memeneka™?",
                        textAlign: TextAlign.center,
                        style: new TextStyle(fontSize: 20.0),
                      ),
                      Divider(
                        color: Colors.teal,
                      ),
                      SizedBox(height: 15.0),
                      Text(
                        "If you enjoy this app, Please rate and review it on Play Store. Thank You!",
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Divider(
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(height: 15.0),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.grey),
                            ),
                            child: Text("Later!"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              print("Open Playstore...");
                            },
                            child: Text("Rate It Now"),
                          )
                        ],
                      )
                    ],
                  ),
                );
              });
          print("Rate");
        }
      },
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _shareMemeneka() async {
    try {
      Share.text(
          'Tell a Friend about Memeneka™',
          'Did you know about Memeneka™ App? Its a cool app that allows you to make memes, If we can make memes, we can change the world😂.',
          'text/plain');
    } catch (e) {
      print('error: $e');
    }
  }
}
