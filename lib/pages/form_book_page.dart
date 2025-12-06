import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FormBookPage extends StatefulWidget {
  final Map? bookData;
  const FormBookPage({super.key, this.bookData});

  @override
  State<FormBookPage> createState() => _FormBookPageState();
}

class _FormBookPageState extends State<FormBookPage> {
  final _judulCtrl = TextEditingController();
  final _hargaCtrl = TextEditingController();
  final _jumlahCtrl = TextEditingController();
  final _tglCtrl = TextEditingController();
  final _volCtrl = TextEditingController();
  final _penulisCtrl = TextEditingController();
  final _penerbitCtrl = TextEditingController();

  bool _isLoading = false;
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    if (widget.bookData != null) {
      _isEdit = true;
      _judulCtrl.text = widget.bookData!['judul'];
      _hargaCtrl.text = widget.bookData!['harga'].toString();
      _jumlahCtrl.text = widget.bookData!['jumlah'].toString();
      _tglCtrl.text = widget.bookData!['tanggal_masuk'];
      _volCtrl.text = widget.bookData!['volume'].toString();
      _penulisCtrl.text = widget.bookData!['penulis'];
      _penerbitCtrl.text = widget.bookData!['penerbit'];
    }
  }

  int _parseNumber(String text) {
    String cleanText = text.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(cleanText) ?? 0;
  }

  Future<void> _saveBook() async {
    if (_judulCtrl.text.isEmpty || _hargaCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Judul dan Harga wajib diisi")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final collection = FirebaseFirestore.instance.collection('books');
    final data = {
      'judul': _judulCtrl.text,
      'harga': _parseNumber(_hargaCtrl.text), 
      'jumlah': _parseNumber(_jumlahCtrl.text),
      'tanggal_masuk': _tglCtrl.text,
      'volume': _parseNumber(_volCtrl.text),
      'penulis': _penulisCtrl.text,
      'penerbit': _penerbitCtrl.text,
    };

    try {
      if (_isEdit) {
        await collection.doc(widget.bookData!['id']).update(data);
      } else {
        await collection.add(data);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data Berhasil Disimpan!")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal Simpan: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? "Edit Iventaris Buku Aluthmart" : "Tambah Iventaris Buku Baru Aluthmart"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Informasi Utama", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.brown)),
            const SizedBox(height: 10),
            _buildTextField(_judulCtrl, "Judul Buku", Icons.book),
            Row(
              children: [
                Expanded(child: _buildTextField(_hargaCtrl, "Harga", Icons.attach_money, isNumber: true)),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField(_jumlahCtrl, "Stok", Icons.inventory_2, isNumber: true)),
              ],
            ),
            
            const SizedBox(height: 20),
            const Text("Detail Buku", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.brown)),
            const SizedBox(height: 10),
            _buildTextField(_penulisCtrl, "Penulis", Icons.person_outline),
            _buildTextField(_penerbitCtrl, "Penerbit", Icons.business),
            Row(
              children: [
                Expanded(child: _buildTextField(_volCtrl, "Volume/Hal", Icons.menu_book, isNumber: true)),
                const SizedBox(width: 10),
                Expanded(child: _buildTextField(_tglCtrl, "Tgl Masuk", Icons.calendar_today)),
              ],
            ),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: _isLoading ? const SizedBox() : const Icon(Icons.save),
                onPressed: _isLoading ? null : _saveBook,
                label: _isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(_isEdit ? "UPDATE DATA" : "SIMPAN DATA SEKARANG"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, IconData icon, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextField(
        controller: ctrl,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.brown[300], size: 20),
        ),
      ),
    );
  }
}