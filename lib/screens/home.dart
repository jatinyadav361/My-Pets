import 'package:flutter/material.dart';
import 'package:furballstory/loading.dart';
import 'package:furballstory/models/pet.dart';
import 'package:furballstory/screens/intermed.dart';
import 'package:furballstory/screens/pet_list.dart';
import 'package:furballstory/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    void _showFilterList() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              child: Form(
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Pet Name',
                      ),
                    )
                  ],
                ),
              ),
            );
          });
    }


    return StreamProvider<List<Dog>>.value(
        value: DatabaseService().dogs,
        child: StreamProvider<List<Cat>>.value(
        value: DatabaseService().cats,

         child:  loading ? Loading():Scaffold(
            appBar: AppBar(
              title: Text(
                'My Pets',
                textScaleFactor: 1.47,
              ),
              actions: [
//                FlatButton.icon(
//                    onPressed: () {
//
//                    },
//                    icon: Icon(Icons.filter_list),
//                    label: Text('Filters')),
                FlatButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return InterMediate();
                          }
                      ));
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add pet')),
              ],
            ),
            body: PetList(),

          ),
    ));
  }
}
