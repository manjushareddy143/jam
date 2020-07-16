
class Invoice {
  final int id;
  final int order_id;
  final int working_hr;
  final String material_names;
  final int material_quantity;
  final int material_price;
  final int additional_charges;
  final int discount;
  final int tax;
  final int tax_rate;

  Invoice(this.id, this.additional_charges, this.discount, this.material_names,
      this.material_price, this.material_quantity, this.order_id, this.tax,
      this.working_hr, this.tax_rate);

  Invoice.fromJson(Map<String, dynamic> json)
      : id = json['id'], order_id = json['order_id'], working_hr = json['working_hr']
  , material_names = json['material_names'], material_quantity = json['material_quantity'],
        material_price = json['material_price'], additional_charges = json['additional_charges'],
        discount = json['discount'], tax = json['tax'], tax_rate = json['tax_rate'];
}