import 'package:flutter_riverpod/flutter_riverpod.dart';


final crimeCounterProvider = StateNotifierProvider((ref) => CrimeCounter());

class CrimeCounter extends StateNotifier<int> {
  CrimeCounter() : super(0);

  void increment() => state++;
}
