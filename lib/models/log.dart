class Log {
  final int? id;
  final int? personId;
  final String? date;

  Log({this.id, required this.personId, required this.date});

  Map<String, dynamic> toMap() {
    return {'id': id, 'person_id': personId, 'date': date};
  }

  factory Log.fromMap(Map<String, dynamic> map) {
    return Log(
      id: map['id'],
      personId: map['person_id'],
      date: map['date'],
    );
  }

  @override
  String toString() {
    return 'Log(id: $id, person_id: $personId, address: $date)';
  }
}
