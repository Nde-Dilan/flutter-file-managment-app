export 'package:file_manager_flutter/custom_app_bar.dart';

import 'dart:io';

// import 'package:file_manager/controller/file_manager_controller.dart';
import 'package:file_manager/file_manager.dart';
import 'package:file_manager_flutter/location_display.dart';
//For UI Stuff
import 'package:flutter/material.dart';
//permission_handler
// import 'package:permission_handler/permission_handler.dart';
//You can find the SystemNavigator.pop() here to close the app (except if ur on IOS)
//Enable the user to open files
// import 'package:open_file/open_file.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentLocation;

  CustomAppBar({super.key, required this.currentLocation});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('File Manager'),
      bottom: const PreferredSize(
        preferredSize:  Size.fromHeight(22.0),
        child:  LocationDisplay(),
      ),
      // The rest of your AppBar code...
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20.0);

  final FileManagerController controller = FileManagerController();

  appBar(BuildContext context) {
    return AppBar(
      title: ValueListenableBuilder(
        valueListenable: controller.titleNotifier,
        builder: (BuildContext context, String value, Widget? child) {
          return Text(value);
        },
      ),
      bottom: const PreferredSize(
        preferredSize:
            Size.fromHeight(20.0), // Here you can set the height of the text
        child: Text(
          'Current Location: ', // Replace this with your actual location
          style: TextStyle(color: Colors.white),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => createFolder(context),
          icon: const Icon(
            Icons.create_new_folder_outlined,
          ),
        ),
        IconButton(
          onPressed: () => sort(context),
          icon: Icon(
            Icons.sort_rounded,
          ),
        ),
        IconButton(
          onPressed: () => selectStorage(context),
          icon: Icon(
            Icons.sd_storage_rounded,
          ),
        ),
      ],
      leading: IconButton(
        onPressed: () async {
          await controller.goToParentDirectory();
        },
        icon: Icon(
          Icons.arrow_back,
        ),
      ),
    );
  }

  // Methods
  selectStorage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: FutureBuilder<List<Directory>>(
              future: FileManager.getStorageList(),
              builder: (context, snapshot) {
                final List<FileSystemEntity> storgeList = snapshot.data!;
                return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: storgeList
                        .map((e) => ListTile(
                              title: Text(FileManager.basename(e)),
                              onTap: () {
                                controller.openDirectory(e);
                                Navigator.pop(context);
                              },
                            ))
                        .toList());
              }),
        );
      },
    );
  }

  createFolder(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var folderCreate = TextEditingController();
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: TextField(
                    controller: folderCreate,
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        await FileManager.createFolder(
                            controller.getCurrentPath, folderCreate.text);
                        controller.setCurrentPath =
                            controller.getCurrentPath + "/" + folderCreate.text;
                        Navigator.pop(context);
                      } catch (e) {
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Create Folders"))
              ],
            ),
          ),
        );
      },
    );
  }

  sort(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var folderCreate = TextEditingController();
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text("Name"),
                  onTap: () {
                    controller.sortBy(SortBy.name);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("Size"),
                  onTap: () {
                    controller.sortBy(SortBy.size);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("Date"),
                  onTap: () {
                    controller.sortBy(SortBy.date);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text("Type"),
                  onTap: () {
                    controller.sortBy(SortBy.type);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
