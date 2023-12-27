import 'dart:io';

import 'package:flutter/material.dart';
import 'package:coin_app/design/colors.dart';
import 'package:coin_app/design/dimensions.dart';
//import 'package:flutter_sound/flutter_sound.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'package:coin_app/design/widgets/accent_button.dart';
import 'package:coin_app/pages/result/happy.dart';

import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';


class SecondPage2 extends StatelessWidget {
  const SecondPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[_first(), Align(alignment: Alignment.bottomCenter, child: _sendButton(context))]);
  }
  Widget _first(){
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
      body: const MyHomePage(title: 'Make an audio-clip of your cat'),
    );
  }
  Widget _sendButton(context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: padding16, right: padding16, bottom:padding8),
        child: AccentButton(
            title: 'Send',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HappyPage()),
              );
            }),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String audioPath = '';

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioRecord = Record();
    super.initState();
  }

  @override
  void dispose() {
    audioRecord.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();
        setState(() {
          isRecording = true;
        });
      }
    } catch (e) {
      print('Error Start Recording : $e');
    }
  }

  Future<void> stopRecording() async {
    try {
      String? path = await audioRecord.stop();
      setState(() {
        isRecording = false;
        audioPath = path!;
      });
    } catch (e) {
      print('Error Stopping record: $e');
    }
  }

  Future<void> playRecording() async {
    try {
      Source urlSource = UrlSource(audioPath);
      await audioPlayer.play(urlSource);
    } catch (e) {
      print('Error playing Recording : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Make an audio-clip of your cat',
        style: TextStyle(
              color: secondaryColor,
              fontSize: fontSize22,
              fontWeight: FontWeight.w500,
            )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (isRecording)
              const Text(
                'Recording in Progress',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ElevatedButton(
              onPressed: isRecording ? stopRecording : startRecording,
              child: isRecording
                  ? const Text('Stop Recording')
                  : const Text('Start Recording'),
            ),
            const SizedBox(
              height: 30,
            ),
            if (!isRecording && audioPath != null)
              ElevatedButton(
                onPressed: playRecording,
                child: const Text('Play Recording'),
              ),
          ],
        ),
      ),
    );
  }
}
