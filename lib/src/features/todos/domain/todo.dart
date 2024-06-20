import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

@freezed
class Todo with _$Todo {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Todo({
    String? id,
    String? title,
    String? status,
    DateTime? dueDate,
    String? description,
    DateTime? createdOn,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
