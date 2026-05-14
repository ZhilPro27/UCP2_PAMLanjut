import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  final bool isKondisi;

  const StatusBadge({
    super.key,
    required this.status,
    this.isKondisi = false,
  });

  @override
  Widget build(BuildContext context) {
    Color getBadgeColor() {
      if (isKondisi) {
        switch (status.toLowerCase()) {
          case 'bagus':
            return const Color(0xFF16a34a); // Green
          case 'rusak kecil':
            return const Color(0xFFca8a04); // Yellow
          case 'butuh perawatan':
            return const Color(0xFFea580c); // Orange
          case 'rusak berat':
            return const Color(0xFFdc2626); // Red
          default:
            return const Color(0xFF6b7280); // Gray
        }
      } else {
        switch (status.toLowerCase()) {
          case 'tersedia':
            return const Color(0xFF16a34a); // Green
          case 'tidak tersedia':
            return const Color(0xFF6b7280); // Gray
          case 'maintenance':
            return const Color(0xFF2563eb); // Blue
          default:
            return const Color(0xFF6b7280); // Gray
        }
      }
    }

    return ShadBadge(
      backgroundColor: getBadgeColor(),
      child: Text(
        status.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
