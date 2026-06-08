import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/review_controller.dart';


class AddReviewPage extends StatelessWidget {
  final String carId;
  final String bookingId;
  final ReviewController controller = Get.put(ReviewController());

  AddReviewPage({
    super.key, 
    required this.carId, 
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Beri Ulasan")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Berapa rating untuk mobil ini?", style: TextStyle(fontSize: 16)),
            Obx(() => Text("${controller.rating.value.toInt()} Bintang", 
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange))),
            
            Obx(() => Slider(
              value: controller.rating.value,
              min: 1, max: 5, divisions: 4,
              activeColor: Colors.orange,
              onChanged: (val) => controller.rating.value = val,
            )),

            const SizedBox(height: 20),
            TextField(
              controller: controller.commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Komentar Anda",
                border: OutlineInputBorder(),
                hintText: "Ceritakan pengalaman sewa Anda...",
              ),
            ),
            const SizedBox(height: 30),
            
            Obx(() => SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                onPressed: controller.isLoading.value 
                ? null 
                : () => controller.submitReview(carId, bookingId), // Kirim nama asli, masking di UI
                child: controller.isLoading.value 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Kirim Ulasan", style: TextStyle(color: Colors.white)),
              ),
            ))
          ],
        ),
      ),
    );
  }
}