import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  final IconData icon;
  final String time;
  final String temp;
  const HourlyForecast({
    super.key,
    required this.icon,
    required this.time,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 6,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                time,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Icon(icon, size: 32),
            const SizedBox(height: 8),
            Text(temp),
          ],
        ),
      ),
    );
  }
}
