import 'package:flutter/material.dart';

class DetailInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const DetailInfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 32, color: Colors.white70),
              const SizedBox(height: 12.0),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(title, style: TextStyle(color: Colors.white70)),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
