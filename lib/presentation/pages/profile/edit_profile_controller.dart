import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../controllers/profile_controller.dart';

class EditProfileController extends GetxController {
  final ApiService _apiService = ApiService();
  final ProfileController _profileController = Get.find<ProfileController>();
  
  final ImagePicker _picker = ImagePicker();
  Rx<File?> selectedImage = Rx<File?>(null);
  
  // Controller untuk input field
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Inisialisasi data dari API yang sudah dimuat di ProfileController
    final user = _profileController.userData;
    nameController.text = user['name'] ?? "";
    phoneController.text = user['penyewa']?['telepon'] ?? "";
    addressController.text = user['penyewa']?['alamat'] ?? "";
  }

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  Future<void> saveProfile() async {
    try {
      // 1. Siapkan data yang akan dikirim
      Map<String, dynamic> data = {
        'name': nameController.text,
        'telepon': phoneController.text,
        'alamat': addressController.text,
      };

      // 2. Panggil API Update
      await _apiService.updateProfile(data);

      // 3. Update data di halaman profil secara otomatis
      _profileController.fetchProfileData();

      // 4. Feedback ke user
      Get.back();
      Get.snackbar(
        "Berhasil", 
        "Profil telah diperbarui",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white
      );
    } catch (e) {
      Get.snackbar(
        "Error", 
        "Gagal menyimpan: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white
      );
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}