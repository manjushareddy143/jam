
import 'package:jam/models/invoice.dart';
import 'package:jam/models/rating.dart';
import 'package:jam/models/service.dart';
import 'package:jam/models/sub_category.dart';
import 'package:jam/models/user.dart';

import 'address.dart';

class OrderCanelled {

  final String reason;
  final String comment;


  OrderCanelled(this.reason, this.comment);
  //this.provider, this.user, this.ratings

  OrderCanelled.fromJson(Map<String, dynamic> json)
      : reason = json['reason'], comment = json['comment'];

  Map<String, dynamic> toJson() => {
    'reason': reason, 'comment': comment,
  };

//        ratings = ((json.containsKey('rating') && json['rating'] != null ) ? Rating.fromJson(json['rating']) : null),
//        provider = ((json.containsKey('provider') && json['provider'] != null ) ? User.fromJson(json['provider']) : null),
//        user = ((json.containsKey('users') && json['users'] != null ) ? User.fromJson(json['users']) : null),
//        service = ((json.containsKey('services') && json['services'] != null ) ? Service.fromJson(json['services']) : null),
//        category = ((json.containsKey('category') && json['category'] != null ) ? SubCategory.fromJson(json['category']) : null);




}