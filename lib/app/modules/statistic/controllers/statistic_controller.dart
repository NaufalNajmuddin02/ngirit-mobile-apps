import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class StatisticController extends GetxController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  var income = <double>[].obs;

  var expense = <double>[].obs;

  var totalIncome = 0.obs; // Total pemasukan
  var totalExpense = 0.obs; // Total pengeluaran
  var totalBalance = 0.obs; // Total saldo
  var pieChartData = <PieChartSectionData>[].obs;

  var selectedYear = DateTime.now().obs;

  // Ambil userId dari pengguna yang sedang login
  String get userId => _auth.currentUser?.uid ?? '';

  // Ambil bulan depan, sekarang, dan sebelumnya
  DateTime get startOfMonth =>
      DateTime(selectedYear.value.year, selectedYear.value.month, 1);
  DateTime get endOfMonth {
    final nextMonth =
        DateTime(selectedYear.value.year, selectedYear.value.month + 1, 1);
    return nextMonth.subtract(Duration(days: 1));
  }

  // Ambil bulan depan, sekarang, dan sebelumnya
  String get nextMonth {
    final nextDate =
        DateTime(selectedYear.value.year, selectedYear.value.month + 1);
    return DateFormat('MMMM yyyy').format(nextDate);
  }

  String get selectedMonth =>
      DateFormat('MMMM yyyy').format(selectedYear.value);

  String get previousMonth {
    final prevDate =
        DateTime(selectedYear.value.year, selectedYear.value.month - 1);
    return DateFormat('MMMM yyyy').format(prevDate);
  }

  // Method to change the month
  void changeMonth(int delta) {
    final newMonth = selectedYear.value.month + delta;
    final newYear = selectedYear.value.year +
        (newMonth > 12
            ? 1
            : newMonth < 1
                ? -1
                : 0);
    selectedYear.value =
        DateTime(newYear, (newMonth % 12) == 0 ? 12 : newMonth % 12);
    fetchTotalIncome();
    fetchTotalExpense();
    fetchTotalBalance();
    fetchIncome();
    fetchExpense();
    fetchExpenseByCategory();
  }

  // Fetch total pemasukan dari Firestore berdasarkan createdAt (timestamp)
  void fetchTotalIncome() {
    _firestore
        .collection('pendapatan')
        .where('user_id', isEqualTo: userId)
        .where('createdAt', isGreaterThanOrEqualTo: startOfMonth)
        .where('createdAt', isLessThanOrEqualTo: endOfMonth)
        .snapshots()
        .listen((snapshot) {
      totalIncome.value = snapshot.docs
          .fold(0, (sum, doc) => sum + int.parse(doc['nominal'] as String));
    }, onError: (e) {
      print('Error fetching income: $e');
    });
  }

  // Fetch total pengeluaran dari Firestore berdasarkan createdAt (timestamp)
  void fetchTotalExpense() {
    _firestore
        .collection('pengeluaran')
        .where('user_id', isEqualTo: userId)
        .where('createdAt', isGreaterThanOrEqualTo: startOfMonth)
        .where('createdAt', isLessThanOrEqualTo: endOfMonth)
        .snapshots()
        .listen((snapshot) {
      totalExpense.value = snapshot.docs
          .fold(0, (sum, doc) => sum + int.parse(doc['nominal'] as String));
    }, onError: (e) {
      print('Error fetching expense: $e');
    });
  }

  Future<void> fetchTotalBalance() async {
    try {
      final accountSnapshot = await _firestore
          .collection('accounts')
          .where('user_id', isEqualTo: userId)
          .get(); // Mengambil semua akun berdasarkan user_id

      if (accountSnapshot.docs.isNotEmpty) {
        int totalSaldo = 0;
        for (var accountDoc in accountSnapshot.docs) {
          int saldoAwal = int.parse(accountDoc['saldo_awal'] as String);
          totalSaldo += saldoAwal;
          print("Saldo Awal dari akun: $saldoAwal");
        }

        totalBalance.value =
            totalSaldo + totalIncome.value - totalExpense.value;
        print("Total Balance: ${totalBalance.value}");
      } else {
        print('No account found for user');
      }
    } catch (e) {
      print('Error fetching balance: $e');
    }
  }

  // Method untuk mengambil data pemasukan
  // Method untuk mengambil data pemasukan secara real-time
  void fetchIncome() {
    _firestore
        .collection('pendapatan')
        .where('user_id', isEqualTo: userId)
        .where('createdAt', isGreaterThanOrEqualTo: startOfMonth)
        .where('createdAt', isLessThanOrEqualTo: endOfMonth)
        .snapshots()
        .listen((snapshot) {
      // Ubah 'nominal' ke dalam format double
      List<double> incomeData = snapshot.docs
          .map((doc) => double.parse(doc['nominal'].toString()))
          .toList();

      // Simpan ke dalam variabel income
      income.value = incomeData;
    }, onError: (e) {
      print('Error fetching income: $e');
    });
  }

