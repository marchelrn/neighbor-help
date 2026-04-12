import 'package:flutter/material.dart';
import '../widgets/request_card.dart';

class RequestListPage extends StatelessWidget {
  const RequestListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9FAFB),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Request Saya",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "1 request aktif • 1 selesai",
                    style: TextStyle(color: Color(0xFF6B7280), fontSize: 13),
                  ),
                ],
              ),

              // BUTTON
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16A34A),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("+ Buat Baru"),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 🔥 ACTIVE CARD
          const RequestCard(isActive: true),

          const SizedBox(height: 12),

          // 🔥 COMPLETED CARD
          const RequestCard(isActive: false),
        ],
      ),
    );
  }
}
