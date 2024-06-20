import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../utils/exception_handling.dart';
import '../data/todos_repository.dart';
import '../domain/add_todo.dart';
import '../domain/todo.dart';
import '../domain/update_todo.dart';

part 'todos_controller.g.dart';

@riverpod
class TodosController extends _$TodosController {
  @override
  Stream<List<Todo>> build({required String uid}) {
    return ref.watch(todosRepositoryProvider).watchTodos(uid: uid);
  }

  Future<bool> addTodo(AddTodo todo) async {
    try {
      await ref.read(todosRepositoryProvider).addTodo(
            uid: uid,
            todo: todo,
          );
      return true;
    } catch (err) {
      err.getErrorMessage();
      return false;
    }
  }

  Future<bool> updateTodo(UpdateTodo todo) async {
    try {
      await ref.read(todosRepositoryProvider).updateTodo(
            uid: uid,
            todo: todo,
          );
      return true;
    } catch (err) {
      err.getErrorMessage();
      return false;
    }
  }

  Future<bool> deleteTodo(String todoId) async {
    try {
      await ref.read(todosRepositoryProvider).deletTodo(
            uid: uid,
            todoId: todoId,
          );
      return true;
    } catch (err) {
      err.getErrorMessage();
      return false;
    }
  }
}

@riverpod
Future<Todo?> getTodo(GetTodoRef ref, {required String uid, required String todoId}) {
  return ref.read(todosRepositoryProvider).getTodo(
        uid: uid,
        todoId: todoId,
      );
}
