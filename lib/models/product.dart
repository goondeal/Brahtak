class Product {
  int id;
  int categoryId;
  String name;
  //String description;
  String image;
  double price;
  double priceCut;
  bool featured;

  String assetName = 'assets/images/Photo_Here1.png';
  //int quantity;
  Product({this.assetName, this.name});

  Product.fromJson(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'].toString(),
        image = data['has_image'].toString(),
        categoryId = int.parse((data['categoy_id'] ?? 0).toString()),
        priceCut = double.parse(data['price_cut'] ?? '0.0'),
        price = double.parse(data['price'].toString()),
        featured = data['featured'].toString() == '1';
  //priceCut = data['price_cut'].toString(),

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'image': image,
      'price': price,
      'featurd': featured,
      'asset_name': assetName,
    };
  }

  @override
  String toString() {
    return this.toMap().toString();
  }
}
