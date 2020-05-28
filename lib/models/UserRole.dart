
class UserRole {
  final int id;
  final String name;
  final String slug;


  UserRole(this.id, this.name, this.slug);

  UserRole.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        slug = json['slug'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'slug': slug
  };
}