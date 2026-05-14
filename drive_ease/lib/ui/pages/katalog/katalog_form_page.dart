import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter/services.dart';

import '../../../logic/bloc/katalog/katalog_bloc.dart';
import '../../../logic/bloc/katalog/katalog_event.dart';
import '../../../logic/bloc/katalog/katalog_state.dart';
import '../../../logic/bloc/kategori/kategori_bloc.dart';
import '../../../logic/bloc/kategori/kategori_event.dart';
import '../../../logic/bloc/kategori/kategori_state.dart';
import '../../core/validators.dart';

class KatalogFormPage extends StatefulWidget {
  final int? katalogId;

  const KatalogFormPage({super.key, this.katalogId});

  @override
  State<KatalogFormPage> createState() => _KatalogFormPageState();
}

class _KatalogFormPageState extends State<KatalogFormPage> {
  final _formKey = GlobalKey<ShadFormState>();
  
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _hargaController = TextEditingController();
  final _nomorPolisiController = TextEditingController();
  
  String? _selectedKategori;
  String? _selectedKondisi;
  String? _selectedStatus;

  final _kondisiOptions = ['Baru', 'Bekas'];
  final _statusOptions = ['Tersedia', 'Disewa', 'Dalam Perawatan'];

  // Not strictly using a mask for Indo license plate since length varies, but converting to uppercase
  final _nopolFormatter = TextInputFormatter.withFunction((oldValue, newValue) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  });

  bool get isEditing => widget.katalogId != null;

  @override
  void initState() {
    super.initState();
    // Fetch categories for dropdown
    context.read<KategoriBloc>().add(FetchKategori());

    if (isEditing) {
      // If editing, state might already have the data, but let's fetch to be safe
      // Alternatively, we could pass the model. But fetching ensures fresh data.
      context.read<KatalogBloc>().add(FetchKatalogById(widget.katalogId!));
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _hargaController.dispose();
    _nomorPolisiController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.saveAndValidate()) {
      if (_selectedKategori == null || _selectedKondisi == null || _selectedStatus == null) {
        ShadToaster.of(context).show(
          const ShadToast.destructive(
            description: Text("Kategori, Kondisi, dan Status harus dipilih."),
          ),
        );
        return;
      }

      final data = {
        'nama': _namaController.text,
        'deskripsi': _deskripsiController.text,
        'kategori_id': int.parse(_selectedKategori!),
        'harga': _hargaController.text.replaceAll(RegExp(r'[^0-9]'), ''), // Clean formatting if any
        'kondisi': _selectedKondisi,
        'status': _selectedStatus,
        'nomor_polisi': _nomorPolisiController.text,
      };

      if (isEditing) {
        context.read<KatalogBloc>().add(UpdateKatalog(widget.katalogId!, data));
      } else {
        context.read<KatalogBloc>().add(CreateKatalog(data));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(isEditing ? 'Edit Katalog' : 'Tambah Katalog'),
      ),
      body: BlocListener<KatalogBloc, KatalogState>(
        listener: (context, state) {
          if (state is KatalogActionSuccess) {
            ShadToaster.of(context).show(
              ShadToast(description: Text(state.message)),
            );
            Navigator.pop(context);
          } else if (state is KatalogError) {
            ShadToaster.of(context).show(
              ShadToast.destructive(description: Text(state.message)),
            );
          } else if (state is KatalogDetailLoaded && isEditing) {
            // Populate form when data loaded
            if (_namaController.text.isEmpty) {
              final katalog = state.katalog;
              _namaController.text = katalog.nama;
              _deskripsiController.text = katalog.deskripsi;
              _hargaController.text = katalog.harga.toInt().toString(); // Will handle formatting later if needed
              _nomorPolisiController.text = katalog.nomor_polisi;
              
              setState(() {
                _selectedKategori = katalog.kategori_id.toString();
                _selectedKondisi = katalog.kondisi;
                _selectedStatus = katalog.status;
              });
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
                  label: const Text('Nama Kendaraan'),
                  placeholder: const Text('Masukkan nama kendaraan'),
                  controller: _namaController,
                  validator: (v) {
                    if (v.isEmpty) return 'Nama kendaraan tidak boleh kosong';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ShadInputFormField(
                  id: 'deskripsi',
                  label: const Text('Deskripsi'),
                  placeholder: const Text('Masukkan deskripsi kendaraan'),
                  controller: _deskripsiController,
                  maxLines: 3,
                  validator: (v) {
                    if (v.isEmpty) return 'Deskripsi tidak boleh kosong';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Kategori Dropdown
                BlocBuilder<KategoriBloc, KategoriState>(
                  builder: (context, state) {
                    if (state is KategoriLoaded) {
                      return ShadSelect<String>(
                        placeholder: const Text('Pilih Kategori'),
                        options: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(32, 6, 6, 6),
                            child: Text(
                              'Kategori',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ...state.kategoriList.map(
                            (k) => ShadOption(
                              value: k.kategori_id,
                              child: Text(k.nama),
                            ),
                          )
                        ],
                        selectedOptionBuilder: (context, value) {
                          final kat = state.kategoriList.firstWhere((e) => e.kategori_id == value);
                          return Text(kat.nama);
                        },
                        initialValue: _selectedKategori,
                        onChanged: (v) {
                          setState(() => _selectedKategori = v);
                        },
                      );
                    }
                    return ShadSelect<String>(
                      placeholder: const Text('Memuat Kategori...'),
                      options: const [],
                      selectedOptionBuilder: (context, value) => Text(value),
                    );
                  },
                ),
                const SizedBox(height: 16),

                ShadInputFormField(
                  id: 'harga',
                  label: const Text('Harga Sewa (Rp)'),
                  placeholder: const Text('Masukkan harga sewa'),
                  controller: _hargaController,
                  keyboardType: TextInputType.number,
                  validator: AppValidators.price,
                ),
                const SizedBox(height: 16),

                ShadInputFormField(
                  id: 'nomor_polisi',
                  label: const Text('Nomor Polisi'),
                  placeholder: const Text('B 1234 ABC'),
                  controller: _nomorPolisiController,
                  inputFormatters: [_nopolFormatter],
                  validator: AppValidators.licensePlate,
                ),
                const SizedBox(height: 16),

                // Kondisi Dropdown
                Text('Kondisi', style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 8),
                ShadSelect<String>(
                  placeholder: const Text('Pilih Kondisi'),
                  options: _kondisiOptions.map(
                    (k) => ShadOption(
                      value: k,
                      child: Text(k),
                    ),
                  ).toList(),
                  selectedOptionBuilder: (context, value) => Text(value),
                  initialValue: _selectedKondisi,
                  onChanged: (v) {
                    setState(() => _selectedKondisi = v);
                  },
                ),
                const SizedBox(height: 16),

                // Status Dropdown
                Text('Status', style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 8),
                ShadSelect<String>(
                  placeholder: const Text('Pilih Status'),
                  options: _statusOptions.map(
                    (s) => ShadOption(
                      value: s,
                      child: Text(s),
                    ),
                  ).toList(),
                  selectedOptionBuilder: (context, value) => Text(value),
                  initialValue: _selectedStatus,
                  onChanged: (v) {
                    setState(() => _selectedStatus = v);
                  },
                ),
                const SizedBox(height: 32),

                BlocBuilder<KatalogBloc, KatalogState>(
                  builder: (context, state) {
                    return ShadButton(
                      onPressed: state is KatalogLoading ? null : _submit,
                      child: state is KatalogLoading 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(isEditing ? 'Simpan Perubahan' : 'Simpan Katalog'),
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
