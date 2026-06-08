// lib/presentation/pages/home/search_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../controllers/home_controller.dart';

import '../../widgets/car_card.dart';
import '../../widgets/car_category_list.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
 Widget build(BuildContext context) {
    final HomeController homeController =
        Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppTheme.background,

      appBar: AppBar(
        title: const Text('Cari Mobil'),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),

      body: Column(
        children: [
          // ================= SEARCH BAR =================
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              child: TextField(
                autofocus: false,
                onChanged:
                    homeController.onSearchChanged,

                decoration: const InputDecoration(
                  hintText:
                      'Cari nama atau tipe mobil...',

                  prefixIcon: Icon(
                    Icons.search,
                    color: AppTheme.primary,
                  ),

                  border: InputBorder.none,

                  contentPadding:
                      EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          // ================= CATEGORY =================
          const CarCategoryList(),

          const SizedBox(height: 12),

          // ================= RESULT =================
          Expanded(
            child: Obx(() {
              if (homeController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primary,
                  ),
                );
              }

              final cars =
                  homeController.filteredCars;

              // ================= EMPTY STATE =================
              if (cars.isEmpty) {
                return Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 70,
                          color: AppTheme.textLight,
                        ),

                        const SizedBox(height: 14),

                        Text(
                          'Mobil tidak ditemukan',
                          style: AppTheme.body2,
                        ),
                      ],
                    ),
                  ),
                );
              }

              // ================= GRID =================
              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(
                    16, 0, 16, 24),

                itemCount: cars.length,

                physics:
                    const BouncingScrollPhysics(),

                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,

                  // FIX OVERFLOW
                  mainAxisExtent: 320,

                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),

                itemBuilder: (_, i) {
                  return CarCard(
                    car: cars[i],
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}