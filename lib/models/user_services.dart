
import 'package:jam/models/service.dart';
import 'package:jam/models/sub_category.dart';

class UserServices {

  final int id;
  final int user_id;
  final int service_id;
  final int category_id;
  final String price;
  final Service service;
  final SubCategory categories;

  UserServices(this.id, this.price, this.category_id, this.service_id, this.user_id, this.categories, this.service);

  UserServices.fromJson(Map<String, dynamic> json)
      : id = json['id'],  price = json['price'], service_id = json['service_id'],
        category_id = json['category_id'], user_id = json['user_id'],
        service = ((json.containsKey('service') && json['service'] != null )
            ? Service.fromJson(json['service']) : null),
        categories = ((json.containsKey('categories') && json['categories'] != null )
            ? SubCategory.fromJson(json['categories']) : null);


  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': user_id, 'service_id': service_id,
    'category_id': category_id, 'price': price,
    'service': (service != null) ? service.toJson() : null , 'categories': (categories != null) ? categories.toJson() : null ,
  };

  static List processListOfUserServices(List<UserServices> userServices) {
    List list = new List();
    for(var i = 0; i < userServices.length; i++){
      list.add(userServices[i].toJson());
    }
    return list;
  }

}