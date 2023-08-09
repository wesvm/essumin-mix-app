import 'package:essumin_mix/data/models/sigla/sigla.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused, continued }

class AcronymsInfo extends StatefulWidget {
  final List<Sigla> data;

  const AcronymsInfo({required this.data, super.key});

  @override
  State<AcronymsInfo> createState() => _AcronymsInfoState();
}

class _AcronymsInfoState extends State<AcronymsInfo> {
  final FlutterTts flutterTts = FlutterTts();

  late TtsState ttsState;

  @override
  void initState() {
    super.initState();
    ttsState = TtsState.stopped;
  }

  void _speakText(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.4);

    ttsState = TtsState.playing;
    await flutterTts.speak(text);
    ttsState = TtsState.stopped;
  }

  void _stopSpeaking() async {
    await flutterTts.stop();
    ttsState = TtsState.stopped;
  }

  @override
  void dispose() {
    _stopSpeaking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info'),
      ),
      body: ListView.builder(
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: InkWell(
              onTap: () => _speakText(widget.data[index].value),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromRGBO(113, 128, 150, 0.25),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.volume_up_rounded,
                            color: Color.fromARGB(255, 58, 100, 238),
                            size: 30,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            widget.data[index].key,
                            style: const TextStyle(fontSize: 20.0),
                            textAlign: TextAlign.center,
                          ),
                        ]),
                    const SizedBox(height: 8.0),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromRGBO(113, 128, 150, 0.25),
                          width: 1.0,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.data[index].value,
                          style: const TextStyle(fontSize: 18.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
