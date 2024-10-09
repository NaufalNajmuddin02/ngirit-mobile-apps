import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../controllers/batas_pengeluaran_controller.dart';

class BatasPengeluaranView extends StatelessWidget {
  final BatasPengeluaranController controller =
      Get.put(BatasPengeluaranController());

  final Map<String, IconData> categoryIcons = {
    'Belanja': Icons.shopping_cart,
    'Alat Mandi': Icons.bathtub,
    'Makan': Icons.fastfood,
    'Liburan': Icons.beach_access,
    'Transportasi': Icons.directions_car,
    'Kesehatan': Icons.local_hospital,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
          Container(
            height: 90,
            decoration: BoxDecoration(
              color: Color(0xFF1E2147),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(40),
              ),
            ),
          ),
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
          Positioned(
            top: 30,
            right: 12,
            child: IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
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
                        children: categoryIcons.keys.map((kategori) {
                          return ListTile(
                            leading: Icon(categoryIcons[kategori]),
                            title: Text(kategori),
                            onTap: () {
                              Navigator.pop(context);
                              _showInputModal(context, kategori);
                            },
                          );
                        }).toList(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Main content with padding to move it down
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: controller
                  .getBatasPengeluaranStream(), // Gunakan fungsi query dengan user_id
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Jika data sedang di-load, tampilkan loading spinner
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  // Tampilkan error jika ada masalah dengan data
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  // Jika tidak ada data pengeluaran
                  return Center(child: Text('Tidak ada data pengeluaran.'));
                }

                final batasPengeluaranList = snapshot.data!.docs;

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: batasPengeluaranList.length,
                  itemBuilder: (context, index) {
                    var batasPengeluaran = batasPengeluaranList[index];
                    var kategori =
                        batasPengeluaran['kategori'] ?? 'Tidak diketahui';
                    var jumlah = batasPengeluaran['jumlah'] ?? 0;
                    var documentId = batasPengeluaran.id;
                    var tanggal =
                        (batasPengeluaran['tanggal'] as Timestamp).toDate();

                    IconData? icon = categoryIcons[kategori] ?? Icons.help;

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: Icon(icon, color: Colors.blue, size: 30),
                        title: Text(
                          kategori,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tanggal: ${tanggal.toLocal().toString().split(' ')[0]}',
                              style: TextStyle(fontSize: 10),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Jumlah: Rp $jumlah',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Batas: Rp ${controller.spendingLimitsByCategory[kategori] ?? 0.0}',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Obx(() {
                              double progress = jumlah /
                                  (controller
                                          .spendingLimitsByCategory[kategori] ??
                                      1.0);
                              Color progressColor = progress >= 1
                                  ? Colors.red
                                  : progress >= 0.75
                                      ? Colors.orange
                                      : Colors.blue;

                              return LinearProgressIndicator(
                                value: progress.clamp(0.0, 1.0),
                                backgroundColor: Colors.grey[300],
                                color: progressColor,
                              );
                            }),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _showEditModal(
                                    context, kategori, jumlah, documentId);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _confirmDelete(context, documentId);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
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
                  Get.toNamed('/batas');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showInputModal(BuildContext context, String kategori) {
  final controller = Get.find<BatasPengeluaranController>();
  double valueJumlah = 0.0;
  double valueLimit = 0.0;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Center(
          child: Text(
            'Tambah Pengeluaran - $kategori',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Jumlah Pengeluaran',
                  hintText: 'Masukkan jumlah pengeluaran',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.money),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  valueJumlah = double.tryParse(value) ?? 0.0;
                },
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Batas Pengeluaran',
                  hintText: 'Masukkan batas pengeluaran',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.warning),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  valueLimit = double.tryParse(value) ?? 0.0;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Batal'),
            style: TextButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (valueJumlah > 0 && valueLimit > 0) {
                controller.setSpendingLimit(valueLimit, kategori);
                controller.addBatasPengeluaran(kategori, valueJumlah);
                Navigator.of(context).pop();
              } else {
                Get.snackbar(
                    'Kesalahan', 'Jumlah dan batas harus lebih besar dari 0');
              }
            },
            child: Text('Simpan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Color.fromARGB(255, 255, 255, 255),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    },
  );
}

void _showEditModal(BuildContext context, String kategori, double currentAmount,
    String documentId) {
  final controller = Get.find<BatasPengeluaranController>();
  double newAmount = currentAmount;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Center(
          child: Text(
            'Edit Pengeluaran - $kategori',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Jumlah Pengeluaran',
                  hintText: 'Masukkan jumlah pengeluaran',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.money),
                ),
                keyboardType: TextInputType.number,
                controller:
                    TextEditingController(text: currentAmount.toString()),
                onChanged: (value) {
                  newAmount = double.tryParse(value) ?? currentAmount;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Batal'),
            style: TextButton.styleFrom(
              foregroundColor: const Color.fromARGB(255, 255, 255, 255),
              textStyle: TextStyle(fontSize: 16),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (newAmount > 0) {
                // Update the spending amount in Firestore
                controller.firestore
                    .collection('batas_pengeluaran')
                    .doc(documentId)
                    .update({'jumlah': newAmount});
                Navigator.of(context).pop();
              } else {
                Get.snackbar('Kesalahan', 'Jumlah harus lebih besar dari 0');
              }
            },
            child: Text('Simpan'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Color.fromARGB(255, 255, 255, 255),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    },
  );
}

void _confirmDelete(BuildContext context, String documentId) {
  final controller = Get.find<BatasPengeluaranController>();

  // Fetch the document to get the category before deletion
  controller.firestore
      .collection('batas_pengeluaran')
      .doc(documentId)
      .get()
      .then((doc) {
    if (doc.exists) {
      String category = doc['kategori']; // Get the category from the document

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Center(
              child: Text(
                'Konfirmasi Hapus',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            content: Text('Apakah Anda yakin ingin menghapus pengeluaran ini?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Batal'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Delete the batas_pengeluaran document
                  await controller.firestore
                      .collection('batas_pengeluaran')
                      .doc(documentId)
                      .delete();

                  // Delete the corresponding spending limit document
                  String spendingLimitDocId = '${controller.userId}_$category';
                  await controller.firestore
                      .collection('spending_limits')
                      .doc(spendingLimitDocId)
                      .delete();

                  Navigator.of(context).pop();
                  Get.snackbar('Sukses',
                      'Pengeluaran dan batas pengeluaran berhasil dihapus');
                },
                child: Text('Hapus'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
    } else {
      Get.snackbar('Gagal', 'Pengeluaran tidak ditemukan.');
    }
  }).catchError((error) {
    Get.snackbar('Gagal', 'Terjadi kesalahan: $error');
  });
}
