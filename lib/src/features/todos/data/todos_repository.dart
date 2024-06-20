import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/add_todo.dart';

class TodosRepository {
  final FirebaseFirestore _firestore;
  const TodosRepository(this._firestore);

  static String todoPath(String uid, String todoId) => 'Users/$uid/todos/$todoId';
  static String todosPath(String uid) => 'Users/$uid/todos';

  // Create
  Future<void> addJob({
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

  // Stream<List<Job>> watchJobs({required UserID uid}) => queryJobs(uid: uid)
  //     .snapshots()
  //     .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
}
