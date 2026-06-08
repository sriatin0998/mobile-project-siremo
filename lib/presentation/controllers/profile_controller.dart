import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../services/api_service.dart';

class ProfileController extends GetxController {
  final ApiService _apiService = ApiService();
  final _storage = const FlutterSecureStorage();
  
  // Data profil disimpan dalam bentuk Map yang reaktif
  var userData = {}.obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfileData();
  }

  // Mengambil data dari API
  void fetchProfileData() async {
    try {
      isLoading.value = true;
      var data = await _apiService.getProfile();
      userData.value = data;
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat profil: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Navigasi ke Edit Profil dan refresh data otomatis saat kembali
  void goToEditProfile() {
    Get.toNamed('/edit-profile')?.then((_) => fetchProfileData());
  }

  void goToSecurity() => Get.toNamed('/security');
  void goToHelpCenter() => Get.toNamed('/help-center');
  void goToTerms() => Get.toNamed('/terms-conditions');
  void goToPrivacy() => Get.toNamed('/privacy-policy');

  // Fungsi Hubungi Admin (WhatsApp)
  Future<void> openWhatsApp() async {
    final String phoneNumber = "6281234567890";
    final Uri whatsappUrl = Uri.parse("https://wa.me/$phoneNumber?text=Halo%20Admin,%20saya%20butuh%20bantuan.");

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Tidak dapat membuka WhatsApp");
    }
  }

  // Fungsi Logout Lengkap
  void logout() {
    Get.defaultDialog(
      title: "Konfirmasi",
      middleText: "Apakah Anda yakin ingin keluar dari akun?",
      textConfirm: "Ya, Keluar",
      textCancel: "Batal",
      onConfirm: () async {
        // Hapus token dari storage agar session benar-benar hilang
        await _storage.delete(key: 'auth_token');
        
        // Bersihkan data lokal
        userData.value = {};
        
        // Arahkan ke halaman login
        Get.offAllNamed('/login');
      },
    );
  }
}