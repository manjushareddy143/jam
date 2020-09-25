
import 'dart:convert';

import 'package:jam/models/UserRole.dart';
import 'package:jam/models/address.dart';
import 'package:jam/models/organisation.dart';
import 'package:jam/models/provider_detail.dart';
import 'package:jam/models/rate.dart';
import 'package:jam/models/review.dart';
import 'package:jam/models/user_services.dart';

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

  List<Address> address;
  final List<UserRole> roles;
  final List<Rate> rate;
  final ProviderDetail provider;
  final Organisation organisation;
  final List<Review> reviews;
  final int jobs_count;
  final String price;
  final List<UserServices> services;
  final UserServices servicePrice;
//  final List<Jobs> jobs;


  User(this.id, this.first_name, this.last_name, this.image, this.languages,
      this.contact, this.email, this.gender, this.org_id, this.term_id,
      this.type_id, this.rate, this.address, this.resident_country, this.roles,
      this.social_signin, this.existing_user, this.provider, this.organisation,
      this.reviews, this.jobs_count, this.price, this.services, this.servicePrice);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],  first_name = json['first_name'],
        last_name = json['last_name'], image = json['image'],
        languages = json['languages'], contact = json['contact'],
        price = json['price'],
        email = json['email'], gender = json['gender'],
        org_id = json['org_id'], term_id = json['term_id'],
        type_id = json['type_id'],resident_country = json['resident_country'],
        social_signin = json['social_signin'],existing_user = json['existing_user'],
        roles = ((json.containsKey('roles') && json['roles'] != null ) ?
        json['roles'].map<UserRole>((json) => new UserRole.fromJson(json)).toList() : null),
        address = ((json.containsKey('address') && json['address'] != null ) ?
        json['address'].map<Address>((json) => new Address.fromJson(json)).toList().reversed.toList() :
        null), rate = ((json.containsKey('rate') && json['rate'] != null )
      ? json['rate'].map<Rate>((json) => new Rate.fromJson(json)).toList() : null),
        provider = ((json.containsKey('provider') && json['provider'] != null )
            ? ProviderDetail.fromJson(json['provider']) : null),
        servicePrice = ((json.containsKey('service_price') && json['service_price'] != null )
            ? UserServices.fromJson(json['service_price']) : null),
        organisation = ((json.containsKey('organisation') && json['organisation'] != null )
            ? Organisation.fromJson(json['organisation']) : null),
        reviews = ((json.containsKey('reviews') && json['reviews'] != null )
            ? json['reviews'].map<Review>((json) => new Review.fromJson(json)).toList() : null),
        services = ((json.containsKey('services') && json['services'] != null )
            ? json['services'].map<UserServices>((json) => new UserServices.fromJson(json)).toList() : null),
        jobs_count = json['jobs_count'];

  Map<String, dynamic> toJson() => {
    'id': id, 'first_name': first_name,
    'last_name': last_name, 'image': image,
    'languages': languages, 'contact': contact,
    'email': email, 'gender': gender,
    'org_id': org_id, 'term_id': term_id,
    'type_id': type_id,'resident_country': resident_country,
    'roles': (roles != null) ? UserRole.processListOfRoles(roles) : null ,
    'social_signin': social_signin,
    'existing_user': existing_user,
    'address': (address != null) ? Address.processListOfAddressList(address) : null ,
    'services': (services != null) ? UserServices.processListOfUserServices(services) : null ,
    'jobs_count': (jobs_count != null) ? jobs_count : null ,
    'reviews': (reviews != null) ? reviews : null ,
    'organisation': (organisation != null) ? organisation.toJson() : null ,
    'servicePrice': (servicePrice != null) ? servicePrice.toJson() : null ,
    'provider': (provider != null) ? provider.toJson() : null ,
    'rate': (rate != null) ? rate : null ,
  };

  static List<User> processListOfUser(List users) {
    print("users = $users");
    return users.map<User>((json) => new User.fromJson(json)).toList();
  }
}