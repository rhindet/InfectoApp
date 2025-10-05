// lib/src/components/theme_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false); // false = claro, true = oscuro
  void toggle() => emit(!state);
}