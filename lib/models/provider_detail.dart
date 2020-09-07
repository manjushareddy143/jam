
class ProviderDetail {
  final int id;
  final int user_id;
  final String resident_country;
  final int proof_id;
  final int verified;
  final int service_radius;

  ProviderDetail(this.id, this.user_id, this.resident_country, this.proof_id, this.verified, this.service_radius);

  ProviderDetail.fromJson(Map<String, dynamic> json)
      : id = json['id'], user_id = json['user_id'], resident_country =
  json['resident_countryd'], proof_id = json['proof_id'], service_radius = json['service_radius'],
        verified = json['verified'];

  Map<String, dynamic> toJson() => {
    'id': id, 'user_id': user_id, 'resident_country': resident_country,
    'proof_id': proof_id, 'verified': verified,
    'service_radius': service_radius
  };

}