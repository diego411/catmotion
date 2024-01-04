//import 'dart:js';

import 'package:coin_app/pages/second_page.dart';
import 'package:coin_app/pages/second_page2.dart';
import 'package:flutter/material.dart';

import 'package:coin_app/design/colors.dart';
import 'package:coin_app/design/dimensions.dart';
import 'package:coin_app/design/images.dart';
import 'package:coin_app/design/widgets/accent_button.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) => Stack(children: <Widget>[
        _first(),
        Align(alignment: Alignment.bottomCenter, child: _likeButton(context))
      ]);

  Widget _first() {

    return Scaffold(
        appBar: AppBar(
          title: const Text('CatMotion',
              style: TextStyle(
                color: primaryColor,
                fontSize: fontSize25,
                fontWeight: FontWeight.w500,
              )),
          centerTitle: true,
          elevation: elevation0,
          backgroundColor: surfaceColor,
        ),
        body: Stack(
          children: [
            const Text("What the heck - what means my cat?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: fontSize35,
                  fontWeight: FontWeight.w500,
                  fontFamily: AutofillHints.familyName,
                )),
            Center(child: catImage),
          ],
        ));
  }

  Widget _likeButton(context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: padding16, right: padding16, bottom:padding8),
        child: AccentButton(
            title: 'Let´s go',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecondPage2()),
              );
            }),
      ),
    );
  }
}
