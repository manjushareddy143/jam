
class Address {
  final int id;
  final String name;
  final String address_line1;
  final String address_line2;
  final String landmark;
  final String district;
  final String city;
  final String postal_code;
  final String location;
  final int user_id;

  Address(this.id, this.address_line1, this.address_line2, this.landmark,
      this.district, this.city, this.postal_code, this.location, this.user_id, this.name);

  Address.fromJson(Map<String, dynamic> json)
      : id = json['id'], address_line1 = json['address_line1'], name = json['name'],
        address_line2 = json['address_line2'], landmark = json['landmark'],
        district = json['district'], city = json['city'],
        postal_code = json['postal_code'], location = json['location'],
        user_id =  json['user_id'];

  Map<String, dynamic> toJson() => {
    'id': id, 'address_line1': address_line1, 'name': name,
    'address_line2': address_line2, 'landmark': landmark,
    'district': district, 'city': city,
    'postal_code': postal_code, 'location': location,
    'user_id': user_id
  };

  static List processListOfAddressList(List<Address> address) {
    List list = new List();
    for(var i = 0; i < address.length; i++){
      list.add(address[i].toJson());
    }
    return list;
  }

  static List<Address> processListOfAddress(List addresses) {
    return addresses.map<Address>((json) => new Address.fromJson(json)).toList();
  }
}