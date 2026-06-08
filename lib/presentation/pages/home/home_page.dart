// lib/presentation/pages/home/home_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/location_controller.dart';

import '../../widgets/banner_carousel.dart';
import '../../widgets/car_category_list.dart';
import '../../widgets/car_card.dart';

import '../booking/history_page.dart';
import 'profile_page.dart';
import 'search_page.dart';
import 'notification_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  List<Widget> _pages() => const [
        _DashboardTab(),
        SearchPage(),
        HistoryPage(),
        ProfilePage(),
        NotificationPage(),
      ];

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppTheme.background,

      body: Obx(
        () => _pages()[homeController.currentNavIndex.value],
      ),

      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: homeController.currentNavIndex.value,
          onTap: (index) {
            homeController.currentNavIndex.value = index;
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: AppTheme.textLight,
          backgroundColor: AppTheme.white,
          elevation: 10,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Cari',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Akun',
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find<HomeController>();
    final LocationController locationController =
        Get.find<LocationController>();
    final AuthController authController = Get.find<AuthController>();

    return Column(
      children: [
        // ================= HEADER =================
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primary,
                AppTheme.primaryDark,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                children: [
                  // ================= TOP ROW =================
                  Row(
                    children: [
                      const Text(
                        'Siremo',
                        style: TextStyle(
                          color: AppTheme.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),

                      const SizedBox(width: 8),

                      // LOCATION
                      Expanded(
                        child: GestureDetector(
                          onTap: locationController.refreshLocation,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: AppTheme.white,
                                size: 16,
                              ),

                              const SizedBox(width: 2),

                              Expanded(
                                child: Obx(() {
                                  return Text(
                                    locationController.currentAddress.value,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppTheme.white,
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                    ),
                                  );
                                }),
                              ),

                              const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppTheme.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),

                      // NOTIFICATION
                      IconButton(
                        onPressed: () {
                          // Navigasi ke halaman notifikasi
                          Get.to(() => const NotificationPage());

                        },
                        icon: const Icon(
                          Icons.notifications_outlined,
                          color: AppTheme.white,
                        ),
                      ),

                      // PROFILE
                      Obx(() {
                        final user = authController.currentUser.value;

                        return CircleAvatar(
                          radius: 16,
                          backgroundColor:
                              AppTheme.white.withOpacity(0.3),
                          backgroundImage:
                              (user?.photoUrl.isNotEmpty == true)
                                  ? NetworkImage(user!.photoUrl)
                                  : null,
                          child: (user?.photoUrl.isEmpty != false)
                              ? const Icon(
                                  Icons.person,
                                  color: AppTheme.white,
                                  size: 18,
                                )
                              : null,
                        );
                      }),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ================= SEARCH BAR =================
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(
                            Icons.search,
                            color: AppTheme.textGrey,
                          ),
                        ),

                        Expanded(
                          child: TextField(
                            onChanged:
                                homeController.onSearchChanged,
                            decoration: const InputDecoration(
                              hintText: 'Cari mobil...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                AppTheme.primary.withOpacity(0.12),
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.tune,
                            color: AppTheme.primary,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ================= CONTENT =================
        Expanded(
          child: RefreshIndicator(
            onRefresh: homeController.loadCars,
            color: AppTheme.primary,
            child: SingleChildScrollView(
              physics:
                  const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // BANNER
                  const BannerCarousel(),

                  // ================= CATEGORY =================
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(16, 20, 16, 8),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Kategori Mobil',
                          style: AppTheme.heading3,
                        ),
                        Text(
                          'Lihat semua >',
                          style: AppTheme.body2.copyWith(
                            color: AppTheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const CarCategoryList(),

                  // ================= CONTENT RESULT =================
                  Obx(() {
                    final isSearching = homeController
                        .searchQuery.value.isNotEmpty;

                    final isFiltering =
                        homeController.selectedCategory.value !=
                            'semua';

                    if (isSearching || isFiltering) {
                      return _buildFilteredResults(
                          homeController);
                    }

                    return _buildRecommendations(
                        homeController);
                  }),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ================= RECOMMENDATIONS =================

  Widget _buildRecommendations(
      HomeController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(
              color: AppTheme.primary,
            ),
          ),
        );
      }

      final cars = controller.recommendedCars;

      return Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Text(
              'Rekomendasi untuk Anda',
              style: AppTheme.heading3,
            ),
          ),

          // ================= GRID VIEW FIX =================
          GridView.builder(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(),
            padding:
                const EdgeInsets.symmetric(horizontal: 16),

            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,

              // FIX OVERFLOW
              mainAxisExtent: 320,

              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),

            itemCount: cars.length,

            itemBuilder: (_, i) {
              return CarCard(car: cars[i]);
            },
          ),
        ],
      );
    });
  }

  // ================= FILTER RESULT =================

  Widget _buildFilteredResults(
      HomeController controller) {
    return Obx(() {
      final cars = controller.filteredCars;

      if (cars.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                const Icon(
                  Icons.search_off,
                  size: 64,
                  color: AppTheme.textLight,
                ),

                const SizedBox(height: 12),

                Text(
                  'Mobil tidak ditemukan',
                  style: AppTheme.body2,
                ),
              ],
            ),
          ),
        );
      }

      return Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Text(
              '${cars.length} mobil ditemukan',
              style: AppTheme.heading3,
            ),
          ),

          // ================= GRID VIEW FIX =================
          GridView.builder(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(),
            padding:
                const EdgeInsets.symmetric(horizontal: 16),

            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,

              // FIX OVERFLOW
              mainAxisExtent: 320,

              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),

            itemCount: cars.length,

            itemBuilder: (_, i) {
              return CarCard(car: cars[i]);
            },
          ),
        ],
      );
    });
  }
}