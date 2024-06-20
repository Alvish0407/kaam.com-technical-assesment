import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_todo.freezed.dart';
part 'add_todo.g.dart';

@freezed
class AddTodo with _$AddTodo {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory AddTodo({
    required String title,
    required String status,
    required DateTime dueDate,
    required String description,
    required DateTime createdOn,
  }) = _AddTodo;

  factory AddTodo.fromJson(Map<String, dynamic> json) => _$AddTodoFromJson(json);
}
