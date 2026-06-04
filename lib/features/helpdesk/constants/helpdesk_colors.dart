import 'package:flutter/material.dart';

/// Konstanta warna khusus untuk role Helpdesk.
/// Helpdesk menggunakan primary color biru (#3B82F6) untuk
/// membedakan dari Admin (Indigo #4F46E5).
class HelpdeskColors {
  HelpdeskColors._();

  // Primary
  static const Color primary = Color(0xFF3B82F6); // Blue 500
  static const Color primaryDark = Color(0xFF1E40AF); // Blue 800
  static const Color primaryLight = Color(0xFFDBEAFE); // Blue 100

  // Status Colors (khusus Helpdesk - hanya 4 status)
  static const Map<String, Map<String, Color>> statusColors = {
    'signed_assigned': {
      'background': Color(0xFFDBEAFE), // Blue 100
      'text': Color(0xFF1E40AF), // Blue 800
    },
    'in_progress': {
      'background': Color(0xFFEEF2FF), // Indigo 100
      'text': Color(0xFF4F46E5), // Indigo 600
    },
    'resolved': {
      'background': Color(0xFFD1FAE5), // Green 100
      'text': Color(0xFF065F46), // Green 800
    },
    'closed': {
      'background': Color(0xFFE5E7EB), // Gray 100
      'text': Color(0xFF374151), // Gray 700
    },
  };

  // Status Badge Color Map (untuk StatusBadge widget)
  static const Map<String, Color> statusBackground = {
    'signed_assigned': Color(0xFFDBEAFE),
    'in_progress': Color(0xFFEEF2FF),
    'resolved': Color(0xFFD1FAE5),
    'closed': Color(0xFFE5E7EB),
  };

  static const Map<String, Color> statusText = {
    'signed_assigned': Color(0xFF1E40AF),
    'in_progress': Color(0xFF4F46E5),
    'resolved': Color(0xFF065F46),
    'closed': Color(0xFF374151),
  };

  // Role Color
  static const Color roleBackground = Color(0xFFDBEAFE); // Blue 100
  static const Color roleText = Color(0xFF1E40AF); // Blue 800
}
