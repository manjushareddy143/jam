
import 'package:flutter/foundation.dart';
import 'package:jam/models/sub_category.dart';
import 'package:jam/utils/utils.dart';

class Service {
  final int id;
  int index;

  final String name;
  bool isSelected;
  final String icon_image;
  final String banner_image;
  final String description;
  final List<SubCategory> categories;

  Service(this.id, this.name, this.icon_image, this.banner_image, this.description, this.categories, this.isSelected);

  Service.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        icon_image = json['icon_image'],
        banner_image = json['banner_image'],
        description = json['description'],isSelected = json['isSelected'],
        categories = json['categories'].map<SubCategory>((json) => new SubCategory.fromJson(json)).toList();


  static List<Service> processServices(List services) {
    printLog("reached here");
    return services.map<Service>((json) => new Service.fromJson(json)).toList();
  }
}