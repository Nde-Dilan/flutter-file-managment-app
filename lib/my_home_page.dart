export 'package:file_manager_flutter/my_home_page.dart';

import 'dart:io';

// import 'package:file_manager/controller/file_manager_controller.dart';
import 'package:file_manager/file_manager.dart';
//For UI Stuff
import 'package:flutter/material.dart';
//permission_handler
// import 'package:permission_handler/permission_handler.dart';
//You can find the SystemNavigator.pop() here to close the app (except if ur on IOS)
import 'package:flutter/services.dart';
//Enable the user to open files
import 'package:open_file/open_file.dart';

import 'custom_app_bar.dart';

//StatefulWidget means needs to hold some state, will change over time and with user interactions
class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //When i launch the app ask for permission after initializing the state
  @override
  void initState() {
    super.initState();
    // requestStoragePermission(context);
  }

  /*void requestStoragePermission(BuildContext context) async {
    PermissionStatus status = await Permission.storage.request();
    if (!status.isGranted) {
      SystemNavigator.pop();
    }
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MyHomePage(title: 'File Manager')),
    );
  }
*/

  final FileManagerController controller = FileManagerController();

  String currentLocation = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(currentLocation: currentLocation),
      body: FileManager(
        controller: controller,
        builder: (BuildContext context, List<FileSystemEntity> snapshot) {
          final List<FileSystemEntity> entities = snapshot;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            itemCount: entities.length,
            itemBuilder: (BuildContext context, int index) {
              FileSystemEntity entity = entities[index];
              return Card(
                child: ListTile(
                  leading: FileManager.isFile(entity)
                      ? (entity.path.endsWith('.jpg') ||
                              entity.path.endsWith('.png') ||
                              entity.path.endsWith('.jpeg')
                          ? Image.file(
                              File(entity.path),
                              width: 24,
                              height: 24,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.feed_outlined,
                              color: Color.fromARGB(58, 7, 5, 5)))
                      : const Icon(Icons.folder, color: Colors.deepOrange),
                  title: Text(
                    FileManager.basename(entity, showFileExtension: true),
                  ),
                  subtitle: subTitle(entity),
                  onTap: () async {
                    // delete  a folder or file
                    // await entity.delete();

                    // rename a folder or file
                    // await entity.rename("newPath");

                    //check exists or not
                    // await entity.exists();

                    //get data of folder or file
                    // DateTime date = (await entity.stat()).modified;

                    if (FileManager.isDirectory(entity)) {
                      controller.openDirectory(entity);
                      // updateLocation(entity.path);
                      // setState(() {});
                    } else if (FileManager.isFile(entity)) {
                      OpenFile.open(entity.path);
                    } else {
                      //close the app
                      SystemNavigator.pop();
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () async {
      //     // print("pressed");
      //     Permission.storage.request();
      //     Navigator.pushAndRemoveUntil(
      //         context,
      //         MaterialPageRoute(
      //             builder: (_) => const MyHomePage(title: "FIle Manager")),
      //         (route) => false);
      //   },
      //   label: const Text("Request File Access Permission"),
      // ),
    );
  }

  void updateLocation(String newLocation) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        currentLocation = newLocation;
      });
    });
  }

  subTitle(FileSystemEntity entity) {
    return FutureBuilder(
      future: entity.stat(),
      builder: (BuildContext context, AsyncSnapshot<FileStat> snapshot) {
        if (snapshot.hasData) {
          if (entity is File) {
            int size = snapshot.data!.size;
            return Text(FileManager.formatBytes(size));
          }
          return Text("${snapshot.data!.modified}");
        } else {
          return const Text("");
        }
      },
    );
  }
}
