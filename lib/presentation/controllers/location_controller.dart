// lib/presentation/controllers/location_controller.dart
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  final RxString currentAddress = 'Mendeteksi lokasi...'.obs;
  final RxBool isLoadingLocation = false.obs;
  final Rx<Position?> currentPosition = Rx<Position?>(null);

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      isLoadingLocation.value = true;

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        currentAddress.value = 'Lokasi tidak aktif';
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          currentAddress.value = 'Izin lokasi ditolak';
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        currentAddress.value = 'Izin lokasi diblokir';
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      currentPosition.value = position;

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final parts = [
          place.street,
          place.subLocality,
          place.locality,
        ].where((p) => p != null && p.isNotEmpty).toList();

        currentAddress.value =
            parts.isNotEmpty ? parts.take(2).join(', ') : 'Lokasi ditemukan';
      }
    } catch (e) {
      currentAddress.value = 'Jl. Balai Graha';
    } finally {
      isLoadingLocation.value = false;
    }
  }

  Future<void> refreshLocation() async {
    await _getCurrentLocation();
  }
}
