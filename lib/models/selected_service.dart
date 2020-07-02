
import 'package:jam/models/user.dart';

class SelectedService {
  int service_id;
  int category_id;
  int price;

  SelectedService(this.service_id, this.category_id, this.price);

  SelectedService.fromJson(Map<String, dynamic> json)
      : service_id = json['service_id'], category_id = json['category_id'],
        price = json['price'];


  Map<String, dynamic> toJson() => {
    'service_id': service_id, 'category_id': category_id,
    'price': price };


}