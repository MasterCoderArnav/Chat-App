import 'package:chat_app/widgets/chat/messages.dart';
import 'package:chat_app/widgets/chat/new_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

enum MenuAction { logout }

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    final fbm = FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.onMessage.listen((event) {
      print('Foreground message title: ${event.notification!.title}');
      print('Foreground message body: ${event.notification!.body}');
    });

    Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
      print('background message title: ${message.notification?.title}');
      print('background message: ${message.notification?.body}');
      return Future.delayed(Duration.zero); //Mock Future
    }

    FirebaseMessaging.onBackgroundMessage((message) {
      print('background message title: ${message.notification?.title}');
      print('background message: ${message.notification?.body}');
      return Future.delayed(Duration.zero);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Chat'),
        centerTitle: true,
        elevation: 0.0,
        actions: [
          PopupMenuButton(
            onSelected: (value) async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Logout?'),
                    content: const Text('Are you sure you want to logout'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Logout'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('No'),
                      )
                    ],
                  );
                },
              ).then((value) {
                return value ?? false;
              });
              if (shouldLogout) {
                FirebaseAuth.instance.signOut();
              } else {
                return;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('LogOut'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: const [
          Expanded(
            child: Messages(),
          ),
          NewMessages(),
        ],
      ),
    );
  }
}
