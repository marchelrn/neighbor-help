import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_colors.dart';

class PetaAreaPage extends StatefulWidget {
  const PetaAreaPage({super.key});

  @override
  State<PetaAreaPage> createState() => _PetaAreaPageState();
}

class _PetaAreaPageState extends State<PetaAreaPage> {
  String selectedFilter = "Semua";

  final LatLng center = LatLng(1.4748, 124.8421); // Manado

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // =========================
          // 🔥 REAL MAP (FIXED)
          // =========================
          FlutterMap(
            options: MapOptions(initialCenter: center, initialZoom: 15),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.neighborhelp.app',
                maxZoom: 19,
              ),

              // =========================
              // 🔥 MARKERS
              // =========================
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(1.475, 124.84),
                    width: 120,
                    height: 70,
                    child: _markerWidget("Butuh Bantuan", true),
                  ),
                  Marker(
                    point: LatLng(1.476, 124.843),
                    width: 120,
                    height: 70,
                    child: _markerWidget("Angkat Barang", false),
                  ),
                  Marker(
                    point: LatLng(1.473, 124.845),
                    width: 120,
                    height: 70,
                    child: _markerWidget("Pinjam Tangga", false),
                  ),
                ],
              ),
            ],
          ),

          // =========================
          // 🔹 HEADER
          // =========================
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, size: 18),
                          SizedBox(width: 8),
                          Text("Cari area atau request..."),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.filter_list),
                  ),
                ],
              ),
            ),
          ),

          // =========================
          // 🔹 FILTER CHIPS
          // =========================
          Positioned(
            top: 90,
            left: 16,
            right: 16,
            child: SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _filterChip("Semua"),
                  _filterChip("Urgent"),
                  _filterChip("Dekat"),
                  _filterChip("Baru"),
                ],
              ),
            ),
          ),

          // =========================
          // 🔹 FLOAT BUTTON
          // =========================
          Positioned(
            right: 16,
            bottom: 140,
            child: FloatingActionButton(
              onPressed: () {
                // Future: center map
              },
              backgroundColor: Colors.white,
              child: const Icon(Icons.my_location, color: Colors.black),
            ),
          ),

          // =========================
          // 🔹 BOTTOM CARD
          // =========================
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    child: Icon(Icons.person, size: 18),
                  ),
                  const SizedBox(width: 12),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Butuh bantuan pindahan",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "300m • 1 helper",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text("Lihat"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // 🔹 FILTER CHIP
  // =========================
  Widget _filterChip(String label) {
    final bool selected = selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() => selectedFilter = label);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // =========================
  // 🔥 MARKER UI
  // =========================
  Widget _markerWidget(String text, bool urgent) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: urgent ? Colors.red : AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ),
        const Icon(Icons.location_pin, color: Colors.red),
      ],
    );
  }
}
