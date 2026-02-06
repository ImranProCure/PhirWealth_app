import 'package:flutter/material.dart';

class ServiceDetailData {
  final String title;
  final IconData icon;
  final Color color;
  final String description;
  final List<String> features;
  final List<String> benefits;
  final String ctaTitle;
  final String ctaDescription;

  ServiceDetailData({
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
    required this.features,
    required this.benefits,
    required this.ctaTitle,
    required this.ctaDescription,
  });
}