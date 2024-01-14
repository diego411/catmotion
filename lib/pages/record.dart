import 'dart:io';

import 'package:coin_app/design/widgets/progress_accent_button.dart';
import 'package:flutter/material.dart';
import 'package:coin_app/design/colors.dart';
import 'package:coin_app/design/dimensions.dart';
import 'package:coin_app/pages/result.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;

import 'package:file_picker/file_picker.dart';

class RecordPage extends StatefulWidget {
  RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  bool isLoading = false;
  late AudioRecorder audioRecord;
  late AudioPlayer audioPlayer;
  bool isRecording = false;
  String? audioPath = null;

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
    if (audioPath == null) return;
    try {
      Source urlSource = UrlSource(audioPath!);
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

      if (response.statusCode == 200)
        print('Audio file uploaded successfully!');
      else
        return Future.error(
          'Failed to upload audio file. Status code: ${response.statusCode}',
        );

      return response.body;
    } catch (e) {
      return Future.error('Error uploading audio file: $e');
    } finally {
      client.close();
    }
  }

  void send() async {
    if (isLoading || audioPath == null) return;

    setState(() {
      isLoading = true;
    });

    String? predictedClass = null;
    try {
      predictedClass = await uploadAudioFile(audioPath!);
      print(predictedClass);
    } catch (error) {
      print(error.toString());
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).size.height * 0.2),
            dismissDirection: DismissDirection.none,
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'An Error occured',
              message: error.toString(),
              contentType: ContentType.failure,
              color: DefaultColors.failureRed,
            ),
          ),
        );
    }

    setState(() {
      isLoading = false;
    });

    if (predictedClass == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(result: predictedClass!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      _first(),
      Align(alignment: Alignment.bottomCenter, child: _sendButton(context))
    ]);
  }

  Widget _first() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: Icon(Icons.pets, color: Colors.white),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Column(
            children: [
              const Center(
                child: Text(
                  'Decoding an Audio-Clip of your Cat',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: fontSize35,
                    fontWeight: FontWeight.w500,
                    fontFamily: AutofillHints.familyName,
                  ),
                ),
              ),
              SizedBox(height: 100),
              ElevatedButton(
                child: Icon(Icons.file_upload_rounded, size: 40),
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles();

                  if (result == null) return;

                  final file = result.files.first;
                  print(file.path!);
                  setState(() {
                    isRecording = isRecording;
                    audioPath = file.path!;
                  });
                },
              ),
            ],
          ),
          const SizedBox(
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
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: isRecording ? stopRecording : startRecording,
                  child: Icon(isRecording ? Icons.stop : Icons.mic, size: 40),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
          if (audioPath != null)
            Center(
              child: ElevatedButton(
                onPressed: playRecording,
                child: const Icon(Icons.play_arrow_rounded, size: 40),
              ),
            )
        ],
      ),
    );
  }

  Widget _sendButton(context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          left: padding16,
          right: padding16,
          bottom: padding8,
        ),
        child: ProgressAccentButton(
          disabled: audioPath == null,
          title: 'Send',
          isLoading: isLoading,
          onTap: send,
        ),
      ),
    );
  }
}
