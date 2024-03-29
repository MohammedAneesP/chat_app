import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ningal_chat/bloc/users_list/users_list_bloc.dart';
import 'package:ningal_chat/push_notification.dart';
import 'package:ningal_chat/screens/splash_screen.dart';

import 'firebase_options.dart';

Future firebaseBackgroundMessage(RemoteMessage anMessage) async {
  if (anMessage.notification != null) {
    log("notification recieved latest 1");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PushNotification.getFcmPermission();
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => UsersListBloc())],
      child: MaterialApp(
        theme: ThemeData(),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
