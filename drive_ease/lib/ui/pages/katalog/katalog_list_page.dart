import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'dart:async';

import '../../../logic/bloc/katalog/katalog_bloc.dart';
import '../../../logic/bloc/katalog/katalog_event.dart';
import '../../../logic/bloc/katalog/katalog_state.dart';
import '../../core/formatters.dart';
import '../../widgets/loading_skeleton.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/status_badge.dart';

class KatalogListPage extends StatefulWidget {
  const KatalogListPage({super.key});

  @override
  State<KatalogListPage> createState() => _KatalogListPageState();
}

class _KatalogListPageState extends State<KatalogListPage> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<KatalogBloc>().add(FetchKatalog());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ShadInput(
            placeholder: const Text('Cari kendaraan...'),
            controller: _searchController,
            onChanged: (value) {
              if (_debounce?.isActive ?? false) _debounce!.cancel();
              _debounce = Timer(const Duration(milliseconds: 400), () {
                if (value.isEmpty) {
                  context.read<KatalogBloc>().add(FetchKatalog());
                } else {
                  context.read<KatalogBloc>().add(SearchKatalog(value));
                }
              });
            },
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              BlocBuilder<KatalogBloc, KatalogState>(
                // Rebuild hanya saat state membawa data baru atau error.
                // Saat Loading/ActionSuccess, gunakan cache di BLoC.
                buildWhen: (previous, current) {
                  return current is KatalogLoaded ||
                      current is KatalogSearchLoaded ||
                      current is KatalogError ||
                      current is KatalogInitial ||
                      // Rebuild saat Loading hanya jika cache masih kosong (first load)
                      (current is KatalogLoading &&
                          context.read<KatalogBloc>().katalogList.isEmpty);
                },
                builder: (context, state) {
                  // Ambil data dari cache BLoC — selalu ada meskipun state sedang Loading
                  final cachedList = context.read<KatalogBloc>().katalogList;

                  if (state is KatalogError && cachedList.isEmpty) {
                    return ErrorStateWidget(
                      message: state.message,
                      onRetry: () => _searchController.text.isEmpty
                          ? context.read<KatalogBloc>().add(FetchKatalog())
                          : context.read<KatalogBloc>().add(SearchKatalog(_searchController.text)),
                    );
                  }

                  // Tampilkan skeleton hanya saat benar-benar belum ada data
                  if ((state is KatalogLoading || state is KatalogInitial) &&
                      cachedList.isEmpty) {
                    return const LoadingSkeleton();
                  }

                  if (cachedList.isEmpty) {
                    return const EmptyStateWidget(
                      title: 'Katalog Kosong',
                      message: 'Belum ada katalog kendaraan yang ditemukan.',
                      icon: Icons.directions_car_outlined,
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 0, bottom: 80),
                    itemCount: cachedList.length,
                    itemBuilder: (context, index) {
                      final katalog = cachedList[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        color: Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: ShadTheme.of(context).colorScheme.border,
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/katalog/detail',
                              arguments: {'id': katalog.katalog_id},
                            ).then((_) {
                              if (!mounted) return;
                              if (_searchController.text.isEmpty) {
                                context.read<KatalogBloc>().add(FetchKatalog());
                              } else {
                                context.read<KatalogBloc>().add(SearchKatalog(_searchController.text));
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        katalog.nama,
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    StatusBadge(status: katalog.status),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  AppFormatters.formatCurrency(katalog.harga.toString()),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: ShadTheme.of(context).colorScheme.accent,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: ShadTheme.of(context).colorScheme.muted,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        katalog.nomor_polisi,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: ShadTheme.of(context).colorScheme.mutedForeground,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: ShadTheme.of(context).colorScheme.muted,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        katalog.kondisi,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: ShadTheme.of(context).colorScheme.mutedForeground,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (katalog.updated_at.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Text(
                                    'Diperbarui: ${AppFormatters.formatDateTime(DateTime.tryParse(katalog.updated_at))}',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: ShadTheme.of(context).colorScheme.mutedForeground,
                                        ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/katalog/form')
                        .then((_) {
                          if (!mounted) return;
                          if (_searchController.text.isEmpty) {
                            context.read<KatalogBloc>().add(FetchKatalog());
                          } else {
                            context.read<KatalogBloc>().add(SearchKatalog(_searchController.text));
                          }
                        });
                  },
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: ShadTheme.of(context).colorScheme.primaryForeground,
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
