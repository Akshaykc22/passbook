import 'package:flutter/material.dart';

class AddAccountHome extends StatefulWidget {
  String title;
   AddAccountHome({Key key,this.title}) : super(key: key);

  @override
  _AddAccountHomeState createState() => _AddAccountHomeState();
}

class _AddAccountHomeState extends State<AddAccountHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
    );
  }
}
