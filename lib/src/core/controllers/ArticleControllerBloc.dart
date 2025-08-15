import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/ArticleModel.dart';

/// Eventos
abstract class ArticleEvent {}

class CambiarTitulo extends ArticleEvent {
  final String nuevoTitulo;
  CambiarTitulo(this.nuevoTitulo);
}

/// Controlador (BLoC)
class ArticleControllerBloc extends Bloc<ArticleEvent, ArticleModel> {
  ArticleControllerBloc() : super(ArticleModel(tema: "Sin tema")) {
    on<CambiarTitulo>((event, emit) {
      emit(state.copyWith(tema: event.nuevoTitulo));
    });
  }
}