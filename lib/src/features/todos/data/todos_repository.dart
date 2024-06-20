import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/add_todo.dart';
import '../domain/todo.dart';
import '../domain/update_todo.dart';

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
    required UpdateTodo todo,
  }) =>
      _firestore.doc(todoPath(uid, todo.id)).update(todo.toJson());

  // Delete
  Future<void> deletTodo({required String uid, required String todoId}) async {
    final todoRef = _firestore.doc(todoPath(uid, todoId));
    await todoRef.delete();
  }

  // Read All
  Stream<List<Todo>> watchTodos({required String uid}) {
    return _firestore
        .collection(todosPath(uid))
        .orderBy('created_on', descending: true)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map((doc) {
          return Todo.fromJson({
            ...doc.data(),
            ...{'id': doc.id}
          });
        }).toList();
      },
    );
  }

  // Read One
  Future<Todo> getTodo({required String uid, required String todoId}) {
    return _firestore.doc(todoPath(uid, todoId)).get().then(
          (doc) => Todo.fromJson(doc.data()!),
        );
  }
}

@riverpod
TodosRepository todosRepository(TodosRepositoryRef ref) {
  return TodosRepository(FirebaseFirestore.instance);
}
