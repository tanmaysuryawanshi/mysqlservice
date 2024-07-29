class Country {
  final int id;
  final String name;

  Country({required this.id, required this.name});

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      id: map['id'] is int
          ? map['id'] as int
          : int.tryParse(map['id'].toString()) ?? 0,
      name: map['name'] is String
          ? map['name'] as String
          : map['name'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
