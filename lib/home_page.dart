import 'dart:io';

import 'package:file_manager/file_manager.dart';
import 'package:file_manager_flutter/models/category_model.dart';
import 'package:file_manager_flutter/folder_listing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:file_manager_flutter/pages/image_page.dart'; // Import your pages
import 'package:file_manager_flutter/pages/video_page.dart';
import 'package:file_manager_flutter/pages/music_page.dart';
import 'package:file_manager_flutter/pages/cloud_page.dart';
import 'package:file_manager_flutter/pages/download_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = [];
  final FileManagerController controller = FileManagerController();
  final Future<List<Directory>> storgeList = FileManager.getStorageList();

  void _getCategories() {
    // print(storgeList);
    categories = CategoryModel.getCategories();
  }

  @override
  void initState() {
    super.initState();
    _getCategories();
  }
//TODO: Add a method as a prop to the constructor of the model to change the onTap behavior

  @override
  Widget build(BuildContext context) {
    _getCategories();
    return Scaffold(
      appBar: appBarFunction(context),
      body: SingleChildScrollView(
          child: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          inputSearch(),
          const SizedBox(
            height: 40,
          ),
          storageSection(
              "Internal Storage", "64 Gb out of 128 Gb", "mobile_icon", 0.50),
          const SizedBox(
            height: 30,
          ),
          storageSection(
              "External Storage", "6 Gb out of 28 Gb", "sdcard", 0.2142),
          const SizedBox(
            height: 40,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(
              'Category',
              style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
            ),
          ),
          categorySection(0),
          categorySection(3),
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.only(left: 1),
            child: Text(
              'Recently viewed',
              style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
            ),
          ),
          recentFolderSection(),
          const SizedBox(
            height: 200,
          ),
        ]),
      )),
      bottomNavigationBar: bottomNavigationBar(),
      floatingActionButton: GestureDetector(
        onTap: () {},
        child: Container(
          width: 198,
          height: 198,
          decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromARGB(31, 255, 255, 255)),
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: SvgPicture.asset("assets/icons/add_folder.svg"),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
        // backgroundColor: Color(0xFF6350FF).withOpacity(0.15),
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: SizedBox(
              width: 24,
              height: 24,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: SvgPicture.asset("assets/icons/home.svg"),
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: "Folder",
            icon: SizedBox(
              width: 24,
              height: 24,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: SvgPicture.asset("assets/icons/folder_bottom.svg"),
              ),
            ),
          ),
          BottomNavigationBarItem(
            label: " ",
            icon: SizedBox(
              width: 28,
              height: 28,
              child: SvgPicture.asset("assets/icons/mobile_icon.svg"),
            ),
          ),
          BottomNavigationBarItem(
            label: "Settings",
            icon: SizedBox(
              width: 24,
              height: 24,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: SvgPicture.asset("assets/icons/settings.svg"),
              ),
            ),
          ),
        ]);
  }

  Container storageSection(
      String name, String storage, String iconPath, double? spaceLeft) {
    return Container(
      width: 304,
      height: 99,
      decoration: BoxDecoration(
        color: const Color(0xFF6350FF).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 35,
                height: 35,
                padding: const EdgeInsets.only(left: 10, top: 10),
                decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Color.fromARGB(31, 255, 255, 255)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 0.0),
                  child: SvgPicture.asset("assets/icons/$iconPath.svg"),
                ),
              ),
              const SizedBox(
                width: 12,
                height: 5,
              ),
              GestureDetector(
                onTap: () {
                  // controller.openDirectory(e);
                  Navigator.pop(context);
                },
                child: Text(
                  name,
                  style:
                      const TextStyle(fontSize: 22, color: Color(0xff6350FF)),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              children: [
                SizedBox(
                  width: 285,
                  height: 5,
                  // padding: const EdgeInsets.only(left: 55, top: 10),
                  child: LinearProgressIndicator(
                    value: spaceLeft,
                    color: const Color(0xFF6350FF),
                    semanticsLabel: 'Linear progress space indicator',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(08.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(storage),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage(
                                  storageType: name == "Internal Storage"
                                      ? StorageType.internal
                                      : StorageType.external)));
                    },
                    child: const Text("Explore")),
              ],
            ),
          )
        ],
      ),
    );
  }

  Row recentFolderSection() {
    return Row(
      children: [
        Container(
          width: 75,
          height: 75,
          padding: const EdgeInsets.only(left: 10, top: 10),
          decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Color.fromARGB(31, 255, 255, 255)),
          child: Padding(
            padding: const EdgeInsets.only(left: 0.0),
            child: SvgPicture.asset("assets/icons/folder.svg"),
          ),
        ),
        const Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Media',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Last modified 2 days ago',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }

  Column categorySection(int step) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        SizedBox(
          height: 90,
          // color: const Color.fromARGB(255, 212, 76, 13),
          child: ListView.separated(
            itemCount: categories.length - 3,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(2),
            separatorBuilder: (context, index) {
              return const SizedBox(
                width: 25,
              );
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    switch (categories[index + step].path) {
                      case '/image':
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ImagePage()));
                        break;
                      case '/video':
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const VideoPage()));
                        break;
                      case '/music':
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MusicPage()));
                        break;
                      case '/document':
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyHomePage(
                                      storageType: StorageType.internal,
                                    )));
                        break;
                      case '/cloud':
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CloudPage()));
                        break;
                      case '/download':
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DownloadPage()));
                        break;
                      default:
                        // Handle unknown paths or add additional cases as needed
                        break;
                    }
                  },
                  child: Container(
                      // height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6350FF).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Color.fromARGB(31, 255, 255, 255)),
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: SvgPicture.asset(
                                  categories[index + step].iconPath),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(categories[index + step].name,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xff6350FF),
                                  fontWeight: FontWeight.bold)),
                        ],
                      )));
            },
          ),
        ),
      ],
    );
  }

  Container inputSearch() {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
      child: TextField(
          decoration: InputDecoration(
        hintText: 'Search for files...',
        hintStyle: const TextStyle(
          color: Color.fromARGB(218, 0, 0, 0),
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: const Color(0xFF6350FF).withOpacity(0.19),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(7),
            borderSide: BorderSide.none),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(9.0),
          child: GestureDetector(
              onTap: () {
                //Search functionallity
              },
              child: SvgPicture.asset('assets/icons/search.svg')),
        ),
      )),
    );
  }

  AppBar appBarFunction(BuildContext context) {
    return AppBar(
      title: const Text('Home'),
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/settings');
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset('assets/icons/3_dots.svg'),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/settings');
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset('assets/icons/user.svg', width: 30),
          ),
        )
      ],
    );
  }
}
