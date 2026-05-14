import 'package:equatable/equatable.dart';
import 'package:drive_ease/data/models/Katalog_model.dart';

abstract class KatalogState extends Equatable {
  const KatalogState();

  @override
  List<Object> get props => [];
}
class KatalogInitial extends KatalogState{}
class KatalogLoading extends KatalogState{}
class KatalogLoaded extends KatalogState{
  final List<KatalogModel> katalogList;
  KatalogLoaded(this.katalogList);
  @override
  List<Object> get props => [katalogList];
}
class KatalogDetailLoaded extends KatalogState {
  final KatalogModel katalog;
  KatalogDetailLoaded(this.katalog);
  @override
  List<Object> get props => [katalog];
}
class KatalogError extends KatalogState {
  final String message;
  KatalogError(this.message);
  @override
  List<Object> get props => [message];
}
class KatalogActionSuccess extends KatalogState {
  final String message;
  KatalogActionSuccess(this.message);
  @override
  List<Object> get props => [message];
}
class KatalogSearchLoaded extends KatalogState {
  final List<KatalogModel> katalogList;
  KatalogSearchLoaded(this.katalogList);
  @override
  List<Object> get props => [katalogList];
}