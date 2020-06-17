import 'package:flutter/material.dart';
import 'package:furballstory/models/pet.dart';
import 'package:provider/provider.dart';

class PetList extends StatefulWidget {


  @override
  _PetListState createState() => _PetListState();
}

class _PetListState extends State<PetList> {
  List<Dog> _dogs = List();
  List<Cat> _cats = List();

  var _age;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {
      _dogs = Provider.of<List<Dog>>(context) ?? [];
    });
    setState(() {
      _cats = Provider.of<List<Cat>>(context) ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;

    final dogs = Provider.of<List<Dog>>(context) ?? [];
    final cats = Provider.of<List<Cat>>(context) ?? [];

    var itemCountTotal = _dogs.length + _cats.length + 3;

    return ListView.builder(
        itemCount: itemCountTotal,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(right: size.width*.45,top: 10),
                  child: Text("Filter by pet's name"),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: TextField(
                    onChanged: (val) {
                      val = val.toLowerCase();
                      setState(() {
                        _cats = cats.where((cat) {
                          var catName = cat.name.toLowerCase();
                          return catName.contains(val);
                        }).toList();
                      });
                      setState(() {
                        _dogs = dogs.where((dog) {
                          var dogName = dog.name.toLowerCase();
                          return dogName.contains(val);
                        }).toList();

                        itemCountTotal = _dogs.length + _cats.length + 2;
                      });
                    },
                    keyboardType: TextInputType.text,
                    decoration:
                        InputDecoration(labelText: 'Search pet name ...'),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(right: 120,top: 10),
                  child: Text('Filter by age(in months)'),
                ),

                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Slider(
                      max: 100,
                      min: 1,
                      divisions: 99,
                      onChanged: (val) {
                         setState(() {
                           _age = val;

                           _dogs = dogs.where((dog){
                             var dogAge = dog.age;
                             return dogAge == val;
                           }).toList();

                           _cats = cats.where((cat){
                             var catAge = cat.age;
                             return catAge == val;
                           }).toList();
                         });
                      },
                      label: _age != null ? '${_age.toInt()}' : null,
                      value: _age ?? 1),
                ),
              ],
            );
          }

          if (index == 1) {
            return Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'Dogs',
                textScaleFactor: 1.75,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          if (index == _dogs.length + 1 + 1) {
            return Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'Cats',
                textScaleFactor: 1.75,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          if (index > 1 && index <= _dogs.length + 1) {
            return Card(
              margin: EdgeInsets.only(left: 15, right: 15, top: 10),
              child: ListTile(
                onTap: () {
                  print(itemCountTotal);
                },
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    '${_dogs[index - 2].photoUrl}'
                  ),
                ),
                title: Text(_dogs[index - 2].name),
                subtitle: Text('${_dogs[index - 2].breed}'),
                trailing: Text('${_dogs[index - 2].age} months old'),
              ),
            );
          }
          else {
            return Card(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                      '${_cats[index - _dogs.length - 3].photoUrl}'
                  ),
                ),
                title: Text(_cats[index - _dogs.length - 3].name),
                subtitle: Text('${_cats[index - _dogs.length - 3].breed}'),
                trailing:
                    Text('${_cats[index - _dogs.length - 3].age} months old'),
              ),
            );
          }
        });
  }
}
