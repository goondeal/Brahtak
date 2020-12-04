class Address {
  final String areaID;

  final String addressName;
  final String comment;
  final String phoneNumber;
  final String flat;
  final String st;

  Address({
    this.addressName,
    this.areaID,
    this.phoneNumber,
    this.flat,
    this.st,
    this.comment,
  });

  Address.fromMap(Map<String, dynamic> data)
      : areaID = data['area_id'],
        addressName = data['NameOfAddress'],
        comment = data['comment'],
        phoneNumber = data['PhoneNumber'],
        flat = data['Flat'],
        st = data['St'];

  Map<String, String> get toMap {
    return {
      'area_id': areaID,
      'NameOfAddress': addressName,
      'comment': comment??'No Comment',
      'PhoneNumber': phoneNumber,
      'Flat': flat.toString(),
      'St': st,
    };
  }
  @override
  String toString() {
    return this.toMap.toString();
  }
}
