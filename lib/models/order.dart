
import 'address.dart';

class Order {
  final int id;
  final int user_id;
  final int provider_id;
  final int service_id;
  final int category_id;
  final int status;
  final String provider_first_name;
  final String provider_last_name;
  final String provider_image;
  final String service;
  final String category;
  final String booking_date;
  final String orderer_name;
  final String email;
  final String contact;
  final String start_time;
  final String end_time;
  final String remark;
  final int rating;
  final String comment;
  final Address address;


  Order(this.id, this.provider_id, this.service_id, this.category_id,
      this.orderer_name, this.email,this.contact, this.start_time,
      this.end_time, this.remark, this.status, this.booking_date,
      this.service, this.category, this.provider_first_name,
      this.provider_image, this.provider_last_name,
      this.rating, this.comment,this.user_id,this.address);


  Order.fromJson(Map<String, dynamic> json)
      : id = json['id'], provider_id = json['provider_id'],
        service_id = json['service_id'], category_id = json['category_id'],
        orderer_name = json['orderer_name'], email = json['email'],
        contact = json['contact'], start_time = json['start_time'],
        end_time = json['end_time'], remark = json['remark'],
        status = json['status'], booking_date = json['booking_date'],
        service = json['service'], category = json['category'],
        provider_first_name = json['provider_first_name'],
        provider_image = json['provider_image'],
        provider_last_name = json['provider_last_name'],
        rating = json['rating'], comment = json['comment'], user_id = json['user_id'],
        address = ((json.containsKey('address') && json['address'] != null ) ? Address.fromJson(json['address']) : null);


  static List<Order> processOrders(List orders) {
    print("orders = $orders");
    return orders.map<Order>((json) => new Order.fromJson(json)).toList();
  }

}