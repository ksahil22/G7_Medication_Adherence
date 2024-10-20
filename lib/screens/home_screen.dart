import 'package:flutter/material.dart';
import 'package:medication_adherence_app/components/reminder_card.dart';
import 'package:medication_adherence_app/screens/chat_screen.dart';
import 'package:medication_adherence_app/screens/reminder_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeView(),
    const ReminderView(),
    const ChatAIView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'MediAlert',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Add your logout functionality here
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white, // Selected item color
        unselectedItemColor: Colors.white70, // Unselected item color
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_rounded,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications_active_outlined,
            ),
            label: 'Reminder',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_outlined,
            ),
            label: 'Chat AI',
          ),
        ],
      ),
    );
  }
}

// Home Screen with welcome message and reminders
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Gracy!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Current Reminders',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          // SizedBox(height: 8),
          ReminderCard(
            medicineName: 'Aspirin',
            pillsCount: 2,
            time: '9:00 AM',
          ),
          ReminderCard(
            medicineName: 'Paracetamol',
            pillsCount: 1,
            time: '2:00 PM',
          ),
        ],
      ),
    );
  }
}

// Placeholder for Reminder View
class ReminderView extends StatelessWidget {
  const ReminderView({super.key});

  @override
  Widget build(BuildContext context) {
    return ReminderScreen();
  }
}

// Placeholder for Chat AI View
class ChatAIView extends StatelessWidget {
  const ChatAIView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChatScreen();
  }
}
