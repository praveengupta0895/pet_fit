import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:firebase_database/firebase_database.dart';

import 'package:pet_fit/utils/constants.dart';
import 'package:pet_fit/view/screens/home_screen.dart';

class AddNewPetPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const AddNewPetPage());
  }
  const AddNewPetPage({Key? key}) : super(key: key);

  @override
  _AddNewPetPageState createState() => _AddNewPetPageState();
}

class _AddNewPetPageState extends State<AddNewPetPage> {
  final TextEditingController _petName = TextEditingController();
  final TextEditingController _petLocation = TextEditingController();
  final TextEditingController _petBreed = TextEditingController();
  final TextEditingController _petOwnerDetail = TextEditingController();
  File _convertedFile = File('');


  DateTime selectedDate = DateTime.now();
  bool _progress=false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Add Pet")),
        leading: InkWell(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back)),),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: _progress?const Center(child: CircularProgressIndicator()):Column(
         children:  [
           _buildCustomTextField(context, "Pet Name","Enter Pet Name",_petName),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: SizedBox(
               width: MediaQuery.of(context).size.width/1.3,
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   const Text("Pet DOB:",style: TextStyle(fontWeight: FontWeight.bold),),
                   SizedBox(
                     width: MediaQuery.of(context).size.width/2,
                     child: InkWell(
                         onTap: ()=> _selectDate(context),
                         child: TextField(
                           enabled: false,
                           decoration: InputDecoration(
                             hintText: "${selectedDate.toLocal()}".split(' ')[0]
                           ),
                         )
                     )
                   )

                 ],
               ),
             ),
           ),
           _buildCustomTextField(context, "Pet Location","Enter Pet Location",_petLocation),
           _buildCustomTextField(context, "Pet Breed","Enter Pet Breed",_petBreed),
           _buildOwnerDetail(context, _petOwnerDetail),
            Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width/1.3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Add Pet's Photo/Video",style: TextStyle(fontWeight: FontWeight.bold,),),
                InkWell(
                    onTap: (){
                      _photoSelection(context);
                    },
                    child: const Icon(Icons.camera ))
              ],
            ),
          ),
        ),
           ElevatedButton(onPressed: (){
             if(_petName.text==""||_petOwnerDetail.text==""||_petLocation.text==""||_petBreed.text==""){
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please provide all the details")));
             }else if(_convertedFile.path.isEmpty){
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please upload the picture")));
             }else{
               uploadImageToFirebase(context);
             }
           }, child: const Text("Add")),
         ],
       )
      ),
    );
  }

  Future uploadImageToFirebase(BuildContext context) async {

    setState(() {
      _progress=true;
    });
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("uploads/" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(_convertedFile);

   uploadTask.whenComplete(() {
     uploadTask.then((res) {
       res.ref.getDownloadURL().then((value)  {
         DatabaseReference databaseReference = FirebaseDatabase.instance.
         reference().child(petDataReference);
         String _child = selectedDate.toString().split(".")[0]+"pr-"+CurrentUser.userName;
         databaseReference.child(_child).set({
           'breed':_petBreed.text,
           'dob': selectedDate.toString(),
           'image': value,
           'location':_petLocation.text,
           'name':_petName.text,
           'ownerDetails':_petOwnerDetail.text
         });

         Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomePage()));
         Future.delayed(const Duration(milliseconds: 1000), () {
           setState(() {
             _progress=false;
           });
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("File Uploaded Successfully")));
         });

       });
     });
   }).catchError((onError){
     setState(() {
       _progress=false;
     });
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(onError.toString())));
   })

    ;
  }

  void _photoSelection(BuildContext context)async{
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.black,
      context: context,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.all(10.0),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: (){
                    getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text("Camera",style: TextStyle(color: Colors.grey.shade700,fontSize: 18,fontFamily: 'MYF',fontWeight: FontWeight.bold),))),

                ),
                InkWell(
                  onTap: (){
                    getImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:Center(child: Text("Gallery",style: TextStyle(color: Colors.grey.shade700,fontSize: 18,fontFamily: 'MYF',fontWeight: FontWeight.bold),))),

                ),

              ],
            ),
          ),
        );
      },
    );
  }
  getImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: source);
    if(image != null){
      File? cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: Platform.isAndroid
              ? [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ]
              : [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio5x3,
            CropAspectRatioPreset.ratio5x4,
            CropAspectRatioPreset.ratio7x5,
            CropAspectRatioPreset.ratio16x9
          ],
          aspectRatio: const CropAspectRatio(
              ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxWidth: 700,
          maxHeight: 700,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: const AndroidUiSettings(

            toolbarTitle: "Pet-Fit",
          )
      );

      setState((){
        _convertedFile = cropped!;
      });
    } else {
    }
  }

}


Widget _buildCustomTextField(BuildContext context,String title,String hint,TextEditingController _textController){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      width: MediaQuery.of(context).size.width/1.3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Text(title+":",style: const TextStyle(fontWeight: FontWeight.bold),),
          SizedBox(
            width: MediaQuery.of(context).size.width/2,
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: hint
              ),
            ),
          )

        ],
      ),
    ),
  );
}
_buildOwnerDetail(BuildContext context,TextEditingController _textController){
  
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      width: MediaQuery.of(context).size.width/1.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Owner Details:",style: TextStyle(fontWeight: FontWeight.bold),),
          Container(
            color: Colors.grey,
            width: MediaQuery.of(context).size.width/1.3,
            height: MediaQuery.of(context).size.height/6,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                      hintText: 'Enter Owner Details',

                  ),


                ),
              ),
            ),
          )

        ],
      ),
    ),
  );
}

