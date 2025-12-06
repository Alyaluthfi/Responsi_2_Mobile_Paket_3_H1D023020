import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'form_book_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference _booksRef = FirebaseFirestore.instance.collection('books');

  Future<void> _deleteBook(String id) async {
    await _booksRef.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Menyesuaikan judul soal
        title: const Column(
          children: [
            Text("Iventaris Buku Aluthmart", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300)),
            Text("Paket 3 (H1D023020)", style: TextStyle(fontSize: 16)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: _booksRef.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Terjadi kesalahan'));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.library_books_outlined, size: 80, color: Colors.brown[200]),
                  const SizedBox(height: 10),
                  Text("Belum ada buku", style: TextStyle(color: Colors.brown[300])),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final book = doc.data() as Map<String, dynamic>;
              book['id'] = doc.id;

              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                elevation: 4,
                shadowColor: Colors.brown.withOpacity(0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      // ICON BUKU
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.brown.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.brown.shade100),
                        ),
                        child: Center(
                          child: Text(
                            (book['judul'] ?? 'X')[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 24, 
                              fontWeight: FontWeight.bold, 
                              color: Color(0xFF5D4037)
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      
                      // INFO BUKU
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book['judul'] ?? '',
                              style: const TextStyle(
                                fontSize: 16, 
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF5D4037),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text("Penulis: ${book['penulis']}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "Rp ${book['harga']}",
                                    style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "Stok: ${book['jumlah']}",
                                    style: TextStyle(color: Colors.orange.shade800, fontSize: 12),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      // TOMBOL AKSI
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => FormBookPage(bookData: book)),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.edit_note, color: Colors.blue),
                            ),
                          ),
                          InkWell(
                            onTap: () => _deleteBook(doc.id),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.delete_outline, color: Colors.red),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF5D4037),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Tambah Buku", style: TextStyle(color: Colors.white)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormBookPage()),
          );
        },
      ),
    );
  }
}