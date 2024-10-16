import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cash_flow_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CashFlowView extends StatelessWidget {
  final CashFlowController controller = Get.put(CashFlowController());
  // State variable to manage search field visibility
  final RxBool isSearchVisible = false.obs;
  final TextEditingController nominalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade900,
                  Colors.white,
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
          // Positioned 'Arus' text
          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Arus',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          // Search Field Positioned above 'Arus' text
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Obx(() => Visibility(
                  visible: isSearchVisible.value,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Background color
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              controller.updateSearchQuery(value);
                            },
                            decoration: InputDecoration(
                              labelText: 'Cari',
                              prefixIcon: Icon(Icons.search),
                              border: InputBorder
                                  .none, // No border for better styling
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10), // Padding
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            // Hide the search field and clear the text
                            isSearchVisible.value = false;
                            controller.updateSearchQuery(
                                ''); // Clear the search query
                          },
                        ),
                      ],
                    ),
                  ),
                )),
          ),
          // Three dots button (overflow menu) positioned at the top-right corner
          Positioned(
            top: 30,
            right: 12,
            child: Obx(() => Visibility(
                  visible:
                      !isSearchVisible.value, // Show only when search is hidden
                  child: IconButton(
                    icon: Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () {
                      // Show the bottom sheet menu
                      showModalBottomSheet(
                        context: context,
                        backgroundColor:
                            Colors.white, // Set the background color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20), // Rounded corners
                          ),
                        ),
                        builder: (BuildContext context) {
                          // Example list of categories and accounts
                          List<String> allCategories = [
                            'Makanan',
                            'Minuman',
                            'Transportasi',
                            'Belanja',
                            'Hiburan',
                            'Gaji',
                          ];
                          List<String> allAccounts = [
                            'BRI',
                            'BCA',
                            'Mandiri',
                            'BNI',
                            'Cash',
                          ]; // Example accounts list

                          return Container(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: Icon(Icons.search), // Search icon
                                  title: Text('Aktifkan Pencarian'),
                                  onTap: () {
                                    isSearchVisible.value =
                                        !isSearchVisible.value;
                                  },
                                ),
                                ListTile(
                                  leading:
                                      Icon(Icons.filter_list), // Filter icon
                                  title: Text('Filter'),
                                  onTap: () {
                                    // Show filter options modal
                                    showModalBottomSheet(
                                      context: context,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                      builder: (BuildContext context) {
                                        return Container(
                                          padding: EdgeInsets.all(16),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Pilih Kategori',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(height: 10),
                                              Obx(() => Wrap(
                                                    spacing: 8.0,
                                                    children: allCategories
                                                        .map((category) {
                                                      bool isSelected =
                                                          controller
                                                              .selectedCategories
                                                              .contains(
                                                                  category);
                                                      return FilterChip(
                                                        label: Text(category),
                                                        selected: isSelected,
                                                        onSelected:
                                                            (bool selected) {
                                                          if (selected) {
                                                            controller
                                                                .selectedCategories
                                                                .add(category);
                                                          } else {
                                                            controller
                                                                .selectedCategories
                                                                .remove(
                                                                    category);
                                                          }
                                                        },
                                                      );
                                                    }).toList(),
                                                  )),
                                              SizedBox(height: 20),
                                              Text(
                                                'Pilih Akun',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(height: 10),
                                              Obx(() => Wrap(
                                                    spacing: 8.0,
                                                    children: allAccounts
                                                        .map((account) {
                                                      bool isSelected =
                                                          controller
                                                              .selectedAccounts
                                                              .contains(
                                                                  account);
                                                      return FilterChip(
                                                        label: Text(account),
                                                        selected: isSelected,
                                                        onSelected:
                                                            (bool selected) {
                                                          if (selected) {
                                                            controller
                                                                .selectedAccounts
                                                                .add(account);
                                                          } else {
                                                            controller
                                                                .selectedAccounts
                                                                .remove(
                                                                    account);
                                                          }
                                                        },
                                                      );
                                                    }).toList(),
                                                  )),
                                              SizedBox(height: 10),
                                              ElevatedButton(
                                                child: Text('Terapkan Filter'),
                                                onPressed: () {
                                                  Get.back(); // Close bottom sheet
                                                  // The filtered data will update automatically via controller
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                )),
          ),

          // Month Navigation with enhanced styling and adjacent months
          Positioned(
            top: 100,
            left: 16,
            right: 16,
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Previous month button
                    IconButton(
                      icon:
                          Icon(Icons.arrow_left, size: 40, color: Colors.white),
                      onPressed: controller.previousMonth,
                    ),
                    // Display the previous month
                    Column(
                      children: [
                        Text(
                          '${controller.getMonthName(controller.getPreviousMonth())}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${controller.getPreviousMonthYear()}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    // Current month display
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Color(0xFF1E2147),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 189, 189, 189)
                                .withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${controller.getMonthName(controller.selectedMonth.value)}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${controller.selectedYear.value}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Display the next month
                    Column(
                      children: [
                        Text(
                          '${controller.getMonthName(controller.getNextMonth())}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${controller.getNextMonthYear()}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    // Next month button
                    IconButton(
                      icon: Icon(Icons.arrow_right,
                          size: 40, color: Colors.white),
                      onPressed: controller.nextMonth,
                    ),
                  ],
                )),
          ),

          // Main content with Padding
          Padding(
            padding: const EdgeInsets.only(top: 160.0), // Adjusted top padding
            child: Column(
              children: [
                Expanded(
                  child: Obx(
                    () => ListView(
                      children: [
                        controller.filteredExpenses.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'Belum ada data di bulan ini',
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            : ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: controller.filteredExpenses.length,
                                itemBuilder: (context, index) {
                                  final expense =
                                      controller.filteredExpenses[index];

                                  // Menentukan ikon berdasarkan kategori
                                  String assetPath;

                                  switch (expense['kategori']) {
                                    case 'Makanan':
                                      assetPath =
                                          'assets/icons/icons8-eat-96.png';
                                      break;
                                    case 'Transportasi':
                                      assetPath =
                                          'assets/icons/icons8-cars-96.png';
                                      break;
                                    case 'Hiburan':
                                      assetPath =
                                          'assets/icons/icons8-entertainment-96.png';
                                      break;
                                    case 'Belanja':
                                      assetPath =
                                          'assets/icons/icons8-add-shopping-cart-96.png';
                                      break;
                                    default:
                                      assetPath =
                                          'assets/icons/icons8-no-96.png'; // Ikon default jika kategori tidak cocok
                                  }

                                  return Card(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 4,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: Image.asset(
                                          assetPath,
                                          fit: BoxFit
                                              .cover, // Menyesuaikan gambar dalam CircleAvatar
                                        ),
                                      ),
                                      title: Text(
                                        'Rp ${expense['nominal'].toString()}',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Deskripsi: ${expense['deskripsi']}'),
                                          Text(
                                              'Kategori: ${expense['kategori']}'),
                                          Text('Akun: ${expense['akun']}'),
                                          Text(
                                              'Tanggal: ${expense['tanggal']}'),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                        controller.filteredIncome.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'Belum ada data di bulan ini',
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            : ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: controller.filteredIncome.length,
                                itemBuilder: (context, index) {
                                  final income =
                                      controller.filteredIncome[index];

                                  // Menentukan ikon berdasarkan kategori
                                  String assetPath;

                                  switch (income['kategori']) {
                                    case 'Makanan':
                                      assetPath =
                                          'assets/icons/icons8-eat-96.png';
                                      break;
                                    case 'Transportasi':
                                      assetPath =
                                          'assets/icons/icons8-cars-96.png';
                                      break;
                                    case 'Hiburan':
                                      assetPath =
                                          'assets/icons/icons8-entertainment-96.png';
                                      break;
                                    case 'Belanja':
                                      assetPath =
                                          'assets/icons/icons8-add-shopping-cart-96.png';
                                      break;
                                    default:
                                      assetPath =
                                          'assets/icons/icons8-no-96.png'; // Ikon default jika kategori tidak cocok
                                  }

                                  return Card(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 4,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: Image.asset(
                                          assetPath,
                                          fit: BoxFit
                                              .cover, // Menyesuaikan gambar dalam CircleAvatar
                                        ),
                                      ),
                                      title: Text(
                                        'Rp ${income['nominal'].toString()}',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Deskripsi: ${income['deskripsi']}'),
                                          Text(
                                              'Kategori: ${income['kategori']}'),
                                          Text('Akun: ${income['akun']}'),
                                          Text('Tanggal: ${income['tanggal']}'),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ),
                // Fixed Total Income and Expenses Section
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  child: Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Memposisikan kolom
                        children: [
                          // Kolom untuk Total Pengeluaran
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Rp ${controller.totalExpenses.toStringAsFixed(0)}',
                                style: TextStyle(
                                    fontSize:
                                        15, // Ukuran font lebih besar untuk angka
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                              SizedBox(
                                  height: 4), // Spasi antara angka dan teks
                              Text('Total Pengeluaran',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          const Color.fromARGB(255, 0, 0, 0))),
                            ],
                          ),
                          // Kolom untuk Total Pemasukan
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Rp ${controller.totalIncome.toStringAsFixed(0)}',
                                style: TextStyle(
                                    fontSize:
                                        15, // Ukuran font lebih besar untuk angka
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                              SizedBox(
                                  height: 4), // Spasi antara angka dan teks
                              Text('Total Pemasukan',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: const Color.fromARGB(
                                          255, 37, 37, 37))),
                            ],
                          ),
                          // Kolom untuk Saldo
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Rp ${controller.totalBalanceValue.toStringAsFixed(0)}',
                                style: TextStyle(
                                    fontSize:
                                        15, // Ukuran font lebih besar untuk angka
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                              SizedBox(
                                  height: 4), // Spasi antara angka dan teks
                              Text('Saldo',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          const Color.fromARGB(255, 0, 0, 0))),
                            ],
                          ),
                        ],
                      )),
                ),
                SizedBox(height: 12),
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
                onPressed: () {},
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
                  Get.toNamed('/batas');
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
                    case 2:
                      backgroundColor =
                          Colors.blue; // Warna biru untuk Transfer
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
                            _buildTabItem('Transfer', Colors.blue, 2),
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
                                  controller:
                                      nominalController, // Menggunakan controller
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
                                ),
// Hilangkan koma yang tidak perlu di sini
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
                            case 2:
                              return _buildTransferForm();
                            default:
                              return _buildPengeluaranForm(context);
                          }
                        }),
                        SizedBox(height: 20),
                        // Tombol Save di bagian bawah BottomSheet
                        // Tombol Save di bagian bawah BottomSheet
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            onPressed: () {
                              // Ambil nilai nominal dari nominalController sebagai String
                              String nominal = nominalController.text;

                              // Panggil fungsi untuk menyimpan data ke Firebase
                              controller.saveFormData(
                                  nominal); // Panggil saveFormData() dari controller
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
                              'Save',
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

// Fungsi untuk membuat text field di dalam bottom sheet
  Widget _buildTabItem(String title, Color color, int index) {
    return Expanded(
      child: Obx(() {
        bool isSelected = controller.selectedTab.value == index;
        return GestureDetector(
          onTap: () {
            controller.selectedTab.value = index;
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
                      color: Colors.white, // Selalu putih untuk teks
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

        // TextField untuk Tanggal
        Text(
          'Tanggal',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () async {
            // Tampilkan DatePicker saat pengguna mengetuk field tanggal
            DateTime? selectedDate = await showDatePicker(
              context: context, // Gunakan context di sini
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            // Jika pengguna memilih tanggal, simpan ke controller
            if (selectedDate != null) {
              controller.selectedDate.value =
                  "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
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
                        hintText: controller.selectedDate.value.isNotEmpty
                            ? controller.selectedDate.value
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
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (selectedDate != null) {
              controller.selectedDate.value =
                  "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
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
                        text: controller.selectedDate.value,
                      ),
                      decoration: InputDecoration(
                        hintText: controller.selectedDate.value.isNotEmpty
                            ? controller.selectedDate.value
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

  Widget _buildTransferForm() {
    return Column(
      children: [
        _buildTextField('Deskripsi', Icons.edit),
        _buildTextField('Kategori', Icons.list),
        _buildTextField('Dibayar dengan', Icons.wallet_giftcard),
        _buildTextField('Tanggal', Icons.calendar_today),
      ],
    );
  }

// Fungsi untuk membuat text field di dalam bottom sheet

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
            if (controller.accounts.isEmpty) {
              return Center(
                child: Text('Tidak ada akun tersedia'),
              );
            } else {
              return ListView.builder(
                itemCount: controller.accounts.length,
                itemBuilder: (context, index) {
                  var akun = controller.accounts[index];

                  return ListTile(
                    leading: Icon(
                        Icons.account_balance_wallet), // Ikon bisa disesuaikan

                    title: Text(akun['nama_akun']),

                    subtitle: Text('Saldo: ${akun['saldo_awal']}'),

                    onTap: () {
                      // Update selected akun

                      controller.selectedAkun.value = akun['nama_akun'];

                      Navigator.pop(context); // Tutup bottom sheet
                    },
                  );
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
      {'labels': 'Makanan', 'icon': 'assets/icons/icons8-eat-96.png'},
      {'labels': 'Transportasi', 'icon': 'assets/icons/icons8-cars-96.png'},
      {
        'labels': 'Belanja',
        'icon': 'assets/icons/icons8-add-shopping-cart-96.png'
      },
      {'labels': 'Hiburan', 'icon': 'assets/icons/icons8-entertainment-96.png'},
    ];

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Kategori',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: kategoriList.map((kategori) {
                  return GestureDetector(
                    onTap: () {
                      // Simpan kategori yang dipilih di controller
                      controller.selectedKategori.value = kategori['labels'];
                      Navigator.pop(context); // Tutup bottom sheet
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30, // Ukuran icon
                          backgroundColor: Colors.grey[200],
                          child: Image.asset(
                            kategori['icon'], // Menampilkan gambar dari assets
                            width: 28, // Ukuran gambar
                            height: 28,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          kategori['labels'], // Menggunakan 'labels' yang benar
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }).toList(),
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
      {'labels': 'Makanan', 'icon': 'assets/icons/icons8-eat-96.png'},
      {'labels': 'Transportasi', 'icon': 'assets/icons/icons8-cars-96.png'},
      {
        'labels': 'Belanja',
        'icon': 'assets/icons/icons8-add-shopping-cart-96.png'
      },
      {'labels': 'Hiburan', 'icon': 'assets/icons/icons8-entertainment-96.png'},
    ];

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Kategori Pendapatan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: kategoriPendapatanList.map((kategori) {
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
                            kategori['icon'], // Menampilkan gambar dari assets
                            width: 28, // Ukuran gambar
                            height: 28,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          kategori['labels'], // Menggunakan 'labels' yang benar
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}


