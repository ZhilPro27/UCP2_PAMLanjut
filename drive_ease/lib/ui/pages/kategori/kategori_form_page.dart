import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter/services.dart';

import '../../../logic/bloc/kategori/kategori_bloc.dart';
import '../../../logic/bloc/kategori/kategori_event.dart';
import '../../../logic/bloc/kategori/kategori_state.dart';
import '../../core/validators.dart';

class KategoriFormPage extends StatefulWidget {
  final int? kategoriId;

  const KategoriFormPage({super.key, this.kategoriId});

  @override
  State<KategoriFormPage> createState() => _KategoriFormPageState();
}

class _KategoriFormPageState extends State<KategoriFormPage> {
  final _formKey = GlobalKey<ShadFormState>();
  final _namaController = TextEditingController();

  bool get isEditing => widget.kategoriId != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      context.read<KategoriBloc>().add(FetchKategoriById(widget.kategoriId!));
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.saveAndValidate()) {
      final data = {
        'nama': _namaController.text,
      };

      if (isEditing) {
        context.read<KategoriBloc>().add(UpdateKategori(widget.kategoriId!, data));
      } else {
        context.read<KategoriBloc>().add(CreateKategori(data));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(isEditing ? 'Edit Kategori' : 'Tambah Kategori'),
      ),
      body: BlocListener<KategoriBloc, KategoriState>(
        listener: (context, state) {
          if (state is KategoriActionSuccess) {
            ShadToaster.of(context).show(
              ShadToast(description: Text(state.message)),
            );
            Navigator.pop(context);
          } else if (state is KategoriError) {
            ShadToaster.of(context).show(
              ShadToast.destructive(description: Text(state.message)),
            );
          } else if (state is KategoriDetailLoaded && isEditing) {
            if (_namaController.text.isEmpty) {
              _namaController.text = state.kategori.nama;
            }
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ShadForm(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ShadInputFormField(
                  id: 'nama',
                  label: const Text('Nama Kategori'),
                  placeholder: const Text('Masukkan nama kategori'),
                  controller: _namaController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
                  ],
                  validator: (v) => AppValidators.nameWithoutSymbols(v, 'Nama Kategori'),
                ),
                const SizedBox(height: 32),
                BlocBuilder<KategoriBloc, KategoriState>(
                  builder: (context, state) {
                    return ShadButton(
                      onPressed: state is KategoriLoading ? null : _submit,
                      child: state is KategoriLoading 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(isEditing ? 'Simpan Perubahan' : 'Simpan Kategori'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
