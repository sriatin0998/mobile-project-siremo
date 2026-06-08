class ReviewModel {
  final String id;
  final String carId;
  final String userName;
  final String comment;
  final double rating;
  final DateTime date;

  ReviewModel({
    required this.id,
    required this.carId,
    required this.userName,
    required this.comment,
    required this.rating,
    required this.date,
  });
}