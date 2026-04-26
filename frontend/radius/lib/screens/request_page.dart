import 'package:flutter/material.dart';

class RequestPage extends StatelessWidget {
  final Function(String) onSelectChat;

  const RequestPage({super.key, required this.onSelectChat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Request Saya",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text("+ Buat Baru"),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ACTIVE CARD
          GestureDetector(
            onTap: () => onSelectChat("Budi Santoso"),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Aktif", style: TextStyle(color: Colors.green)),
                    SizedBox(height: 8),
                    Text(
                      "Butuh bantuan pindahan minggu depan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text("1 helper • 1 pesan"),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // COMPLETED CARD
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Selesai"),
                  SizedBox(height: 8),
                  Text("Pinjam tangga untuk ganti lampu"),
                  SizedBox(height: 6),
                  Text("1 helper • 0 pesan"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
