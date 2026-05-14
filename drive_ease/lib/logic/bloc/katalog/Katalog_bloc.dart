import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drive_ease/data/repositories/katalog_repository.dart';
import 'package:drive_ease/data/models/katalog_model.dart';
import 'package:drive_ease/logic/bloc/katalog/katalog_event.dart';
import 'package:drive_ease/logic/bloc/katalog/katalog_state.dart';

class KatalogBloc extends Bloc<KatalogEvent, KatalogState> {
  final KatalogRepository repository;

  /// Cache data terakhir yang berhasil di-load.
  /// Disimpan di BLoC (bukan di widget State) agar tetap ada
  /// meskipun widget di-rebuild atau navigator stack berubah.
  List<KatalogModel> katalogList = [];

  KatalogBloc({required this.repository}) : super(KatalogInitial()) {
    String cleanErrorMessage(Object error) {
      return error.toString().replaceAll('Exception: ', '');
    }

    on<FetchKatalog>((event, emit) async {
      emit(KatalogLoading());
      try {
        final list = await repository.getAllKatalog();
        katalogList = list; // simpan ke cache BLoC
        emit(KatalogLoaded(list));
      } catch (e) {
        emit(KatalogError(cleanErrorMessage(e)));
      }
    });

    on<FetchKatalogById>((event, emit) async {
      emit(KatalogLoading());
      try {
        final katalog = await repository.getKatalogById(event.id);
        emit(KatalogDetailLoaded(katalog));
      } catch (e) {
        emit(KatalogError(cleanErrorMessage(e)));
      }
    });

    on<CreateKatalog>((event, emit) async {
      emit(KatalogLoading());
      try {
        await repository.createKatalog(event.data);
        emit(KatalogActionSuccess("Katalog berhasil ditambahkan"));
        add(FetchKatalog());
      } catch (e) {
        emit(KatalogError(cleanErrorMessage(e)));
      }
    });

    on<UpdateKatalog>((event, emit) async {
      emit(KatalogLoading());
      try {
        await repository.updateKatalog(event.id, event.data);
        // Tidak perlu add(FetchKatalog()) di sini.
        // List page akan refresh via .then() setelah Navigator.pop().
        emit(KatalogActionSuccess("Katalog berhasil diperbarui"));
      } catch (e) {
        emit(KatalogError(cleanErrorMessage(e)));
      }
    });

    on<DeleteKatalog>((event, emit) async {
      emit(KatalogLoading());
      try {
        await repository.deleteKatalog(event.id);
        // Tidak perlu add(FetchKatalog()) di sini.
        // List page akan refresh via .then() setelah Navigator.pop().
        emit(KatalogActionSuccess("Katalog berhasil dihapus"));
      } catch (e) {
        emit(KatalogError(cleanErrorMessage(e)));
      }
    });

    on<SearchKatalog>((event, emit) async {
      emit(KatalogLoading());
      try {
        final results = await repository.searchKatalog(event.query);
        katalogList = results; // simpan hasil search ke cache juga
        emit(KatalogSearchLoaded(results));
      } catch (e) {
        emit(KatalogError(cleanErrorMessage(e)));
      }
    });
  }
}