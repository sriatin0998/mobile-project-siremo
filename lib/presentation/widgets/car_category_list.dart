// lib/presentation/widgets/car_category_list.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_theme.dart';
import '../controllers/home_controller.dart';

class CarCategoryList extends StatelessWidget {
  const CarCategoryList({super.key});

  static const Map<String, IconData> _categoryIcons = {
    'semua': Icons.directions_car,
    'City car': Icons.directions_car_filled,
    'MPV': Icons.airport_shuttle,
    'Minibus': Icons.directions_bus,
    'SUV': Icons.agriculture,
  };

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: controller.categories.length,
        itemBuilder: (_, i) {
          final cat = controller.categories[i];

          return Obx(() {
            final isSelected =
                controller.selectedCategory.value == cat;

            return GestureDetector(
              onTap: () => controller.selectCategory(cat),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primary
                            : AppTheme.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected
                                ? AppTheme.primary.withOpacity(0.35)
                                : Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Icon(
                        _categoryIcons[cat] ??
                            Icons.directions_car,
                        color: isSelected
                            ? AppTheme.white
                            : AppTheme.textGrey,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      cat,
                      style: TextStyle(
                        color: isSelected
                            ? AppTheme.primary
                            : AppTheme.textGrey,
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }
}