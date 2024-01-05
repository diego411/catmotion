import 'package:flutter/material.dart';
import 'package:coin_app/pages/first_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
//class ImageWidget extends StatelessWidget {
  //const ImageWidget({Key key}): super(key: key);
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Kiparo dispatcher',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const FirstPage(),
      );
}
