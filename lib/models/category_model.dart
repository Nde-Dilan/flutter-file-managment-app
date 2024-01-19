import 'package:flutter/material.dart';

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
