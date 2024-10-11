// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class CashFlowController extends GetxController {
//   var expenses = <Map<String, dynamic>>[].obs;
//   var income = <Map<String, dynamic>>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchExpenses();
//     fetchIncome();
//   }

//   // Function to fetch expenses from Firestore
//   Future<void> fetchExpenses() async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//             .collection('pengeluaran')
//             .where('user_id', isEqualTo: user.uid)
//             .get();

//         expenses.assignAll(
//           querySnapshot.docs
//               .map((doc) => {
//                     'nominal': doc['nominal'],
//                     'deskripsi': doc['deskripsi'],
//                     'kategori': doc['kategori'],
//                     'akun': doc['akun'],
//                     'tanggal': doc['tanggal'],
//                   })
//               .toList(),
//         );
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to fetch expenses');
//     }
//   }

//   // Function to fetch income from Firestore
//   Future<void> fetchIncome() async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//             .collection('pendapatan')
//             .where('user_id', isEqualTo: user.uid)
//             .get();

//         income.assignAll(
//           querySnapshot.docs
//               .map((doc) => {
//                     'nominal': doc['nominal'],
//                     'deskripsi': doc['deskripsi'],
//                     'kategori': doc['kategori'],
//                     'akun': doc['akun'],
//                     'tanggal': doc['tanggal'],
//                   })
//               .toList(),
//         );
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to fetch income');
//     }
//   }

//   // Getter to calculate total expenses
//   double get totalExpenses => expenses.fold(0, (sum, item) {
//         double nominal = item['nominal'] is String
//             ? double.parse(item['nominal'])
//             : item['nominal'].toDouble();
//         return sum + nominal;
//       });

// // Getter to calculate total income
//   double get totalIncome => income.fold(0, (sum, item) {
//         double nominal = item['nominal'] is String
//             ? double.parse(item['nominal'])
//             : item['nominal'].toDouble();
//         return sum + nominal;
//       });
// }

// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart'; // Tambahkan ini

// class CashFlowController extends GetxController {
//   var expenses = <Map<String, dynamic>>[].obs;
//   var income = <Map<String, dynamic>>[].obs;
//   var selectedMonth = DateTime.now().month.obs; // Bulan yang dipilih
//   var selectedYear =
//       DateTime.now().year.obs; // Tambahkan juga tahun agar bulan sesuai
//   var searchQuery = ''.obs; // Search query

//   @override
//   void onInit() {
//     super.onInit();
//     fetchExpenses();
//     fetchIncome();
//   }

//   // Fungsi untuk mengambil data pengeluaran
//   Future<void> fetchExpenses() async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//             .collection('pengeluaran')
//             .where('user_id', isEqualTo: user.uid)
//             .get();

//         expenses.assignAll(
//           querySnapshot.docs
//               .where((doc) {
//                 DateTime tanggal;
//                 if (doc['tanggal'] is String) {
//                   try {
//                     // Parsing string berdasarkan format yang sesuai (contoh: "dd-MM-yyyy")
//                     tanggal = DateFormat('dd-MM-yyyy').parse(doc['tanggal']);
//                   } catch (e) {
//                     return false; // Jika parsing gagal
//                   }
//                 } else if (doc['tanggal'] is Timestamp) {
//                   tanggal = (doc['tanggal'] as Timestamp).toDate();
//                 } else {
//                   return false; // Format tidak valid
//                 }
//                 return tanggal.month == selectedMonth.value &&
//                     tanggal.year == selectedYear.value;
//               })
//               .map((doc) => {
//                     'nominal': doc['nominal'],
//                     'deskripsi': doc['deskripsi'],
//                     'kategori': doc['kategori'],
//                     'akun': doc['akun'],
//                     'tanggal': doc['tanggal'],
//                   })
//               .toList(),
//         );
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to fetch expenses: ${e.toString()}');
//     }
//   }

//   // Fungsi untuk mengambil data pemasukan
//   Future<void> fetchIncome() async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//             .collection('pendapatan')
//             .where('user_id', isEqualTo: user.uid)
//             .get();

