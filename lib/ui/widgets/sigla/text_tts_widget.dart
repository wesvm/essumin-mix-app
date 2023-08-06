import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused, continued }

class SpeakableTextWidget extends StatefulWidget {
  final String text;
  final bool state;

  const SpeakableTextWidget({Key? key, required this.text, required this.state})
      : super(key: key);

  @override
  State<SpeakableTextWidget> createState() => _SpeakableTextWidgetState();
}

class _SpeakableTextWidgetState extends State<SpeakableTextWidget> {
  final FlutterTts flutterTts = FlutterTts();

  late TtsState ttsState;
  late bool showText;

  @override
  void initState() {
    super.initState();
    showText = widget.state;
    ttsState = TtsState.stopped;
  }

  void _speakText(String text, double speechRate, int duration) async {
    if (ttsState == TtsState.playing) {
      _stopSpeaking();
      return;
    }

    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(speechRate);

    ttsState = TtsState.playing;

    //await flutterTts.speak(spacedText);
    for (int i = 0; i < text.length; i++) {
      if (ttsState == TtsState.stopped) break;
      String letter = text[i].toUpperCase();
      await flutterTts.speak(letter);
      await Future.delayed(Duration(milliseconds: duration));
    }
    ttsState = TtsState.stopped;
  }

  void _stopSpeaking() async {
    await flutterTts.stop();
    ttsState = TtsState.stopped;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromRGBO(113, 128, 150, 0.25),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                !showText ? const Text('?') : Text(widget.text),
                TextButton(
                  onPressed: () => setState(() {
                    showText = !showText;
                  }),
                  child: const Text('Mostrar sigla'),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromRGBO(113, 128, 150, 0.25),
                width: 2.0,
              ),
            ),
          ),
          Expanded(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextButton.icon(
                label: const Text('fast'),
                icon: const Icon(Icons.volume_up_rounded),
                onPressed: () {
                  _speakText(widget.text, 0.85, 500);
                },
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
                    const Size(135, 35),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFF1e40af)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
              ),
              TextButton.icon(
                label: const Text('slow'),
                icon: const Icon(Icons.volume_up_rounded),
                onPressed: () {
                  _speakText(widget.text, 0.5, 800);
                },
                style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all<Size>(
                    const Size(135, 35),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFF1e40af)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}