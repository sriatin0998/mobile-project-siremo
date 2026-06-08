import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Syarat & Ketentuan")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children:  [
          Text("Syarat & Ketentuan Penggunaan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 15),
          Text("Terakhir diperbarui: Juni 2026", style: TextStyle(color: Colors.grey)),
          SizedBox(height: 20),
          _buildParagraph("1. Ketentuan Umum", "Dengan menggunakan aplikasi SIREMO, Anda setuju untuk terikat dengan syarat dan ketentuan yang berlaku."),
          _buildParagraph("2. Kewajiban Pengguna", "Anda bertanggung jawab untuk menjaga kerahasiaan akun Anda dan memberikan informasi yang akurat saat melakukan penyewaan."),
          _buildParagraph("3. Pembatalan", "Kebijakan pembatalan penyewaan mengikuti aturan yang tercantum pada masing-masing unit mobil yang disewa."),
        ],
      ),
    );
  }

  static Widget _buildParagraph(String title, String content) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      const SizedBox(height: 5),
      Text(content, style: const TextStyle(fontSize: 14, color: Colors.black87)),
      const SizedBox(height: 15),
    ],
  );
}