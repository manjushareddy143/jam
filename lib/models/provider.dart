
class Provider {
  final int id;
  final String name;
  final String email;
  final String image;
  final String contact;
  final String gender;
  final String languages;
  final int type_id;
  final int term_id;
  final int org_id;
  final String resident_country;
  final String doc;
  final String document_image;

  Provider(this.id, this.name, this.image, this.languages, this.contact,
      this.doc, this.document_image, this.email, this.gender, this.org_id,
  this.resident_country,this.term_id, this.type_id);


  Provider.fromJson(Map<String, dynamic> json)
      : id = json['id'], name = json['name'], image = json['image'],
        languages = json['languages'], contact = json['contact'],
        doc = json['doc'], document_image = json['document_image'],
        email = json['email'], gender = json['gender'],
        org_id = json['org_id'], resident_country = json['resident_country'],
        term_id = json['term_id'], type_id = json['type_id'];


  static List<Provider> processProviders(List providers) {
    print("providers = $providers");
    return providers.map<Provider>((json) => new Provider.fromJson(json)).toList();
  }

}