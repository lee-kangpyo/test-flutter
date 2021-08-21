import 'package:flutter/material.dart';

class Animal {
  String imagePath;
  String animalName;
  String kind;
  bool? flyExist = false;

  Animal({
    required this.imagePath,
    required this.animalName,
    required this.kind,
    this.flyExist
  });
}