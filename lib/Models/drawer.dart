import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:meme_gen/screens/explore.dart';
import 'package:meme_gen/screens/saved.dart';
import 'package:url_launcher/url_launcher.dart';

class MemenekaDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: new ListView(
        children: [
          DrawerHeader(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16.0, left: 8.0, right: 8.0, bottom: 16.0),
                  child: Image.asset(
                    "assets/images/splash.png",
                    height: 100.0,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    new Text(
                      "Memeneka™",
                      style: TextStyle(fontSize: 17.0, color: Colors.white),
                      textAlign: TextAlign.start,
                    ),
                    new Text(
                      "Own your meme.",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Normal",
                      ),
                    ),
                  ],
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.teal,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          ListTile(
            leading: Icon(Icons.home_outlined),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.amp_stories_outlined),
            title: Text('Explore'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExploreScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.folder_outlined),
            title: Text('My Saved'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SavedMemeScreen()),
              );
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.settings_applications_outlined),
          //   title: Text('Settings'),
          //   onTap: () {
          //     // Update the state of the app.
          //     // ...
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About'),
            onTap: () async {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Icon(Icons.person_outline_rounded),
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
                          new Text("Version 1.1"),
                          Divider(
                            color: Colors.teal,
                          ),
                          Image.asset(
                            "assets/images/splash.png",
                            height: 100.0,
                          ),
                          SizedBox(height: 10.0),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: new Text(
                              "'A meme creator app intended for creating memes, So make memes guys and together we will change the world!😂",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w100),
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
                            ],
                          )
                        ],
                      ),
                    );
                  });
            },
          ),
          ListTile(
            leading: Icon(Icons.share_outlined),
            title: Text('Tell a Friend'),
            onTap: () async => await _shareMemeneka(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "App Version 1.1",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.withOpacity(.5)),
            ),
          )
        ],
      ),
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
