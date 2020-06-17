import 'package:flutter/material.dart';
import 'package:furballstory/models/pet.dart';
import 'package:furballstory/screens/add_pets.dart';
import 'package:furballstory/services/database.dart';
import 'package:provider/provider.dart';

class InterMediate extends StatefulWidget {
  @override
  _InterMediateState createState() => _InterMediateState();
}

class _InterMediateState extends State<InterMediate> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Cat>>.value(
        value: DatabaseService().cats,
        child: StreamProvider<List<Dog>>.value(
          value: DatabaseService().dogs,
          child: AddPet(),
        ));
  }
}
