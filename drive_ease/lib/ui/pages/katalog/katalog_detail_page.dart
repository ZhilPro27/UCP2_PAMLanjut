import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../logic/bloc/katalog/katalog_bloc.dart';
import '../../../logic/bloc/katalog/katalog_event.dart';
import '../../../logic/bloc/katalog/katalog_state.dart';
import '../../core/formatters.dart';
import '../../widgets/loading_skeleton.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/confirm_dialog.dart';

class KatalogDetailPage extends StatefulWidget {
  final int katalogId;

  const KatalogDetailPage({super.key, required this.katalogId});

  @override
  State<KatalogDetailPage> createState() => _KatalogDetailPageState();
}

class _KatalogDetailPageState extends State<KatalogDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<KatalogBloc>().add(FetchKatalogById(widget.katalogId));
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Hapus Katalog',
        message: 'Apakah Anda yakin ingin menghapus katalog ini? Tindakan ini tidak dapat dibatalkan.',
        confirmText: 'Hapus',
        cancelText: 'Batal',
        isDestructive: true,
        onConfirm: () {
          context.read<KatalogBloc>().add(DeleteKatalog(widget.katalogId));
          Navigator.pop(context); // Close dialog
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<KatalogBloc, KatalogState>(
      listener: (context, state) {
        if (state is KatalogActionSuccess) {
          ShadToaster.of(context).show(
            ShadToast(
              description: Text(state.message),
            ),
          );
          Navigator.pop(context); // Go back after success delete
        } else if (state is KatalogError && ModalRoute.of(context)?.isCurrent == true) {
          ShadToaster.of(context).show(
            ShadToast.destructive(
              description: Text(state.message),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Detail Katalog'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                final bloc = context.read<KatalogBloc>();
                Navigator.pushNamed(
                  context,
                  '/katalog/form',
                  arguments: {'id': widget.katalogId},
                ).then((_) {
                  // Refresh on return
                  bloc.add(FetchKatalogById(widget.katalogId));
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: ShadTheme.of(context).colorScheme.destructive),
              onPressed: _showDeleteDialog,
            ),
          ],
        ),
        body: BlocBuilder<KatalogBloc, KatalogState>(
          buildWhen: (previous, current) => current is KatalogDetailLoaded || current is KatalogLoading || current is KatalogError,
          builder: (context, state) {
            if (state is KatalogLoading || state is KatalogInitial) {
              return const LoadingSkeleton(count: 3, height: 120);
            } else if (state is KatalogError) {
              return ErrorStateWidget(
                message: state.message,
                onRetry: () => context.read<KatalogBloc>().add(FetchKatalogById(widget.katalogId)),
              );
            } else if (state is KatalogDetailLoaded) {
              final katalog = state.katalog;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            katalog.nama,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        StatusBadge(status: katalog.status),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppFormatters.formatCurrency(katalog.harga.toString()),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: ShadTheme.of(context).colorScheme.accent,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),
                    _buildInfoRow(context, 'Nomor Polisi', katalog.nomor_polisi),
                    _buildInfoRow(context, 'Kondisi', katalog.kondisi),
                    _buildInfoRow(context, 'Kategori ID', katalog.kategori_id.toString()), // Wait until we resolve kategori name
                    const SizedBox(height: 16),
                    Text(
                      'Deskripsi',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      katalog.deskripsi,
                      style: TextStyle(
                        color: ShadTheme.of(context).colorScheme.primaryForeground.withValues(alpha: 0.8),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                      if (katalog.updated_at != null)
                        Text(
                          'Terakhir diperbarui: ${AppFormatters.formatDateTime(DateTime.tryParse(katalog.updated_at!))}',
                          style: TextStyle(
                            fontSize: 12,
                            color: ShadTheme.of(context).colorScheme.mutedForeground,
                          ),
                        ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: ShadTheme.of(context).colorScheme.mutedForeground,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
