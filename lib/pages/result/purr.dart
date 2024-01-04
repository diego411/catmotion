import 'dart:io';

import 'package:coin_app/pages/first_page.dart';
import 'package:flutter/material.dart';
import 'package:coin_app/design/colors.dart';
import 'package:coin_app/design/dimensions.dart';
import 'package:coin_app/design/images.dart';
import 'package:coin_app/design/widgets/accent_button.dart';
import 'package:coin_app/pages/second_page.dart';
import 'package:coin_app/pages/second_page2.dart';

class HappyPage extends StatelessWidget {
  const HappyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      _bildText(),
      Align(
        alignment: Alignment.bottomCenter,
        child: _returnButton(context),
        ),
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
        body: Column(
          children: [
            const Padding(
              padding:  EdgeInsets.only(top: 50, bottom: 70),
              child:  Text("Your cat is relaxed!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: fontSize35,
                    fontWeight: FontWeight.w500,
                    fontFamily: AutofillHints.familyName,
                  )),
            ),
            Center(child: purrImage),
          ],
        ));
  }


  Widget _returnButton(context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: padding16, right: padding16, bottom:padding8),
        child: AccentButton(
            title: 'Try Again',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FirstPage()),
              );
            }),
      ),
    );
  }
}