//         income.assignAll(
//           querySnapshot.docs
//               .where((doc) {
//                 DateTime tanggal;
//                 if (doc['tanggal'] is String) {
//                   try {
//                     // Parsing string berdasarkan format yang sesuai (contoh: "dd-MM-yyyy")
//                     tanggal = DateFormat('dd-MM-yyyy').parse(doc['tanggal']);
//                   } catch (e) {
//                     return false; // Jika parsing gagal
//                   }
//                 } else if (doc['tanggal'] is Timestamp) {
//                   tanggal = (doc['tanggal'] as Timestamp).toDate();
//                 } else {
//                   return false; // Format tidak valid
//                 }
//                 return tanggal.month == selectedMonth.value &&
//                     tanggal.year == selectedYear.value;
//               })
//               .map((doc) => {
//                     'nominal': doc['nominal'],
//                     'deskripsi': doc['deskripsi'],
//                     'kategori': doc['kategori'],
//                     'akun': doc['akun'],
//                     'tanggal': doc['tanggal'],
//                   })
//               .toList(),
//         );
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to fetch income: ${e.toString()}');
//     }
//   }

//   // Fungsi untuk berpindah ke bulan sebelumnya
//   void previousMonth() {
//     if (selectedMonth.value > 1) {
//       selectedMonth.value--;
//     } else {
//       selectedMonth.value = 12;
//       selectedYear.value--; // Pindah ke tahun sebelumnya jika bulan Januari
//     }
//     fetchExpenses();
//     fetchIncome();
//   }

//   // Fungsi untuk berpindah ke bulan berikutnya
//   void nextMonth() {
//     if (selectedMonth.value < 12) {
//       selectedMonth.value++;
//     } else {
//       selectedMonth.value = 1;
//       selectedYear.value++; // Pindah ke tahun berikutnya jika bulan Desember
//     }
//     fetchExpenses();
//     fetchIncome();
//   }

//   // Fungsi untuk mendapatkan nama bulan
//   String getMonthName(int month) {
//     const List<String> monthNames = [
//       'Januari',
//       'Februari',
//       'Maret',
//       'April',
//       'Mei',
//       'Juni',
//       'Juli',
//       'Agustus',
//       'September',
//       'Oktober',
//       'November',
//       'Desember',
//     ];
//     return monthNames[month - 1]; // Sesuaikan index dengan urutan bulan
//   }

//   // Getter untuk menghitung total pengeluaran
//   double get totalExpenses => expenses.fold(0, (sum, item) {
//         double nominal = item['nominal'] is String
//             ? double.parse(item['nominal'])
//             : item['nominal'].toDouble();
//         return sum + nominal;
//       });

//   // Getter untuk menghitung total pemasukan
//   double get totalIncome => income.fold(0, (sum, item) {
//         double nominal = item['nominal'] is String
//             ? double.parse(item['nominal'])
//             : item['nominal'].toDouble();
//         return sum + nominal;
//       });

//   // Reactive lists for filtered data
//   List<Map<String, dynamic>> get filteredExpenses {
//     if (searchQuery.value.isEmpty) return expenses;
//     return expenses
//         .where((expense) => expense['deskripsi']
//             .toLowerCase()
//             .contains(searchQuery.value.toLowerCase()))
//         .toList();
//   }

//   List<Map<String, dynamic>> get filteredIncome {
//     if (searchQuery.value.isEmpty) return income;
//     return income
//         .where((incomeItem) => incomeItem['deskripsi']
//             .toLowerCase()
//             .contains(searchQuery.value.toLowerCase()))
//         .toList();
//   }

//   // Method to update the search query
//   void updateSearchQuery(String query) {
//     searchQuery.value = query;
//   }

// }







// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart'; // Tambahkan ini

