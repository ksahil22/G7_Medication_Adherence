import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medication_adherence_app/components/reminder_card.dart';
import 'package:medication_adherence_app/views/chat_screen.dart';
import 'package:medication_adherence_app/views/reminder_screen.dart';
import 'package:medication_adherence_app/viewmodel/notification_service.dart';

class HomeScreen extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final bool enableNotifications;

  const HomeScreen({
    required this.auth,
    required this.firestore,
    required this.enableNotifications,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState(
      auth: auth,
      firestore: firestore,
      enableNotifications: enableNotifications);
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final bool enableNotifications;

  _HomeScreenState({
    required this.auth,
    required this.firestore,
    required this.enableNotifications,
  }) : this.screens = [
          HomeView(
            firestore: firestore,
            firebaseAuth: auth,
            enableNotifications: enableNotifications,
          ),
          ReminderView(
            firebaseAuth: auth,
            firestore: firestore,
          ),
          const ChatAIView(),
        ];

  List<Widget> screens;

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
      body: screens[_currentIndex],
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

  @override
  void initState() {
    super.initState();
  }

  void onClickedNotifications(String? payload) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          auth: auth,
          firestore: firestore,
          enableNotifications: enableNotifications,
        ),
      ),
    );
  }
}

// Home Screen with welcome message and reminders
class HomeView extends StatelessWidget {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final bool enableNotifications;

  const HomeView({
    required this.firestore,
    required this.firebaseAuth,
    required this.enableNotifications,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore
              .collection('users')
              .doc(firebaseAuth.currentUser!.uid)
              .collection('reminder')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

                // Format the time as "hour : minutes am/pm"
                String formattedTime = DateFormat('hh:mm a').format(dateTime);

                log("Date: ${dateTime.day} ${dateTime.month} ${dateTime.year} $formattedTime");
                if (enableNotifications) {
                  NotificationService.scheduleNotification(
                    "Reminder Title",
                    "Don't forget to take the medicine",
                    dateTime,
                  );
                }

                return ReminderCard(
                  medicineName: medicineName,
                  medicineType: medicineType,
                  pillCount: pillCount,
                  medicinePower: medicinePower,
                  time: formattedTime,
                  onDelete: () {
                    // Delete the reminder from the list and database
                    reminders.removeAt(index);
                    // Optional: delete from Firebase or other database
                    // await reminders[index].reference.delete();
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// Placeholder for Reminder View
class ReminderView extends StatelessWidget {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  const ReminderView({required this.firebaseAuth, required this.firestore});

  @override
  Widget build(BuildContext context) {
    return ReminderScreen(
      firebaseAuth: firebaseAuth,
      firestore: firestore,
    );
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
