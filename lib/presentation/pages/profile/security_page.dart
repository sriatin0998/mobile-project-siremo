import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'security_controller.dart';

class SecurityPage extends StatelessWidget {
  final SecurityController controller = Get.put(SecurityController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Keamanan")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildMenuTile(
            icon: Icons.lock_outline,
            title: "Ubah Kata Sandi",
            subtitle: "Kelola kata sandi akun Anda",
            onTap: () => Get.to(() => ChangePasswordPage()),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text("Hapus Akun", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () => _confirmDeleteAccount(),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount() {
    Get.defaultDialog(
      title: "Hapus Akun",
      middleText: "Yakin? Semua data sewa akan hilang permanen.",
      textConfirm: "Ya, Hapus",
      buttonColor: Colors.red,
      onConfirm: () => controller.deleteAccount(),
    );
  }

  Widget _buildInfoCard() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("Lindungi Akun Anda", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 8),
        Text("Kelola pengaturan keamanan untuk memastikan data dan riwayat sewa mobil Anda tetap privat.", style: TextStyle(color: Colors.grey)),
      ],
    ),
  );

  Widget _buildMenuTile({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) => ListTile(
    leading: CircleAvatar(backgroundColor: Colors.orange.withOpacity(0.1), child: Icon(icon, color: Colors.orange)),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text(subtitle),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    onTap: onTap,
  );

  Widget _buildToggleTile({required IconData icon, required String title, required String subtitle}) => ListTile(
    leading: CircleAvatar(backgroundColor: Colors.orange.withOpacity(0.1), child: Icon(icon, color: Colors.orange)),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text(subtitle),
    trailing: Switch(value: true, onChanged: (v) {}),
  );

  Widget _buildPrivacyCard() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.orange.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("PRIVASI", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 8),
        const Text("Kami sangat menghargai privasi Anda. Baca bagaimana kami melindungi data perjalanan dan transaksi Anda di SIREMO."),
        const SizedBox(height: 8),
        TextButton(onPressed: () {}, child: const Text("Pelajari Selengkapnya →")),
      ],
    ),
  );
}

// Halaman khusus untuk Ubah Password (Gunakan TextField yang Anda buat sebelumnya di sini)
class ChangePasswordPage extends StatelessWidget {
  final SecurityController controller = Get.find<SecurityController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ubah Kata Sandi")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildField("Password Lama", controller.oldPassController),
            _buildField("Password Baru", controller.newPassController),
            _buildField("Konfirmasi Password", controller.confirmPassController),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => controller.changePassword(),
              child: const Text("Simpan Perubahan"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) => 
    TextField(controller: controller, obscureText: true, decoration: InputDecoration(labelText: label));
}