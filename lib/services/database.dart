import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furballstory/models/pet.dart';

class DatabaseService {

  final CollectionReference dogCollection = Firestore.instance.collection('dogs');


  final CollectionReference catCollection = Firestore.instance.collection('cats');

  //create document of a particular dog
  Future updateUserDataDog(String dogName,String breed,int age,String uid,String photoUrl) async{
    return await dogCollection.document(uid).setData({
      'photoUrl':photoUrl,
      'name':dogName,
      'age':age,
      'breed':breed,
    });
  }

  //stream of dog document
  Stream<Dog> get dog {
    return dogCollection.document().snapshots().map(
      _getDogFromDocumentSnapshot
    );
  }

  //stream of dog list
  Stream<List<Dog>> get dogs {
    return dogCollection.snapshots().map(_getDogListFromQuerySnapshot);
  }


  //to get dog list
  List<Dog> _getDogListFromQuerySnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      return Dog(
        uid: doc.documentID,
        photoUrl: doc.data['photoUrl'],
        breed: doc.data['breed'],
        name: doc.data['name'],
        age: doc.data['age'],
      );
    }).toList();
  }

  //get dog data from document snapshot
  Dog _getDogFromDocumentSnapshot(DocumentSnapshot snapshot) {
    return Dog(
      age: snapshot.data['age'],
      photoUrl: snapshot.data['photoUrl'],
      name: snapshot.data['name'],
      breed: snapshot.data['breed'],
    );
  }


  //create document for cat
  Future updateUserDataCat(String name,String breed,int age,String uid,String photoUrl) async{
    return catCollection.document(uid).setData({
      'photoUrl':photoUrl,
     'name': name,
     'breed':breed,
     'age':age,
    });
  }

  //stream of cat list
  Stream<List<Cat>> get cats {
    return catCollection.snapshots().map(
      _getCatListFromQuerySnapshot
    );
  }

  //cat list from query snapshot
  List<Cat> _getCatListFromQuerySnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc){
      return Cat(
        uid: doc.documentID,
        name: doc.data['name'],
          photoUrl: doc.data['photoUrl'],
        breed: doc.data['breed'],
        age: doc.data['age']
      );
    }).toList();
  }


  Stream<Cat> get cat {
    return catCollection.document().snapshots().map(
        _getCatFromDocumentSnapshot
    );
  }

  Cat _getCatFromDocumentSnapshot(DocumentSnapshot snapshot) {
    return Cat(
      age: snapshot.data['age'],
      name: snapshot.data['name'],
      breed: snapshot.data['breed'],
      photoUrl: snapshot.data['photoUrl'],
    );
  }




}