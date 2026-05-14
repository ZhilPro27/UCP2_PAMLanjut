import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drive_ease/data/repositories/kategori_repository.dart';
import 'package:drive_ease/logic/bloc/kategori/kategori_event.dart';
import 'package:drive_ease/logic/bloc/kategori/kategori_state.dart';

class KategoriBloc extends Bloc<KategoriEvent, KategoriState> {
  final KategoriRepository repository;

  KategoriBloc({required this.repository}) : super(KategoriInitial()) {
    String cleanErrorMessage(Object error) {
      return error.toString().replaceAll('Exception: ', '');
    }

    on<FetchKategori>((event, emit) async {
      emit(KategoriLoading());
      try{
        final list = await repository.getAllKategori();
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
        emit(KategoriActionSuccess("Kategori berhasil diperbarui"));
        add(FetchKategori());
      } catch (e) {
        emit(KategoriError(cleanErrorMessage(e)));
      }
    });

    on<DeleteKategori>((event, emit) async {
      emit(KategoriLoading());
      try {
        await repository.deleteKategori(event.id);
        emit(KategoriActionSuccess("Kategori berhasil dihapus"));
        add(FetchKategori());
      } catch (e) {
        emit(KategoriError(cleanErrorMessage(e)));
      }
    });
  }
}