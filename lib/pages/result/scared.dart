import 'dart:io';

import 'package:flutter/material.dart';
import 'package:coin_app/design/colors.dart';
import 'package:coin_app/design/dimensions.dart';
import 'package:coin_app/design/images.dart';
import 'package:coin_app/design/widgets/accent_button.dart';
import 'package:coin_app/pages/second_page.dart';

class HappyPage extends StatelessWidget {
  const HappyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      _bildText(),
      Align(
        alignment: Alignment.bottomCenter,
        child: ButtonBar(
          children: [_returnButton(context), _endButton(context)],
        ),
      )
    ]);
  }

  Widget _bildText() {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Result of Test',
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
            Center(child: scaredImage),
            const Text("Your cat is scared ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: fontSize35,
                  fontWeight: FontWeight.w500,
                  fontFamily: AutofillHints.familyName,
                )),
          ],
        ));
  }

  Widget _endButton(context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
            left: padding16, right: padding16, bottom: padding8),
        child: AccentButton(
            title: 'Exit',
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => exit(0)));
            }),
      ),
    );
  }

  Widget _returnButton(context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
            left: padding16, right: padding116, bottom: padding8),
        child: AccentButton(
            title: 'Try again',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecondPage()),
              );
            }),
      ),
    );
  }
}
