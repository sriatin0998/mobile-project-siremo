// lib/presentation/pages/booking/history_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/format_utils.dart';
import '../../../data/models/booking_model.dart';
import '../../controllers/booking_controller.dart';
import 'history_detail_page.dart';
import '../review/add_review_page.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingController = Get.find<BookingController>();

    return DefaultTabController(
      length: 4, // Jumlah Tab
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: const Text('Riwayat Transaksi'),
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            indicatorColor: AppTheme.primary,
            labelColor: AppTheme.primaryDark,
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(text: "Pending"),
              Tab(text: "Disewa"),
              Tab(text: "Selesai"),
              Tab(text: "Dibatalkan"),
            ],
          ),
        ),
        body: Obx(() {
          if (bookingController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // Filter data berdasarkan status
          final pending = bookingController.myBookings.where((b) => b.status == BookingStatus.pending).toList();
          final active = bookingController.myBookings.where((b) => b.status == BookingStatus.active || b.status == BookingStatus.confirmed).toList();
          final completed = bookingController.myBookings.where((b) => b.status == BookingStatus.completed).toList();
          final cancelled = bookingController.myBookings.where((b) => b.status == BookingStatus.cancelled).toList();
          return TabBarView(
            children: [
              _buildList(pending, "Belum ada booking pending"),
              _buildList(active, "Tidak ada sewa aktif"),
              _buildList(completed, "Belum ada riwayat selesai"),
              _buildList(cancelled, "Belum ada riwayat dibatalkan"),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildList(List<BookingModel> list, String emptyMessage) {
    if (list.isEmpty) {
      return Center(child: Text(emptyMessage, style: AppTheme.body2));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (_, i) => _BookingHistoryCard(booking: list[i]),
    );
  }
}

class _BookingHistoryCard extends StatelessWidget {
  final BookingModel booking;
  const _BookingHistoryCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Get.to(() => HistoryDetailPage(booking: booking));
          },
          child: Column(
            children: [
              // Header with status
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: _statusColor(booking.status).withOpacity(0.08),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ID: ${booking.id}', style: AppTheme.caption),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: _statusColor(booking.status),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        booking.statusLabel,
                        style: const TextStyle(
                          color: AppTheme.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Car info
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        booking.carImageUrl,
                        width: 80,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 80,
                          height: 60,
                          color: AppTheme.primaryLight,
                          child: const Icon(Icons.directions_car, color: AppTheme.primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${booking.carBrand} ${booking.carName}',
                            style: AppTheme.heading3.copyWith(fontSize: 15),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${FormatUtils.formatDate(booking.startDate)} - ${FormatUtils.formatDate(booking.endDate)}',
                            style: AppTheme.body2,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${booking.totalDays} hari • ${booking.pickupLocation}',
                            style: AppTheme.caption,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Total price footer
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: AppTheme.divider)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Bayar', style: AppTheme.body2),
                    Text(FormatUtils.formatCurrency(booking.totalPrice), style: AppTheme.price),
                  ],
                ),
              ),

              // --- TOMBOL BERI ULASAN ---
              // Logika 'if' diletakkan di dalam children Column, bukan di dalam Container
              if (booking.status == BookingStatus.completed)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        // Pastikan class AddReviewPage sudah ada di project Anda
                        Get.to(() => AddReviewPage(
                        carId: booking.carId.toString(), 
                        bookingId: booking.id.toString(), 
                      ));
                    },
                      child: const Text("Beri Ulasan", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  

  Color _statusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending: return AppTheme.warning;
      case BookingStatus.confirmed: return AppTheme.info;
      case BookingStatus.active: return AppTheme.primary;
      case BookingStatus.completed: return AppTheme.success;
      case BookingStatus.cancelled: return AppTheme.error;
    }
  }
}