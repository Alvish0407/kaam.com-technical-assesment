### A Todo app _(ToDone)_ built with Flutter & Firebase within 8 Hours

https://github.com/Alvish0407/kaam-hiring-test/assets/80829856/6e3f2c8a-1775-4069-8e25-c1ca2cac9263

<details>
<summary>Assignment: To-Do List App</summary>
  
**Objective:** Build a simple yet functional To-Do List application using Flutter.

**Task:** Develop a To-Do List application with the following features:

**User Authentication:**
1. Implement user login and registration using Firebase Authentication.
2. Use email and password as the login method.
3. Include basic form validation (e.g., email format, password strength).

**To-Do List:**
1. Allow authenticated users to create, read, update, and delete to-do items.
2. Each to-do item should have a title, description, due date, and completion status.
3. Store to-do items in Firebase Firestore, associating them with the logged-in user.

**State Management:**
1. Use a state management solution such as Provider, Riverpod, or Bloc.
2. Justify your choice in the README file.

**UI/UX:**
1. Design a clean, user-friendly interface.
2. Ensure the app is responsive and works on both Android and iOS devices.
3. Include basic animations for transitions and status changes.

**Technical Requirements:**
1. Use the latest version of Flutter and Dart.
2. Implement asynchronous programming and error handling.
3. Follow best practices for clean and maintainable code.

### Deliverables
**Flutter Project:**
1. Host the project in a public Git repository (e.g., GitHub, GitLab).
2. Include a README file with setup instructions, state management justification, and any additional notes or assumptions.

**Video Demonstration:**
1. Record a short video (2-3 minutes) demonstrating the functionality of the app.
2. Showcase the user authentication flow, to-do list management, and any animations.

</details>

## Prerequisite
1. Download [fvm](https://fvm.app/) and follow the [instructions](https://fvm.app/documentation/guides/basic-commands#examples-1)
2. [Setup](https://github.com/Alvish0407/kaam-hiring-test/blob/main/README.md#running-the-project-with-firebase) Firebase Project

## Features

- [x] Implement user login and registration using Firebase Authentication (Email and Password).
- [x] Include basic form validation (e.g., email format, password strength)
- [x] Allow authenticated users to create, read, update, and delete to-do items.
- [x] Each to-do item has a title, description, due date, and completion status which are stored in Firebase Firestore.
- [x] Basic animations for transitions and status changes.
- [x] Responsive UI and Clean Code using Feature-First architecture.
- [x] Clean, user-friendly interface.

## Packages in use

These are the main packages used in the app:

- [Flutter Riverpod](https://pub.dev/packages/flutter_riverpod) for data caching, dependency injection, and more
- [Riverpod Generator](https://pub.dev/packages/riverpod_generator) and [Riverpod Lint](https://pub.dev/packages/riverpod_lint) for the latest Riverpod APIs
- [GoRouter](https://pub.dev/packages/go_router) for navigation
- [Firebase Auth](https://pub.dev/packages/firebase_auth) for authentication
- [Cloud Firestore](https://pub.dev/packages/cloud_firestore) as a realtime database
- [Intl](https://pub.dev/packages/intl) for date formatting
- [Flutter Animate](https://pub.dev/packages/flutter_animate) for performing animations reducing boilerplate code
- [Build Runner](https://pub.dev/packages/build_runner) is concrete way of generating files using Dart code

See the [pubspec.yaml](pubspec.yaml) file for the complete list.

## Why Riverpod ?
Riverpod is a reactive caching framework for Flutter/Dart.

Using declarative and reactive programming, Riverpod takes care of a large part of your application's logic for you. It can perform network-requests with built-in error handling and caching, while automatically re-fetching data when necessary.

## Running the project with Firebase

To use this project with Firebase, follow these steps:

- Create a new project with the Firebase console
- Enable Firebase Authentication, along with the Email/Password Authentication Sign-in provider in the Firebase Console (Authentication > Sign-in method > Email/Password > Edit > Enable > Save)
- Enable Cloud Firestore

### Using the CLI

Make sure you have the Firebase CLI and [FlutterFire CLI](https://pub.dev/packages/flutterfire_cli) installed.

Then run this on the terminal from the root of this project:

- Run `firebase login` so you have access to the Firebase project you have created
- Run `flutterfire configure` and follow all the steps

That's it. Have fun!
