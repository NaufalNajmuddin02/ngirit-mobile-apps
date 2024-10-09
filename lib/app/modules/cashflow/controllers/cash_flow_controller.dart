import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CashFlowController extends GetxController {
  var expenses = <Map<String, dynamic>>[].obs;
  var income = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchExpenses();
    fetchIncome();
  }

  // Function to fetch expenses from Firestore
  Future<void> fetchExpenses() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('pengeluaran')
            .where('user_id', isEqualTo: user.uid)
            .get();

        expenses.assignAll(
          querySnapshot.docs
              .map((doc) => {
                    'nominal': doc['nominal'],
                    'deskripsi': doc['deskripsi'],
                    'kategori': doc['kategori'],
                    'akun': doc['akun'],
                    'tanggal': doc['tanggal'],
                  })
              .toList(),
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch expenses');
    }
  }

  // Function to fetch income from Firestore
  Future<void> fetchIncome() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('pendapatan')
            .where('user_id', isEqualTo: user.uid)
            .get();

        income.assignAll(
          querySnapshot.docs
              .map((doc) => {
                    'nominal': doc['nominal'],
                    'deskripsi': doc['deskripsi'],
                    'kategori': doc['kategori'],
                    'akun': doc['akun'],
                    'tanggal': doc['tanggal'],
                  })
              .toList(),
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch income');
    }
  }

  // Getter to calculate total expenses
  double get totalExpenses => expenses.fold(0, (sum, item) {
        double nominal = item['nominal'] is String
            ? double.parse(item['nominal'])
            : item['nominal'].toDouble();
        return sum + nominal;
      });

// Getter to calculate total income
  double get totalIncome => income.fold(0, (sum, item) {
        double nominal = item['nominal'] is String
            ? double.parse(item['nominal'])
            : item['nominal'].toDouble();
        return sum + nominal;
      });

  
}
