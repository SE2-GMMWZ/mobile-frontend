class ReviewData {
  final String reviewId;
  final String reviewerId;
  final String rating;
  final String comment;
  final String dateOfReview;

  ReviewData({
    required this.reviewId,
    required this.reviewerId,
    required this.rating,
    required this.comment,
    required this.dateOfReview,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      reviewId: json['review_id'],
      reviewerId: json['reviewer_id'],
      rating: json['rating'],
      comment: json['comment'],
      dateOfReview: json['date_of_review'],
    );
  }
}