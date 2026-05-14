import 'package:equatable/equatable.dart';
import 'package:drive_ease/data/models/Kategori_model.dart';

abstract class KategoriState extends Equatable {
  const KategoriState();

  @override
  List<Object> get props => [];
}
class KategoriInitial extends KategoriState{}
class KategoriLoading extends KategoriState{}
class KategoriLoaded extends KategoriState{
  final List<KategoriModel> kategoriList;
  KategoriLoaded(this.kategoriList);
  @override
  List<Object> get props => [kategoriList];
}
class KategoriDetailLoaded extends KategoriState {
  final KategoriModel kategori;
  KategoriDetailLoaded(this.kategori);
  @override
  List<Object> get props => [kategori];
}
class KategoriError extends KategoriState {
  final String message;
  KategoriError(this.message);
  @override
  List<Object> get props => [message];
}
class KategoriActionSuccess extends KategoriState {
  final String message;
  KategoriActionSuccess(this.message);
  @override
  List<Object> get props => [message];
}