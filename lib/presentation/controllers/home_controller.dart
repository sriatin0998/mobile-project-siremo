// lib/presentation/controllers/home_controller.dart
import 'package:get/get.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/car_model.dart';
import '../../services/api_service.dart';

class HomeController extends GetxController {
  final ApiService _apiService = ApiService();
  final RxList<CarModel> allCars = <CarModel>[].obs;
  final RxList<CarModel> filteredCars = <CarModel>[].obs;
  final RxList<CarModel> recommendedCars = <CarModel>[].obs;
  final RxString selectedCategory = 'semua'.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxInt currentBannerIndex = 0.obs;
  final RxInt currentNavIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCars();
  }

  Future<void> loadCars() async {
    isLoading.value = true;
    try {
      // Panggil API di sini
      final List<CarModel> data = await _apiService.fetchCars();
      
      allCars.assignAll(data);
      // Logika rekomendasi (misal rating > 4.5 atau semua jika API tidak kirim rating)
      recommendedCars.assignAll(allCars); 
      filteredCars.assignAll(allCars);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    _applyFilter();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _applyFilter();
  }

  void _applyFilter() {
    List<CarModel> result = allCars.toList();

    if (selectedCategory.value != 'semua') {
      result = result
          .where((c) =>
              c.category.toLowerCase() ==
              selectedCategory.value.toLowerCase())
          .toList();
    }

    if (searchQuery.value.isNotEmpty) {
      result = result
          .where((c) =>
              c.name
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              c.brand
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()) ||
              c.category
                  .toLowerCase()
                  .contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    filteredCars.value = result;
  }

  List<String> get categories => AppConstants.carCategories;
}
