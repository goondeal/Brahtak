class Area{
  final int id;
  final String name;
  final double deliveryPrice;

  Area({this.id, this.name, this.deliveryPrice});

  Area.fromMap(Map<String, dynamic> data)
  : id = data['id'],
    name = data['name'],
    deliveryPrice = double.parse(data['delivery_price']);

}