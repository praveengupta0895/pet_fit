import 'package:meta/meta.dart';
import 'dart:convert';


class PetModel {
  PetModel({
    required this.breed,
    required this.image,
    required this.dob,
    required this.location,
    required this.name,
    required this.age,
    required this.owner,
    required this.ownerDetails
  });

  String breed;
  String image;
  String dob;
  String location;
  String name;
  String age;
  String owner;
  String ownerDetails;

}
