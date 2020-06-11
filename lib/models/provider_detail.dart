
class ProviderDetail {
  final int id;
  final int user_id;
  final String resident_country;
  final int proof_id;
  final int verified;

  ProviderDetail(this.id, this.user_id, this.resident_country, this.proof_id, this.verified);

  ProviderDetail.fromJson(Map<String, dynamic> json)
      : id = json['id'], user_id = json['user_id'], resident_country =
  json['resident_countryd'], proof_id = json['proof_id'],
        verified = json['verified'];
}