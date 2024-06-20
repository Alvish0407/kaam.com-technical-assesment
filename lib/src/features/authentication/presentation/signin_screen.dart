import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../constants/app_sizes.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/exception_handling.dart';
import '../data/firebase_auth_repository.dart';

class SigninScreen extends HookConsumerWidget {
  const SigninScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final passwordVisible = useState(false);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    Future<void> onSignIn() async {
      if (formKey.currentState!.validate()) {
        final email = emailController.text;
        final password = passwordController.text;
        try {
          await ref
              .read(firebaseAuthProvider)
              .signInWithEmailAndPassword(email: email, password: password);
        } catch (e) {
          if (context.mounted) context.errorSnackBar(e.getErrorMessage());
        }
      }
    }

    return Scaffold(
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: Sizes.p16),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  gapH32,
                  Text(
                    "ToDone",
                    style: context.theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.primary,
                    ),
                  ),
                  Text(
                    "Organize your work and\nlife, finally.",
                    textAlign: TextAlign.center,
                    style: context.theme.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w600, height: 1.1),
                  ),
                  gapH64,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sign In",
                          style: context.theme.textTheme.titleLarge?.semiBold,
                        ),
                        Text(
                          "Add your email and password.",
                          style: context.theme.textTheme.titleSmall?.copyWith(
                            color: context.colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  gapH20,
                  TextFormField(
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(CupertinoIcons.mail),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'required';
                      } else if (!value.isValidEmail) {
                        return 'Please enter valid email';
                      }
                      return null;
                    },
                  ),
                  gapH16,
                  TextFormField(
                    controller: passwordController,
                    obscureText: !passwordVisible.value,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      errorMaxLines: 5,
                      labelText: "Password",
                      prefixIcon: const Icon(CupertinoIcons.lock),
                      suffixIcon: switch (passwordVisible.value) {
                        false => IconButton(
                            icon: const Icon(CupertinoIcons.eye_slash_fill),
                            onPressed: () => passwordVisible.value = true,
                          ),
                        _ => IconButton(
                            color: context.colorScheme.primary,
                            icon: const Icon(CupertinoIcons.eye_fill),
                            onPressed: () => passwordVisible.value = false,
                          ),
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'required';
                      } else if (!value.isPasswordStrong) {
                        return '1. At least 8 characters long.\n2. Contains both uppercase and lowercase letters.\n3. Includes at least one numeric digit.\n4. Has at least one special character (e.g., @, #, \$, etc.).';
                      }
                      return null;
                    },
                  ),
                  gapH40,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
                    child: ElevatedButton(
                      onPressed: onSignIn,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, Sizes.p48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Sizes.p16),
                        ),
                      ),
                      child: Text(
                        "Sign In",
                        style: context.theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  gapH12,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension ValidatorsX on String {
  bool get isValidEmail {
    const emailPattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    return RegExp(emailPattern).hasMatch(this);
  }

  // At least 8 characters long.
  // Contains both uppercase and lowercase letters.
  // Includes at least one numeric digit.
  // Has at least one special character (e.g., @, #, $, etc.).
  bool get isPasswordStrong {
    const passwordPattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    return RegExp(passwordPattern).hasMatch(this);
  }
}
