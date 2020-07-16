
import 'package:jam/models/invoice.dart';
import 'package:jam/models/rating.dart';
import 'package:jam/models/service.dart';
import 'package:jam/models/sub_category.dart';
import 'package:jam/models/user.dart';

import 'address.dart';

class Order {
  final int id;
  final int user_id;
  final int provider_id;
  final int service_id;
  final int category_id;
  int status;
//  final String provider_first_name;
//  final String provider_last_name;
//  final String provider_image;
//  final String service;
  final SubCategory category;
  final String booking_date;
  final String orderer_name;
  final String email;
  final String contact;
  final String start_time;
  final String end_time;
  final String remark;
//  final int rating;
  final int otp;
  final String comment;
  final Address address;
  final User user;
  final User provider;
  final Service service;
  final Rating rating;
  Invoice invoice;
//  final User provider;
//  final User user;

  Order(this.id, this.provider_id, this.service_id, this.category_id,
      this.orderer_name, this.email,this.contact, this.start_time,
      this.end_time, this.remark, this.status, this.booking_date,
      this.service, this.category,
//      this.provider_first_name, this.provider_image, this.provider_last_name,
      this.comment, this.rating, this.invoice,
      this.user_id,this.address, this.otp, this.user, this.provider);
  //this.provider, this.user, this.ratings

  Order.fromJson(Map<String, dynamic> json)
      : id = json['id'], provider_id = json['provider_id'],
        service_id = json['service_id'],
        category_id = json['category_id'],
        orderer_name = json['orderer_name'],
        email = json['email'],
        contact = json['contact'],
        start_time = json['start_time'],
        end_time = json['end_time'],
        remark = json['remark'],
        status = json['status'],
        booking_date = json['booking_date'],
//        provider_first_name = json['provider_first_name'],
//        provider_image = json['provider_image'],
//        provider_last_name = json['provider_last_name'],
        comment = json['comment'],
        user_id = json['user_id'], otp = json['otp'],
        rating = ((json.containsKey('rating') && json['rating'] != null ) ? Rating.fromJson(json['rating']) : null),
        address = ((json.containsKey('address') && json['address'] != null ) ? Address.fromJson(json['address']) : null),
        service = ((json.containsKey('services') && json['services'] != null ) ? Service.fromJson(json['services']) : null),
        provider = ((json.containsKey('provider') && json['provider'] != null ) ? User.fromJson(json['provider']) : null),
        user = ((json.containsKey('user') && json['user'] != null ) ? User.fromJson(json['user']) : null),
        invoice = ((json.containsKey('invoice') && json['invoice'] != null ) ? Invoice.fromJson(json['invoice']) : null),
        category = ((json.containsKey('category') && json['category'] != null ) ? SubCategory.fromJson(json['category']) : null);

//        ratings = ((json.containsKey('rating') && json['rating'] != null ) ? Rating.fromJson(json['rating']) : null),
//        provider = ((json.containsKey('provider') && json['provider'] != null ) ? User.fromJson(json['provider']) : null),
//        user = ((json.containsKey('users') && json['users'] != null ) ? User.fromJson(json['users']) : null),
//        service = ((json.containsKey('services') && json['services'] != null ) ? Service.fromJson(json['services']) : null),
//        category = ((json.containsKey('category') && json['category'] != null ) ? SubCategory.fromJson(json['category']) : null);


  static List<Order> processOrders(List orders) {
    print("orders = $orders");
    return  orders.map<Order>((json) => new Order.fromJson(json)).toList();
  }

}