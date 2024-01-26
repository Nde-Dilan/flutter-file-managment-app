import 'package:flutter/material.dart';

import 'package:file_manager_flutter/pages/image_page.dart'; // Import your pages
import 'package:file_manager_flutter/pages/video_page.dart';
import 'package:file_manager_flutter/pages/music_page.dart';
import 'package:file_manager_flutter/folder_listing.dart';
import 'package:file_manager_flutter/pages/cloud_page.dart';
import 'package:file_manager_flutter/pages/download_page.dart';

class CategoryModel {
  String name;
  String iconPath;
  String path;
  Color boxColor;

  CategoryModel({
    required this.name,
    required this.iconPath,
    required this.path,
    required this.boxColor,
  });

  void navigateToPage(BuildContext context) {
    switch (path) {
      case '/image':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ImagePage()));
        break;
      case '/video':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const VideoPage()));
        break;
      case '/music':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const MusicPage()));
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
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CloudPage()));
        break;
      case '/download':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const DownloadPage()));
        break;
      default:
        // Handle unknown paths or add additional cases as needed
        break;
    }
  
  }

  static List<CategoryModel> categoryList = [
    CategoryModel(
      name: 'Images',
      iconPath: 'assets/icons/picture.svg',
      path: '/image',
      boxColor: const Color.fromARGB(255, 172, 45, 204),
    ),
    CategoryModel(
      name: 'Videos',
      iconPath: 'assets/icons/video.svg',
      path: '/video',
      boxColor: const Color.fromARGB(255, 44, 23, 202),
    ),
    CategoryModel(
      name: 'Music',
      iconPath: 'assets/icons/music.svg',
      path: '/music',
      boxColor: const Color.fromARGB(255, 6, 2, 32),
    ),
    CategoryModel(
      name: 'Documents',
      iconPath: 'assets/icons/document.svg',
      path: '/document',
      boxColor: const Color.fromARGB(255, 96, 192, 17),
    ),
    CategoryModel(
      name: 'Cloud',
      iconPath: 'assets/icons/cloud.svg',
      path: '/cloud',
      boxColor: const Color.fromARGB(255, 96, 192, 17),
    ),
    CategoryModel(
      name: 'Downloads',
      iconPath: 'assets/icons/download.svg',
      path: '/download',
      boxColor: const Color.fromARGB(255, 48, 29, 190),
    ),
  ];
  static List<CategoryModel> getCategories() {
    return categoryList;
  }
}
