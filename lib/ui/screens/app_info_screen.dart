import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInfo extends StatelessWidget {
  final String developer;

  const AppInfo({Key? key, required this.developer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Info')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/images/fara.jpg'),
            ),
            const SizedBox(height: 20),
            const Text(
              'essumin app - practica siglas y simbologias.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Redes: ',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  label: const Text('GitHub'),
                  icon: const Icon(Icons.link),
                  onPressed: _launchUrl,
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(150, 35),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF1e40af)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Developed by: $developer',
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse('https://github.com/wesvm');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
