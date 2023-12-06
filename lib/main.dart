// import 'dart:io';

// import 'package:file_manager/controller/file_manager_controller.dart';
// import 'package:file_manager/file_manager.dart';
//For UI Stuff
import 'package:flutter/material.dart';
//permission_handler
import 'package:permission_handler/permission_handler.dart';
import 'my_home_page.dart';
void main() {
  runApp(const MyApp());
}

//StatelessWidget means no need to hold any state, won't change over time
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: FutureBuilder<PermissionStatus>(
          future: Permission.storage.request(),
          builder:
              (BuildContext context, AsyncSnapshot<PermissionStatus> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data?.isGranted ?? false) {
                return const MyHomePage(title: 'File Manager');
              } else {
                return const PermissionDeniedPage();
              }
            } else {
              // A page showing a loading spinner
              return const LoadingPage();
            }
          },
        ));
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
class PermissionDeniedPage extends StatelessWidget {
  const PermissionDeniedPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

