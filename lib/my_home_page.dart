export 'package:file_manager_flutter/my_home_page.dart';
import 'package:intl/intl.dart';
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

//StatefulWidget means needs to hold some state, will change over time and with user interactions
class MyHomePage extends StatefulWidget {

   const MyHomePage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      // drawer: Drawer(),
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
                          : (entity.path.endsWith('.mp3') ||
                                  entity.path.endsWith('.wav') ||
                                  entity.path.endsWith('.m4a') ||
                                  entity.path.endsWith('.ogg'))
                              ? const Icon(
                                  Icons.audiotrack,
                                  size: 24,
                                  color: Colors.blue,
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
                  onLongPress: () => {options(context, entity)},
                ),
              );
            },
          );
        },
      ),
    );
  }

  delete(FileSystemEntity entity) async {
    await entity.delete();
  }

  rename(FileSystemEntity entity, String newName) async {
    await entity.rename("newPath/$newName");
  }

  String formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  subTitle(FileSystemEntity entity) {
    return FutureBuilder(
      future: entity.stat(),
      builder: (BuildContext context, AsyncSnapshot<FileStat> snapshot) {
        if (snapshot.hasData) {
          if (entity is File) {
            int size = snapshot.data!.size;
            return Text(FileManager.formatBytes(size));
          } else if (entity is Directory) {
            int itemCount = entity.listSync().length;
            String dateModified = "${snapshot.data!.modified}";

            return Text(
                "${itemCount != 0 ? itemCount : 'No'} items                                 ${formatDate(dateModified)}");
          }
          return const Text("");
        } else {
          return const Text("");
        }
      },
    );
  }

  appBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () => createFolder(context),
          icon: const Icon(
            Icons.create_new_folder_outlined,
          ),
        ),
        IconButton(
          onPressed: () => sort(context),
          icon: const Icon(
            Icons.sort_rounded,
          ),
        ),
        IconButton(
          onPressed: () => selectStorage(context),
          icon: const Icon(
            Icons.sd_storage_rounded,
          ),
        ),
      ],
      title: ValueListenableBuilder(
        valueListenable: controller.titleNotifier,
        builder: (BuildContext context, String value, Widget? child) {
          return Text(value);
        },
      ),
      leading: IconButton(
        onPressed: () async {
          try {
            await controller.goToParentDirectory();
          } catch (e) {
            // print(e);
          }
        },
        icon: const Icon(
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
            padding: const EdgeInsets.all(10),
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
                        //controller.setCurrentPath ="${controller.getCurrentPath}/${folderCreate.text}";
                        Navigator.pop(context);
                      } catch (e) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Create Folder"))
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
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text("Name"),
                  onTap: () {
                    controller.sortBy(SortBy.name);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Size"),
                  onTap: () {
                    controller.sortBy(SortBy.size);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Date"),
                  onTap: () {
                    controller.sortBy(SortBy.date);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Type"),
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

  options(BuildContext context, FileSystemEntity entity) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text("Path:${entity.path}"),
                ),
                ListTile(
                  title: const Text("Delete"),
                  onTap: () async {
                    await entity.delete();

                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Date"),
                  onTap: () {
                    controller.sortBy(SortBy.date);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Type"),
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
