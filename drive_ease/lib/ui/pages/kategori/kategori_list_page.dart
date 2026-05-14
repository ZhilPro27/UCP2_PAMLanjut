import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../logic/bloc/kategori/kategori_bloc.dart';
import '../../../logic/bloc/kategori/kategori_event.dart';
import '../../../logic/bloc/kategori/kategori_state.dart';
import '../../widgets/loading_skeleton.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/confirm_dialog.dart';

class KategoriListPage extends StatefulWidget {
  const KategoriListPage({super.key});

  @override
  State<KategoriListPage> createState() => _KategoriListPageState();
}

class _KategoriListPageState extends State<KategoriListPage> {
  @override
  void initState() {
    super.initState();
    context.read<KategoriBloc>().add(FetchKategori());
  }

  void _showDeleteDialog(int id) {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Hapus Kategori',
        message: 'Apakah Anda yakin ingin menghapus kategori ini? Tindakan ini tidak dapat dibatalkan.',
        confirmText: 'Hapus',
        cancelText: 'Batal',
        isDestructive: true,
        onConfirm: () {
          context.read<KategoriBloc>().add(DeleteKategori(id));
          Navigator.pop(context); // Close dialog
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<KategoriBloc, KategoriState>(
      listener: (context, state) {
        if (state is KategoriActionSuccess) {
          ShadToaster.of(context).show(
            ShadToast(description: Text(state.message)),
          );
        } else if (state is KategoriError) {
          ShadToaster.of(context).show(
            ShadToast.destructive(description: Text(state.message)),
          );
        }
      },
      child: Stack(
        children: [
          BlocBuilder<KategoriBloc, KategoriState>(
            builder: (context, state) {
              if (state is KategoriLoading || state is KategoriInitial) {
                return const LoadingSkeleton();
              } else if (state is KategoriError) {
                return ErrorStateWidget(
                  message: state.message,
                  onRetry: () => context.read<KategoriBloc>().add(FetchKategori()),
                );
              } else if (state is KategoriLoaded) {
                final kategoriList = state.kategoriList;
                if (kategoriList.isEmpty) {
                  return const EmptyStateWidget(
                    title: 'Kategori Kosong',
                    message: 'Belum ada kategori yang ditambahkan.',
                    icon: Icons.category_outlined,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 80),
                  itemCount: kategoriList.length,
                  itemBuilder: (context, index) {
                    final kategori = kategoriList[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      color: Theme.of(context).colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: ShadTheme.of(context).colorScheme.border,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    kategori.nama,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Diperbarui: ${kategori.updated_at}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: ShadTheme.of(context).colorScheme.mutedForeground,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/kategori/form',
                                  arguments: {'id': int.tryParse(kategori.kategori_id) ?? 0},
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, size: 20, color: ShadTheme.of(context).colorScheme.destructive),
                              onPressed: () => _showDeleteDialog(int.tryParse(kategori.kategori_id) ?? 0),
                            ),
                          ],
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
                Navigator.pushNamed(context, '/kategori/form');
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: ShadTheme.of(context).colorScheme.primaryForeground,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
