
import 'package:jam/models/user.dart';

class Review {
  final int id;
  final int rating;
  final User rate_by;
  final int rate_to;
  final int booking_id;
  final String comment;

  Review(this.id, this.rating, this.rate_by, this.rate_to, this.comment, this.booking_id);

  Review.fromJson(Map<String, dynamic> json)
      : id = json['id'], rating = json['rating'],
        rate_to = json['rate_to'],
        rate_by = ((json.containsKey('rate_by') && json['rate_by'] != null ) ? User.fromJson(json['rate_by']) : null),
        comment = json['comment'], booking_id = json['booking_id'];
}