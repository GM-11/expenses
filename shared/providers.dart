import 'package:expenses/services/authentications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final groupNameProvider = StateProvider<String>((ref) {
  return "";
});

final authProvider = Provider<Authentications>((ref) {
  return Authentications();
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.read(authProvider).authStateChanges;
});
