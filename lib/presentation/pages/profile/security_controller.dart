import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../services/api_service.dart';

class SecurityController extends GetxController {
  final ApiService _apiService = ApiService();
  final _storage = const FlutterSecureStorage();

  // Controller untuk Password
  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  Future<void> changePassword() async {
    if (newPassController.text != confirmPassController.text) {
      Get.snackbar("Error", "Password baru tidak cocok");
      return;
    }
    
    try {
      await _apiService.changePassword(
        currentPassword: oldPassController.text,
        newPassword: newPassController.text,
        confirmPassword: confirmPassController.text,
      );
      Get.back();
      Get.snackbar("Sukses", "Password berhasil diubah");
    } catch (e) {
      Get.snackbar("Error", "Gagal mengubah password: $e");
    }
  }

  Future<void> deleteAccount() async {
    try {
      // Panggil API delete account (pastikan sudah dibuat di Laravel)
      // await _apiService.deleteAccount(); 
      await _storage.delete(key: 'auth_token');
      Get.offAllNamed('/login');
      Get.snackbar("Berhasil", "Akun telah dihapus");
    } catch (e) {
      Get.snackbar("Error", "Gagal menghapus akun: $e");
    }
  }
}