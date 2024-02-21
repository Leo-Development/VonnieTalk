import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:voice_access/providers/audio_data.dart';

enum AudioState { recording, stop, play, initial }

const veryDarkBlue = Color(0xff172133);
const kindaDarkBlue = Color(0xff202641);

void main() {
  runApp(RecordingScreen());
}

class RecordingScreen extends StatefulWidget {
  @override
  _RecordingScreenState createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  AudioState audioState = AudioState.initial;
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  String? _filePath;
  @override
  void initState() {
    // TODO: implement initState
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    super.initState();
  }

  void handleAudioState(AudioState state) {
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
            //start Recording
            await Future.delayed(Duration(seconds: 2));
            setState(() {
              audioState = AudioState.recording;
              handleAudioState(state);
            });
          } else {
            return;
          }
        });
        // Finished recording
        audioState = AudioState.recording;
      } else if (audioState == AudioState.recording) {
        audioState = AudioState.recording;

        _recorder?.stopRecorder().then((value) {
          _recorder?.closeRecorder();
          print('audio:$_filePath');
          Provider.of<AudioData>(context, listen: false).filepath =
              _filePath.toString();
        });

        audioState = AudioState.play;
        // Play recorded audio
      } else if (audioState == AudioState.play) {
        _player?.openPlayer().then((value) => _player?.startPlayer(
              fromURI: _filePath,
              codec: Codec.aacMP4,
              whenFinished: () {
                setState(() {
                  audioState = AudioState.play;
                });
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: handleAudioColour(),
            ),
            child: RawMaterialButton(
              fillColor: Colors.white,
              shape: CircleBorder(),
              padding: EdgeInsets.all(30),
              onPressed: () => handleAudioState(audioState),
              child: getIcon(audioState as AudioState),
            ),
          ),
          SizedBox(width: 20),
          if (audioState == AudioState.play || audioState == AudioState.stop)
            Container(
              padding: EdgeInsets.all(24),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: kindaDarkBlue,
              ),
              child: RawMaterialButton(
                fillColor: Colors.white,
                shape: CircleBorder(),
                padding: EdgeInsets.all(30),
                onPressed: () => setState(() {
                  audioState = AudioState.initial;
                }),
                child: const Icon(Icons.replay, size: 50),
              ),
            ),
        ],
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

  Icon getIcon(AudioState state) {
    switch (state) {
      case AudioState.play:
        return const Icon(Icons.play_arrow, size: 50);
      case AudioState.stop:
        return const Icon(Icons.stop, size: 50);
      case AudioState.recording:
        return const Icon(Icons.mic, color: Colors.redAccent, size: 50);
      default:
        return const Icon(Icons.mic, size: 50);
    }
  }
}
