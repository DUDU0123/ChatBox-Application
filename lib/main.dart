import 'package:camera/camera.dart';
import 'package:chatbox/core/service/locator.dart';
import 'package:chatbox/firebase_options.dart';
import 'package:chatbox/features/presentation/root_widget_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
List<CameraDescription> cameras = [];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeServiceLocator();
  cameras= await availableCameras();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAjw1MzBwJsUdOGpLQeUDhUwHOyrCY61BE",
        authDomain: "official-chatbox-application.firebaseapp.com",
        projectId: "official-chatbox-application",
        storageBucket: "official-chatbox-application.appspot.com",
        messagingSenderId: "414609473719",
        appId: "1:414609473719:web:e12041a79bed5ab66e4d32",
      ),
    );
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const RootWidgetPage(),
  );
}