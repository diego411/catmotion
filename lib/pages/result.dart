import 'dart:io';

import 'package:flutter/material.dart';
import 'package:coin_app/design/colors.dart';
import 'package:coin_app/design/dimensions.dart';
import 'package:coin_app/design/images.dart';
import 'package:coin_app/design/widgets/accent_button.dart';
import 'package:coin_app/pages/second_page2.dart';

class ResultPage extends StatelessWidget {
  final String result;
  ResultPage({super.key, required this.result});

  final labelMap = {
    'chirp':
        'Your cat seems to be in hunting mode. We just heard a chirping sound.',
    'hiss': 'Was that a hiss? Your cat seems angry!',
    'meow': '',
    'purr': 'Your cat seems happy and relaxed. Its purring!',
    'angry (Meow)': 'Your cat seems angry!',
    'happy (Meow)': 'Your cat seems happy!',
    'sad (Meow)': 'Your cat seems sad!',
    'scared (Meow)': 'Your cat seems scared!'
  };

  final Map<String, Widget> imageMap = {
    'chirp': chirpImage,
    'hiss': hissImage,
    'meow': notFoundImage,
    'purr': purrImage,
    'angry (Meow)': angryImage,
    'happy (Meow)': happyImage,
    'sad (Meow)': sadImage,
    'scared (Meow)': scaredImage
  };

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
          title: const Text('Our prediction',
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
            Center(child: imageMap[result]!),
            Text(labelMap[result]!,
                textAlign: TextAlign.center,
                style: const TextStyle(
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
                MaterialPageRoute(builder: (context) => SecondPage2()),
              );
            }),
      ),
    );
  }
}
