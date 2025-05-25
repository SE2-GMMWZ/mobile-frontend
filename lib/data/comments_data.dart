class CommentData {
  final String commentId;
  final String content;
  final String guideId;
  final String timestamp;
  final String userId;

  CommentData({
    required this.commentId,
    required this.content,
    required this.guideId,
    required this.timestamp,
    required this.userId,
  });

  factory CommentData.fromJson(Map<String, dynamic> json) {
    return CommentData(
      commentId: json['comment_id'],
      content: json['content'],
      guideId: json['guide_id'],
      timestamp: json['timestamp'],
      userId: json['user_id'],
    );
  }
}