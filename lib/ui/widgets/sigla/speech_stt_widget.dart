import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextWidget extends StatefulWidget {
  final String language;
  final String labelText;
  final TextEditingController textEditingController;
  final Function(bool) onChanged;

  const SpeechToTextWidget({
    Key? key,
    required this.language,
    required this.labelText,
    required this.onChanged,
    required this.textEditingController,
  }) : super(key: key);

  @override
  State<SpeechToTextWidget> createState() => _SpeechToTextWidgetState();
}

class _SpeechToTextWidgetState extends State<SpeechToTextWidget> {
  final SpeechToText _speech = SpeechToText();
  bool _isButtonPressed = false;

  bool _speechEnabled = false;
  bool hasPermission = true;
  late String micText;
  late String localeId;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _initLanguage();
  }

  void _initSpeech() async {
    _speechEnabled = await _speech.initialize();
    hasPermission = await _speech.hasPermission;
  }

  void _initLanguage() {
    if (widget.language == 'en') {
      localeId = 'en_US';
      micText = 'Press and hold to speak.';
    } else {
      localeId = 'es_ES';
      micText = 'Manten presionado para hablar.';
    }
  }

  void _startListening() async {
    if (_speech.isListening) {
      _stopListening();
      return;
    }

    if (!_speech.isListening) {
      widget.textEditingController.clear();
      _handleTextChanged('');
      await _speech.listen(
        onResult: _onSpeechResult,
        localeId: localeId,
      );
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    widget.textEditingController.text = result.recognizedWords;

    _handleTextChanged(widget.textEditingController.text);
  }

  void _stopListening() async {
    await _speech.stop();
  }

  void _handleTextChanged(String text) {
    widget.onChanged(text.trim().isEmpty);
  }

  @override
  void dispose() {
    _speech.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TextField(
            controller: widget.textEditingController,
            decoration: InputDecoration(
              labelText: widget.labelText,
            ),
            onChanged: _handleTextChanged,
          ),
          const SizedBox(height: 16.0),
          if (hasPermission)
            Column(
              children: [
                AvatarGlow(
                  endRadius: 65.0,
                  animate: _isButtonPressed,
                  duration: const Duration(milliseconds: 2000),
                  repeat: true,
                  showTwoGlows: true,
                  child: GestureDetector(
                    onTapDown: (details) {
                      if (_speechEnabled) {
                        setState(() {
                          _isButtonPressed = true;
                        });
                        _startListening();
                      }
                    },
                    onTapUp: (details) {
                      if (mounted) {
                        setState(() {
                          _isButtonPressed = false;
                        });
                      }
                      _stopListening();
                    },
                    onTapCancel: () {
                      if (mounted) {
                        setState(() {
                          _isButtonPressed = false;
                        });
                      }
                      _stopListening();
                    },
                    child: CircleAvatar(
                      radius: _isButtonPressed ? 35 : 30,
                      backgroundColor:
                          _isButtonPressed ? Colors.red : Colors.blue,
                      child: Icon(
                        !_isButtonPressed ? Icons.mic_off : Icons.mic,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(micText),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
