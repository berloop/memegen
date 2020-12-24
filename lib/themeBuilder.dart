import 'package:flutter/material.dart';

class ThemeBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, Brightness brightness) builder;
  final Brightness defaultBrighness;

  ThemeBuilder({this.builder, this.defaultBrighness});
  @override
  _ThemeBuilderState createState() => _ThemeBuilderState();

  // to access this builder, we need a static object...
  static _ThemeBuilderState of(BuildContext context) {
    return context.ancestorStateOfType(const TypeMatcher<_ThemeBuilderState>());
  }
}

class _ThemeBuilderState extends State<ThemeBuilder> {
  Brightness _brightness;

  @override
  void initState() {
    super.initState();
    //light theme by-default..
    _brightness = widget.defaultBrighness;
    if (mounted) {
      setState(() {});
    }
  }

  void changeAppTheme() {
    setState(() {
      if (_brightness == Brightness.dark) {
        _brightness = Brightness.light;

      }
      else{
         _brightness = Brightness.dark;
      }
      print("App Theme has changed!");
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _brightness);
  }
}
