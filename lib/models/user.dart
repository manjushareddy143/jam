
import 'package:jam/models/UserRole.dart';
import 'package:jam/models/address.dart';

class User {
  final int id;
  final int type_id;
  final int term_id;
  final int org_id;
  final int existing_user;

  final String first_name;
  final String last_name;
  final String email;
  final String image;
  final String contact;
  final String gender;
  final String languages;
  final String resident_country;
  final String social_signin;

  final List<Address> address;
  final List<UserRole> roles;

  User(this.id, this.first_name, this.last_name, this.image, this.languages, this.contact,
       this.email, this.gender, this.org_id, this.term_id, this.type_id,
      this.address, this.resident_country, this.roles, this.social_signin, this.existing_user);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],  first_name = json['first_name'],
        last_name = json['last_name'], image = json['image'],
        languages = json['languages'], contact = json['contact'],
        email = json['email'], gender = json['gender'],
        org_id = json['org_id'], term_id = json['term_id'],
        type_id = json['type_id'],resident_country = json['resident_country'],
        social_signin = json['social_signin'],existing_user = json['existing_user'],
        roles = ((json.containsKey('roles') && json['roles'] != null ) ?
        json['roles'].map<UserRole>((json) => new UserRole.fromJson(json)).toList() : null),
        address = ((json.containsKey('address') && json['address'] != null ) ?
        json['address'].map<Address>((json) => new Address.fromJson(json)).toList() :
        null);
        //json['address'].map<Address>((json) => new Address.fromJson(json)).toList();
        //((json.containsKey('address') && json['address'] != null ) ? Address.fromJson(json['address']) : null);

  Map<String, dynamic> toJson() => {
    'id': id, 'first_name': first_name,
    'last_name': last_name, 'image': image,
    'languages': languages, 'contact': contact,
    'email': email, 'gender': gender,
    'org_id': org_id, 'term_id': term_id,
    'type_id': type_id,'resident_country': resident_country,
    'roles': roles, 'social_signin': social_signin,
    'existing_user': existing_user,
    'address': (address != null) ? address : null ,
  };
}