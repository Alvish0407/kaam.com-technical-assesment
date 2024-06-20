import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../constants/app_sizes.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/exception_handling.dart';
import '../../authentication/data/firebase_auth_repository.dart';
import '../domain/add_todo.dart';
import '../domain/todo.dart';
import '../domain/update_todo.dart';
import 'add_todo_sheet.dart';
import 'todo_details_update_sheet.dart';
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
          Padding(
            padding: const EdgeInsets.only(right: Sizes.p8),
            child: IconButton.filledTonal(
              color: context.colorScheme.error,
              icon: const Icon(Icons.logout_outlined),
              onPressed: () async {
                final firebaseAuth = ref.read(firebaseAuthProvider);
                await firebaseAuth.signOut();
              },
            ),
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

          return todos.isEmpty
              ? Image.asset(
                  AppImages.illustrator,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : ListView.separated(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    return TodoTile(todos[index]).animate().fade(
                          duration: 250.ms,
                          delay: 50.ms * index,
                        );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      indent: Sizes.p48,
                      color: context.colorScheme.onSurface.withOpacity(0.2),
                    );
                  },
                );
        },
      ),
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

class TodoTile extends ConsumerWidget {
  final Todo todo;
  const TodoTile(this.todo, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCompleted = todo.status == TodoStatus.completed;

    Future<void> onUpdateStatus(TodoStatus newStatus) async {
      try {
        final updatedTodo = UpdateTodo(id: todo.id!, status: newStatus);

        final uid = ref.read(firebaseAuthProvider).currentUser!.uid;
        await ref.read(todosControllerProvider(uid: uid).notifier).updateTodo(updatedTodo);
      } catch (err) {
        if (context.mounted) context.errorSnackBar(err.getErrorMessage());
      }
    }

    Color getCompletedColor(Color color) {
      return isCompleted ? context.colorScheme.outline.withOpacity(0.5) : color;
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        showModalBottomSheet(
          context: context,
          useSafeArea: true,
          isScrollControlled: true,
          builder: (context) {
            return TodoDetailsUpdateSheet(todo: todo);
          },
        );
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              switch (todo.status) {
                TodoStatus.completed => IconButton(
                    onPressed: () {
                      onUpdateStatus(TodoStatus.pending);
                    },
                    color: context.colorScheme.primary,
                    icon: const Icon(
                      CupertinoIcons.check_mark_circled_solid,
                    ),
                  ),
                TodoStatus.pending || _ => IconButton(
                    onPressed: () {
                      onUpdateStatus(TodoStatus.completed);
                    },
                    icon: Icon(
                      CupertinoIcons.circle,
                      color: context.colorScheme.secondary,
                    ),
                  ),
              },
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todo.title ?? '-',
                      style: context.theme.textTheme.titleMedium?.copyWith(
                        decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                      ),
                    ),
                    Text(
                      todo.description ?? '-',
                      style: context.theme.textTheme.titleSmall?.copyWith(
                        color: getCompletedColor(context.colorScheme.onSurface.withOpacity(0.5)),
                      ),
                    ),
                    gapH4,
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.calendar_today,
                              size: 16,
                              color: getCompletedColor(context.colorScheme.primary),
                            ),
                            gapW4,
                            Text(
                              DateFormat.MMMd().format(todo.createdOn!),
                              style: TextStyle(
                                fontSize: 12,
                                color: getCompletedColor(context.colorScheme.primary),
                              ),
                            ),
                          ],
                        ),
                        gapW12,
                        if (todo.dueDate != null)
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.calendar_today,
                                size: 16,
                                color: getCompletedColor(context.colorScheme.error),
                              ),
                              gapW4,
                              Text(
                                "Due on ${DateFormat.MMMd().format(todo.dueDate!)}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: getCompletedColor(context.colorScheme.error),
                                ),
                              ),
                            ],
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
