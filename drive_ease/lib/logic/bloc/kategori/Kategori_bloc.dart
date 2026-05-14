import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drive_ease/data/repositories/kategori_repository.dart';
import 'package:drive_ease/data/models/kategori_model.dart';
import 'package:drive_ease/logic/bloc/kategori/kategori_event.dart';
import 'package:drive_ease/logic/bloc/kategori/kategori_state.dart';

class KategoriBloc extends Bloc<KategoriEvent, KategoriState> {
  final KategoriRepository repository;

  /// Cache data terakhir yang berhasil di-load.
  /// Disimpan di BLoC (bukan di widget State) agar tetap ada
  /// meskipun widget di-rebuild atau navigator stack berubah.
  List<KategoriModel> kategoriList = [];

  KategoriBloc({required this.repository}) : super(KategoriInitial()) {
    String cleanErrorMessage(Object error) {
      return error.toString().replaceAll('Exception: ', '');
    }

    on<FetchKategori>((event, emit) async {
      emit(KategoriLoading());
      try {
        final list = await repository.getAllKategori();
        kategoriList = list; // simpan ke cache BLoC
        emit(KategoriLoaded(list));
      } catch (e) {
        emit(KategoriError(e.toString()));
      }
    });

    on<FetchKategoriById>((event, emit) async {
      emit(KategoriLoading());
      try {
        final kategori = await repository.getKategoriById(event.id);
        emit(KategoriDetailLoaded(kategori));
      } catch (e) {
        emit(KategoriError(cleanErrorMessage(e)));
      }
    });

    on<CreateKategori>((event, emit) async {
      emit(KategoriLoading());
      try {
        await repository.createKategori(event.data);
        emit(KategoriActionSuccess("Kategori berhasil ditambahkan"));
        add(FetchKategori());
      } catch (e) {
        emit(KategoriError(cleanErrorMessage(e)));
      }
    });

    on<UpdateKategori>((event, emit) async {
      emit(KategoriLoading());
      try {
        await repository.updateKategori(event.id, event.data);
        // Tidak perlu add(FetchKategori()) di sini.
        // List page akan refresh via .then() setelah Navigator.pop().
        emit(KategoriActionSuccess("Kategori berhasil diperbarui"));
      } catch (e) {
        emit(KategoriError(cleanErrorMessage(e)));
      }
    });

    on<DeleteKategori>((event, emit) async {
      emit(KategoriLoading());
      try {
        await repository.deleteKategori(event.id);
        // Tidak perlu add(FetchKategori()) di sini.
        // List page akan refresh via .then() setelah Navigator.pop().
        emit(KategoriActionSuccess("Kategori berhasil dihapus"));
      } catch (e) {
        emit(KategoriError(cleanErrorMessage(e)));
      }
    });
  }
}