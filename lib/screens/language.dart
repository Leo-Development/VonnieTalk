import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_access/providers/audio_data.dart';
import 'package:voice_access/providers/languageNot.dart';
import 'package:voice_access/widgets/recording_screen.dart';

class Language extends StatelessWidget {
  const Language({super.key});
  static const routeName = '/Language';

  void Save(BuildContext context) {
    final audio = Provider.of<AudioData>(context, listen: false).filepath;
    if (audio != null) {
      Provider.of<LanguageNot>(context, listen: false).addLan(audio.toString());

      print('in language: $audio');
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final lan = Provider.of<LanguageNot>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Language'),
        actions: [
          IconButton(onPressed: () => Save(context), icon: Icon(Icons.save))
        ],
      ),
      body: lan.language != null
          ? Center(
              child: Column(
                children: [
                  Text('Delete the previous translation to record a new one'),
                  SizedBox(
                    height: 10,
                  ),
                  IconButton(
                      onPressed: () {
                        lan.delete();
                        Provider.of<AudioData>(context, listen: false)
                            .removeAudio();
                      },
                      icon: Icon(
                        Icons.delete,
                        size: 20,
                      ))
                ],
              ),
            )
          : Center(
              child: Column(
                children: [
                  Text('Record a translation of \'Say\''),
                  SizedBox(
                    height: 20,
                  ),
                  RecordingScreen()
                ],
              ),
            ),
    );
  }
}
