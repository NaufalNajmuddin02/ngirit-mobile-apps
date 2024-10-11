// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/cash_flow_controller.dart';

// class CashFlowView extends StatelessWidget {
//   final CashFlowController controller = Get.put(CashFlowController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Background Gradient
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.blue.shade900, // Light blue
//                   Colors.white, // Dark blue
//                 ],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//           ),
//           // Upper curve design
//           Container(
//             height: 90,
//             decoration: BoxDecoration(
//               color: Color(0xFF1E2147),
//               borderRadius: BorderRadius.vertical(
//                 bottom: Radius.circular(40),
//               ),
//             ),
//           ),
//           // Positioned Batas Pengeluaran text
//           Positioned(
//             top: 40,
//             left: 0,
//             right: 0,
//             child: Center(
//               child: Text(
//                 'Arus',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   fontSize: 22,
//                 ),
//               ),
//             ),
//           ),
//           // Three dots button (overflow menu) positioned at the top-right corner
//           Positioned(
//             top: 30,
//             right: 12,
//             child: IconButton(
//               icon: Icon(Icons.more_vert, color: Colors.white),
//               onPressed: () {
//                 // Show the bottom sheet menu
//                 showModalBottomSheet(
//                   context: context,
//                   backgroundColor: Colors.white, // Set the background color
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.vertical(
//                       top: Radius.circular(20), // Rounded corners
//                     ),
//                   ),
//                   builder: (BuildContext context) {
//                     return Container(
//                       padding: EdgeInsets.all(16),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           ListTile(
//                             leading: Icon(Icons.search), // Search icon
//                             title: Text('Pencarian'),
//                             onTap: () {},
//                           ),
//                           ListTile(
//                             leading: Icon(Icons.filter_list), // Filter icon
//                             title: Text('Filter'),
//                             onTap: () {},
//                           ),
//                           ListTile(
//                             leading: Icon(Icons.date_range), // Date range icon
//                             title: Text('Berdasarkan Periode'),
//                             onTap: () {},
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           // Main content with Padding
//           Padding(
//             padding: const EdgeInsets.only(top: 90.0), // Adjusted top padding
//             child: Column(
//               children: [
//                 Expanded(
//                   child: Obx(
//                     () => ListView(
//                       children: [
//                         // Expenses Section
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                           child: Text(
//                             'Pengeluaran',
//                             style: TextStyle(
//                                 fontSize: 24, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         ListView.builder(
//                           physics: NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           itemCount: controller.expenses.length,
//                           itemBuilder: (context, index) {
//                             final expense = controller.expenses[index];
//                             return Card(
//                               margin: EdgeInsets.symmetric(vertical: 8),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               elevation: 4,
//                               child: ListTile(
//                                 leading: Icon(Icons.arrow_downward,
//                                     color: Colors.red),
//                                 title: Text(expense['nominal'].toString(),
//                                     style: TextStyle(
//                                         color: Colors.red,
//                                         fontWeight: FontWeight.bold)),
//                                 subtitle: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text('Deskripsi: ${expense['deskripsi']}'),
//                                     Text('Kategori: ${expense['kategori']}'),
//                                     Text('Akun: ${expense['akun']}'),
//                                     Text('Tanggal: ${expense['tanggal']}'),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                         // Income Section
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 16.0, vertical: 20.0),
//                           child: Text(
//                             'Pemasukan',
//                             style: TextStyle(
//                                 fontSize: 24, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         ListView.builder(
//                           physics: NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           itemCount: controller.income.length,
//                           itemBuilder: (context, index) {
//                             final income = controller.income[index];
//                             return Card(
//                               margin: EdgeInsets.symmetric(vertical: 8),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               elevation: 4,
//                               child: ListTile(
//                                 leading: Icon(Icons.arrow_upward,
//                                     color: Colors.green),
//                                 title: Text(income['nominal'].toString(),
//                                     style: TextStyle(
//                                         color: Colors.green,
//                                         fontWeight: FontWeight.bold)),
//                                 subtitle: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text('Deskripsi: ${income['deskripsi']}'),
//                                     Text('Kategori: ${income['kategori']}'),
//                                     Text('Akun: ${income['akun']}'),
//                                     Text('Tanggal: ${income['tanggal']}'),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 // Fixed Total Income and Expenses Section
//                 Container(
//                   padding: EdgeInsets.all(16.0),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius:
//                         BorderRadius.vertical(top: Radius.circular(20)),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.2),
//                         blurRadius: 5.0,
//                         spreadRadius: 1.0,
//                       ),
//                     ],
//                   ),
//                   child: Obx(() => Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Total Pengeluaran',
//                                   style: TextStyle(
//                                       fontSize: 16, color: Colors.red)),
//                               Text(
//                                   'Rp ${controller.totalExpenses.toStringAsFixed(0)}',
//                                   style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.red)),
//                             ],
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: [
//                               Text('Total Pemasukan',
//                                   style: TextStyle(
//                                       fontSize: 16, color: Colors.green)),
//                               Text(
//                                   'Rp ${controller.totalIncome.toStringAsFixed(0)}',
//                                   style: TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.green)),
//                             ],
//                           ),
//                         ],
//                       )),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       // Floating Action Button
//       floatingActionButton: FloatingActionButton(
//         shape: CircleBorder(),
//         backgroundColor: Colors.black,
//         onPressed: () {
//           Get.toNamed('/tambahcc');
//         },
//         child: Icon(Icons.add, color: Colors.white, size: 36),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       // Bottom Navigation Bar
//       bottomNavigationBar: BottomAppBar(
//         shape: CircularNotchedRectangle(),
//         notchMargin: 8.0,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               IconButton(
//                 icon: Icon(Icons.home, size: 30),
//                 onPressed: () {
//                   Get.toNamed('/dashboard');
//                 },
//               ),
//               IconButton(
//                 icon: Icon(Icons.swap_horiz, size: 30),
//                 onPressed: () {},
//               ),
//               SizedBox(width: 48), // Space for FloatingActionButton
//               IconButton(
//                 icon: Icon(Icons.bar_chart, size: 30),
//                 onPressed: () {
//                   Get.toNamed('/grafik');
//                 },
//               ),
//               IconButton(
//                 icon: Icon(Icons.settings, size: 30),
//                 onPressed: () {
//                   Get.toNamed('/settings');
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cash_flow_controller.dart';

class CashFlowView extends StatelessWidget {
  final CashFlowController controller = Get.put(CashFlowController());
  // State variable to manage search field visibility
  final RxBool isSearchVisible = false.obs;

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

          // Month Navigation with enhanced styling
          Positioned(
            top: 100,
            left: 16,
            right: 16,
            child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Previous month button with custom style
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            0, 25, 118, 210), // Button color
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(12),
                      ),
                      onPressed: controller.previousMonth,
                      child: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    // Month and year display with card style
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        '${controller.getMonthName(controller.selectedMonth.value)} - ${controller.selectedYear.value}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                    // Next month button with custom style
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            0, 25, 118, 210), // Button color
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(12),
                      ),
                      onPressed: controller.nextMonth,
                      child: Icon(Icons.arrow_forward, color: Colors.white),
                    ),
                  ],
                )),
          ),
          // Main content with Padding
          Padding(
            padding: const EdgeInsets.only(top: 170.0), // Adjusted top padding
            child: Column(
              children: [
                Expanded(
                  child: Obx(
                    () => ListView(
                      children: [
                        // Expenses Section Title
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Pengeluaran',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 23, 23, 23),
                            ),
                          ),
                        ),
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
                                  return Card(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 4,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.redAccent,
                                        child: Icon(Icons.arrow_downward,
                                            color: Colors.white),
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
                        // Income Section Title
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 20.0),
                          child: Text(
                            'Pemasukan',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 43, 43, 43),
                            ),
                          ),
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
                                  return Card(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 4,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.greenAccent,
                                        child: Icon(Icons.arrow_upward,
                                            color: Colors.white),
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
                        BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  child: Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total Pengeluaran',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.red)),
                              Text(
                                  'Rp ${controller.totalExpenses.toStringAsFixed(0)}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Total Pemasukan',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.green)),
                              Text(
                                  'Rp ${controller.totalIncome.toStringAsFixed(0)}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green)),
                            ],
                          ),
                        ],
                      )),
                ),
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
          Get.toNamed('/tambahcc');
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
                icon: Icon(Icons.settings, size: 30),
                onPressed: () {
                  Get.toNamed('/Bataspengeluaran');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
