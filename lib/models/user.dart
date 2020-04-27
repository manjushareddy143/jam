
import 'package:jam/models/address.dart';

class User {
  final int id;
  final String type_id;
  final String term_id;
  final int org_id;

  final String first_name;
  final String last_name;
  final String email;
  final String image;
  final String contact;
  final String gender;
  final String languages;

  final Address address;

  User(this.id, this.first_name, this.last_name, this.image, this.languages, this.contact,
       this.email, this.gender, this.org_id, this.term_id, this.type_id, this.address);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],  first_name = json['first_name'],
        last_name = json['last_name'], image = json['image'],
        languages = json['languages'], contact = json['contact'],
        email = json['email'], gender = json['gender'],
        org_id = json['org_id'], term_id = json['term_id'],
        type_id = json['type_id'], address = json['address'];
  //.map<Address>((json) => new Address.fromJson(json));

  Map<String, dynamic> toJson() => {
    'id': id, 'first_name': first_name,
    'last_name': last_name, 'image': image,
    'languages': languages, 'contact': contact,
    'email': email, 'gender': gender,
    'org_id': org_id, 'term_id': term_id,
    'type_id': type_id, 'address': address,
  };
}