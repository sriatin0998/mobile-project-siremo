import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/review_model.dart';
import '../../../services/api_service.dart';


class ReviewController extends GetxController {
  final ApiService _apiService = ApiService();
  var reviews = <ReviewModel>[].obs;
  var isLoading = false.obs;
  var rating = 5.0.obs;

  final commentController = TextEditingController();

  // 1. DEFINISI FUNGSI INI WAJIB ADA agar tidak error "not defined"
  Future<void> fetchReviews(String carId) async {
    isLoading.value = true;
    try {
      // Panggil service atau API Anda di sini
      // Contoh: reviews.assignAll(await ReviewService.getReviews(carId));
      await Future.delayed(const Duration(seconds: 1)); 
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // 2. Fungsi untuk submit ulasan
  Future<void> submitReview(String carId, String bookingId) async {
  isLoading.value = true;
  try {
    await _apiService.postReview({
      'id_mobil': carId,
      'id_transaksi': bookingId,
      'rating': rating.value.toInt(),
      'ulasan': commentController.text,
    });

    Get.back();
    Get.snackbar("Sukses", "Ulasan berhasil dikirim!");
  } catch (e) {
    Get.snackbar("Error", "Gagal mengirim ulasan");
  } finally {
    isLoading.value = false;
  }
}
  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}