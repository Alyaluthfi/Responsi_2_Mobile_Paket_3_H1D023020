# h1d023020_responsi2_paket3

# Analisis Proyek Responsi 2 - Inventaris Buku Firebase

Proyek ini adalah aplikasi Mobile untuk manajemen inventaris buku (Aluthmart) yang dibangun menggunakan Flutter dan terintegrasi dengan Firebase. Aplikasi ini mendemonstrasikan implementasi Autentikasi dan alur manipulasi data (CRUD) yang tersinkronisasi secara Real-time.

---

## 👤 Identitas Pembuat

| Data | Keterangan |
|------|-----------|
| Nama | Alya Luthfi Kharimah |
| NIM | H1D023020 |
| Shift Baru | F |
| Shift Asal | C |

---

##  📱Demo Aplikasi 

Berikut adalah link video demo penggunaan aplikasi:

![Demo Aplikasi Responsi 2 Paket #](assets/Demo_Aplikasi.gif)

---

## 🧠 Analisis Kode & Logika Program

Berikut analisis teknis mendalam untuk setiap modul aplikasi:

---

## 1. Entry Point & Konfigurasi (lib/main.dart)

### Komponen Kode  
**ensureInitialized()**  
• *Flutter Engine Binding*  
• Dipanggil sebelum `runApp()` karena Firebase perlu diinisialisasi melalui native channel.

**Firebase.initializeApp**  
• *Async Initialization*  
• Menghubungkan aplikasi dengan Firebase sebelum UI dirender.  
• `await` mencegah race condition ketika database belum siap.

**ThemeData**  
• *Global Styling*  
• Menggunakan satu sumber tema global untuk warna dan style input (DRY Principle).

---

## 2. Halaman Login (lib/pages/login_page.dart)

### Komponen Kode  
**signInWithEmailAndPassword**  
• *Token-Based Auth*  
• Mengirim email & password ke server Firebase dan menerima Auth Token.

**pushReplacement**  
• *Stack Management*  
• Menghapus halaman login dari stack agar user tidak bisa kembali ke sana setelah login.

**try-catch**  
• *Exception Handling*  
• Menangkap error Firebase seperti *wrong-password*, *user-not-found*, lalu menampilkan SnackBar ramah pengguna.

---

## 3. Halaman Registrasi (lib/pages/register_page.dart)

### Komponen Kode  
**_isLoading**  
• Menghindari race condition (double-click) saat tombol ditekan berulang.  
• Sementara loading, tombol berubah menjadi spinner.

**createUser...**  
• *Server-Side Creation*  
• Membuat akun baru di Firebase Authentication.

**Navigator.pop**  
• Mengembalikan user ke halaman Login setelah registrasi sukses.

---

## 4. Halaman Utama / Dashboard (lib/pages/home_page.dart)

### Komponen Kode  
**StreamBuilder**  
• *Reactive Programming*  
• Terhubung ke Firestore Real-time Stream → UI auto update tanpa refresh.  
• Berbeda dengan `FutureBuilder` yang hanya sekali ambil data.

**ListView.builder**  
• *Memory Optimization*  
• Menggunakan lazy loading & recycling widget agar tetap ringan meskipun ribuan data.

**_deleteBook**  
• Menghapus dokumen berdasarkan ID:  
`doc(id).delete()`  
• Karena StreamBuilder aktif, UI langsung update setelah data terhapus.

---

## 5. Halaman Form Buku (lib/pages/form_book_page.dart)

Halaman ini bersifat *polimorfik*, digunakan untuk **Tambah** dan **Edit** sekaligus.

### Komponen Kode  
**initState**  
• *Lifecycle Hook*  
• Pre-fill form ketika mode Edit (`widget.bookData != null`).

**_parseNumber**  
• *Data Sanitization*  
• Membersihkan input angka yang mengandung titik, koma, atau simbol (Regex `[^0-9]`).

**_isEdit logic**  
• Menentukan apakah memanggil  
`collection.add()` atau `collection.doc(id).update()`  
• Mengurangi duplikasi logic hingga 50%.

---

## 📡 Spesifikasi Data (Firestore NoSQL)

Aplikasi menggunakan model NoSQL (Dokumen) untuk koleksi `books`.

| Field | Tipe Data | Fungsi |
|-------|-----------|--------|
| judul | String | Nama buku |
| harga | Number (Int) | Harga (integer murni) |
| jumlah | Number (Int) | Stok buku |
| volume | Number (Int) | Volume/tebal buku |
| tanggal_masuk | String | Tanggal pencatatan (YYYY-MM-DD) |
| penulis | String | Nama penulis |
| penerbit | String | Nama penerbit |

---

