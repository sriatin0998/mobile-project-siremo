// lib/presentation/pages/detail/car_detail_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/format_utils.dart';
import '../../../data/models/car_model.dart';
import '../booking/booking_page.dart';
import '../../controllers/review_controller.dart';
import '../../controllers/detail_controller.dart';


class CarDetailPage extends StatelessWidget {
  final CarModel car;
  
  const CarDetailPage({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller
    final detailController = Get.put(DetailController());
    final reviewController = Get.put(ReviewController());

    // Panggil data saat halaman dimuat
    detailController.fetchCarDetail(car.id);
    reviewController.fetchReviews(car.id);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Obx(() {
        // Tampilkan loading jika data masih diambil dari API
        if (detailController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Gunakan carDetail (data terbaru dari API)
        final displayCar = detailController.carDetail.value ?? car;

        return Stack(
          children: [
          // Scrollable content
          CustomScrollView(
            slivers: [
              // App bar with car image
              SliverAppBar(
                expandedHeight: 260,
                pinned: true,
                backgroundColor: AppTheme.primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      car.imageUrl.isNotEmpty
                          ? Image.network(
                              car.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: AppTheme.primary.withOpacity(0.2),
                                child: const Icon(Icons.directions_car,
                                    size: 80, color: AppTheme.primary),
                              ),
                            )
                          : Container(
                              color: AppTheme.primaryLight,
                              child: const Icon(Icons.directions_car,
                                  size: 80, color: AppTheme.primary),
                            ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.4),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Car name + rating
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${car.brand} ${car.name}',
                              style: AppTheme.heading2,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star,
                                    color: AppTheme.primary, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  car.rating.toStringAsFixed(1),
                                  style: AppTheme.body2.copyWith(
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Category + Year
                      Row(
                        children: [
                          _buildTag(car.category),
                          const SizedBox(width: 8),
                          _buildTag('${car.year}'),
                          const SizedBox(width: 8),
                          _buildTag(car.isAvailable ? 'Tersedia' : 'Tidak Tersedia',
                              color: car.isAvailable
                                  ? AppTheme.success
                                  : AppTheme.error),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Specs row
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSpec(Icons.people_outline, '${car.capacity} Kursi'),
                            _buildDivider(),
                            _buildSpec(Icons.settings_outlined, car.transmission),
                            _buildDivider(),
                            _buildSpec(Icons.confirmation_number_outlined,
                                car.licensePlate),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Description
                      Text('Deskripsi', style: AppTheme.heading3),
                      const SizedBox(height: 8),
                      Text(car.description, style: AppTheme.body2),
                      const SizedBox(height: 16),

                      // Features
                      Text('Fasilitas', style: AppTheme.heading3),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: car.features.map((f) => _buildFeatureItem(f)).toList(),
                      ),

                      // --- BAGIAN ULASAN DIPERBAIKI ---
                      const SizedBox(height: 24),
                      Text('Ulasan Pengguna', style: AppTheme.heading3),
                      const SizedBox(height: 12),
                      
                      Obx(() {
                        if (reviewController.isLoading.value) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (reviewController.reviews.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Text("Belum ada ulasan untuk mobil ini."),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: reviewController.reviews.length,
                          itemBuilder: (context, index) {
                            final review = reviewController.reviews[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(color: Colors.grey.shade200)),
                              child: ListTile(
                                leading: const CircleAvatar(child: Icon(Icons.person)),
                                title: Text(review.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: List.generate(5, (star) => Icon(
                                        star < review.rating ? Icons.star : Icons.star_border,
                                        size: 14, color: Colors.amber,
                                      )),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(review.comment),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),
                      
                      const SizedBox(height: 80), // Space for bottom bar
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
              decoration: const BoxDecoration(
                color: AppTheme.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, -4),
                  )
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Harga / hari', style: AppTheme.caption),
                      Text(
                        FormatUtils.formatCurrency(car.pricePerDay),
                        style: AppTheme.price.copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: car.isAvailable
                          ? () => Get.to(() => BookingPage(car: car))
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: car.isAvailable
                            ? AppTheme.primary
                            : AppTheme.textLight,
                      ),
                      child: Text(
                          car.isAvailable ? 'Pesan Sekarang' : 'Tidak Tersedia'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }
    ),
  );
}

  Widget _buildTag(String label, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: (color ?? AppTheme.primary).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppTheme.caption.copyWith(
          color: color ?? AppTheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSpec(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primary, size: 22),
        const SizedBox(height: 4),
        Text(label, style: AppTheme.caption),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: AppTheme.divider,
    );
  }
}

  Widget _buildFeatureItem(String feature) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(feature, style: AppTheme.caption.copyWith(color: AppTheme.primary)),
    );
  }