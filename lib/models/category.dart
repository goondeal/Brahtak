class Category{
  int id;
  String name;
  dynamic image;

  Category.fromMap(Map<String, dynamic> data)
  : id = data['id'],
    name = data['name'],
    image = data['has_image'];  // dump title from the backend.

}