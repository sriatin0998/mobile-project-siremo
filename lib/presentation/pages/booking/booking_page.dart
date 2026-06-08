import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/format_utils.dart';
import '../../../data/models/car_model.dart';
import '../../controllers/booking_controller.dart';

class BookingPage extends StatelessWidget {
  final CarModel car;

  const BookingPage({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    final BookingController bookingController = Get.find<BookingController>();
    bookingController.setCarPrice(car.pricePerDay);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text("Form Booking")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCarCard(),
            const SizedBox(height: 24),
            Text("Data Identitas", style: AppTheme.heading2),
            const SizedBox(height: 12),
            TextField(controller: bookingController.nameController, decoration: _inputDecoration("Nama Lengkap")),
            const SizedBox(height: 12),
            TextField(controller: bookingController.phoneController, keyboardType: TextInputType.phone, decoration: _inputDecoration("No. HP")),
            
            const SizedBox(height: 24),
            Text("Pilih Tanggal & Waktu", style: AppTheme.heading2),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.divider),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Obx(() => Text(bookingController.startTime.value == null 
                      ? "Mulai: Pilih Tanggal & Jam" 
                      : DateFormat('dd MMM yyyy, HH:mm').format(bookingController.startTime.value!))),
                    leading: const Icon(Icons.access_time, color: AppTheme.primary),
                    onTap: () => bookingController.pickDateTime(true),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: Obx(() => Text(bookingController.endTime.value == null 
                      ? "Kembali: Pilih Tanggal & Jam" 
                      : DateFormat('dd MMM yyyy, HH:mm').format(bookingController.endTime.value!))),
                    leading: const Icon(Icons.date_range, color: AppTheme.primary),
                    onTap: () => bookingController.pickDateTime(false),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            Text("Upload Dokumen", style: AppTheme.heading2),
            const SizedBox(height: 12),
            _buildDocumentUploadRow(bookingController),
            const SizedBox(height: 24),
            Text("Durasi Sewa", style: AppTheme.heading2),
            const SizedBox(height: 12),
            _buildInfoCard(Obx(() => Text(bookingController.totalDays.value == 0 ? "-" : "${bookingController.totalDays.value} Hari"))),
            const SizedBox(height: 20),
            Obx(() => _buildInfoCard(Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Total Biaya"),
                    Text(FormatUtils.formatCurrency(bookingController.totalPrice.value), style: AppTheme.price),
                  ],
                ))),
            const SizedBox(height: 32),
            _buildSubmitButton(bookingController),
          ],
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---
  InputDecoration _inputDecoration(String label) => InputDecoration(
      labelText: label, filled: true, fillColor: AppTheme.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)));

  Widget _buildInfoCard(Widget child) => Container(
      width: double.infinity, padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppTheme.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppTheme.divider)),
      child: child);

  Widget _buildCarCard() => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFF6EEDF), borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        ClipRRect(borderRadius: BorderRadius.circular(10), child: Image.network(car.imageUrl, width: 90, height: 70, fit: BoxFit.cover)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("${car.brand} ${car.name}", style: AppTheme.heading3),
          Text("${car.capacity} Kursi • ${car.transmission}", style: AppTheme.caption),
          Text("${FormatUtils.formatCurrency(car.pricePerDay)}/hari", style: AppTheme.price),
        ])),
      ]));

  Widget _buildDocumentUploadRow(BookingController controller) => Row(children: [
        _buildUploadItem(controller, true),
        const SizedBox(width: 16),
        _buildUploadItem(controller, false),
      ]);

  Widget _buildUploadItem(BookingController controller, bool isKtp) => Expanded(
    child: InkWell(
      onTap: () => isKtp ? controller.pickKtp() : controller.pickSim(),
      borderRadius: BorderRadius.circular(10),
      child: Obx(() {
        final path = isKtp ? controller.ktpPath.value : controller.simPath.value;
        return Container(
          height: 120,
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.divider),
          ),
          child: path.isEmpty 
            ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(isKtp ? Icons.badge_outlined : Icons.credit_card, size: 40),
                Text(isKtp ? "Upload KTP" : "Upload SIM"),
              ])
            : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(File(path), fit: BoxFit.cover),
              ),
        );
      }),
    ),
  );

 Widget _buildSubmitButton(BookingController controller) => Obx(() => SizedBox(
      width: double.infinity, 
      height: 55,
      child: ElevatedButton(
        // Jika sedang loading, onPressed jadi null (tombol tidak bisa diklik)
        onPressed: controller.isSubmitting.value 
            ? null 
            : () => controller.processFinalBooking(car), 
        child: controller.isSubmitting.value 
            ? const SizedBox(
                width: 24, 
                height: 24, 
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
              ) 
            : const Text("Konfirmasi Pembayaran"),
      ),
    ));
}