import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/app_sizes.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_theme.dart';
import '../../authentication/data/firebase_auth_repository.dart';
import '../domain/add_todo.dart';
import '../domain/todo.dart';
import 'add_todo_sheet.dart';
import 'todos_controller.dart';

class TodosListScreen extends ConsumerWidget {
  const TodosListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.read(firebaseAuthProvider).currentUser!.uid;
    final todosAsync = ref.watch(todosControllerProvider(uid: uid).future);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        leading: Padding(
          padding: const EdgeInsets.all(Sizes.p8),
          child: CircleAvatar(child: Image.asset(AppImages.memoji)),
        ),
        actions: [
          IconButton(
            color: context.colorScheme.error,
            icon: const Icon(Icons.logout_outlined),
            onPressed: () async {
              final firebaseAuth = ref.read(firebaseAuthProvider);
              await firebaseAuth.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Todo>>(
          stream: todosAsync.asStream(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final todos = snapshot.data!;

            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  title: Text(todo.title ?? '-'),
                  subtitle: Text(todo.description ?? '-'),
                  trailing: Checkbox(
                    value: todo.status == TodoStatus.completed,
                    onChanged: (value) {
                      // ref.read(todosControllerProvider(uid: uid)).updateTodo(
                      //   todo.copyWith(isDone: value!),
                      // );
                    },
                  ),
                );
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            useSafeArea: true,
            isScrollControlled: true,
            builder: (context) {
              return const AddTodoSheet();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
