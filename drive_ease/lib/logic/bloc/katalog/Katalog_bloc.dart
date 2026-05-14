import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drive_ease/data/repositories/Katalog_repository.dart';
import 'package:drive_ease/logic/bloc/katalog/Katalog_event.dart';
import 'package:drive_ease/logic/bloc/katalog/Katalog_state.dart';

class KatalogBloc extends Bloc<KatalogEvent, KatalogState> {
  final KatalogRepository repository;

  KatalogBloc({required this.repository}) : super(KatalogInitial()) {
    String _cleanErrorMessage(Object error) {
      return error.toString().replaceAll('Exception: ', '');
    }

    on<FetchKatalog>((event, emit) async {
      emit(KatalogLoading());
      try{
        final list = await repository.getAllKatalog();
        emit(KatalogLoaded(list));
      } catch (e) {
        emit(KatalogError(e.toString()));
      }
    });

    on<FetchKatalogById>((event, emit) async {
      emit(KatalogLoading());
      try {
        final Katalog = await repository.getKatalogById(event.id);
        emit(KatalogDetailLoaded(Katalog));
      } catch (e) {
        emit(KatalogError(_cleanErrorMessage(e)));
      }
    });

    on<CreateKatalog>((event, emit) async {
      emit(KatalogLoading());
      try {
        await repository.createKatalog(event.data);
        emit(KatalogActionSuccess("Katalog berhasil ditambahkan"));
        add(FetchKatalog());
      } catch (e) {
        emit(KatalogError(_cleanErrorMessage(e)));
      }
    });

    on<UpdateKatalog>((event, emit) async {
      emit(KatalogLoading());
      try {
        await repository.updateKatalog(event.id, event.data);
        emit(KatalogActionSuccess("Katalog berhasil diperbarui"));
        add(FetchKatalog());
      } catch (e) {
        emit(KatalogError(_cleanErrorMessage(e)));
      }
    });

    on<DeleteKatalog>((event, emit) async {
      emit(KatalogLoading());
      try {
        await repository.deleteKatalog(event.id);
        emit(KatalogActionSuccess("Katalog berhasil dihapus"));
        add(FetchKatalog());
      } catch (e) {
        emit(KatalogError(_cleanErrorMessage(e)));
      }
    });

    on<SearchKatalog>((event, emit) async {
      emit(KatalogLoading());
      try {
        final results = await repository.searchKatalog(event.query);
        emit(KatalogSearchLoaded(results));
      } catch (e) {
        emit(KatalogError(_cleanErrorMessage(e)));
      }
    });
  }
}