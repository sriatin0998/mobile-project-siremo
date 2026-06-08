import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/models/car_model.dart';
import '../core/constants/api_constants.dart';

class ApiService {
  final String baseUrl = ApiConstants.baseUrl;
  final _storage = const FlutterSecureStorage();
  late Dio dio;

  ApiService() {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Interceptor akan otomatis menambahkan token ke setiap request (termasuk /booking)
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = await _storage.read(key: 'auth_token');
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      },
    ));
  }

  // HANYA SATU fungsi fetchCars yang tersisa
  Future<List<CarModel>> fetchCars() async {
    try {
      final response = await dio.get('/mobil');
      
      if (response.statusCode == 200) {
        List jsonResponse = response.data['data'];
        return jsonResponse.map((item) => CarModel.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat data: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception('Sesi berakhir, silakan login kembali.');
      }
      throw Exception('Terjadi kesalahan: ${e.message}');
    }
  }

  // Di dalam class ApiService
Future<CarModel> fetchCarDetail(String id) async {
  try {
    final response = await dio.get('/mobil/$id');
    
    if (response.statusCode == 200) {
      // Asumsi response Laravel adalah { "data": {...} }
      return CarModel.fromJson(response.data['data']);
    } else {
      throw Exception('Gagal memuat detail mobil');
    }
  } on DioException catch (e) {
    throw Exception('Error: ${e.message}');
  }
}

// 1. Ambil Profil User
Future<Map<String, dynamic>> getProfile() async {
  try {
    final response = await dio.get('/profile');
    return response.data['data'];
  } on DioException catch (e) {
    if (e.response?.statusCode == 401) {
      throw Exception('Sesi telah berakhir.');
    }
    throw Exception('Gagal mengambil data profil.');
  }
}

// 2. Update Profil
Future<void> updateProfile(Map<String, dynamic> data) async {
  await dio.put('/profile/update', data: data);
}

// 3. Ganti Password
// Ganti bagian ini di ApiService Anda
Future<void> changePassword({
  required String currentPassword, 
  required String newPassword, 
  required String confirmPassword
}) async {
  await dio.post('/profile/change-password', data: {
    'current_password': currentPassword,
    'new_password': newPassword,
    'new_password_confirmation': confirmPassword,
  });
}

Future<void> submitBooking({
  required Map<String, dynamic> data,
  required String ktpPath,
  required String simPath,
}) async {
  FormData formData = FormData.fromMap({
    ...data,
    'bukti_ktp': await MultipartFile.fromFile(ktpPath),
    'bukti_sim': await MultipartFile.fromFile(simPath),
  });

  await dio.post('/booking', data: formData);
}

// Di dalam class ApiService
Future<Response> updateProfileWithPhoto(Map<String, dynamic> data, String? imagePath) async {
  FormData formData = FormData.fromMap(data);

  if (imagePath != null) {
    formData.files.add(MapEntry(
      'foto', // Harus sama dengan 'foto' di controller Laravel
      await MultipartFile.fromFile(imagePath, filename: 'profile.jpg'),
    ));
  }

  // Penting: Gunakan POST untuk FormData
  return await dio.post('profile/update', data: formData);
}

Future<Response> postReview(Map<String, dynamic> data) async {
    return await dio.post('/ulasan', data: data);
  }

}