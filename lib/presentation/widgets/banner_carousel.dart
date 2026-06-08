// lib/presentation/widgets/banner_carousel.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';
import '../controllers/home_controller.dart';

class BannerCarousel extends StatelessWidget {
  const BannerCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final banners = [
      _BannerData(
        title: 'Sewa Mobil\nMudah & Cepat',
        subtitle: 'Pilihan mobil lengkap\nHarga transparan\nProses booking instan',
        color1: const Color(0xFFF9A825),
        color2: const Color(0xFFFF6F00),
      ),
      _BannerData(
        title: 'Promo Akhir Pekan',
        subtitle: 'Diskon 20% untuk\nsemua jenis SUV\nBerlaku sampai Minggu',
        color1: const Color(0xFF1565C0),
        color2: const Color(0xFF0D47A1),
      ),
      _BannerData(
        title: 'Booking Lebih Awal',
        subtitle: 'Hemat hingga 15%\nuntuk pemesanan\n3 hari sebelumnya',
        color1: const Color(0xFF2E7D32),
        color2: const Color(0xFF1B5E20),
      ),
    ];

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            onPageChanged: (i) => controller.currentBannerIndex.value = i,
            itemCount: banners.length,
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: _BannerItem(data: banners[i]),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                banners.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: controller.currentBannerIndex.value == i ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: controller.currentBannerIndex.value == i
                        ? AppTheme.primary
                        : AppTheme.textLight,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            )),
      ],
    );
  }
}

class _BannerData {
  final String title;
  final String subtitle;
  final Color color1;
  final Color color2;

  _BannerData({
    required this.title,
    required this.subtitle,
    required this.color1,
    required this.color2,
  });
}

class _BannerItem extends StatelessWidget {
  final _BannerData data;
  const _BannerItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [data.color1, data.color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: data.color1.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.white.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.white.withOpacity(0.06),
              ),
            ),
          ),
          // Car icon on right
          Positioned(
            right: 12,
            bottom: 0,
            top: 0,
            child: Icon(
              Icons.directions_car,
              size: 90,
              color: AppTheme.white.withOpacity(0.2),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    color: AppTheme.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                ...data.subtitle.split('\n').map((line) => Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: AppTheme.white, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          line,
                          style: const TextStyle(
                            color: AppTheme.white,
                            fontSize: 12,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
