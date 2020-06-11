
class Rate {
  final String rate;
  final int rate_to;
  final int reviews;

  Rate(this.rate_to, this.rate, this.reviews);

  Rate.fromJson(Map<String, dynamic> json)
      : rate = json['rate'], rate_to = json['rate_to'],
        reviews = json['reviews'];

}