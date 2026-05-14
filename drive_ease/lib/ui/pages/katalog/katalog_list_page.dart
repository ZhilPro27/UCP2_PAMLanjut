import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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
  @override
  void initState() {
    super.initState();
    context.read<KatalogBloc>().add(FetchKatalog());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<KatalogBloc, KatalogState>(
          builder: (context, state) {
            if (state is KatalogLoading || state is KatalogInitial) {
              return const LoadingSkeleton();
            } else if (state is KatalogError) {
              return ErrorStateWidget(
                message: state.message,
                onRetry: () => context.read<KatalogBloc>().add(FetchKatalog()),
              );
            } else if (state is KatalogLoaded) {
              final katalogList = state.katalogList;
              if (katalogList.isEmpty) {
                return const EmptyStateWidget(
                  title: 'Katalog Kosong',
                  message: 'Belum ada katalog kendaraan yang ditambahkan.',
                  icon: Icons.directions_car_outlined,
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 16, bottom: 80),
                itemCount: katalogList.length,
                itemBuilder: (context, index) {
                  final katalog = katalogList[index];
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
                        ).then((_) => context.read<KatalogBloc>().add(FetchKatalog()));
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
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/katalog/form')
                  .then((_) => context.read<KatalogBloc>().add(FetchKatalog()));
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: ShadTheme.of(context).colorScheme.primaryForeground,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
