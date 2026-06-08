import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format_utils.dart';
import '../../data/models/car_model.dart';

class BookingCarCard extends StatelessWidget {
  final CarModel car;

  const BookingCarCard({
    super.key,
    required this.car,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xffF8F0E4),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.network(
              car.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${car.brand} ${car.name}",
                  style: AppTheme.heading3,
                ),
                const SizedBox(height: 3),
                Text(
                  "${car.category} • ${car.transmission}",
                  style: AppTheme.caption,
                ),
                const SizedBox(height: 5),
                Text(
                  "${FormatUtils.formatCurrency(car.pricePerDay)}/hari",
                  style: AppTheme.price,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}