import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/add_todo.dart';
import '../domain/todo.dart';

part 'todos_repository.g.dart';

class TodosRepository {
  final FirebaseFirestore _firestore;
  const TodosRepository(this._firestore);

  static String todoPath(String uid, String todoId) => 'Users/$uid/todos/$todoId';
  static String todosPath(String uid) => 'Users/$uid/todos';

  // Create
  Future<void> addTodo({
    required String uid,
    required AddTodo todo,
  }) =>
      _firestore.collection(todosPath(uid)).add(todo.toJson());

  // Update
  Future<void> updateTodo({
    required String uid,
    required AddTodo todo,
    required String todoId,
  }) =>
      _firestore.doc(todoPath(uid, todoId)).update(todo.toJson());

  // Delete
  Future<void> deletTodo({required String uid, required String todoId}) async {
    final todoRef = _firestore.doc(todoPath(uid, todoId));
    await todoRef.delete();
  }

  // Read
  Stream<List<Todo>> watchTodos({required String uid}) => queryTodos(uid: uid)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  Query<Todo> queryTodos({required String uid}) =>
      _firestore.collection(todosPath(uid)).withConverter(
            fromFirestore: (snapshot, _) =>
                Todo.fromJson(snapshot.data()!.putIfAbsent('id', () => snapshot.id)),
            toFirestore: (todo, _) => todo.toJson(),
          );
}

@riverpod
TodosRepository todosRepository(TodosRepositoryRef ref) {
  return TodosRepository(FirebaseFirestore.instance);
}
