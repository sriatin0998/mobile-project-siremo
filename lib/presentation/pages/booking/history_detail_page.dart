import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/format_utils.dart';
import '../../../data/models/booking_model.dart';
import '../review/add_review_page.dart';

class HistoryDetailPage extends StatelessWidget {
  final BookingModel booking;
  const HistoryDetailPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text("Detail Pesanan")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 1. Header Struk
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text("E-RECEIPT SIREMO", style: TextStyle(color: Colors.white70, letterSpacing: 1.2)),
                  const SizedBox(height: 8),
                  Text(booking.id, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                    child: Text(booking.statusLabel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. Gambar Mobil
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(booking.carImageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. Detail Informasi
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildDetailItem("Unit", "${booking.carBrand} ${booking.carName}"),
                    _buildDetailItem("Penyewa", booking.customerName),
                    const Divider(height: 30),
                    _buildDetailItem("Jadwal", "${FormatUtils.formatDate(booking.startDate)} - ${FormatUtils.formatDate(booking.endDate)}"),
                    _buildDetailItem("Jam Ambil", booking.pickupTime),
                    _buildDetailItem("Jam Kembali", booking.returnTime),
                    _buildDetailItem("Lokasi", booking.pickupLocation),
                    const Divider(height: 30),
                    _buildDetailItem("Total Bayar", FormatUtils.formatCurrency(booking.totalPrice), isPrice: true),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 4. Tombol Aksi
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () { /* Tambahkan fungsi URL Launcher WhatsApp di sini */ },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.chat),
                label: const Text("Hubungi Admin via WhatsApp", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 16), // Memberi jarak antara tombol WA dan Ulasan

        if (booking.status == BookingStatus.completed)
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () {
                // Navigasi ke halaman AddReviewPage
                Get.to(() => AddReviewPage(carId: booking.carId, bookingId: booking.id));
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.star_border, color: AppTheme.primary),
              label: const Text(
                "Beri Ulasan untuk Mobil Ini",
                style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk baris detail
  Widget _buildDetailItem(String title, String value, {bool isPrice = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100, 
            child: Text(title, style: TextStyle(color: Colors.grey[600]))
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isPrice ? 18 : 14,
                color: isPrice ? AppTheme.primary : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}