import 'package:cat_motion/pages/record.dart';
import 'package:flutter/material.dart';

import 'package:cat_motion/design/colors.dart';
import 'package:cat_motion/design/dimensions.dart';
import 'package:cat_motion/design/images.dart';
import 'package:cat_motion/design/widgets/accent_button.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      _first(),
      Align(alignment: Alignment.bottomCenter, child: _likeButton(context))
    ]);
  }

  Widget _first() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CatMotion',
          style: TextStyle(
            color: primaryColor,
            fontSize: fontSize25,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        elevation: elevation0,
        backgroundColor: surfaceColor,
      ),
      body: Stack(
        children: [
          const Text("What the heck - what does my cat mean?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: fontSize35,
                fontWeight: FontWeight.w600,
                fontFamily: 'Merienda',
              )),
          Center(child: catImage),
        ],
      ),
    );
  }

  Widget _likeButton(context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
            left: padding16, right: padding16, bottom: padding8),
        child: AccentButton(
          title: 'Let´s go',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RecordPage()),
            );
          },
        ),
      ),
    );
  }
}
