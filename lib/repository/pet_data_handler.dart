// import 'package:firebase_database/firebase_database.dart';
// import 'package:pet_fit/model/pet_model.dart';
// import 'package:pet_fit/utils/constants.dart';
//
// class PetDataHandler{
//   List<PetModel> petDetails=[];
//   Future<List<PetModel>> fetchPetData() async {
//     try{
//       await FirebaseDatabase.instance.reference().child(petDataReference).once().then((DataSnapshot _snapShot){
//         for(var i in _snapShot.value.keys){
//           PetModel petModel =
//           PetModel(
//               breed: _snapShot.value[i]['breed'],
//               dob: _snapShot.value[i]['dob'],
//               location: _snapShot.value[i]['location'],
//               name: _snapShot.value[i]['name'],
//               image: _snapShot.value[i]['image']
//           );
//           petDetails.add(petModel);
//         }
//       }).catchError((onError){
//
//       });
//       return petDetails;
//     }catch (e){
//       return petDetails;
//     }
//
//   }
//
//
// }