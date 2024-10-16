import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Tambahkan ini

class CashFlowController extends GetxController {
  var expenses = <Map<String, dynamic>>[].obs;
  var income = <Map<String, dynamic>>[].obs;
  var selectedMonth = DateTime.now().month.obs; // Bulan yang dipilih
  var selectedYear =
      DateTime.now().year.obs; // Tambahkan juga tahun agar bulan sesuai
  var searchQuery = ''.obs; // Search query
  var selectedCategories = <String>[].obs; // Selected filter categories
  var selectedAccounts = <String>[].obs; // Selected filter accounts
  var totalBalance = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchExpenses();
    fetchIncome();
    listenToAccountUpdates();
    listenToCreditCardUpdates(); // New listener for credit cards
  }

  // Fungsi untuk mengambil data pengeluaran
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
              .where((doc) {
                DateTime tanggal;
                if (doc['tanggal'] is String) {
                  try {
                    // Parsing string berdasarkan format yang sesuai (contoh: "dd-MM-yyyy")
                    tanggal = DateFormat('dd-MM-yyyy').parse(doc['tanggal']);
                  } catch (e) {
                    return false; // Jika parsing gagal
                  }
                } else if (doc['tanggal'] is Timestamp) {
                  tanggal = (doc['tanggal'] as Timestamp).toDate();
                } else {
                  return false; // Format tidak valid
                }
                return tanggal.month == selectedMonth.value &&
                    tanggal.year == selectedYear.value;
              })
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
      Get.snackbar('Error', 'Failed to fetch expenses: ${e.toString()}');
    }
  }

  // Fungsi untuk mengambil data pemasukan
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
              .where((doc) {
                DateTime tanggal;
                if (doc['tanggal'] is String) {
                  try {
                    // Parsing string berdasarkan format yang sesuai (contoh: "dd-MM-yyyy")
                    tanggal = DateFormat('dd-MM-yyyy').parse(doc['tanggal']);
                  } catch (e) {
                    return false; // Jika parsing gagal
                  }
                } else if (doc['tanggal'] is Timestamp) {
                  tanggal = (doc['tanggal'] as Timestamp).toDate();
                } else {
                  return false; // Format tidak valid
                }
                return tanggal.month == selectedMonth.value &&
                    tanggal.year == selectedYear.value;
              })
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
      Get.snackbar('Error', 'Failed to fetch income: ${e.toString()}');
    }
  }

  // Fungsi untuk berpindah ke bulan sebelumnya
  void previousMonth() {
    if (selectedMonth.value > 1) {
      selectedMonth.value--;
    } else {
      selectedMonth.value = 12;
      selectedYear.value--; // Pindah ke tahun sebelumnya jika bulan Januari
    }
    fetchExpenses();
    fetchIncome();
  }

  // Fungsi untuk berpindah ke bulan berikutnya
  void nextMonth() {
    if (selectedMonth.value < 12) {
      selectedMonth.value++;
    } else {
      selectedMonth.value = 1;
      selectedYear.value++; // Pindah ke tahun berikutnya jika bulan Desember
    }
    fetchExpenses();
    fetchIncome();
  }

  // Fungsi untuk mendapatkan nama bulan
  String getMonthName(int month) {
    const List<String> monthNames = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return monthNames[month - 1]; // Sesuaikan index dengan urutan bulan
  }

  // Get the previous month and handle year transitions
  int getPreviousMonth() {
    if (selectedMonth.value > 1) {
      return selectedMonth.value - 1;
    } else {
      return 12;
    }
  }

  int getPreviousMonthYear() {
    if (selectedMonth.value > 1) {
      return selectedYear.value;
    } else {
      return selectedYear.value - 1;
    }
  }

// Get the next month and handle year transitions
  int getNextMonth() {
    if (selectedMonth.value < 12) {
      return selectedMonth.value + 1;
    } else {
      return 1;
    }
  }

  int getNextMonthYear() {
    if (selectedMonth.value < 12) {
      return selectedYear.value;
    } else {
      return selectedYear.value + 1;
    }
  }

  // Getter untuk menghitung total pengeluaran
  double get totalExpenses => expenses.fold(0, (sum, item) {
        double nominal = item['nominal'] is String
            ? double.parse(item['nominal'])
            : item['nominal'].toDouble();
        return sum + nominal;
      });

// Getter untuk menghitung total pemasukan
  double get totalIncome => income.fold(0, (sum, item) {
        double nominal = item['nominal'] is String
            ? double.parse(item['nominal'])
            : item['nominal'].toDouble();
        return sum + nominal;
      });

// Getter untuk menghitung total saldo (pemasukan - pengeluaran)
// Ini masih bisa digunakan jika Anda memerlukan saldo secara terpisah
  double get totalBalanceValue => totalIncome - totalExpenses;

// Fungsi untuk mengambil saldo dari akun dan menghitung total balance
  Future<void> fetchTotalBalance() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot accountSnapshot = await FirebaseFirestore.instance
            .collection('accounts')
            .where('user_id', isEqualTo: user.uid)
            .get();

        if (accountSnapshot.docs.isNotEmpty) {
          double saldoAwal = 0.0;

          for (var accountDoc in accountSnapshot.docs) {
            saldoAwal += accountDoc['saldo_awal'] is String
                ? double.parse(accountDoc['saldo_awal'])
                : accountDoc['saldo_awal'].toDouble();
          }

          // Update total saldo: saldo awal + total pemasukan - total pengeluaran
          totalBalance.value = saldoAwal +
              totalIncome -
              totalExpenses; // Perhitungan yang diperbarui
          print("Total Balance: ${totalBalance.value}");
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch balance: ${e.toString()}');
    }
  }

  // Fungsi untuk melakukan filter berdasarkan kategori dan akun
  List<Map<String, dynamic>> filterByCategoryAndAccount(
      List<Map<String, dynamic>> data) {
    // Filter berdasarkan kategori
    if (selectedCategories.isNotEmpty) {
      data = data
          .where((item) => selectedCategories.contains(item['kategori']))
          .toList();
    }
    // Filter berdasarkan akun
    if (selectedAccounts.isNotEmpty) {
      data = data
          .where((item) => selectedAccounts.contains(item['akun']))
          .toList();
    }
    return data;
  }

  // Reactive lists for filtered data
  List<Map<String, dynamic>> get filteredExpenses {
    List<Map<String, dynamic>> filteredData =
        filterByCategoryAndAccount(expenses);
    if (searchQuery.value.isEmpty) return filteredData;
    return filteredData
        .where((expense) => expense['deskripsi']
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  List<Map<String, dynamic>> get filteredIncome {
    List<Map<String, dynamic>> filteredData =
        filterByCategoryAndAccount(income);
    if (searchQuery.value.isEmpty) return filteredData;
    return filteredData
        .where((incomeItem) => incomeItem['deskripsi']
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  // Method to update the search query
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Method to update the selected categories
  void updateSelectedCategories(List<String> categories) {
    selectedCategories.assignAll(categories);
  }

  // Method to update the selected accounts
  void updateSelectedAccounts(List<String> accounts) {
    selectedAccounts.assignAll(accounts);
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
    final controller = Get.find<CashFlowController>();
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
