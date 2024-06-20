import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../constants/app_sizes.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/exception_handling.dart';
import '../../authentication/data/firebase_auth_repository.dart';
import '../domain/add_todo.dart';
import '../domain/todo.dart';
import '../domain/update_todo.dart';
import 'todos_controller.dart';

class TodoDetailsUpdateSheet extends HookConsumerWidget {
  final Todo todo;
  const TodoDetailsUpdateSheet({super.key, required this.todo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.read(firebaseAuthProvider).currentUser!.uid;
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final status = useState<TodoStatus?>(todo.status);
    final titleController = useTextEditingController(text: todo.title);
    final descriptionController = useTextEditingController(text: todo.description);
    final dueDate = useState<DateTime?>(todo.dueDate);

    Future<void> onUpdateTodo() async {
      if (formKey.currentState!.validate()) {
        try {
          final updatedTodo = UpdateTodo(
            id: todo.id!,
          );
          await ref.read(todosControllerProvider(uid: uid).notifier).updateTodo(updatedTodo);
          if (context.mounted) context.pop();
        } catch (err) {
          if (context.mounted) context.errorSnackBar(err.getErrorMessage());
        }
      }
    }

    Future<void> onUpdateStatus(TodoStatus newStatus) async {
      if (formKey.currentState!.validate()) {
        final oldStatus = status.value;
        try {
          // Optimistically update the status
          status.value = newStatus;

          final updatedTodo = UpdateTodo(id: todo.id!, status: newStatus);

          await ref.read(todosControllerProvider(uid: uid).notifier).updateTodo(updatedTodo);
        } catch (err) {
          if (context.mounted) context.errorSnackBar(err.getErrorMessage());
          // Revert back to the old status
          status.value = oldStatus;
        }
      }
    }

    Future<void> onDeleteTodo() async {
      if (formKey.currentState!.validate()) {
        try {
          context.pop();
          await ref.read(todosControllerProvider(uid: uid).notifier).deleteTodo(todo.id!);
        } catch (err) {
          if (context.mounted) context.errorSnackBar(err.getErrorMessage());
        }
      }
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(vertical: Sizes.p8),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton.filledTonal(
                      onPressed: onDeleteTodo,
                      color: context.colorScheme.error,
                      constraints: const BoxConstraints.tightFor(width: 35, height: 35),
                      icon: const Icon(CupertinoIcons.delete, size: 20),
                    ),
                    IconButton.filledTonal(
                      onPressed: context.pop,
                      color: context.colorScheme.secondary,
                      constraints: const BoxConstraints.tightFor(width: 35, height: 35),
                      icon: const Icon(CupertinoIcons.xmark, size: 20),
                    ),
                    gapW8,
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    switch (status.value) {
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
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: Sizes.p8,
                          right: Sizes.p16,
                        ),
                        child: TextFormField(
                          maxLines: 3,
                          minLines: 1,
                          cursorHeight: 19,
                          controller: titleController,
                          textInputAction: TextInputAction.next,
                          enabled: status.value != TodoStatus.completed,
                          style: const TextStyle(fontSize: 19).semiBold,
                          decoration: InputDecoration(
                            filled: false,
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            hintText: 'e.g., Renew gym every May 1',
                            hintStyle: TextStyle(
                              fontSize: 19,
                              color: context.colorScheme.outline,
                            ).semiBold,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'required!';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: null,
                      icon: Icon(
                        CupertinoIcons.paragraph,
                        color: context.colorScheme.secondary,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: Sizes.p8,
                          right: Sizes.p16,
                        ),
                        child: TextFormField(
                          minLines: 2,
                          maxLines: 5,
                          cursorHeight: 14,
                          canRequestFocus: true,
                          controller: descriptionController,
                          enabled: status.value != TodoStatus.completed,
                          style: const TextStyle(fontSize: 15).regular,
                          decoration: InputDecoration(
                            filled: false,
                            isDense: true,
                            hintText: 'Description',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            disabledBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: context.colorScheme.outline,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'required!';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                gapH12,
                Divider(
                  indent: Sizes.p40,
                  color: context.colorScheme.secondary.withOpacity(.3),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: Sizes.p8),
                    child: OutlinedButton.icon(
                      onPressed: status.value == TodoStatus.completed
                          ? null
                          : () {
                              showDatePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                initialDate: dueDate.value,
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                              ).then((value) {
                                if (value != null) {
                                  dueDate.value = value;
                                }
                              });
                            },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.colorScheme.secondary,
                        padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Sizes.p8),
                        ),
                      ),
                      icon: Icon(
                        CupertinoIcons.calendar_today,
                        color: context.colorScheme.secondary,
                      ),
                      label: Text(
                        dueDate.value == null
                            ? 'Due date'
                            : DateFormat.MMMd().format(dueDate.value!),
                        style: TextStyle(color: context.colorScheme.outline, fontSize: 13),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: Sizes.p16),
                    child: IconButton.filled(
                      icon: const Icon(CupertinoIcons.arrow_up, size: 20),
                      onPressed: status.value == TodoStatus.completed ? null : onUpdateTodo,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
