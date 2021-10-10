class Review {
  String? id;
  String review;
  DateTime date;
  double rating;
  String reviewerName;
  String reviewerImage;
  // String reviewerId;

  Review({
    this.id,
    required this.date,
    required this.rating,
    required this.review,
    required this.reviewerImage,
    required this.reviewerName,
    // required this.reviewerId,
  });
}