// Method untuk mengambil data pengeluaran secara real-time
  void fetchExpense() {
    _firestore
        .collection('pengeluaran')
        .where('user_id', isEqualTo: userId)
        .where('createdAt', isGreaterThanOrEqualTo: startOfMonth)
        .where('createdAt', isLessThanOrEqualTo: endOfMonth)
        .snapshots()
        .listen((snapshot) {
      // Ubah 'nominal' ke dalam format double
      List<double> expenseData = snapshot.docs
          .map((doc) => double.parse(doc['nominal'].toString()))
          .toList();

      // Simpan ke dalam variabel expense
      expense.value = expenseData;
    }, onError: (e) {
      print('Error fetching expense: $e');
    });
  }

  void fetchExpenseByCategory() {
    _firestore
        .collection('pengeluaran')
        .where('user_id', isEqualTo: userId)
        .where('createdAt', isGreaterThanOrEqualTo: startOfMonth)
        .where('createdAt', isLessThanOrEqualTo: endOfMonth)
        .snapshots()
        .listen((snapshot) {
      // Map untuk menyimpan total pengeluaran per kategori
      Map<String, double> categoryTotals = {
        'Makanan': 0.0,
        'Transportasi': 0.0,
        'Belanja': 0.0,
        'Hiburan': 0.0,
      };

      // Loop melalui dokumen snapshot
      snapshot.docs.forEach((doc) {
        String category = doc['kategori'];
        double amount = double.parse(doc['nominal'].toString());

        // Tambahkan nominal ke kategori yang sesuai
        if (categoryTotals.containsKey(category)) {
          categoryTotals[category] = categoryTotals[category]! + amount;
        }
      });

      // Perbarui data pieChartData dengan data yang baru
      updatePieChartData(categoryTotals);
    }, onError: (e) {
      print('Error fetching expense by category: $e');
    });
  }

  void updatePieChartData(Map<String, double> categoryTotals) {
    // Ubah map data ke dalam bentuk yang sesuai untuk PieChart
    pieChartData.value = [
      PieChartSectionData(
        color: Colors.green,
        value: categoryTotals['Makanan'] ?? 0.0,
        title: '${categoryTotals['Makanan']?.toStringAsFixed(1) ?? '0'}%',
        radius: 50,
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: categoryTotals['Transportasi'] ?? 0.0,
        title: '${categoryTotals['Transportasi']?.toStringAsFixed(1) ?? '0'}%',
        radius: 50,
      ),
      PieChartSectionData(
        color: Colors.red,
        value: categoryTotals['Belanja'] ?? 0.0,
        title: '${categoryTotals['Belanja']?.toStringAsFixed(1) ?? '0'}%',
        radius: 50,
      ),
      PieChartSectionData(
        color: Colors.blue,
        value: categoryTotals['Hiburan'] ?? 0.0,
        title: '${categoryTotals['Hiburan']?.toStringAsFixed(1) ?? '0'}%',
        radius: 50,
      ),
    ];
  }

  // Inisialisasi dan fetch data saat controller dibuat
  @override
  void onInit() {
    super.onInit();

    fetchIncome();
    fetchExpense();
    fetchTotalIncome();
    fetchTotalExpense();
    fetchExpenseByCategory();

    // Hitung ulang saldo ketika total pemasukan atau pengeluaran berubah
    everAll([totalIncome, totalExpense], (_) {
      fetchTotalBalance();
    });
    listenToAccountUpdates();
    listenToCreditCardUpdates(); // New listener for credit cards
  }

  var selectedIndex = 0.obs;
  var username = ''.obs;
  var saldo = 0.obs; // Default saldo 0
  var accounts = <Map<String, dynamic>>[].obs;
  var creditCards = <Map<String, dynamic>>[].obs;
  var selectedTab = 0.obs; // New list for credit cards
  var selectedAkun = ''.obs;
  var selectedKategori = ''.obs;
  var selectedDate = ''.obs;
  var deskripsi = ''.obs; // Variabel untuk menyimpan deskripsi

  TextEditingController nominalController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();

  void onClose() {
    deskripsiController.dispose();
    nominalController.dispose(); // Dispose nominalController juga
    super.onClose();
  }

  // Function to save form data to Firestore
  Future<void> saveFormData(String nominal) async {
    final controller = Get.find<StatisticController>();
    String collection;
    switch (controller.selectedTab.value) {
      case 0:
        collection = 'pengeluaran';
        break;
      case 1:
        collection = 'pendapatan';
        break;
      case 2:
        collection = 'transfer';
        break;
      default:
        collection = 'pengeluaran';
    }

    if (controller.selectedKategori.isNotEmpty &&
        controller.selectedAkun.isNotEmpty &&
        controller.selectedDate.isNotEmpty) {
      try {
        User? user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          await FirebaseFirestore.instance.collection(collection).add({
            'user_id': user.uid,
            'nominal': nominal,
            'deskripsi': controller.deskripsi.value,
            'kategori': controller.selectedKategori.value,
            'akun': controller.selectedAkun.value,
            'tanggal': controller.selectedDate.value,
            'createdAt': FieldValue.serverTimestamp(),
          });
          Get.snackbar('Success', 'Data berhasil disimpan ke $collection');
        }
      } catch (e) {
        Get.snackbar('Error', 'Gagal menyimpan data ke $collection');
      }
    } else {
      Get.snackbar('Error', 'Pastikan semua field diisi');
    }
  }

  // Listen for account updates and calculate total saldo
  void listenToAccountUpdates() {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        FirebaseFirestore.instance
            .collection('accounts')
            .where('user_id', isEqualTo: user.uid)
            .snapshots()
            .listen((accountSnapshot) {
          var totalSaldo = 0;
          accounts.clear();

          for (var doc in accountSnapshot.docs) {
            var accountData = doc.data();
            int saldoAwal = int.tryParse(accountData['saldo_awal']) ?? 0;

            accounts.add({
              'nama_akun': accountData['nama_akun'],
              'saldo_awal': saldoAwal,
              'icon': accountData['icon'] ?? '',
            });

            totalSaldo += saldoAwal;
          }

          saldo.value = totalSaldo;
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load accounts');
    }
  }

  // New function: Listen for credit card updates
  void listenToCreditCardUpdates() {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        FirebaseFirestore.instance
            .collection('kartu_kredit') // Pastikan nama koleksi sudah sesuai
            .where('user_id', isEqualTo: user.uid)
            .snapshots()
            .listen((ccSnapshot) {
          creditCards.clear();

          for (var doc in ccSnapshot.docs) {
            var ccData = doc.data();

            // Debugging: Cetak data yang diambil
            print('Credit card data: $ccData');

            creditCards.add({
              'namaKartu': ccData['namaKartu'] ?? 'No Name',
              'ikonKartu':
                  ccData['ikonKartu'] ?? '', // Jika tidak ada ikon, kosong
              'limitKredit': ccData['limitKredit'] ?? '',
            });
          }
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load credit cards');
    }
  }
}
