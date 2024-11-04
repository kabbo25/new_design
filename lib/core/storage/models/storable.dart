abstract class Storable {
  String get id;
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Storable && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
