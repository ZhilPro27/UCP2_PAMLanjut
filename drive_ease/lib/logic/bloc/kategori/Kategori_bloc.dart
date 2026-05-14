import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drive_ease/data/repositories/Kategori_repository.dart';
import 'package:drive_ease/logic/bloc/kategori/Kategori_event.dart';
import 'package:drive_ease/logic/bloc/kategori/Kategori_state.dart';

class KategoriBloc extends Bloc<KategoriEvent, KategoriState> {
  final KategoriRepository repository;

  KategoriBloc({required this.repository}) : super(KategoriInitial()) {
    on<FetchKategori>((event, emit) async {
      emit(KategoriLoading());
      try{
        final list = await repository.getAllKategori();
        emit(KategoriLoaded(list));
      } catch (e) {
        emit(KategoriError(e.toString()));
      }
    });

    on<CreateKategori>((event, emit) async {
      emit(KategoriLoading());
      try {
        await repository.createKategori(event.data);
        emit(KategoriCreatedSuccess());
        add(FetchKategori());
      } catch (e) {
        emit(KategoriError(e.toString()));
      }
    });

    on<UpdateKategori>((event, emit) async {
      emit(KategoriLoading());
      try {
        await repository.updateKategori(event.id, event.data);
        emit(KategoriCreatedSuccess());
        add(FetchKategori());
      } catch (e) {
        emit(KategoriError(e.toString()));
      }
    });

    on<DeleteKategori>((event, emit) async {
      emit(KategoriLoading());
      try {
        await repository.deleteKategori(event.id);
        emit(KategoriCreatedSuccess());
        add(FetchKategori());
      } catch (e) {
        emit(KategoriError(e.toString()));
      }
    });
  }
}