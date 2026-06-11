// lib/presentation/pages/auth/register_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthController _authController = Get.isRegistered<AuthController>()
      ? Get.find<AuthController>()
      : Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        foregroundColor: AppTheme.textDark,
        elevation: 0,
        title: const Text(
          'Daftar Akun',
          style: TextStyle(
            color: AppTheme.textDark,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Buat akun baru', style: AppTheme.heading2),
              const SizedBox(height: 4),
              Text('Isi data diri Anda untuk mendaftar', style: AppTheme.body2),
              const SizedBox(height: 28),

              // Username
          TextFormField(
            controller: _usernameController, // Pastikan Anda sudah mendeklarasikan _usernameController
            decoration: const InputDecoration(
              labelText: 'Username',
              prefixIcon: Icon(Icons.alternate_email, color: AppTheme.primary),
              hintText: 'Masukkan username unik',
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Username tidak boleh kosong';
              if (v.length < 4) return 'Username minimal 4 karakter';
              if (v.contains(' ')) return 'Username tidak boleh mengandung spasi';
              return null;
            },
          ),

          const SizedBox(height: 16),
              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  prefixIcon: Icon(Icons.person_outline, color: AppTheme.primary),
                  hintText: 'Masukkan nama lengkap',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Nama tidak boleh kosong';
                  if (v.length < 3) return 'Nama minimal 3 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined, color: AppTheme.primary),
                  hintText: 'contoh@email.com',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Email tidak boleh kosong';
                  if (!GetUtils.isEmail(v)) return 'Format email tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  prefixIcon: Icon(Icons.phone_outlined, color: AppTheme.primary),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Nomor telepon wajib diisi';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Password
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.primary),
                  hintText: 'Minimal 6 karakter',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: AppTheme.textGrey,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Password tidak boleh kosong';
                  if (v.length < 6) return 'Password minimal 6 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Confirm Password
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password',
                  prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.primary),
                  hintText: 'Ulangi password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                      color: AppTheme.textGrey,
                    ),
                    onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Konfirmasi password tidak boleh kosong';
                  if (v != _passwordController.text) return 'Password tidak sama';
                  return null;
                },
              ),

              // Error message
              Obx(() {
                if (_authController.errorMessage.value.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _authController.errorMessage.value,
                        style: AppTheme.body2.copyWith(color: AppTheme.error),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),

              const SizedBox(height: 32),

              Obx(() => SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _authController.isLoading.value
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                _authController.registerWithEmail(
                                  _nameController.text.trim(),
                                  _emailController.text.trim(),
                                  _passwordController.text,
                                  _phoneController.text.trim(),
                                  _usernameController.text.trim(),
                                );
                              }
                            },
                      child: _authController.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: AppTheme.white, strokeWidth: 2))
                          : const Text('Daftar Sekarang'),
                    ),
                  )),

              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: RichText(
                    text: TextSpan(
                      text: 'Sudah punya akun? ',
                      style: AppTheme.body2,
                      children: [
                        TextSpan(
                          text: 'Masuk',
                          style: AppTheme.body2.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
