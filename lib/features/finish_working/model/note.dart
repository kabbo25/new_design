import 'package:new_design/core/storage/models/storable.dart';
import 'package:uuid/uuid.dart';

class Note implements Storable {
  @override
  final String id;
  final String content;
  final String createdAt;

  Note({
    String? id,
    required this.content,
    String? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now().toIso8601String();

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      content: json['content'] as String,
      createdAt: json['createdAt'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'createdAt': createdAt,
    };
  }

  Note copyWith({
    String? id,
    String? content,
    String? createdAt,
  }) {
    return Note(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
