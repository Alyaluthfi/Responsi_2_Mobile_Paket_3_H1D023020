import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ====================================================
  // BAGIAN INI WAJIB DIISI ULANG (KHUSUS CHROME)
  // ====================================================
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      // ⚠️ GANTI TULISAN INI DENGAN KODE DARI FIREBASE KAMU SEPERTI TADI ⚠️
      apiKey: "AIzaSyA2ixVCm5wGTe_cuAf7IdSiF1YgSkyvyb8", 
      authDomain: "responsi2-h1d023020.firebaseapp.com",
      projectId: "responsi2-h1d023020",
      storageBucket: "responsi2-h1d023020.firebasestorage.app",
      messagingSenderId: "230053950682",
      appId: "1:230053950682:web:0b0d344ed3e9cf45a0a1e3",
      measurementId: "G-LRL35ZNV7L"
    ),
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aluthmart',
      debugShowCheckedModeBanner: false,
      
      // ====================================================
      // INI TEMA COKLAT YANG SUDAH DIPERCANTIK
      // ====================================================
      theme: ThemeData(
        // Palet Warna
        primaryColor: const Color(0xFF5D4037), 
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF5D4037),
          secondary: const Color(0xFF8D6E63),
        ),
        
        // AppBar Cantik
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF5D4037),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 20,
            fontFamily: 'Sans-Serif',
          ),
        ),

        // Input Text Rounded & Filled
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.brown.shade100),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF5D4037), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),

        // Tombol Besar & Rounded
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5D4037),
            foregroundColor: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}