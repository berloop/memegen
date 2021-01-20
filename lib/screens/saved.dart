import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:share/share.dart';

final Directory _memeDir = Directory('/storage/emulated/0/Memeneka™');

class SavedMemeScreen extends StatefulWidget {
  @override
  _SavedMemeScreenState createState() => _SavedMemeScreenState();
}

class _SavedMemeScreenState extends State<SavedMemeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!Directory("${_memeDir.path}").existsSync()) {
      print("Directory Not Existing");
      return Scaffold(
        appBar: new AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: new Text("My Memes.'"),
          centerTitle: true,
        ),
      );
    } else {
      var imageList = _memeDir
          .listSync()
          .map((item) => item.path)
          .where((item) => item.endsWith(".jpg"))
          .toList(growable: false);
      if (imageList.length > 0) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_outlined),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text("My Memes."),
          ),
          body: StaggeredGridView.countBuilder(
            padding: const EdgeInsets.all(8.0),
            crossAxisCount: 4,
            itemCount: imageList.length,
            itemBuilder: (context, index) {
              String imgPath = imageList[index];
              return Material(
                elevation: 8.0,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: InkWell(
                  onTap: () {
                    //do something about the image....
                    print(imgPath);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Image.file(File(imgPath)),
                            contentPadding: EdgeInsets.all(5),
                            actions: [
                              IconButton(
                                  icon: Icon(Icons.share_outlined),
                                  onPressed: () async {
                                    Share.shareFiles(['${imgPath}'],
                                        text: 'Sharing Meme!');
                                  }),
                              IconButton(
                                  icon: Icon(
                                    Icons.delete_outlined,
                                  ),
                                  onPressed: () {}),
                            ],
                          );
                        });
                  },
                  child: Hero(
                    tag: imgPath,
                    child: Image.file(
                      File(imgPath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
            staggeredTileBuilder: (i) =>
                StaggeredTile.count(2, i.isEven ? 2 : 3),
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
        );
      } else {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_outlined),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            title: Text("My Memes."),
          ),
          body: Center(
            child: Container(
              padding: EdgeInsets.only(bottom: 60.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon(Icons.error),
                  Image.asset(
                    "assets/images/not.png",
                    height: 100.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Hey! Created Memes will appear here!",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
  }
}
