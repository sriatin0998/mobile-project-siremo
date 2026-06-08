import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pusat Bantuan")),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () async {
            final Uri url = Uri.parse("https://wa.me/6281234567890"); // Ganti nomor Anda
            if (await canLaunchUrl(url)) await launchUrl(url);
          },
          icon: const Icon(Icons.chat),
          label: const Text("Hubungi Admin via WhatsApp"),
        ),
      ),
    );
  }
}