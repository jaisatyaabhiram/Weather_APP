import 'package:flutter/material.dart';

class AdditionalData extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const AdditionalData({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: 
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Icon(icon, size: 40),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  value,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        
      
    );
  }
}
