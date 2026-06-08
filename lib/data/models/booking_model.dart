import 'package:cloud_firestore/cloud_firestore.dart';

enum BookingStatus { pending, confirmed, active, completed, cancelled }

class BookingModel {
  final String id;
  final String userId;
  final String carId;
  final String carName;
  final String carBrand;
  final String carImageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final int totalDays;
  final int pricePerDay;
  final int totalPrice;
  final BookingStatus status;
  final String pickupLocation;
  final DateTime createdAt;
  final String customerName;
  final String pickupTime;
  final String returnTime;

  BookingModel({
    required this.id,
    required this.userId,
    required this.carId,
    required this.carName,
    required this.carBrand,
    required this.carImageUrl,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.pricePerDay,
    required this.totalPrice,
    required this.status,
    required this.pickupLocation,
    required this.createdAt,
    required this.customerName,
    required this.pickupTime,
    required this.returnTime,
  });

  String get statusLabel {
    switch (status) {
      case BookingStatus.pending: return 'Menunggu';
      case BookingStatus.confirmed: return 'Dikonfirmasi';
      case BookingStatus.active: return 'Aktif';
      case BookingStatus.completed: return 'Selesai';
      case BookingStatus.cancelled: return 'Dibatalkan';
    }
  }

  factory BookingModel.fromMap(Map<String, dynamic> map, String id) {
    return BookingModel(
      id: id,
      userId: map['userId'] ?? '',
      carId: map['carId'] ?? '',
      carName: map['carName'] ?? '',
      carBrand: map['carBrand'] ?? '',
      carImageUrl: map['carImageUrl'] ?? '',
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      totalDays: map['totalDays'] ?? 0,
      pricePerDay: map['pricePerDay'] ?? 0,
      totalPrice: map['totalPrice'] ?? 0,
      status: BookingStatus.values.firstWhere((e) => e.name == map['status'], orElse: () => BookingStatus.pending),
      pickupLocation: map['pickupLocation'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      customerName: map['customer_name'] ?? '',
      pickupTime: map['pickup_time'] ?? '',
      returnTime: map['return_time'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'carId': carId,
      'carName': carName,
      'carBrand': carBrand,
      'carImageUrl': carImageUrl,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'totalDays': totalDays,
      'pricePerDay': pricePerDay,
      'totalPrice': totalPrice,
      'status': status.name,
      'pickupLocation': pickupLocation,
      'createdAt': Timestamp.fromDate(createdAt),
      'customer_name': customerName,
      'pickup_time': pickupTime,
      'return_time': returnTime,
    };
  }

  static List<BookingModel> getDummyData() {
    return [
      BookingModel(
        id: 'bk001', userId: 'usr001', carId: '1', carName: 'Avanza', carBrand: 'Toyota',
        carImageUrl: 'https://images.unsplash.com/photo-1590362891991-f776e747a588?w=400',
        startDate: DateTime.now().subtract(const Duration(days: 10)),
        endDate: DateTime.now().subtract(const Duration(days: 7)),
        totalDays: 3, pricePerDay: 350000, totalPrice: 1050000, status: BookingStatus.completed,
        pickupLocation: 'Jl. Balai Graha No. 1', createdAt: DateTime.now(),
        customerName: 'Budi Santoso', pickupTime: '08:00', returnTime: '18:00',
      ),
      BookingModel(
        id: 'bk002', userId: 'usr002', carId: '2', carName: 'Xenia', carBrand: 'Daihatsu',
        carImageUrl: 'https://images.unsplash.com/photo-1590362891991-f776e747a588?w=400',
        startDate: DateTime.now().subtract(const Duration(days: 5)),
        endDate: DateTime.now().subtract(const Duration(days: 2)),
        totalDays: 3, pricePerDay: 400000, totalPrice: 1200000, status: BookingStatus.completed,
        pickupLocation: 'Jl. Sudirman No. 10', createdAt: DateTime.now(),
        customerName: 'Ani Permata', pickupTime: '10:00', returnTime: '20:00',
      ),
    ];
  }
}