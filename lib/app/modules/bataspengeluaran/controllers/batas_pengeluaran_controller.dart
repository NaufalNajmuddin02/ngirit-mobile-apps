import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class BatasPengeluaranController extends GetxController {
  var selectedDate = DateTime.now().obs;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  var totalSpending = 0.0.obs;
  var spendingLimitsByCategory = <String, double>{}.obs; // For per-category limits

  // Dapatkan user_id dari Firebase Authentication
  String? get userId => FirebaseAuth.instance.currentUser?.uid;

  // Fungsi untuk mendapatkan data batas pengeluaran berdasarkan user_id dari Firestore
  Stream<QuerySnapshot> getBatasPengeluaranStream() {
    return firestore
        .collection('batas_pengeluaran')
        .where('user_id', isEqualTo: userId) // Filter by user_id
        .snapshots();
  }

  // Function to set spending limit for a category
  void setSpendingLimit(double limit, String category) {
    if (userId != null) {
      spendingLimitsByCategory[category] = limit; // Update limit

      // Simpan ke Firestore berdasarkan user_id dan kategori
      firestore.collection('spending_limits').doc('${userId}_$category').set({
        'user_id': userId, // Simpan user_id
        'limit': limit,
        'category': category,
      }).then((_) {
        Get.snackbar('Berhasil', 'Batas pengeluaran berhasil diperbarui.');
      }).catchError((error) {
        Get.snackbar('Gagal', 'Terjadi kesalahan: $error');
      });
    } else {
      Get.snackbar('Gagal', 'Pengguna tidak terdaftar.');
    }
  }

  // Fungsi untuk menambahkan batas pengeluaran
  Future<void> addBatasPengeluaran(String kategori, double jumlah) async {
    try {
      await firestore.collection('batas_pengeluaran').add({
        'user_id': userId, // Simpan user_id
        'kategori': kategori,
        'jumlah': jumlah,
        'tanggal': DateTime.now(),
      });
      Get.snackbar('Berhasil', 'Batas pengeluaran berhasil ditambahkan.');
      _calculateTotalSpending(); // Update total spending setelah menambah data
    } catch (e) {
      Get.snackbar('Gagal', 'Terjadi kesalahan: $e');
    }
  }

  // Fungsi untuk menghitung total pengeluaran berdasarkan user_id
  void _calculateTotalSpending() {
    firestore
        .collection('batas_pengeluaran')
        .where('user_id', isEqualTo: userId) // Filter by user_id
        .get()
        .then((snapshot) {
      totalSpending.value = snapshot.docs.fold(
        0.0,
        (sum, doc) => sum + (doc['jumlah'] as double),
      );
    });
  }
}
