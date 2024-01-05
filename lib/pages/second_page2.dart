import 'dart:io';

import 'package:flutter/material.dart';
import 'package:coin_app/design/colors.dart';
import 'package:coin_app/design/dimensions.dart';
//import 'package:flutter_sound/flutter_sound.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'package:coin_app/design/widgets/accent_button.dart';
import 'package:coin_app/pages/result.dart';

import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

class SecondPage2 extends StatelessWidget {
  SecondPage2({super.key});
  final GlobalKey<_MyHomePageState> myChildWidgetKey =
      GlobalKey<_MyHomePageState>();

  Future<String> uploadAudioFile(String filePath) async {
    File audioFile = File(filePath);
    List<int> audioBytes = await audioFile.readAsBytes();

    var client = http.Client();

    var domain =
        'https://ds02.wim.uni-koeln.de/coin-audio/classify'; //'http://172.28.12.123:5000/classify';
    var url = Uri.parse(domain);

    try {
      var response = await client.post(
        url,
        headers: {'Content-Type': 'application/octet-stream'},
        body: audioBytes,
      );
      print(response);
      if (response.statusCode == 200) {
        print('Audio file uploaded successfully!');
      } else {
        print(
            'Failed to upload audio file. Status code: ${response.statusCode}');
      }
      return response.body;
    } catch (e) {
      print('Error uploading audio file: $e');
    } finally {
      client.close();
    }
    return "Error";
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      _first(),
      Align(alignment: Alignment.bottomCenter, child: _sendButton(context))
    ]);
  }

  Widget _first() {
    return const Scaffold(
        //title: const Text('Make an audio-clip of your cat',
        //style: TextStyle(
        //color: primaryColor,
        //fontSize: fontSize22,
        //fontWeight: FontWeight.w500,
        //)),
        //centerTitle: true,
        //elevation: elevation0,
        //backgroundColor: secondaryColor,
        //),
        body: MyHomePage(title: 'Make an audio-clip of your cat'));
  }

  Widget _sendButton(context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
            left: padding16, right: padding16, bottom: padding8),
        child: AccentButton(
            title: 'Send',
            onTap: () async {
              _MyHomePageState? childWidgetState =
                  myChildWidgetKey.currentState;
              if (childWidgetState != null) {
                // Access state and perform actions
                final audioPath = childWidgetState.getAudioPath();
                final String predictedClass = await uploadAudioFile(audioPath);
                print(predictedClass);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResultPage(result: predictedClass)),
                );
              }
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
  late AudioRecorder audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String audioPath = '';

  String getAudioPath() {
    return audioPath;
  }

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioRecord = AudioRecorder();
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
        const config = RecordConfig(encoder: AudioEncoder.wav, numChannels: 1);
        await audioRecord.start(config, path: await _getPath());
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

  Future<String> _getPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(
      dir.path,
      'audio_${DateTime.now().millisecondsSinceEpoch}.wav',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          const Center(
            child: Text('Make an Audio-Clip of your Cat',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: fontSize35,
                  fontWeight: FontWeight.w500,
                  fontFamily: AutofillHints.familyName,
                )),
          ),
          SizedBox(
            height: 110,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (isRecording)
                  const Text(
                    'Recording in Progress',
                    style: TextStyle(
                      fontSize: 20,
                      color: primaryColor,
                      fontWeight: FontWeight.w500,
                      fontFamily: AutofillHints.familyName,
                    ),
                  ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: isRecording ? stopRecording : startRecording,
                  child: Icon(isRecording ? Icons.stop : Icons.mic, size: 40),
                ),
                const SizedBox(
                  height: 50,
                ),
                if (!isRecording && audioPath != null)
                  ElevatedButton(
                      onPressed: playRecording,
                      child: Icon(Icons.play_arrow_rounded, size: 40)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
