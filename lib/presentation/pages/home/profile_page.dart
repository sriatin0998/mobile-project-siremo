import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/profile_controller.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final ProfileController profileController = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Obx(() {
  // Ambil dari controller profil yang sudah sinkron dengan API
  final user = profileController.userData; 
  
  if (user.isEmpty) {
    return const Center(child: CircularProgressIndicator()); // Tampilkan loading saat fetch
  }

  return SingleChildScrollView(
    child: Column(
      children: [
        // --- HEADER ---
        Container(
          // ... 
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                // Pastikan key dari API sesuai (misal: 'name', 'email')
                child: Text(user['name'][0], style: TextStyle(fontSize: 40)), 
              ),
              const SizedBox(height: 12),
              Text(user['name'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              Text(user['email'], style: const TextStyle(color: Colors.white70)),
            ],
          ),
        ),

              // --- STATS CARD ---
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _buildInfoCard("Total Sewa", "12"),
                    const SizedBox(width: 16),
                    _buildInfoCard("Ulasan", "5"),
                  ],
                ),
              ),

              // --- MENU ---
            _buildSectionTitle("Akun"),
            _buildMenuItem(Icons.person_outline, "Edit Profil", () => profileController.goToEditProfile()),
            _buildMenuItem(Icons.security, "Keamanan", () => profileController.goToSecurity()),

            _buildSectionTitle("Dukungan"),
            _buildMenuItem(Icons.help_outline, "Pusat Bantuan", () => profileController.openWhatsApp()),
            _buildMenuItem(Icons.description, "Syarat & Ketentuan", () => profileController.goToTerms()),
            _buildMenuItem(Icons.privacy_tip, "Kebijakan Privasi", () => profileController.goToPrivacy()),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () => authController.logout(),
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text("Keluar Akun", style: TextStyle(color: Colors.red)),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoCard(String title, String value) => Expanded(
    child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Column(children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ]),
    ),
  );

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Align(alignment: Alignment.centerLeft, child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold))),
  );

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange), 
        title: Text(title), 
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap, // Menjalankan fungsi saat diklik
      ),
    ),
  );
}