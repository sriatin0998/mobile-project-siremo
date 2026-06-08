class CarModel {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String imageUrl;
  final double rating;
  final int capacity;
  final String transmission;
  final int pricePerDay;
  final String description;
  final List<String> features;
  final bool isAvailable;
  final String licensePlate;
  final int year;

  // 1. Konstruktor HARUS ADA agar variabel di atas punya tempat penyimpanan
  CarModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.capacity,
    required this.transmission,
    required this.pricePerDay,
    required this.description,
    required this.features,
    required this.isAvailable,
    required this.licensePlate,
    required this.year,
  });

factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'].toString(), // Pastikan id diubah ke string
      name: json['nama_mobil'] ?? '', // Sesuaikan dengan key di Resource Laravel
      brand: json['merek'] ?? '',
      category: json['kategori'] ?? '',
      imageUrl: json['foto_url'] ?? '', // Sesuaikan dengan key di Resource Laravel
      rating: 0.0, // Karena API tidak kirim rating, set default
      capacity: 0, // Set default jika API belum menyediakan
      transmission: 'Manual',
      pricePerDay: json['tarif'] ?? 0, // Sesuaikan dengan 'tarif' di Resource
      description: '',
      features: [],
      isAvailable: json['status'] == 'Tersedia', // Logika status dari API
      licensePlate: json['plat_nomor'] ?? '',
      year: 2024,
    );
  }
}