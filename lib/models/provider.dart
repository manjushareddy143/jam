
import 'package:jam/models/provider_detail.dart';
import 'package:jam/models/rate.dart';
import 'package:jam/models/service.dart';
import 'package:jam/models/user.dart';

class Provider {
  final int id;
  final int user_id;
  final int service_id;
  final int category_id;

  final List<User> user;
  final Service service;



//  final String first_name;
//  final String last_name;
//  final String email;
//  final String image;
//  final String contact;
//  final String gender;
//  final String languages;
//  final int type_id;
//  final int term_id;
//  final int org_id;
//  final String resident_country;
//  final String doc;
//  final String document_image;
////  final String rate;
//  final int reviews;
//  final ProviderDetail provider;
//  final List<Rate> rate;

//  Provider(this.id, this.first_name, this.last_name, this.image, this.languages, this.contact,
//      this.doc, this.document_image, this.email, this.gender, this.org_id,
//  this.resident_country,this.term_id, this.type_id, this.rate, this.reviews, this.provider);
  Provider(this.id, this.user_id, this.service, this.user, this.category_id, this.service_id);

  Provider.fromJson(Map<String, dynamic> json)
  : id = json['id'], user_id = json['user_id'], category_id = json['category_id']
  , service_id = json['service_id'], user = ((json.containsKey('user') && json['user'] != null ) ?
  json['user'].map<User>((json) => new User.fromJson(json)).toList() :
  null),
        service = ((json.containsKey('service') && json['service'] != null ) ? Service.fromJson(json['service']) : null);

//  Provider.fromJson(Map<String, dynamic> json)
//      : id = json['id'], first_name = json['first_name'], last_name = json['last_name'], image = json['image'],
//        languages = json['languages'], contact = json['contact'],
//        doc = json['doc'], document_image = json['document_image'],
//        email = json['email'], gender = json['gender'],
//        org_id = json['org_id'], resident_country = json['resident_country'],
//        term_id = json['term_id'], type_id = json['type_id'],
//        reviews = json['reviews'],
//        rate = ((json.containsKey('rate') && json['rate'] != null ) ?
//        json['rate'].map<Rate>((json) => new Rate.fromJson(json)).toList() : null),
//        provider = ((json.containsKey('provider') && json['provider'] != null )
//            ? ProviderDetail.fromJson(json['provider']) : null);


  static List<Provider> processProviders(List providers) {
    print("providers = $providers");
    return providers.map<Provider>((json) => new Provider.fromJson(json)).toList();
  }

}