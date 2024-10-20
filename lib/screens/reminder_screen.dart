import 'package:flutter/material.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  final TextEditingController _medicationNameController =
      TextEditingController();
  final TextEditingController _medicationTypeController =
      TextEditingController();
  int _pillCount = 1;
  String? _selectedPower = 'mg';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Method to show date and time picker
  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add Reminder",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            _buildTextField(_medicationNameController, 'Enter Medication Name'),
            const SizedBox(height: 16),
            _buildTextField(_medicationTypeController, 'Type'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildPillCounter(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: _buildDropdown(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDateTimePicker(context),
            const Spacer(),
            _buildAddButton(),
          ],
        ),
      ),
    );
  }

  // Method to build a text field with the desired decoration
  Widget _buildTextField(TextEditingController controller, String hintText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
      ),
    );
  }

  // Method to build pill counter with plus-minus icons
  Widget _buildPillCounter() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () {
              setState(() {
                if (_pillCount > 0) _pillCount--;
              });
            },
          ),
          Text(
            '$_pillCount Pills',
            style: const TextStyle(fontSize: 16),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                _pillCount++;
              });
            },
          ),
        ],
      ),
    );
  }

  // Method to build dropdown for selecting the power (e.g., mg)
  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedPower,
      items: ['mg', 'g', 'ml'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedPower = newValue;
        });
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
      ),
    );
  }

  // Method to build date and time picker button
  Widget _buildDateTimePicker(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDateTime(context),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDate == null || _selectedTime == null
                  ? 'Select Date & Time'
                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} ${_selectedTime!.format(context)}',
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.calendar_month_rounded, color: Colors.black),
          ],
        ),
      ),
    );
  }

  // Method to build the 'Add' button
  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // Handle the add button press
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Add',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
