import 'package:crime_map/services/service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = Provider((ref) => AuthService());

final userAuthProvider = StreamProvider((ref) {
  final user = ref.read(userProvider);

  return user.user;
});

final crimeCounterProvider = StateNotifierProvider((ref) => CrimeCounter());

class CrimeCounter extends StateNotifier<int> {
  CrimeCounter() : super(0);

  void increment() => state++;
}
