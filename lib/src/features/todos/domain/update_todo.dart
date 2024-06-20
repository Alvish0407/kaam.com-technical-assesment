import 'package:freezed_annotation/freezed_annotation.dart';

import 'add_todo.dart';

part 'update_todo.freezed.dart';
part 'update_todo.g.dart';

@freezed
class UpdateTodo with _$UpdateTodo {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
    explicitToJson: true,
    includeIfNull: false,
  )
  const factory UpdateTodo({
    required String id,
    String? title,
    TodoStatus? status,
    DateTime? dueDate,
    String? description,
  }) = _UpdateTodo;

  factory UpdateTodo.fromJson(Map<String, dynamic> json) => _$UpdateTodoFromJson(json);
}
