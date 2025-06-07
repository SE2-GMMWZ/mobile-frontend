class BookingsData {
  final String? bookingId;
  final String sailorId;
  final String dockId;
  final String startDate;
  final String endDate;
  final String paymentMethod;
  final String paymentStatus;
  final String people;
  String? dockName;

  BookingsData({
    this.bookingId,
    required this.sailorId,
    required this.dockId,
    required this.startDate,
    required this.endDate,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.people,
  });

  factory BookingsData.fromJson(Map<String, dynamic> json) {
    return BookingsData(
      bookingId: json['booking_id']?.toString(),
      sailorId: json['sailor_id']?.toString() ?? '',
      dockId: json['dock_id']?.toString() ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      people: json['people']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'sailor_id': sailorId,
      'dock_id': dockId,
      'start_date': startDate,
      'end_date': endDate,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'people': people,
    };
  }

}
