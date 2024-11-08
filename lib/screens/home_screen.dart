import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('reminder')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No reminders added yet."));
          }

          final reminders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reminders.length,
            itemBuilder: (context, index) {
              var reminder = reminders[index].data() as Map<String, dynamic>;
              String medicineName = reminder['medicineName'] ?? '';
              String medicineType = reminder['medicineType'] ?? '';
              String medicinePower = reminder['medicinePower'] ?? '';
              int pillCount = reminder['pillCount'] ?? 0;
              DateTime dateTime = reminder['dateTime'].toDate();

              return ReminderCard(
                medicineName: medicineName,
                medicineType: medicineType,
                pillCount: pillCount,
                medicinePower: medicinePower,
                time: dateTime.toString(),
              );
            },
          );
        },
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
