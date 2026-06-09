import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_colors.dart';

class LocationPickerDialog extends StatefulWidget {
  final LatLng initialCenter;

  const LocationPickerDialog({
    super.key,
    this.initialCenter = const LatLng(1.4748, 124.8421), // Default Manado
  });

  @override
  State<LocationPickerDialog> createState() => _LocationPickerDialogState();
}

class _LocationPickerDialogState extends State<LocationPickerDialog> {
  late final MapController _mapController;
  LatLng _currentCenter = const LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _currentCenter = widget.initialCenter;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 600,
        height: 500,
        child: Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentCenter,
                initialZoom: 15,
                onPositionChanged: (position, hasGesture) {
                  setState(() {
                    _currentCenter = position.center;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
                  subdomains: const ['a', 'b', 'c', 'd'],
                  userAgentPackageName: 'com.neighborhelp.app',
                  maxZoom: 19,
                ),
              ],
            ),

            // Marker at center of screen
            const Center(
              child: Icon(Icons.location_pin, color: Colors.red, size: 40),
            ),

            // Top Header
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Pilih Lokasi Rumahmu",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Confirm Button
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, _currentCenter);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Simpan Lokasi Ini",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
