import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_todo.freezed.dart';
part 'add_todo.g.dart';

@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.snake)
enum TodoStatus {
  @JsonValue('Pending')
  pending,
  @JsonValue('Completed')
  completed;

  String toJson() => _$TodoStatusEnumMap[this]!;
}

@freezed
class AddTodo with _$AddTodo {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory AddTodo({
    required String title,
    required TodoStatus status,
    required DateTime? dueDate,
    required String description,
    required DateTime createdOn,
  }) = _AddTodo;

  factory AddTodo.fromJson(Map<String, dynamic> json) => _$AddTodoFromJson(json);
}
