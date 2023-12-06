export 'package:file_manager_flutter/my_home_page.dart';

//For UI Stuff
import 'package:flutter/material.dart';
//permission_handler

class LocationDisplay extends StatefulWidget {
  const LocationDisplay({super.key});
  @override
  LocationDisplayState createState() => LocationDisplayState();
}

class LocationDisplayState extends State<LocationDisplay> {
  String currentLocation = '/';

  void updateLocation(String newLocation) {
    setState(() {
      currentLocation = newLocation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Current Location: $currentLocation',
      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
    );
  }
}
