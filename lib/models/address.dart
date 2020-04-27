
class Address {
  final int id;
  final String address_line1;
  final String address_line2;
  final String landmark;
  final String district;
  final String city;
  final String postal_code;
  final String location;
  final int user_id;

  Address(this.id, this.address_line1, this.address_line2, this.landmark,
      this.district, this.city, this.postal_code, this.location, this.user_id);

  Address.fromJson(Map<String, dynamic> json)
      : id = json['id'], address_line1 = json['address_line1'],
        address_line2 = json['address_line2'], landmark = json['landmark'],
        district = json['district'], city = json['city'],
        postal_code = json['postal_code'], location = json['location'],
        user_id = json['user_id'];

}