// class CashFlowController extends GetxController {
//   var expenses = <Map<String, dynamic>>[].obs;
//   var income = <Map<String, dynamic>>[].obs;
//   var selectedMonth = DateTime.now().month.obs; // Bulan yang dipilih
//   var selectedYear =
//       DateTime.now().year.obs; // Tambahkan juga tahun agar bulan sesuai
//   var searchQuery = ''.obs; // Search query
//   var selectedCategories = <String>[].obs; // Selected filter categories

//   @override
//   void onInit() {
//     super.onInit();
//     fetchExpenses();
//     fetchIncome();
//   }

//   // Fungsi untuk mengambil data pengeluaran
//   Future<void> fetchExpenses() async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//             .collection('pengeluaran')
//             .where('user_id', isEqualTo: user.uid)
//             .get();

//         expenses.assignAll(
//           querySnapshot.docs
//               .where((doc) {
//                 DateTime tanggal;
//                 if (doc['tanggal'] is String) {
//                   try {
//                     // Parsing string berdasarkan format yang sesuai (contoh: "dd-MM-yyyy")
//                     tanggal = DateFormat('dd-MM-yyyy').parse(doc['tanggal']);
//                   } catch (e) {
//                     return false; // Jika parsing gagal
//                   }
//                 } else if (doc['tanggal'] is Timestamp) {
//                   tanggal = (doc['tanggal'] as Timestamp).toDate();
//                 } else {
//                   return false; // Format tidak valid
//                 }
//                 return tanggal.month == selectedMonth.value &&
//                     tanggal.year == selectedYear.value;
//               })
//               .map((doc) => {
//                     'nominal': doc['nominal'],
//                     'deskripsi': doc['deskripsi'],
//                     'kategori': doc['kategori'],
//                     'akun': doc['akun'],
//                     'tanggal': doc['tanggal'],
//                   })
//               .toList(),
//         );
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to fetch expenses: ${e.toString()}');
//     }
//   }

//   // Fungsi untuk mengambil data pemasukan
//   Future<void> fetchIncome() async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       if (user != null) {
//         QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//             .collection('pendapatan')
//             .where('user_id', isEqualTo: user.uid)
//             .get();

//         income.assignAll(
//           querySnapshot.docs
//               .where((doc) {
//                 DateTime tanggal;
//                 if (doc['tanggal'] is String) {
//                   try {
//                     // Parsing string berdasarkan format yang sesuai (contoh: "dd-MM-yyyy")
//                     tanggal = DateFormat('dd-MM-yyyy').parse(doc['tanggal']);
//                   } catch (e) {
//                     return false; // Jika parsing gagal
//                   }
//                 } else if (doc['tanggal'] is Timestamp) {
//                   tanggal = (doc['tanggal'] as Timestamp).toDate();
//                 } else {
//                   return false; // Format tidak valid
//                 }
//                 return tanggal.month == selectedMonth.value &&
//                     tanggal.year == selectedYear.value;
//               })
//               .map((doc) => {
//                     'nominal': doc['nominal'],
//                     'deskripsi': doc['deskripsi'],
//                     'kategori': doc['kategori'],
//                     'akun': doc['akun'],
//                     'tanggal': doc['tanggal'],
//                   })
//               .toList(),
//         );
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to fetch income: ${e.toString()}');
//     }
//   }

//   // Fungsi untuk berpindah ke bulan sebelumnya
//   void previousMonth() {
//     if (selectedMonth.value > 1) {
//       selectedMonth.value--;
//     } else {
//       selectedMonth.value = 12;
//       selectedYear.value--; // Pindah ke tahun sebelumnya jika bulan Januari
//     }
//     fetchExpenses();
//     fetchIncome();
//   }

//   // Fungsi untuk berpindah ke bulan berikutnya
//   void nextMonth() {
//     if (selectedMonth.value < 12) {
//       selectedMonth.value++;
//     } else {
//       selectedMonth.value = 1;
//       selectedYear.value++; // Pindah ke tahun berikutnya jika bulan Desember
//     }
//     fetchExpenses();
//     fetchIncome();
//   }

