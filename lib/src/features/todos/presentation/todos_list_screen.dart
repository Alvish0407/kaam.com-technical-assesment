import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/app_sizes.dart';
import '../../../utils/app_assets.dart';
import '../../../utils/app_theme.dart';
import '../../authentication/data/firebase_auth_repository.dart';
import 'add_todo_sheet.dart';

class TodosListScreen extends ConsumerWidget {
  const TodosListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
