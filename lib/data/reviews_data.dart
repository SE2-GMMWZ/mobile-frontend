class ReviewData {
  final String reviewId;
  final String reviewerId;
  final String comment;
  final String dateOfReview;
  final int rating;

  ReviewData({
    required this.reviewId,
    required this.reviewerId,
    required this.comment,
    required this.dateOfReview,
    required this.rating,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      reviewId: json['review_id']?.toString() ?? '',
      reviewerId: json['reviewer_id']?.toString() ?? '',
      comment: json['comment']?.toString() ?? '',
      dateOfReview: json['date_of_review']?.toString() ?? DateTime.now().toIso8601String(),
      rating: json['rating'] is int ? json['rating'] : (json['rating'] as num?)?.toInt() ?? 0,
    );
  }


   Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'reviewer_id': reviewerId,
      'comment': comment,
      'date_of_review': dateOfReview,
      'rating': rating,
    };
    
    // Only include review_id if it's not empty
    if (reviewId.isNotEmpty) {
      json['review_id'] = reviewId;
    }
    
    return json;
  }
}