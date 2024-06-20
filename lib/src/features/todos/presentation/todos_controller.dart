import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../utils/exception_handling.dart';
import '../data/todos_repository.dart';
import '../domain/add_todo.dart';
import '../domain/todo.dart';

part 'todos_controller.g.dart';

@riverpod
class TodosController extends _$TodosController {
  @override
  Stream<List<Todo>> build({required String uid}) {
    return ref.watch(todosRepositoryProvider).watchTodos(uid: uid);
  }

  Future<bool> addTodo(AddTodo todo) async {
    try {
      await ref.read(todosRepositoryProvider).addTodo(uid: uid, todo: todo);
      return true;
    } catch (err) {
      err.getErrorMessage();
      return false;
    }
  }
}
