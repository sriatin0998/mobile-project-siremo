import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants/api_constants.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final Rx<User?> firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  
  // Penanda untuk splash screen
  final RxBool isSplashFinished = false.obs;
  // Tambahkan di bagian atas properti class
  final Dio dio = Dio();
  final storage = const FlutterSecureStorage();
  

 @override
void onInit() {
  super.onInit();
  // 1. Bind stream agar selalu memantau status login
  firebaseUser.bindStream(_auth.authStateChanges());

  // 2. Gunakan worker yang bekerja secara independen untuk mengisi data user
  // Ini memastikan data terisi meskipun splash screen belum selesai
  ever(firebaseUser, (User? user) {
    if (user != null) {
      currentUser.value = UserModel(
        id: user.uid,
        name: user.displayName ?? 'Pengguna',
        email: user.email ?? '',
        photoUrl: user.photoURL ?? '',
        createdAt: DateTime.now(),
      );
    } 
  });
}

void finishSplash() {
    isSplashFinished.value = true;
    _handleNavigation(); // Pastikan navigasi dipicu segera setelah splash selesai
  }

// 1. Ubah _handleNavigation menjadi async
Future<void> _handleNavigation() async {
  if (!isSplashFinished.value) return;

  // Cek Firebase dulu
  if (firebaseUser.value != null) {
    Get.offAllNamed(AppConstants.homeRoute);
    return;
  }

  // Cek Token Laravel secara ASYNC
  String? token = await storage.read(key: 'auth_token');
  
  if (token != null) {
    // VERIFIKASI ke server agar tidak "los"
    try {
      // Panggil endpoint yang butuh autentikasi (misal: /profile)
      await dio.get('${ApiConstants.baseUrl}/profile', 
        options: Options(headers: {"Authorization": "Bearer $token"}));
      
      Get.offAllNamed(AppConstants.homeRoute);
    } catch (e) {
      // Token tidak valid (expired/server error)
      await storage.delete(key: 'auth_token');
      Get.offAllNamed(AppConstants.loginRoute);
    }
  } else {
    Get.offAllNamed(AppConstants.loginRoute);
  }
}

  // Di dalam AuthController
void loginWithEmail(String email, String password) async {
  isLoading.value = true;
  errorMessage.value = ""; // Reset pesan error

  try {
    final response = await dio.post(
      '${ApiConstants.baseUrl}/login',
      data: {'email': email, 'password': password},
      options: Options(headers: {'Accept': 'application/json'}),
    );

    if (response.statusCode == 200) {
      // 1. Simpan token
      String token = response.data['access_token'];
      await storage.write(key: 'auth_token', value: token);
      
      // 2. Navigasi ke Dashboard
      Get.offAllNamed(AppConstants.homeRoute);
    }
  } on DioException catch (e) {
    // Menangkap error dari Laravel (seperti 401 Unauthorized)
    errorMessage.value = e.response?.data['message'] ?? "Terjadi kesalahan";
  } finally {
    isLoading.value = false;
  }
}

  Future<void> registerWithEmail(String name, String email, String password, String phone,String username) async {
  isLoading.value = true;
  errorMessage.value = ""; // Reset error sebelum mulai

  try {
    final response = await dio.post(
      '${ApiConstants.baseUrl}/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password, // WAJIB DITAMBAHKAN
        'no_telepon': phone,
        'username': username,
      },
      options: Options(headers: {'Accept': 'application/json'}), // Tambahkan header ini
    );

    if (response.statusCode == 201) {
      // Simpan token
      await storage.write(key: 'auth_token', value: response.data['access_token']);
      // Pastikan route sesuai dengan AppConstants (Gunakan konstanta, jangan hardcode)
      Get.offAllNamed(AppConstants.homeRoute); 
    }
  } on DioException catch (e) {
    // Menangkap detail error dari Laravel (Validation error)
    if (e.response?.data != null && e.response?.data['errors'] != null) {
      final errors = e.response?.data['errors'];
      // Ambil pesan error pertama dari list errors
      errorMessage.value = errors.values.first[0];
    } else {
      errorMessage.value = e.response?.data['message'] ?? "Registrasi gagal";
    }
  } finally {
    isLoading.value = false;
  }
}

  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      errorMessage.value = _getErrorMessage(e.code);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
  await _googleSignIn.signOut();
  await _auth.signOut();
  await storage.delete(key: 'auth_token'); // Tambahkan ini!
  Get.offAllNamed(AppConstants.loginRoute);
}

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found': return 'Email tidak terdaftar';
      case 'wrong-password': return 'Password salah';
      case 'email-already-in-use': return 'Email sudah digunakan';
      case 'weak-password': return 'Password terlalu lemah';
      case 'invalid-email': return 'Format email tidak valid';
      case 'network-request-failed': return 'Periksa koneksi internet Anda';
      default: return 'Terjadi kesalahan, coba lagi';
    }
  }
}