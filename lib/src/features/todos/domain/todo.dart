import 'package:freezed_annotation/freezed_annotation.dart';

import 'add_todo.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

@freezed
class Todo with _$Todo {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory Todo({
    String? id,
    String? title,
    DateTime? dueDate,
    TodoStatus? status,
    String? description,
    DateTime? createdOn,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
