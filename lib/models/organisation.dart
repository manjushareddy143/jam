
class Organisation {
  final int id;
  final String name;
  final String logo;
  final String country;
  final String number_of_employee;

  Organisation(this.id, this.country, this.name, this.logo, this.number_of_employee);

  Organisation.fromJson(Map<String, dynamic> json)
      : id = json['id'], number_of_employee = json['number_of_employee'],
        logo = json['logo'], name = json['name'], country = json['country'];





}