
class Rating {
  final int id;
  final int rating;
  final int rate_by;
  final int rate_to;
  final int booking_id;
  final String comment;

  Rating(this.id, this.rating, this.rate_by, this.rate_to, this.comment, this.booking_id);

  Rating.fromJson(Map<String, dynamic> json)
      : id = json['id'], rating = json['rating'],
        rate_by = json['rate_by'], rate_to = json['rate_to'],
        comment = json['comment'], booking_id = json['booking_id'];
}