
part of 'printer.dart';

class Printer {
  String? id;

  int? languageLevel;

  String? name;

  String? type;
  Printer({this.id, this.languageLevel, this.name, this.type});

  static Printer? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = Printer(
      id: map['id'],
      languageLevel: map['languageLevel'],
      name: map['name'],
      type: map['type'],
    );
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "languageLevel": languageLevel,
      "name": name,
      "type": type,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'Printer{id: $id, languageLevel: $languageLevel, name: $name, type: $type}';
  }
}
