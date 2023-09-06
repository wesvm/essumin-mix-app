import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class EndScreen extends StatefulWidget {
  final int totalItems;
  final int score;

  const EndScreen({
    Key? key,
    required this.score,
    required this.totalItems,
  }) : super(key: key);

  @override
  State<EndScreen> createState() => _EndScreenState();
}

class _EndScreenState extends State<EndScreen> {
  ConfettiController _confettiController = ConfettiController();

  bool _isPlaying = false;
  late String message;

  @override
  void initState() {
    _message();
    super.initState();
  }

  void _message() {
    if (widget.score == widget.totalItems) {
      message = 'Perfecto.';
      _confettiController =
          ConfettiController(duration: const Duration(seconds: 5));
      _confettiController.play();
    } else if (widget.score >= widget.totalItems / 2) {
      message = 'Masomenos.';
    } else {
      message = 'Muy mal.';
    }
  }

  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
          appBar: AppBar(title: const Text('Resultado')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (message == 'Perfecto.')
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        if (_isPlaying) {
                          _confettiController.stop();
                        } else {
                          _confettiController.play();
                        }
                        _isPlaying = !_isPlaying;
                      });
                    },
                    color: Colors.deepPurple,
                    child: const Text('Confeti!'),
                  ),
                const SizedBox(height: 16.0),
                Text(
                  'Acertadas: ${widget.score}/${widget.totalItems}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(150, 35),
                    ),
                  ),
                  child: const Text('Aceptar'),
                ),
              ],
            ),
          ),
        ),
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirection: pi / 2,
          particleDrag: 0.1,
          blastDirectionality: BlastDirectionality.explosive,
          emissionFrequency: 0.05,
          gravity: 0.2,
          createParticlePath: drawStar,
        )
      ],
    );
  }
}
