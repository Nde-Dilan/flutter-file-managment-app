import 'package:file_manager_flutter/models/category_model.dart';
import 'package:file_manager_flutter/my_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = [];

  void _getCategories() {
    categories = CategoryModel.getCategories();
  }

  @override
  void initState() {
    _getCategories();
  }

  @override
  Widget build(BuildContext context) {
    _getCategories();
    return Scaffold(
      appBar: appBarFunction(context),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        inputSearch(),
        const SizedBox(
          height: 40,
        ),
        storageSection(
            "Internal Storage", "64 Gb out of 128 Gb", "mobile_icon"),
        const SizedBox(
          height: 30,
        ),
        storageSection("External Storage", "6 Gb out of 28 Gb", "sdcard"),
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
          padding: EdgeInsets.only(left: 15),
          child: Text(
            'Recently viewed',
            style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
          ),
        ),
        RecentFolderSection(),
      ]),
      bottomNavigationBar: BottomNavigationBar(
          // backgroundColor: Color(0xFF6350FF).withOpacity(0.15),
          items: [
            BottomNavigationBarItem(
              label: "Music",
              icon: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Color.fromARGB(31, 255, 255, 255)),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: SvgPicture.asset("assets/icons/music.svg"),
                ),
              ),
            ),
            BottomNavigationBarItem(
              label: "Cloud",
              icon: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Color.fromARGB(31, 255, 255, 255)),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: SvgPicture.asset("assets/icons/cloud.svg"),
                ),
              ),
            ),
          ]),
    );
  }

  Container storageSection(String name, String storage, String iconPath) {
    return Container(
      width: 311,
      height: 93,
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
                width: 25,
                height: 25,
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
              Text(
                name,
                style: TextStyle(fontSize: 22, color: Color(0xff6350FF)),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Container(
                  width: 295,
                  height: 5,
                  padding: const EdgeInsets.only(left: 55, top: 10),
                  decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Color.fromARGB(31, 0, 0, 0)),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(storage),
                GestureDetector(
                    onTap: () {
                      print("Explore button clicked");
                    },
                    child: Text("Explore")),
              ],
            ),
          )
        ],
      ),
    );
  }

  Row RecentFolderSection() {
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
            padding: const EdgeInsets.only(left: 45),
            separatorBuilder: (context, index) {
              return const SizedBox(
                width: 25,
              );
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()));
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
