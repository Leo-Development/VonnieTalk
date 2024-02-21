import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:voice_access/providers/data.dart';
import 'package:voice_access/providers/items.dart';
import 'package:voice_access/providers/languageNot.dart';
import 'dart:ui' as ui;

import 'package:voice_access/widgets/voice_recording.dart';

//import 'package:voice_access/providers/items.dart';
enum AudioState { recording, stop, play, initial }

const veryDarkBlue = Color(0xff172133);
const kindaDarkBlue = Color(0xff202641);

class ItemList extends StatefulWidget {
  const ItemList(this.itemData);
  final Data itemData;
  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  FlutterSoundPlayer? _player;
  AudioState audioState = AudioState.initial;
  FlutterTts _tts = FlutterTts();
  bool _isProcessing = false;

  @override
  void initState() {
    // TODO: implement initState
    _player = FlutterSoundPlayer();
    Provider.of<LanguageNot>(context, listen: false).fetch();
    _tts = FlutterTts();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _player?.stopPlayer();
    _player?.closePlayer();
    _tts.stop();
    super.dispose();
  }

  void _showBlur(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.black.withOpacity(0.5),
            alignment: Alignment.center,
            child: Column(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.cancel_sharp,
                    color: Colors.grey,
                  ),
                  alignment: Alignment.topLeft,
                  iconSize: 40,
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  child: Image(
                    image: widget.itemData.imagepath,
                    fit: BoxFit.fill,
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: double.infinity,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Voicerecording(widget.itemData)
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //final itemData = Provider.of<Data>(context);

    final itemPro = Provider.of<Items>(context, listen: false);
    print('We are in the itemList');
    return Stack(children: [
      GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            title: Text(
              widget.itemData.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
                onPressed: () async {
                  _showBlur(context);
                  // handleAudioState(AudioState.recording);
                },
                icon: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: Image.asset(
                    'assets/talk.jfif',
                    fit: BoxFit.cover,
                  ),
                )),
            trailing: IconButton(
                onPressed: () {
                  itemPro.delete(widget.itemData.id.toString());
                },
                icon: const Icon(Icons.delete)),
          ),
          child: GestureDetector(
              onDoubleTap: () async {
                // _isProcessing = false;
                // print('printing the title:${widget.itemData.title}');
                // print('printing the audio file:${widget.itemData.audioPath}');
                if (!_isProcessing) {
                  try {
                    if (!_isProcessing) if (!_isProcessing &&
                        widget.itemData.audioPath != null) {
                      // await _tts.stop();
                      _isProcessing = true;
                      print('This is the first process$_isProcessing');
                      await _player?.openPlayer();
                      await _player?.startPlayer(
                        fromURI: widget.itemData.audioPath,
                        codec: Codec.aacMP4,
                      );
                      await Future.delayed(Duration(seconds: 2));
                    } else {
                      // print('am in the else block ');
                      // await _tts
                      //     .setVoice({"name": "en-US-language", "locale": "en-US"});
                      _isProcessing = true;
                      _tts.setCompletionHandler(() {
                        print('speak has completred ');
                        // _tts.setCompletionHandler(
                        //   () {},
                        // );
                      });
                      await _tts.speak(widget.itemData.title);
                      // _tts.setCompletionHandler(() {
                      //   print('speak has completred2 ');
                      //   // _tts.setCompletionHandler(
                      //   //   () {},
                      //   // );
                      // });

                      //await Future.delayed(Duration(seconds: 2));
                    }
                    // print('after tts');
                    //Removed

                    await Future.delayed(Duration(seconds: 2));
                    _showBlur(context);
                    print('This is the second process$_isProcessing');
                    await Future.delayed(Duration(seconds: 10));
                    print('This is the second 2nd process$_isProcessing');
                    _isProcessing = false;
                  } catch (e) {
                    print(widget.itemData.audioPath);
                    //_isProcessing = false;
                  }
                }
                //_isProcessing = false;
              },
              // ignore: unnecessary_null_comparison
              child: widget.itemData.image != null
                  ? Image(
                      image: widget.itemData.imagepath,
                      fit: BoxFit.cover,
                    )
                  : Placeholder())),
    ]);
  }
}
