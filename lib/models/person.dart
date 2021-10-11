class Person {
  final int? id;
  final int? mobileNumber;
  final String? firstName;
  final String? lastName;
  final String? address;

  Person({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'mobile_number': mobileNumber,
      'address': address,
    };
  }

  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      id: map['id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      mobileNumber: map['mobile_number'],
      address: map['address'],
    );
  }

  Map<String, dynamic> toJson() =>
      {'id': id, 'first_name': firstName, 'last_name': lastName, 'mobile_number': mobileNumber, 'address': address};

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        mobileNumber: json['mobile_number'],
        address: json['address']);
  }

  @override
  String toString() {
    return 'Person{id: $id, first_name: $firstName, last_name: $lastName,  mobile_number: $mobileNumber, address: $address}';
  }

  bool checkIfAnyIsNull() {
    return [id, firstName, lastName, mobileNumber, address].contains(null);
  }
}
