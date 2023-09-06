import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';

import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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
  State<SpeechToTextWidget> createState() => SpeechToTextWidgetState();
}

class SpeechToTextWidgetState extends State<SpeechToTextWidget> {
  late stt.SpeechToText _speech;

  bool speechAvailable = false;
  bool _isListening = false;
  bool hasPermission = true;

  late String micText;
  late String micList;
  late String localeId;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
    _initLanguage();
  }

  Future<void> _initSpeech() async {
    var hasPermission = await _speech.hasPermission;
    if (!mounted) return;

    setState(() {
      hasPermission = hasPermission;
    });
  }

  void _initLanguage() {
    if (widget.language == 'en') {
      localeId = 'en_US';
      micText = 'Press to speak.';
      micList = 'Listening..';
    } else {
      localeId = 'es_ES';
      micText = 'Presiona para hablar.';
      micList = 'Escuchando..';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initSpeech();
  }

  Future<void> _startListening() async {
    if (_isListening || _speech.isListening) {
      _stopListening();
      return;
    }

    var speechAvailable = await _speech.initialize(
      onStatus: (status) => debugPrint('status $status'),
      onError: errorListener,
    );

    if (speechAvailable) {
      widget.textEditingController.clear();
      _handleTextChanged('');
      setState(() => _isListening = true);
      _speech.listen(
        onResult: _onSpeechResult,
        localeId: localeId,
        pauseFor: const Duration(seconds: 3),
        cancelOnError: true,
      );
    }
  }

  void errorListener(SpeechRecognitionError error) {
    debugPrint('error $error');
    debugPrint('mounted: $mounted');
    if (mounted) {
      if (error.permanent) cancelListening();
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    widget.textEditingController.text = result.recognizedWords;
    _handleTextChanged(widget.textEditingController.text);
    if (result.finalResult) setState(() => _isListening = false);
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  void _handleTextChanged(String text) {
    widget.onChanged(text.trim().isEmpty);
  }

  void cancelListening() {
    setState(() => _isListening = false);
    _speech.cancel();
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
            minLines: 1,
            maxLines: null,
          ),
          const SizedBox(height: 16.0),
          if (hasPermission)
            Column(
              children: [
                AvatarGlow(
                  endRadius: 60.0,
                  animate: _speech.isListening,
                  duration: const Duration(milliseconds: 2000),
                  repeat: true,
                  showTwoGlows: true,
                  child: FloatingActionButton(
                    onPressed: _startListening,
                    backgroundColor:
                        _speech.isListening ? Colors.red : Colors.blue,
                    child: Icon(
                      !_isListening ? Icons.mic_off : Icons.mic,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                Center(
                  child: Text(_speech.isListening ? micList : micText),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
