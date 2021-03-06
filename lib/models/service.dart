
import 'package:flutter/foundation.dart';
import 'package:jam/models/sub_category.dart';
import 'package:jam/utils/utils.dart';

class Service {
  final int id;
  int index;

  final String name;
  final String arabic_name;
  bool isSelected;
  final String icon_image;
  final String banner_image;
  final String description;
  final List<SubCategory> categories;

  Service(this.id, this.name, this.arabic_name, this.icon_image, this.banner_image, this.description, this.categories, this.isSelected);

  Service.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        arabic_name = json['arabic_name'],
        icon_image = json['icon_image'],
        banner_image = json['banner_image'],
        description = json['description'],isSelected = json['isSelected'],
//        categories = json['categories'].map<SubCategory>((json) => new SubCategory.fromJson(json)).toList(),
        categories = ((json.containsKey('categories') && json['categories'] != null ) ?
        json['categories'].map<SubCategory>((json) => new SubCategory.fromJson(json)).toList() :
        null);

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name,'arabic_name': arabic_name, 'icon_image': icon_image,
    'banner_image': banner_image, 'categories': categories,
    'description': description
  };

  static List<Service> processServices(List services) {
    //printLog("reached here");
    return services.map<Service>((json) => new Service.fromJson(json)).toList();
  }
}