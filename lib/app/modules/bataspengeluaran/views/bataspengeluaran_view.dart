import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ngirit/app/modules/cashflow/views/cashflow_view.dart';
import '../controllers/bataspengeluaran_controller.dart';

class BataspengeluaranView extends GetView<BataspengeluaranController> {
  final BataspengeluaranController controller =
      Get.put(BataspengeluaranController());

  final TextEditingController nominalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade900, // Light blue
                  Colors.white, // Dark blue
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Upper curve design
          Container(
            height: 90,
            decoration: BoxDecoration(
              color: Color(0xFF1E2147),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(40),
              ),
            ),
          ),
          // Positioned Arus Kas text or search field
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Batas Pengeluaran',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          // Plus button (overflow menu) positioned at the top-right corner
          Positioned(
            top: 30,
            right: 12,
            child: IconButton(
              icon: Icon(Icons.add, color: Colors.white), // Plus icon
              onPressed: () async {
                // Panggil fungsi untuk mendapatkan kategori yang sudah ada
                List<String> existingCategories =
                    await controller.getExistingCategories();

                // Tampilkan modal dengan kategori yang belum dipilih
                showCategorySelection(context, existingCategories);
              },
            ),
          ),

          // Main content with padding to move it down
          Padding(
            padding: const EdgeInsets.only(top: 100.0), // Adjusted top padding
            child: Column(
              children: [
                SizedBox(height: 30), // Space before month section
                // Month section
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0), // Padding lebih besar
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Previous Month Button
                      IconButton(
                        icon: Icon(Icons.arrow_left),
                        color: Colors.white,
                        iconSize: 40,
                        onPressed: () {
                          controller.changeMonth(-1);
                        },
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                      // Previous Month Container
                      Expanded(
                        child: Obx(() =>
                            buildMonthContainer(controller.previousMonth)),
                      ),
                      SizedBox(width: 3),
                      // Selected Month Container
                      Expanded(
                        child: Obx(() => buildMonthContainer(
                            controller.selectedMonth, true)),
                      ),
                      SizedBox(width: 3),
                      // Next Month Container
                      Expanded(
                        child: Obx(
                            () => buildMonthContainer(controller.nextMonth)),
                      ),
                      // Next Month Button
                      IconButton(
                        icon: Icon(Icons.arrow_right),
                        color: Colors.white,
                        iconSize: 40,
                        onPressed: () {
                          controller.changeMonth(1);
                        },
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Expanded list for cash flow content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Grouped transactions
                          Obx(() {
                            // Group transactions by date in the view
                            Map<String, List<Map<String, dynamic>>>
                                groupedTransactions = {};

                            // Group the transactions by 'date'
                            for (var transaction in controller.transactions) {
                              String date = transaction['date']!;

                              // Jika tanggal belum ada di groupedTransactions, tambahkan key baru
                              if (!groupedTransactions.containsKey(date)) {
                                groupedTransactions[date] = [];
                              }

                              // Tambahkan transaksi ke dalam grup berdasarkan tanggal
                              groupedTransactions[date]!.add(transaction);
                            }

                            // Tampilkan groupedTransactions menggunakan ListView.builder
                            return ListView.builder(
                              physics:
                                  NeverScrollableScrollPhysics(), // Prevent scrolling of inner list
                              shrinkWrap: true,
                              itemCount: groupedTransactions.keys.length,
                              itemBuilder: (context, index) {
                                String date =
                                    groupedTransactions.keys.elementAt(index);
                                List<Map<String, dynamic>> transactions =
                                    groupedTransactions[date]!;

                                return buildTransactionGroup(
                                    date, transactions, controller);
                              },
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(
                    height:
                        10), // Spacer between transactions and financial summary
              ],
            ),
          ),
        ],
      ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Colors.black,
        onPressed: () {
          _showModalBottomSheet(
              context); // Panggil fungsi untuk menampilkan bottom sheet
        },
        child: Icon(Icons.add, color: Colors.white, size: 36),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.home, size: 30),
                onPressed: () {
                  Get.toNamed('/dashboard');
                },
              ),
              IconButton(
                icon: Icon(Icons.swap_horiz, size: 30),
                onPressed: () {
                  Get.toNamed('/cashflow');
                },
              ),
              SizedBox(width: 48), // Space for FloatingActionButton
              IconButton(
                icon: Icon(Icons.bar_chart, size: 30),
                onPressed: () {
                  Get.toNamed('/statistic');
                },
              ),
              IconButton(
                icon: Icon(FontAwesomeIcons.bullseye, size: 30),
                onPressed: () {
                  Get.toNamed('/bataspengeluaran');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.9, // Mengatur tinggi BottomSheet
          widthFactor: 0.9, // Mengatur lebar BottomSheet
          child: Stack(
            children: [
              // Bagian atas dengan warna sesuai tab yang diklik
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 160, // Tinggi background termasuk tab
                child: Obx(() {
                  Color backgroundColor;
                  switch (controller.selectedTab.value) {
                    case 0:
                      backgroundColor =
                          Colors.red; // Warna merah untuk Pengeluaran
                      break;
                    case 1:
                      backgroundColor =
                          Colors.green; // Warna hijau untuk Pendapatan
                      break;
                    default:
                      backgroundColor = Colors.red;
                  }
                  return Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20.0)),
                    ),
                    child: Column(
                      children: [
                        // Tab items di bagian atas
                        Row(
                          children: [
                            _buildTabItem('Pengeluaran', Colors.red, 0),
                            _buildTabItem('Pendapatan', Colors.green, 1),
                          ],
                        ),
                        // Input angka "0,00" di dalam background color
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Spacer(), // Menggeser input ke kanan
                              Expanded(
                                child: TextField(
                                  controller: controller.selectedTab.value == 0
                                      ? controller.pengeluaranController
                                      : controller
                                          .pendapatanController, // Controller per tab
                                  keyboardType: TextInputType.number,
                                  textAlign:
                                      TextAlign.right, // Teks sejajar kanan
                                  decoration: InputDecoration(
                                    hintText: '0,00',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 40,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter
                                        .digitsOnly, // Hanya menerima angka
                                    NumberInputFormatter(), // Formatter angka dengan pemisah ribuan
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              // Konten BottomSheet
              Positioned.fill(
                top:
                    160, // Konten dimulai setelah header background dan input angka
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white, // Warna latar belakang form
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20.0)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        // Form Input berdasarkan tab yang dipilih
                        Obx(() {
                          switch (controller.selectedTab.value) {
                            case 0:
                              return _buildPengeluaranForm(context);
                            case 1:
                              return _buildPendapatanForm(context);
                            default:
                              return _buildPengeluaranForm(context);
                          }
                        }),
                        SizedBox(height: 20),
                        // Tombol Save di bagian bawah BottomSheet
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            onPressed: () {
                              // Ambil nilai nominal dari controller yang sesuai
                              String nominal = controller.selectedTab.value == 0
                                  ? controller.pengeluaranController.text
                                  : controller.pendapatanController.text;

                              // Panggil fungsi untuk menyimpan data ke Firebase
                              controller.saveFormData(nominal);

                              // Kosongkan form setelah data disimpan
                              controller
                                  .clearForm(controller.selectedTab.value);

                              // Tutup BottomSheet setelah menyimpan
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: Colors.blue, // Warna tombol
                            ),
                            child: Text(
                              'Simpan',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Fungsi untuk membuat TabItem di dalam bottom sheet
  Widget _buildTabItem(String title, Color color, int index) {
    return Expanded(
      child: Obx(() {
        bool isSelected = controller.selectedTab.value == index;
        return GestureDetector(
          onTap: () {
            // Jika tab saat ini berbeda dari tab yang diklik, reset semua data form
            if (controller.selectedTab.value != index) {
              controller.resetFormData();
            }

            // Set selected tab dan kosongkan controller sesuai tab yang dipilih
            controller.selectedTab.value = index;

            if (index == 0) {
              controller.pengeluaranController
                  .clear(); // Bersihkan semua field di tab Pengeluaran
            } else if (index == 1) {
              controller.pendapatanController
                  .clear(); // Bersihkan semua field di tab Pendapatan
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color:
                      isSelected ? color.withOpacity(0.8) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white, // Teks selalu putih
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // Garis putih di bawah teks untuk tab yang dipilih
              if (isSelected)
                Container(
                  height: 3, // Ketebalan garis
                  width: 40, // Lebar garis
                  margin: EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    color: Colors.white, // Warna garis putih
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPengeluaranForm(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Supaya label di atas text field

      children: [
        // TextField untuk Deskripsi

        Text(
          'Deskripsi', // Label di atas input field
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              TextField(
                controller: controller
                    .deskripsiController, // Gunakan controller biasa tanpa Obx
                onChanged: (value) {
                  controller.deskripsi.value =
                      value; // Ini adalah variabel observable, jadi perlu diperbarui di sini
                },
                decoration: InputDecoration(
                  labelText: 'Masukkan Deskripsi', // Placeholder
                  prefixIcon: Icon(Icons.edit), // Ikon di dalam field
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10), // Padding agar rapi
                ),
              ),
            ],
          ),
        ),

        // TextField untuk Kategori
        Text(
          'Kategori',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () {
            _showKategoriBottomSheet(context); // Gunakan context di sini
          },
          child: AbsorbPointer(
            child: Obx(() {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: controller.selectedKategori.value.isNotEmpty
                            ? controller.selectedKategori.value
                            : 'Pilih Kategori', // Placeholder
                        border: InputBorder.none, // Hilangkan outline border
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10), // Padding agar rapi
                      ),
                    ),
                    Divider(
                      thickness: 1, // Tebal garis bawah
                      color: Colors.grey, // Warna garis bawah
                    ),
                  ],
                ),
              );
            }),
          ),
        ),

        // TextField untuk Akun
        Text(
          'Dibayar dengan',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () {
            _showAkunBottomSheet(context); // Gunakan context di sini
          },
          child: AbsorbPointer(
            child: Obx(() {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: controller.selectedAkun.value.isNotEmpty
                            ? controller.selectedAkun.value
                            : 'Pilih Akun', // Placeholder
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),

        // TextField untuk Tanggal
        Text(
          'Tanggal',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () async {
            // Tampilkan DatePicker saat pengguna mengetuk field tanggal
            DateTime? selectedDates = await showDatePicker(
              context: context, // Gunakan context di sini
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            // Jika pengguna memilih tanggal, simpan ke controller
            if (selectedDates != null) {
              controller.selectedDates.value =
                  "${selectedDates.day}-${selectedDates.month}-${selectedDates.year}";
            }
          },
          child: AbsorbPointer(
            child: Obx(() {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: controller.selectedDates.value.isNotEmpty
                            ? controller.selectedDates.value
                            : 'Pilih Tanggal', // Placeholder
                        prefixIcon:
                            Icon(Icons.calendar_today), // Ikon di dalam field
                        border: InputBorder.none, // Hilangkan outline border
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10), // Padding agar rapi
                      ),
                    ),
                    Divider(
                      thickness: 1, // Tebal garis bawah
                      color: Colors.grey, // Warna garis bawah
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildPendapatanForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TextField untuk Deskripsi Pendapatan
        Text(
          'Deskripsi',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: controller
                  .deskripsiController, // Gunakan controller yang sudah didefinisikan
              onChanged: (value) {
                controller.deskripsi.value =
                    value; // Simpan input deskripsi ke dalam controller
              },
              decoration: InputDecoration(
                labelText: 'Masukkan Deskripsi', // Placeholder
                prefixIcon: Icon(Icons.edit), // Ikon di dalam field
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10), // Padding agar rapi
              ),
            )),

        // TextField untuk Kategori Pendapatan
        Text(
          'Kategori',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () {
            _showKategoriPendapatanBottomSheet(context);
          },
          child: AbsorbPointer(
            child: Obx(() {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: TextEditingController(
                        text: controller.selectedKategori.value,
                      ),
                      decoration: InputDecoration(
                        hintText: controller.selectedKategori.value.isNotEmpty
                            ? controller.selectedKategori.value
                            : 'Pilih Kategori',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
              );
            }),
          ),
        ),

        // TextField untuk Masuk Saldo Ke
        Text(
          'Masuk Saldo Ke',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () {
            _showAkunBottomSheet(context);
          },
          child: AbsorbPointer(
            child: Obx(() {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: TextEditingController(
                        text: controller.selectedAkun.value,
                      ),
                      decoration: InputDecoration(
                        hintText: controller.selectedAkun.value.isNotEmpty
                            ? controller.selectedAkun.value
                            : 'Pilih Akun',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
              );
            }),
          ),
        ),

        // TextField untuk Tanggal Pendapatan
        Text(
          'Tanggal',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () async {
            DateTime? selectedDates = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (selectedDates != null) {
              controller.selectedDates.value =
                  "${selectedDates.day}-${selectedDates.month}-${selectedDates.year}";
            }
          },
          child: AbsorbPointer(
            child: Obx(() {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: TextEditingController(
                        text: controller.selectedDates.value,
                      ),
                      decoration: InputDecoration(
                        hintText: controller.selectedDates.value.isNotEmpty
                            ? controller.selectedDates.value
                            : 'Pilih Tanggal',
                        prefixIcon: Icon(Icons.calendar_today),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label untuk field input
          Text(
            label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 5),
          // TextField tanpa border dengan logo di dalam
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey),
              hintText: 'Masukkan $label',
              border: InputBorder.none, // Hilangkan outline/border
              contentPadding: EdgeInsets.symmetric(
                  vertical: 10), // Padding agar terlihat lebih rapi
            ),
          ),

          Divider(
            thickness: 1, // Tebal garis
            color: Colors.grey, // Warna garis pembatas
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTile(String accountName, String amountString,
      Color amountColor, String iconPath) {
    // Periksa jika iconPath mengandung path lokal (contoh: "assets/icons/bni.jpg")
    bool isLocalAsset = iconPath.startsWith("assets/");

    return ListTile(
      leading: isLocalAsset
          ? Image.asset(
              iconPath, // Gunakan Image.asset untuk ikon lokal
              width: 40,
              height: 40,
              errorBuilder: (context, error, stackTrace) {
                // Jika ada error, tampilkan ikon default
                return Image.asset('assets/icons/default_icon.png',
                    width: 40, height: 40);
              },
            )
          : Image.network(
              iconPath, // Jika path bukan lokal, gunakan Image.network
              width: 40,
              height: 40,
              errorBuilder: (context, error, stackTrace) {
                // Jika URL tidak valid, tampilkan ikon default
                return Image.asset('assets/icons/default_icon.png',
                    width: 40, height: 40);
              },
            ),
      title: Text(accountName),
      subtitle: Text(amountString, style: TextStyle(color: amountColor)),
    );
  }

  void _showAkunBottomSheet(BuildContext context) {
    final List<Map<String, dynamic>> akunList = [
      {'nama_akun': 'BNI', 'icon': 'assets/icons/bni.jpg'},
      // Akun lainnya...
    ];

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          height: 300,
          child: Obx(() {
            if (controller.accounts.isEmpty && controller.creditCards.isEmpty) {
              return Center(
                child: Text('Tidak ada akun atau kartu tersedia'),
              );
            } else {
              return ListView.builder(
                itemCount:
                    controller.accounts.length + controller.creditCards.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> item;
                  if (index < controller.accounts.length) {
                    item = controller.accounts[index];
                    return ListTile(
                      leading: Icon(Icons.account_balance_wallet),
                      title: Text(item['nama_akun']),
                      subtitle: Text('Saldo: ${item['saldo_awal']}'),
                      onTap: () {
                        controller.selectedAkun.value = item['nama_akun'];
                        Navigator.pop(context);
                      },
                    );
                  } else {
                    // Menampilkan data kartu kredit
                    item = controller
                        .creditCards[index - controller.accounts.length];
                    return ListTile(
                      leading: Icon(Icons.credit_card),
                      title: Text(item['namaKartu']),
                      subtitle: Text('Limit: ${item['limitKredit']}'),
                      onTap: () {
                        controller.selectedAkun.value = item['namaKartu'];
                        Navigator.pop(context);
                      },
                    );
                  }
                },
              );
            }
          }),
        );
      },
    );
  }

// Fungsi buttomsheet kategori pengeluaran

  void _showKategoriBottomSheet(BuildContext context) {
    final List<Map<String, dynamic>> kategoriList = [
      {'labels': 'Makan', 'icon': 'assets/icons/makanan.png'},
      {'labels': 'Transportasi', 'icon': 'assets/icons/cars.png'},
      {'labels': 'Belanja', 'icon': 'assets/icons/shop2.png'},
      {'labels': 'Hiburan', 'icon': 'assets/icons/hiburan.png'},
      {'labels': 'Pendidikan', 'icon': 'assets/icons/pendidikan.png'},
      {'labels': 'Rumah Tangga', 'icon': 'assets/icons/rt.png'},
      {'labels': 'Investasi', 'icon': 'assets/icons/investasi.png'},
      {'labels': 'Kesehatan', 'icon': 'assets/icons/kesehatan.png'},
      {'labels': 'Liburan', 'icon': 'assets/icons/liburan.png'},
      {'labels': 'Perbaikan Rumah', 'icon': 'assets/icons/rumah.png'},
      {'labels': 'Pakaian', 'icon': 'assets/icons/outfit.png'},
      {'labels': 'Internet', 'icon': 'assets/icons/internet.png'},
      {'labels': 'Olahraga & Gym', 'icon': 'assets/icons/gym.png'},
      {'labels': 'Lainnya', 'icon': 'assets/icons/lainnya.png'},
    ];

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          height:
              MediaQuery.of(context).size.height * 0.6, // 60% of screen height
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Kategori',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: GridView.builder(
                    shrinkWrap:
                        true, // Prevents GridView from expanding infinitely
                    physics:
                        NeverScrollableScrollPhysics(), // Disable GridView scrolling
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // Number of columns in grid
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio:
                          0.7, // Adjusted for better space for text
                    ),
                    itemCount: kategoriList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final kategori = kategoriList[index];
                      return GestureDetector(
                        onTap: () {
                          // Simpan kategori yang dipilih di controller
                          controller.selectedKategori.value =
                              kategori['labels'];
                          Navigator.pop(context); // Tutup bottom sheet
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30, // Ukuran icon
                              backgroundColor: Colors.grey[200],
                              child: Image.asset(
                                kategori[
                                    'icon'], // Menampilkan gambar dari assets
                                width: 28, // Ukuran gambar
                                height: 28,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: 70, // Batasan lebar teks
                              child: Text(
                                kategori[
                                    'labels'], // Menggunakan 'labels' yang benar
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center, // Rata tengah
                                softWrap: true, // Mengizinkan pembungkusan teks
                                overflow:
                                    TextOverflow.visible, // Tidak overflow
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

// Fungsi buttomsheet kategori penghasilan
  void _showKategoriPendapatanBottomSheet(BuildContext context) {
    final List<Map<String, dynamic>> kategoriPendapatanList = [
      {'label': 'Gaji', 'icon': 'assets/icons/gaji.png'},
      {'label': 'Investasi', 'icon': 'assets/icons/investasi.png'},
      {'label': 'Bonus', 'icon': 'assets/icons/hadiah.png'},
      {'label': 'Uang Saku', 'icon': 'assets/icons/uangsaku.png'},
      {'label': 'Lainnya', 'icon': 'assets/icons/lainnya.png'},
    ];

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          height:
              MediaQuery.of(context).size.height * 0.6, // 60% of screen height
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Kategori',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: GridView.builder(
                    shrinkWrap:
                        true, // Prevents GridView from expanding infinitely
                    physics:
                        NeverScrollableScrollPhysics(), // Disable GridView scrolling
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // Number of columns in grid
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio:
                          0.7, // Adjusted for better space for text
                    ),
                    itemCount: kategoriPendapatanList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final kategori = kategoriPendapatanList[index];
                      return GestureDetector(
                        onTap: () {
                          // Simpan kategori yang dipilih di controller
                          controller.selectedKategori.value = kategori['label'];
                          Navigator.pop(context); // Tutup bottom sheet
                        },
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30, // Ukuran icon
                              backgroundColor: Colors.grey[200],
                              child: Image.asset(
                                kategori[
                                    'icon'], // Menampilkan gambar dari assets
                                width: 28, // Ukuran gambar
                                height: 28,
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: 70, // Batasan lebar teks
                              child: Text(
                                kategori[
                                    'label'], // Menggunakan 'labels' yang benar
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center, // Rata tengah
                                softWrap: true, // Mengizinkan pembungkusan teks
                                overflow:
                                    TextOverflow.visible, // Tidak overflow
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  final List<Map<String, String>> categories = [
    {'labels': 'Makan', 'icon': 'assets/icons/makanan.png'},
    {'labels': 'Transportasi', 'icon': 'assets/icons/cars.png'},
    {'labels': 'Belanja', 'icon': 'assets/icons/shop2.png'},
    {'labels': 'Hiburan', 'icon': 'assets/icons/hiburan.png'},
    {'labels': 'Pendidikan', 'icon': 'assets/icons/pendidikan.png'},
    {'labels': 'Rumah Tangga', 'icon': 'assets/icons/rt.png'},
    {'labels': 'Investasi', 'icon': 'assets/icons/investasi.png'},
    {'labels': 'Kesehatan', 'icon': 'assets/icons/kesehatan.png'},
    {'labels': 'Liburan', 'icon': 'assets/icons/liburan.png'},
    {'labels': 'Perbaikan Rumah', 'icon': 'assets/icons/rumah.png'},
    {'labels': 'Pakaian', 'icon': 'assets/icons/outfit.png'},
    {'labels': 'Internet', 'icon': 'assets/icons/internet.png'},
    {'labels': 'Olahraga & Gym', 'icon': 'assets/icons/gym.png'},
    {'labels': 'Lainnya', 'icon': 'assets/icons/lainnya.png'},
  ];

  // Fungsi untuk menampilkan pilihan kategori
  void showCategorySelection(
      BuildContext context, List<String> existingCategories) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext context) {
          return SingleChildScrollView(
            // Tambahkan ini
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: categories.map((category) {
                  String label = category['labels']!;
                  String iconPath = category['icon']!;

                  return ListTile(
                    leading: Image.asset(iconPath, width: 24, height: 24),
                    title: Text(label),
                    enabled: !existingCategories.contains(label),
                    onTap: existingCategories.contains(label)
                        ? null
                        : () {
                            Navigator.pop(context);
                            _showValueLimitModal(context, label);
                          },
                  );
                }).toList(),
              ),
            ),
          );
        });
  }

  // Month Container with Month on top and Year below
  Widget buildMonthContainer(String monthYear, [bool isCurrent = false]) {
    final parts = monthYear.split(" ");
    final month = parts[0];
    final year = parts[1];

    return Container(
      width: 90,
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: isCurrent ? Color(0xFF1E2147) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        boxShadow: isCurrent
            ? [
                BoxShadow(
                  color: Color.fromARGB(255, 189, 189, 189).withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            month,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2),
          Text(
            year,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Create a NumberFormat for Rupiah
  final NumberFormat rupiahFormat = NumberFormat.currency(
    locale: 'id', // Indonesian locale
    symbol: 'Rp ', // Currency symbol for Rupiah
    decimalDigits: 0, // No decimal places
  );

// Transaction Group by Date
  Widget buildTransactionItem(
    String date,
    String amount,
    String category,
    BataspengeluaranController controller,
  ) {
    return StreamBuilder<double>(
      stream: controller.getTotalPengeluaran(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        double amountValue = snapshot.data ?? 0.0;

        return FutureBuilder<double>(
          future: controller.getBatasPengeluaran(category),
          builder: (context, futureSnapshot) {
            if (futureSnapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (futureSnapshot.hasError) {
              return Text('Error: ${futureSnapshot.error}');
            }

            double target = futureSnapshot.data ?? 0.0;
            double progress = amountValue / (target > 0 ? target : 1);

            // Find the appropriate icon based on the category
            String iconPath = 'assets/icons/default.png'; // Default icon
            for (var cat in categories) {
              if (cat['labels'] == category) {
                iconPath = cat['icon']!;
                break;
              }
            }
            double iconSize = 48; // Icon size

            return Container(
              margin: EdgeInsets.symmetric(vertical: 4),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Replace CircleAvatar with Image
                      Image.asset(
                        iconPath,
                        width: iconSize,
                        height: iconSize,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 4),
                            Text(date, style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showEditDialog(
                              context, category, amountValue, target);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Divider(thickness: 1, color: Colors.grey.withOpacity(0.5)),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Tersedia",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                rupiahFormat.format(amountValue),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Target",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                          SizedBox(height: 4),
                          Text(
                            rupiahFormat.format(target),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      Container(
                        height: 80,
                        width: 20,
                        child: RotatedBox(
                          quarterTurns: -1,
                          child: LinearProgressIndicator(
                            value: progress.clamp(0.0, 1.0),
                            backgroundColor: Colors.grey.withOpacity(0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progress >= 1.0 ? Colors.red : Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showEditDialog(
    BuildContext context,
    String category,
    double amountValue,
    double target,
  ) {
    final _formKey = GlobalKey<FormState>();
    final _amountController = TextEditingController();
    final NumberFormat currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    controller.getBatasPengeluaran(category).then((limitAmount) {
      _amountController.text = limitAmount.toStringAsFixed(0);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit Batas Pengeluaran'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Jumlah (Rp)'),
                    controller: _amountController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Silakan masukkan jumlah';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      // Menghapus semua karakter non-digit untuk menghitung jumlah
                      String numericValue =
                          value.replaceAll(RegExp(r'[^0-9]'), '');

                      // Mengonversi string numerik ke double dan memformatnya
                      if (numericValue.isNotEmpty) {
                        double jumlah = double.tryParse(numericValue) ?? 0.0;

                        // Memperbarui TextField dengan format mata uang
                        _amountController.value = TextEditingValue(
                          text: currencyFormatter.format(jumlah),
                          selection: TextSelection.collapsed(
                              offset: currencyFormatter.format(jumlah).length),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Batal'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Text('Simpan'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Menghapus simbol dan format sebelum parsing
                    String rawValue = _amountController.text
                        .replaceAll(RegExp(r'[^0-9]'), '');
                    double amount = double.tryParse(rawValue) ?? 0.0;

                    controller.updateTransactionItem(category, amount);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        },
      );
    });
  }

// Widget untuk membangun grup transaksi berdasarkan tanggal
  Widget buildTransactionGroup(
    String date,
    List<Map<String, dynamic>> transactions,
    BataspengeluaranController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tanggal grup
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            date, // Menampilkan tanggal
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
        ),
        // List transaksi di dalam grup
        Column(
          children: transactions.map((transaction) {
            return buildTransactionItem(
              transaction['date']!,
              transaction['amount'].toString(), // Mengubah nominal ke string
              transaction['category']!,
              controller, // Pass the controller
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showValueLimitModal(BuildContext context, String kategori) {
    TextEditingController jumlahController = TextEditingController();
    final NumberFormat currencyFormatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
          ),
          title: Text(
            'Masukkan Batas Pengeluaran untuk $kategori',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: Container(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: jumlahController,
              decoration: InputDecoration(
                labelText: 'Jumlah (Rp)',
                labelStyle: TextStyle(color: Colors.blueGrey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded border
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.blueGrey),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // Remove non-digit characters
                String numericValue = value.replaceAll(RegExp(r'[^0-9]'), '');

                // Convert to double and format
                if (numericValue.isNotEmpty) {
                  double jumlah = double.tryParse(numericValue) ?? 0.0;

                  // Update TextField with currency format
                  jumlahController.value = TextEditingValue(
                    text: currencyFormatter.format(jumlah),
                    selection: TextSelection.collapsed(
                        offset: currencyFormatter.format(jumlah).length),
                  );
                }
              },
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // Button text color
              ),
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // Button text color
              ),
              child: Text('Simpan'),
              onPressed: () {
                // Remove symbols before parsing
                String rawValue =
                    jumlahController.text.replaceAll(RegExp(r'[^0-9]'), '');
                double jumlah = double.tryParse(rawValue) ?? 0.0;

                // Add spending limit
                controller.addBatasPengeluaran(kategori, jumlah);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
