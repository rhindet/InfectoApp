import 'package:flutter_bloc/flutter_bloc.dart';

// Evento
abstract class ChangePageEvent {}

class CambiarPagina extends ChangePageEvent {
  final int index;
  CambiarPagina(this.index);
}

// Bloc
// ChangePageBloc.dart
class ChangePageBloc extends Bloc<ChangePageEvent, int> {

  ChangePageBloc() : super(1) {
    on<CambiarPagina>((event, emit) {
      emit(event.index);
    });
  }


}