//   // Fungsi untuk mendapatkan nama bulan
//   String getMonthName(int month) {
//     const List<String> monthNames = [
//       'Januari',
//       'Februari',
//       'Maret',
//       'April',
//       'Mei',
//       'Juni',
//       'Juli',
//       'Agustus',
//       'September',
//       'Oktober',
//       'November',
//       'Desember',
//     ];
//     return monthNames[month - 1]; // Sesuaikan index dengan urutan bulan
//   }

//   // Getter untuk menghitung total pengeluaran
//   double get totalExpenses => expenses.fold(0, (sum, item) {
//         double nominal = item['nominal'] is String
//             ? double.parse(item['nominal'])
//             : item['nominal'].toDouble();
//         return sum + nominal;
//       });

//   // Getter untuk menghitung total pemasukan
//   double get totalIncome => income.fold(0, (sum, item) {
//         double nominal = item['nominal'] is String
//             ? double.parse(item['nominal'])
//             : item['nominal'].toDouble();
//         return sum + nominal;
//       });

//   // Fungsi untuk melakukan filter berdasarkan kategori
//   List<Map<String, dynamic>> filterByCategory(List<Map<String, dynamic>> data) {
//     if (selectedCategories.isEmpty) return data;
//     return data
//         .where((item) => selectedCategories.contains(item['kategori']))
//         .toList();
//   }

//   // Reactive lists for filtered data
//   List<Map<String, dynamic>> get filteredExpenses {
//     List<Map<String, dynamic>> filteredData = filterByCategory(expenses);
//     if (searchQuery.value.isEmpty) return filteredData;
//     return filteredData
//         .where((expense) => expense['deskripsi']
//             .toLowerCase()
//             .contains(searchQuery.value.toLowerCase()))
//         .toList();
//   }

//   List<Map<String, dynamic>> get filteredIncome {
//     List<Map<String, dynamic>> filteredData = filterByCategory(income);
//     if (searchQuery.value.isEmpty) return filteredData;
//     return filteredData
//         .where((incomeItem) => incomeItem['deskripsi']
//             .toLowerCase()
//             .contains(searchQuery.value.toLowerCase()))
//         .toList();
//   }

//   // Method to update the search query
//   void updateSearchQuery(String query) {
//     searchQuery.value = query;
//   }

//   // Method to update the selected categories
//   void updateSelectedCategories(List<String> categories) {
//     selectedCategories.assignAll(categories);
//   }
// }



import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Tambahkan ini

class CashFlowController extends GetxController {
  var expenses = <Map<String, dynamic>>[].obs;
  var income = <Map<String, dynamic>>[].obs;
  var selectedMonth = DateTime.now().month.obs; // Bulan yang dipilih
  var selectedYear = DateTime.now().year.obs; // Tambahkan juga tahun agar bulan sesuai
  var searchQuery = ''.obs; // Search query
  var selectedCategories = <String>[].obs; // Selected filter categories
  var selectedAccounts = <String>[].obs; // Selected filter accounts

  @override
  void onInit() {
    super.onInit();
    fetchExpenses();
    fetchIncome();
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

  // Fungsi untuk melakukan filter berdasarkan kategori dan akun
  List<Map<String, dynamic>> filterByCategoryAndAccount(List<Map<String, dynamic>> data) {
    // Filter berdasarkan kategori
    if (selectedCategories.isNotEmpty) {
      data = data.where((item) => selectedCategories.contains(item['kategori'])).toList();
    }
    // Filter berdasarkan akun
    if (selectedAccounts.isNotEmpty) {
      data = data.where((item) => selectedAccounts.contains(item['akun'])).toList();
    }
    return data;
  }

  // Reactive lists for filtered data
  List<Map<String, dynamic>> get filteredExpenses {
    List<Map<String, dynamic>> filteredData = filterByCategoryAndAccount(expenses);
    if (searchQuery.value.isEmpty) return filteredData;
    return filteredData
        .where((expense) => expense['deskripsi']
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  List<Map<String, dynamic>> get filteredIncome {
    List<Map<String, dynamic>> filteredData = filterByCategoryAndAccount(income);
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
}
