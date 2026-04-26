import 'package:flutter/material.dart';
import 'chat_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Halo, Keefa 👋",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          "Permintaan bantuan dalam radius 500m",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 30),

        Row(
          children: const [
            Expanded(
              child: StatCard(title: "Sekitar", value: "12"),
            ),
            SizedBox(width: 20),
            Expanded(
              child: StatCard(title: "Permintaan Anda", value: "3"),
            ),
            SizedBox(width: 20),
            Expanded(
              child: StatCard(title: "Selesai", value: "8"),
            ),
          ],
        ),

        const SizedBox(height: 30),

        const Text(
          "Permintaan Sekitar",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 16),

        Expanded(
          child: ListView(
            children: [
              RequestCard(
                name: "Ibu Maria",
                distance: "120m",
                request: "Butuh bantuan membawa belanjaan",
                urgency: "Tinggi",
              ),
              RequestCard(
                name: "Pak John",
                distance: "300m",
                request: "Memperbaiki lampu rusak",
                urgency: "Sedang",
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;

  const StatCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class RequestCard extends StatelessWidget {
  final String name;
  final String distance;
  final String request;
  final String urgency;

  const RequestCard({
    super.key,
    required this.name,
    required this.distance,
    required this.request,
    required this.urgency,
  });

  Color getUrgencyColor() {
    switch (urgency) {
      case "Tinggi":
        return Colors.red;
      case "Sedang":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(distance),
              ],
            ),

            const SizedBox(height: 10),

            Text(request, style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 12),

            Row(
              children: [
                Icon(Icons.warning, color: getUrgencyColor()),
                const SizedBox(width: 6),
                Text(
                  urgency,
                  style: TextStyle(
                    color: getUrgencyColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatPage(receiverName: name),
                        ),
                      );
                    },
                    child: const Text("Chat"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text("Detail"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
