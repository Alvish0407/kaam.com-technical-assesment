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
import 'todos_controller.dart';

class AddTodoSheet extends StatefulHookConsumerWidget {
  const AddTodoSheet({super.key});

  @override
  ConsumerState<AddTodoSheet> createState() => _AddTodoSheetState();
}

class _AddTodoSheetState extends ConsumerState<AddTodoSheet> {
  final titleFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    titleFocusNode.requestFocus();
  }

  @override
  void dispose() {
    titleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final titleController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final dueDate = useState<DateTime?>(null);

    Future<void> onAddTodo() async {
      if (formKey.currentState!.validate()) {
        try {
          final todo = AddTodo(
            dueDate: dueDate.value,
            createdOn: DateTime.now(),
            status: TodoStatus.pending,
            title: titleController.text,
            description: descriptionController.text,
          );
          final uid = ref.read(firebaseAuthProvider).currentUser!.uid;
          await ref.read(todosControllerProvider(uid: uid).notifier).addTodo(todo);
          if (context.mounted) {
            context.pop();
            context.successSnackBar("Todo added");
          }
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
          minimum: const EdgeInsets.all(Sizes.p16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  cursorHeight: 20,
                  focusNode: titleFocusNode,
                  controller: titleController,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(fontSize: 20).semiBold,
                  decoration: InputDecoration(
                    filled: false,
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    hintText: 'e.g., Renew gym every May 1',
                    hintStyle: TextStyle(color: context.colorScheme.outline, fontSize: 20).semiBold,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required!';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  minLines: 2,
                  maxLines: 5,
                  cursorHeight: 14,
                  canRequestFocus: true,
                  controller: descriptionController,
                  style: const TextStyle(fontSize: 15).regular,
                  decoration: InputDecoration(
                    filled: false,
                    isDense: true,
                    hintText: 'Description',
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    focusedErrorBorder: InputBorder.none,
                    hintStyle: TextStyle(color: context.colorScheme.outline, fontSize: 15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'required!';
                    }
                    return null;
                  },
                ),
                gapH12,
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        initialDate: DateTime.now(),
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
                      side: BorderSide(color: context.colorScheme.secondary.withOpacity(.3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Sizes.p8),
                      ),
                    ),
                    icon: Icon(
                      CupertinoIcons.calendar_today,
                      size: 18,
                      color: context.colorScheme.secondary,
                    ),
                    label: Text(
                      dueDate.value == null ? 'Due date' : DateFormat.MMMd().format(dueDate.value!),
                      style: TextStyle(color: context.colorScheme.outline, fontSize: 13),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton.filled(
                    onPressed: onAddTodo,
                    icon: const Icon(CupertinoIcons.arrow_up, size: 20),
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
