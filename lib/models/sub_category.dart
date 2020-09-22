
class SubCategory {
  final int id;
  final String name;
  final String arabic_name;
  final String image;
  final String description;
  bool isSelected;
  SubCategory(this.id, this.name,this.arabic_name, this.image, this.description);

  SubCategory.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        arabic_name = json['arabic_name'],
        image = json['image'],
        description = json['description'];


  Map<String, dynamic> toJson() => {
    'id': id, 'name': name,'arabic_name': arabic_name, 'image': image,
    'description': description
  };

  static List<SubCategory> processSubCategories(List category) {
    return category.map<SubCategory>((json) => new SubCategory.fromJson(json)).toList();
  }
}