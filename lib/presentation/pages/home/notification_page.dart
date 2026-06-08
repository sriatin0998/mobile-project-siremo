import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("Notifikasi", style: TextStyle(color: Colors.black)),
        backgroundColor: AppTheme.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: 2, // Sesuaikan dengan jumlah data Anda
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          // Contoh data
          if (index == 0) {
            return _buildNotificationTile(
              "Denda Keterlambatan",
              "Unit Avanza harus kembali hari ini pukul 14:00. Keterlambatan akan dikenakan denda.",
              Icons.warning_amber_rounded,
              Colors.red,
            );
          } else {
            return _buildNotificationTile(
              "Konfirmasi Pengembalian",
              "Terima kasih telah menyewa unit Innova Reborn. Mobil telah diterima admin.",
              Icons.check_circle_outline,
              Colors.green,
            );
          }
        },
      ),
    );
  }

  Widget _buildNotificationTile(String title, String subtitle, IconData icon, Color color) {
    return Container(
      color: AppTheme.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ),
      ),
    );
  }
}