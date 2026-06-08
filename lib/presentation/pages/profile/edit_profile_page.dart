import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'edit_profile_controller.dart';

class EditProfilePage extends StatelessWidget {
  final EditProfileController controller = Get.put(EditProfileController());

  EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profil")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 1. Profil Image Section
          Center(
            child: Stack(
              children: [
                Obx(() => CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: controller.selectedImage.value != null 
                    ? FileImage(controller.selectedImage.value!) as ImageProvider
                    : const NetworkImage("https://via.placeholder.com/150"), // Bisa diganti dengan URL dari API
                )),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.orange,
                    radius: 18,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                      onPressed: () => controller.pickImage(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // 2. Form Fields
          _buildTextField("Nama Lengkap", controller.nameController, Icons.person_outline),
          _buildTextField("Nomor Telepon", controller.phoneController, Icons.phone_outlined),
          _buildTextField("Alamat Lengkap", controller.addressController, Icons.location_on_outlined, maxLines: 2),

          const SizedBox(height: 30),

          // 3. Tombol Simpan
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => controller.saveProfile(),
              child: const Text("Simpan Perubahan", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController textController, IconData icon, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: textController,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.orange),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey[50],
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.orange),
          ),
        ),
      ),
    );
  }
}