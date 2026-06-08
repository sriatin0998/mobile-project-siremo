// lib/presentation/controllers/booking_controller.dart

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/booking_model.dart';
import '../../data/models/car_model.dart';
import '../pages/payment/payment_page.dart';
import '../../services/api_service.dart';
import 'package:dio/dio.dart' as dio;
import 'package:intl/intl.dart';


class BookingController extends GetxController {
  final RxList<BookingModel> myBookings = <BookingModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;
  final ApiService _api = ApiService();

  // =========================
  // FORM
  // =========================

  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);

  final RxString ktpPath = ''.obs;
  final RxString simPath = ''.obs;

  final RxInt totalDays = 0.obs;
  final RxInt totalPrice = 0.obs;

  final Rx<DateTime?> startTime = Rx<DateTime?>(null);
  final Rx<DateTime?> endTime = Rx<DateTime?>(null);

  int _pricePerDay = 0;

  @override
  void onInit() {
    super.onInit();
    loadBookings();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  // =========================
  // LOAD BOOKING
  // =========================

  Future<void> loadBookings() async {
    isLoading.value = true;

    await Future.delayed(
      const Duration(milliseconds: 500),
    );

    myBookings.value = BookingModel.getDummyData();

    isLoading.value = false;
  }

  // =========================
  // DATE
  // =========================
  void setCarPrice(int price) {
    _pricePerDay = price;
  }

  void onStartDateSelected(DateTime date) {
    startDate.value = date;

    if (endDate.value != null &&
        endDate.value!.isBefore(date)) {
      endDate.value = null;
    }

    _calculateDurationAndPrice();
  }

  void onEndDateSelected(DateTime date) {
    endDate.value = date;

    _calculateDurationAndPrice();
  }

  void _calculateDurationAndPrice() {
    if (startDate.value == null ||
        endDate.value == null) {
      totalDays.value = 0;
      totalPrice.value = 0;
      return;
    }

    final days =
        endDate.value!.difference(startDate.value!).inDays + 1;

    if (days <= 0) {
      totalDays.value = 0;
      totalPrice.value = 0;
      return;
    }

    totalDays.value = days;
    totalPrice.value = days * _pricePerDay;
  }

    Future<void> pickDateTime(bool isStart) async {
      DateTime? pickedDate = await showDatePicker(
        context: Get.context!,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );

      if (pickedDate != null) {
        TimeOfDay? pickedTime = await showTimePicker(
          context: Get.context!,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          DateTime finalDateTime = DateTime(
            pickedDate.year, pickedDate.month, pickedDate.day,
            pickedTime.hour, pickedTime.minute
          );
          
          if (isStart) {
            startTime.value = finalDateTime;
            onStartDateSelected(finalDateTime); // Tetap update logic tanggal Anda
          } else {
            endTime.value = finalDateTime;
            onEndDateSelected(finalDateTime);
          }
        }
      }
    }

  // =========================
  // FILE PICKER
  // =========================

  Future<void> pickKtp() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
        // withReadPermissions: true, // Opsional, hanya jika diperlukan
      );

      if (result != null && result.files.single.path != null) {
        ktpPath.value = result.files.single.path!;
        print("KTP terpilih: ${ktpPath.value}");
      }
    } catch (e) {
      print("Error saat memilih KTP: $e");
      Get.snackbar("Error", "Gagal mengakses file: $e");
    }
  }

  Future<void> pickSim() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null && result.files.single.path != null) {
        simPath.value = result.files.single.path!;
        print("SIM terpilih: ${simPath.value}");
      }
    } catch (e) {
      print("Error saat memilih SIM: $e");
      Get.snackbar("Error", "Gagal mengakses file: $e");
    }
  }

  // =========================
  // LOGIKA PEMBAYARAN
  // =========================
  bool isFormValid() {
    if (nameController.text.trim().isEmpty || 
        phoneController.text.trim().isEmpty ||
        startDate.value == null || 
        endDate.value == null || 
        ktpPath.value.isEmpty || 
        simPath.value.isEmpty) {
      Get.snackbar("Error", "Mohon lengkapi semua data dan dokumen");
      return false;
    }
    return true;
  }

  void goToPayment(CarModel car) {
    if (isFormValid()) {
      Get.to(() => PaymentPage(car: car));
    }
  }

  Future<void> processFinalBooking(CarModel car) async {
  try {
    isSubmitting.value = true;

    // Tambahkan prefix 'dio.' di depan class FormData dan MultipartFile
    dio.FormData formData = dio.FormData.fromMap({
      'id_mobil': car.id,
      'tgl_sewa': startDate.value.toString(),
      'tgl_rencana_kembali': endDate.value.toString(),
      'lama_sewa_hari': totalDays.value,
      'total_bayar': totalPrice.value,
      'bukti_ktp': await dio.MultipartFile.fromFile(ktpPath.value, filename: 'ktp.jpg'),
      'bukti_sim': await dio.MultipartFile.fromFile(simPath.value, filename: 'sim.jpg'),
    });

    // Gunakan _api.dio (karena di ApiService Anda sudah terdefinisi)
    final response = await _api.dio.post('/booking', data: formData);

    if (response.statusCode == 201) {
      resetForm();
      Get.offAllNamed('/home');
      Get.snackbar("Berhasil", "Booking berhasil dibuat!");
    }
  } on dio.DioException catch (e) { // Tambahkan juga prefix di sini
    String errorMessage = e.response?.data['message'] ?? "Gagal menghubungi server";
    Get.snackbar("Error", errorMessage);
  } finally {
    isSubmitting.value = false;
  }
}

  // =========================
  // SUBMIT BOOKING
  // =========================

  Future<bool> submitBooking(CarModel car) async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Nama lengkap wajib diisi',
      );
      return false;
    }

    if (phoneController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Nomor HP wajib diisi',
      );
      return false;
    }

    if (startDate.value == null) {
      Get.snackbar(
        'Error',
        'Pilih tanggal mulai',
      );
      return false;
    }

    if (endDate.value == null) {
      Get.snackbar(
        'Error',
        'Pilih tanggal kembali',
      );
      return false;
    }

    if (ktpPath.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Upload KTP terlebih dahulu',
      );
      return false;
    }

    if (simPath.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Upload SIM terlebih dahulu',
      );
      return false;
    }

    try {
      isSubmitting.value = true;

      await Future.delayed(
        const Duration(seconds: 2),
      );

      final booking = BookingModel(
      id: 'BK${DateTime.now().millisecondsSinceEpoch}',
      userId: 'USR001',
      carId: car.id,
      carName: car.name,
      carBrand: car.brand,
      carImageUrl: car.imageUrl,
      startDate: startDate.value!,
      endDate: endDate.value!,
      totalDays: totalDays.value,
      pricePerDay: car.pricePerDay,
      totalPrice: totalPrice.value,
      status: BookingStatus.pending,
      pickupLocation: '-',
      createdAt: DateTime.now(),
      // Tambahkan baris ini:
      customerName: nameController.text,
      pickupTime: "${startTime.value?.hour}:${startTime.value?.minute}", 
      returnTime: "${endTime.value?.hour}:${endTime.value?.minute}",
);

      myBookings.insert(0, booking);

      resetForm();

      return true;
    } finally {
      isSubmitting.value = false;
    }
  }
  

  // =========================
  // RESET
  // =========================

  void resetForm() {
    nameController.clear();
    phoneController.clear();

    startDate.value = null;
    endDate.value = null;

    startTime.value = null;
    endTime.value = null;

    ktpPath.value = '';
    simPath.value = '';

    totalDays.value = 0;
    totalPrice.value = 0;
  }
}