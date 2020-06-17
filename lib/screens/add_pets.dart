import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:furballstory/loading.dart';
import 'package:furballstory/models/pet.dart';
import 'package:furballstory/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPet extends StatefulWidget {
  @override
  _AddPetState createState() => _AddPetState();
}

class _AddPetState extends State<AddPet> {

  File _image;

  String error='';

  Future getImage() async{
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image != null){
      setState(() {
        _image = image;
      });
    }
  }

  Future uploadPic(BuildContext context) async {
    String fileName = _image.path;
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(_image);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    setState(() {
      print('profile pic xuccess');
    });
  }

  Future uploadFile(String id,String collection) async {
    String fileName = id;
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask =  reference.putFile(_image);
    StorageTaskSnapshot storageTaskSnapshot;
    await uploadTask.onComplete.then((value){
      if(value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl){
          _photoUrl = downloadUrl;
          print(_photoUrl);
          Firestore.instance.collection(collection).document(id).updateData({
            'photoUrl' : downloadUrl,
          });
        });
      }
    });
  }

  List<bool> isSelected = List.generate(2, (index) => false);

  bool loading = false;


  final _formKey = GlobalKey<FormState>();

  String _petName;
  int _age;
  String _breed;
  String _photoUrl;

  @override
  Widget build(BuildContext context) {

    final dogs = Provider.of<List<Dog>>(context);
    final cats = Provider.of<List<Cat>>(context);

    var size = MediaQuery.of(context).size;

    return Scaffold(


      appBar: AppBar(
        title: Text('Add Pets'),
      ),



      body: Stack(

        children: [
          Form(
              key: _formKey,
              child: ListView(
                children: [

                  SizedBox(height: 20,),
                  Center(child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     Center(child: Align(
                        alignment: Alignment.center,
                        child: CircleAvatar(
                          radius: 100,
//                          backgroundColor: Colors.red,
                          child: ClipOval(
                            child: SizedBox(
                              width: 180,
                              height: 180,
                              child: _image!=null? Image.file(_image,fit: BoxFit.fill,): Image(
                                image: NetworkImage('https://user-images.githubusercontent.com/27860743/64064695-b88dab00-cbfc-11e9-814f-30921b66035f.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      )),
                      Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: () {
                            getImage();
                          },
                        ),
                      )
                    ],
                  )),

                  SizedBox(height: 20,),

                  Padding(
                    padding: EdgeInsets.only(left: 40),
                    child: Text('Type'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: ToggleButtons(
                      borderWidth: 1,
                      constraints: BoxConstraints.expand(width: 140,height: 40),
                      children: [
                        Text('Cat'),
                        Text('Dog'),
                      ],
                      isSelected: isSelected,

                      onPressed: (int index) {
                        setState(() {
                          for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                            if (buttonIndex == index) {
                              isSelected[buttonIndex] = true;
                            } else {
                              isSelected[buttonIndex] = false;
                            }
                          }
                        });
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: size.width*.1),
                    child: Text(error!=null? error: '',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextFormField(
                        onChanged: (val) {
                          _petName = val;
                        },
                        validator: (val) {
                          return val.isEmpty ? "Please enter pet's name" : null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          labelText: 'Pet Name',
                        )),
                  ),

                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextFormField(
                      onChanged: (val) {
                        _breed = val;
                      },
                      validator: (val) {
                        return val.isEmpty ? "Please enter pet's breed" : null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        labelText: 'Pet breed',
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(15),
                    child: TextFormField(
                        onChanged: (val) {
                          _age = int.parse(val);
                        },
                        validator: (val) {
                          return val.isEmpty ? "Please enter valid pet's age" : null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          labelText: 'Pet age(in months)',
                        )),
                  ),

                  Padding(
                    padding: EdgeInsets.all(15),
                    child: RaisedButton(
                      child: Text('Save Pet'),
                      onPressed: () async {
                         if(_formKey.currentState.validate()) {
                            uploadPic(context);
                            //todo validate toggle buttons
                            setState(() {
                              loading = true;
                            });
                            if(isSelected[0]==true) {
                              await uploadFile('${cats.length}','cats');
                              var result = await DatabaseService()
                                  .updateUserDataCat(_petName, _breed,_age,'${cats.length}',_photoUrl );
                              if (result != null) {
                                setState(() {
                                  loading = false;
                                });
                                print('success');
                              } else {
                                //todo flutter toast
                                Fluttertoast.showToast(msg: 'Cat added successfully!');
                                print('failure');
                                setState(() {
                                  loading = false;
                                });
                              }
                            } else {
                              await uploadFile('${dogs.length}','dogs');
                              var result = await DatabaseService()
                                  .updateUserDataDog(_petName, _breed,_age, '${dogs.length}',_photoUrl);
                              if (result != null) {
                                setState(() {
                                  loading = false;
                                });
                                print('success');
                              } else {
                                Fluttertoast.showToast(msg: 'Dog added successfully!');
                                //todo flutter toast
                                print('failure');
                                setState(() {
                                  loading = false;
                                });
                              }
                            }

                            Navigator.pop(context);

                          }
                      },
                    ),
                  ),

                ],
              )),

          Positioned(
            child: loading ? Loading() : Container(),
          )
        ],
      ),
    );
  }


}
