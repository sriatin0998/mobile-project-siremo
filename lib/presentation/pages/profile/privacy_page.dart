import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kebijakan Privasi")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text("Kebijakan Privasi", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Text("Kami di SIREMO sangat menghargai privasi Anda. Berikut adalah poin-poin utama perlindungan data Anda:"),
          SizedBox(height: 20),
          _buildPoint("Data yang Kami Kumpulkan", "Kami mengumpulkan informasi nama, email, nomor telepon, dan lokasi yang diperlukan untuk proses penyewaan."),
          _buildPoint("Penggunaan Data", "Data Anda digunakan untuk memproses transaksi, memberikan dukungan pelanggan, dan meningkatkan layanan kami."),
          _buildPoint("Keamanan Data", "Kami menggunakan protokol keamanan standar industri untuk melindungi data pribadi Anda dari akses yang tidak sah."),
        ],
      ),
    );
  }

  static Widget _buildPoint(String title, String description) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 5),
        Text(description, style: const TextStyle(color: Colors.black87)),
      ],
    ),
  );
}