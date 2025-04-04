

import 'package:example/select_photo_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'photo_view_widget.dart';

void main() {
   runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainWidget(),
    );
  }
}

class MainWidget extends StatelessWidget {
  const MainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('功能'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ElevatedButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => PhotoViewWidget()));
          }, child: Text('图片浏览器')),

          ElevatedButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectPhotoWidget()));
          }, child: Text('选择图片'))
        ],
      ),
    );
  }
}

