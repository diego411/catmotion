import 'package:coin_app/pages/record.dart';
import 'package:flutter/material.dart';
import 'package:coin_app/design/colors.dart';
import 'package:coin_app/design/dimensions.dart';
import 'package:coin_app/design/images.dart';
import 'package:coin_app/design/widgets/accent_button.dart';

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
        child: _returnButton(context),
      ),
    ]);
  }

  Widget _bildText() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Our Prediction',
          style: TextStyle(
            color: primaryColor,
            fontSize: fontSize25,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        elevation: elevation0,
        backgroundColor: surfaceColor,
        leading: Icon(Icons.pets),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50, bottom: 70),
            child: Text(
              labelMap[result]!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: secondaryTextColor,
                fontSize: fontSize35,
                fontWeight: FontWeight.w500,
                fontFamily: AutofillHints.familyName,
              ),
            ),
          ),
          Center(child: imageMap[result]!),
        ],
      ),
    );
  }

  Widget _returnButton(context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          left: padding16,
          right: padding16,
          bottom: padding8,
        ),
        child: AccentButton(
          title: 'Try Again',
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
