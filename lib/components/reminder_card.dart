import 'package:flutter/material.dart';

class ReminderCard extends StatelessWidget {
  final String medicineName;
  final String medicineType;
  final int pillCount;
  final String medicinePower;
  final String time;
  final VoidCallback onDelete; // Callback for delete action

  const ReminderCard({
    super.key,
    required this.medicineName,
    required this.medicineType,
    required this.pillCount,
    required this.medicinePower,
    required this.time,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        onDelete();
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        color: Colors.black,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                Icons.medication_rounded,
                color: Colors.white,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medicineName,
                      style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    Text(
                      '$pillCount pills',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
