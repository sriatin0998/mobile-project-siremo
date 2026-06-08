import 'package:get/get.dart';
import '../../data/models/car_model.dart';
import '../../services/api_service.dart';


class DetailController extends GetxController {
  final ApiService _api = ApiService();
  final Rx<CarModel?> carDetail = Rx<CarModel?>(null);
  final RxBool isLoading = false.obs;

  Future<void> fetchCarDetail(String id) async {
    isLoading.value = true;
    try {
      // Panggil endpoint /api/mobil/{id}
      carDetail.value = await _api.fetchCarDetail(id);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat detail mobil");
    } finally {
      isLoading.value = false;
    }
  }
}