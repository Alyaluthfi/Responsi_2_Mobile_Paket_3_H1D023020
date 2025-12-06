# H1D023020_responsi2_paket3

# Penjelasan Proyek Responsi 2 - Inventaris Buku 

Proyek ini adalah aplikasi Mobile Flutter untuk manajemen inventaris buku (Aluthmart) yang terhubung dengan Firebase.  
Fitur utama aplikasi ini meliputi autentikasi pengguna (Login & Register) dan CRUD (Create, Read, Update, Delete) data buku secara Real-time menggunakan Cloud Firestore.

---

## 👤 Identitas Pembuat

| Data | Keterangan |
|------|------------|
| Nama | Alya Luthfi Kharimah |
| NIM | H1D023020 |
| Shift Baru | F |
| Shift Asal | C |

---

## 🔄 Alur Kerja Aplikasi

Aplikasi ini bekerja terhubung langsung dengan Firebase dan memiliki tiga proses utama:

---

### 1. Menampilkan Data Real-time (Read)

Data buku tidak disimpan di perangkat, tetapi diambil langsung dari koleksi `books` dalam Cloud Firestore.  
Aplikasi menggunakan `StreamBuilder` untuk memantau perubahan data secara Real-time.

```dart
// Snippet dari lib/pages/home_page.dart

StreamBuilder(
  stream: _booksRef.snapshots(),
  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }

    return ListView(
      children: snapshot.data!.docs.map((doc) {
        return Card(child: ...);
      }).toList(),
    );
  },
);
```
### 2. Menambah & Mengubah Data (Create & Update)
Input data dilakukan melalui halaman `form_book_page.dart`.
Aplikasi menggunakan variabel  `_isEdit` untuk menentukan apakah pengguna sedang menambah atau mengedit data buku.

```dart
// Snippet dari lib/pages/form_book_page.dart

Future<void> _saveBook() async {
  final data = {
    'judul': _judulCtrl.text,
    'harga': int.parse(_hargaCtrl.text),
  };

  if (_isEdit) {
    await collection.doc(widget.bookData!['id']).update(data);
  } else {
    await collection.add(data);
  }
}
```

### 3. Autentikasi Pengguna (Login & Register)
Aplikasi menggunakan FirebaseAuth untuk:
- Membuat akun baru saat Register <br>
- Memverifikasi kredensial saat Login 
Setelah berhasil login, pengguna diarahkan ke halaman utama inventaris buku.

### Spesifikasi Database (Cloud Firestore)
Strutur koleksi `books` :
| Field | Tipe Data  | Keterangan |
|-----|------------|------------|
| judul | String | Judul buku |
| harga | Number | Harga buku |
| jumlah | Number | Stok buku |
| volume | Number | Volume buku |
| tanggal_masuk | String | Format YYYY-MM-DD |
| penulis | String | Nama penulis |
|penerbit | string | Nama Penerbit |

### 📱Demo Aplikasi 
![Demo Aplikasi Responsi 2 Paket 3](assets/DemoAplikasi.gif)

