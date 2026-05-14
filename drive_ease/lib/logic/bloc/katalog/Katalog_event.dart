import 'package:equatable/equatable.dart';

abstract class KatalogEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchKatalog extends KatalogEvent {}
class FetchKatalogById extends KatalogEvent {
  final int id;
  FetchKatalogById(this.id);
  @override
  List<Object> get props => [id];
}
class CreateKatalog extends KatalogEvent {
  final Map<String, dynamic> data;
  CreateKatalog(this.data);
  @override
  List<Object> get props => [data];
}
class UpdateKatalog extends KatalogEvent {
  final int id;
  final Map<String, dynamic> data;
  UpdateKatalog(this.id, this.data);
  @override
  List<Object> get props => [id, data];
}
class DeleteKatalog extends KatalogEvent {
  final int id;
  DeleteKatalog(this.id);
  @override
  List<Object> get props => [id];
}
class SearchKatalog extends KatalogEvent {
  final String query;
  SearchKatalog(this.query);
  @override
  List<Object> get props => [query];
}