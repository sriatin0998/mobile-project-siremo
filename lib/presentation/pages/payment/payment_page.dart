import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/booking_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/car_model.dart';

class PaymentPage extends StatelessWidget {
  final CarModel car;
  final BookingController controller = Get.find<BookingController>();

  PaymentPage({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pembayaran")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Total Tagihan", style: TextStyle(fontSize: 16)),
            Obx(() => Text(
              "Rp ${controller.totalPrice.value}", // Pastikan total harga ada di controller
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primary),
            )),
            const SizedBox(height: 30),
            const Align(alignment: Alignment.centerLeft, child: Text("Pilih Metode Pembayaran:")),
            RadioListTile(title: const Text("Transfer Bank"), value: 1, groupValue: 1, onChanged: (v){}),
            RadioListTile(title: const Text("E-Wallet"), value: 2, groupValue: 1, onChanged: (v){}),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.processFinalBooking(car),
                child: const Text("Bayar Sekarang"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}