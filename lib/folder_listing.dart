export 'package:file_manager_flutter/folder_listing.dart';
import 'package:file_manager_flutter/home_page.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:file_manager/file_manager.dart';
//For UI Stuff
import 'package:flutter/material.dart';
//You can find the SystemNavigator.pop() here to close the app (except if ur on IOS)
import 'package:flutter/services.dart';
//Enable the user to open files
import 'package:open_file/open_file.dart';

enum StorageType {
  internal,
  external,
}

class MyHomePage extends StatefulWidget {
  // to know what shoulb be displayed, internal or external?
  final StorageType storageType;
  const MyHomePage({super.key, required this.storageType});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //When i launch the app ask for permission after initializing the state
  @override
  void initState() {
    super.initState();
  }

//FileManager is a wonderful widget that allows you to manage files and folders, pick files and folders, and do a lot more. Designed to feel like part of the Flutter framework.

/*https://github.com/DevsOnFlutter/file_manager/blob/main/README.md */
  final FileManagerController controller = FileManagerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context), //the app bar func
      body: FileManager(
        controller: controller,
        builder: (BuildContext context, List<FileSystemEntity> snapshot) {
          //List of files/folderds found inside the storage
          final List<FileSystemEntity> entities = snapshot;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            itemCount: entities.length,
            itemBuilder: (BuildContext context, int index) {
              //Single file or directory
              FileSystemEntity entity = entities[index];
              return Card(
                child: ListTile(
                  leading: fileOrFolder(entity),
                  title: Text(
                    FileManager.basename(entity, showFileExtension: true),
                  ),
                  subtitle: subTitle(entity), // to format the name
                  onTap: () async {
                    if (FileManager.isDirectory(entity)) {
                      handleDirectory(entity);
                    } else if (FileManager.isFile(entity)) {
                      OpenFile.open(entity.path);
                    } else {
                      SystemNavigator.pop();
                    }
                  },
                  onLongPress: () => {fileOrFolderProps(context, entity)},
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Methods

  delete(FileSystemEntity entity) async {
    controller.goToParentDirectory();
    await entity.delete();
  }

  rename(FileSystemEntity entity, String newName) async {
    await entity.rename("newPath/$newName");
  }

  formatDate(String dateStr) {
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

  renameFolder(BuildContext context, FileSystemEntity entity) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var folderCreate = TextEditingController();
        return Dialog(
          child: Container(
            // height: 220,
            decoration: BoxDecoration(color: Color(0xfff6350FF)),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text("Enter New Folder Name"),
                ),
                ListTile(
                  title: TextField(
                      controller: folderCreate,
                      decoration: InputDecoration(
                        hintText: 'New Name',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(218, 241, 241, 241)
                              .withOpacity(0.19),
                          fontWeight: FontWeight.bold,
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 255, 255, 255),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3),
                            borderSide: BorderSide.none),
                      )),
                ),
                const SizedBox(
                  height: 53,
                ),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          try {
                            entity.rename(folderCreate.text);
                            Navigator.pop(context);
                          } catch (e) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("Rename Folder")),
                    const SizedBox(
                      width: 80,
                    ),
                    ElevatedButton(
                        onPressed: () async {}, child: const Text("Cancel"))
                  ],
                ),
              ],
            ),
          ),
        );
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
            print("e");
            if (await controller.isRootDirectory()) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Home()));
            }
            controller.goToParentDirectory();
          } catch (e) {
            print(e);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Home()));
          }
        },
        icon: const Icon(
          Icons.arrow_back,
        ),
      ),
    );
  }

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
            // height: 220,
            decoration: BoxDecoration(color: Color(0xfff6350FF)),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text("Enter Folder Name"),
                ),
                ListTile(
                  title: TextField(
                      controller: folderCreate,
                      decoration: InputDecoration(
                        hintText: 'New Folder',
                        hintStyle: TextStyle(
                          color: Color.fromARGB(218, 241, 241, 241)
                              .withOpacity(0.19),
                          fontWeight: FontWeight.bold,
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(255, 255, 255, 255),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(3),
                            borderSide: BorderSide.none),
                      )),
                ),
                const SizedBox(
                  height: 53,
                ),
                Row(
                  children: [
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
                        child: const Text("Create Folder")),
                    const SizedBox(
                      width: 80,
                    ),
                    ElevatedButton(
                        onPressed: () async {}, child: const Text("Cancel"))
                  ],
                ),
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

  fileOrFolderProps(BuildContext context, FileSystemEntity entity) async {
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
                  title: const Text("Rename"),
                  onTap: () async {
                    createFolder(context);
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

  void handleDirectory(FileSystemEntity entity) {
    switch (widget.storageType) {
      case StorageType.internal:
        controller.openDirectory(entity);
        break;
      case StorageType.external:
        controller.openDirectory(entity);
        break;
    }
  }

  fileOrFolder(FileSystemEntity entity) {
    return FileManager.isFile(entity)
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
        : const Icon(Icons.folder, color: Colors.deepOrange);
  }
}
