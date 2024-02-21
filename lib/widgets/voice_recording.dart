import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:voice_access/providers/data.dart';
import 'package:voice_access/providers/languageNot.dart';

enum AudioState { recording, stop, play, initial }

const veryDarkBlue = Color(0xff172133);
const kindaDarkBlue = Color(0xff202641);

class Voicerecording extends StatefulWidget {
  //factory Voicerecording.instance() => Voicerecording();
  final Data itemData;
  Voicerecording(this.itemData);

  @override
  _VoicerecordingState createState() => _VoicerecordingState();
}

class _VoicerecordingState extends State<Voicerecording> {
  AudioState audioState = AudioState.initial;
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  String? _filePath;
  FlutterTts _tts = FlutterTts();
  var _count = 0;
  @override
  void initState() {
    // TODO: implement initState
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    _tts = FlutterTts();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _recorder?.closeRecorder();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    intiTts();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void intiTts() async {
    if (Provider.of<LanguageNot>(context).language != null) {
      await _player?.openPlayer();
      print(
          'printing from init:${Provider.of<LanguageNot>(context, listen: false).language}');
      await _player?.startPlayer(
        fromURI: Provider.of<LanguageNot>(context, listen: false).language,
        codec: Codec.aacMP4,
        whenFinished: () async {
          if (widget.itemData.audioPath != null) {
            await _player?.openPlayer();
            await _player?.startPlayer(
              fromURI: widget.itemData.audioPath,
              codec: Codec.aacMP4,
            );
            //return;
          } else {
            await _tts.speak(widget.itemData.title);
          }
          await Future.delayed(Duration(seconds: 2));
          handleAudioState(audioState);
        },
      );

      await Future.delayed(Duration(seconds: 2));
    } else {
      await _tts.speak('Say.');
      await Future.delayed(Duration(seconds: 1));
      // print('inside sencond if');
      if (widget.itemData.audioPath != null) {
        await _player?.openPlayer();
        await _player?.startPlayer(
          fromURI: widget.itemData.audioPath,
          codec: Codec.aacMP4,
        );
        //return;
      } else {
        await _tts.speak(widget.itemData.title);
      }
      await Future.delayed(Duration(seconds: 2));
      handleAudioState(audioState);
    }
  }

  void handleAudioState(AudioState state) {
    print('handleAudioState');
    _count = _count + 1;
    //
    setState(() {
      if (audioState == AudioState.initial) {
        // Starts recording

        _recorder?.openRecorder().then((value) async {
          PermissionStatus status = await Permission.microphone.status;
          if (!status.isGranted) {
            status = await Permission.microphone.request();
          }

          if (status.isGranted) {
            Directory appDocDirectory =
                await getApplicationDocumentsDirectory();
            String fileName =
                '/audio_record_${DateTime.now().millisecondsSinceEpoch}.m4a';
            _filePath = appDocDirectory.path + fileName;

            _recorder?.startRecorder(toFile: _filePath, codec: Codec.aacMP4);

            await Future.delayed(Duration(seconds: 5));
            setState(() {
              audioState = AudioState.recording;
              handleAudioState(state);
            });

            //start Recording
          } else {
            return;
          }
        });

        // Finished recording
        audioState = AudioState.recording;
      } else if (audioState == AudioState.recording) {
        //audioState = AudioState.recording;

        _recorder?.stopRecorder().then((value) {
          _recorder?.closeRecorder();
          print('audio:$_filePath');
          // Provider.of<AudioData>(context, listen: false).filepath =
          //     _filePath.toString();
        });
        setState(() {
          audioState = AudioState.play;
          handleAudioState(state);
        });

        // Play recorded audio
      } else if (audioState == AudioState.play) {
        _player?.openPlayer().then((value) => _player?.startPlayer(
              fromURI: _filePath,
              codec: Codec.aacMP4,
              whenFinished: () async {
                setState(() {
                  audioState = AudioState.play;
                });
                //widget.onFinished?.call();

                await Future.delayed(Duration(seconds: 1));
                Navigator.of(context).pop();
              },
            ));
        audioState = AudioState.stop;

        // Stop recorded audio
      } else if (audioState == AudioState.stop) {
        _player?.stopPlayer().then((value) => _player?.closePlayer());
        audioState = AudioState.play;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: handleAudioColour(),
        ),
        // height: 100,
        child: RawMaterialButton(
          fillColor: Colors.white,
          shape: CircleBorder(),
          padding: EdgeInsets.all(30),
          onPressed: () {
            // handleAudioState(audioState);
          },
          child: getIcon(audioState),
        ),
      ),
    );
  }

  Color handleAudioColour() {
    if (audioState == AudioState.recording) {
      return Colors.deepOrangeAccent.shade700.withOpacity(0.5);
    } else if (audioState == AudioState.stop) {
      return Colors.green.shade900;
    } else {
      return kindaDarkBlue;
    }
  }

  getIcon(AudioState state) {
    switch (state) {
      case AudioState.play:
        return const Icon(Icons.play_arrow, size: 50);
      case AudioState.stop:
        return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/mouth.jfif',
              height: 100,
            ));
      case AudioState.recording:
        return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/ear.jfif',
              height: 100,
            ));
      default:
        return const Icon(Icons.mic, size: 50);
    }
  }
}
