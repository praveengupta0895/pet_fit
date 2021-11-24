import 'package:flutter/material.dart';
import 'package:pet_fit/model/pet_model.dart';
import 'package:url_launcher/url_launcher.dart';

class PetDetailsPage extends StatefulWidget {
  final PetModel petModel;
  const PetDetailsPage({Key? key,required this.petModel}) : super(key: key);

  @override
  _PetDetailsPageState createState() => _PetDetailsPageState();
}

class _PetDetailsPageState extends State<PetDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Pet Details",style: Theme.of(context).textTheme.bodyText1,)),
        leading: InkWell(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
            child: Column(

              children: [
                _networkImage(context, widget.petModel.image),
                _petDetails(context,widget.petModel),
                _ownerDetails(context,widget.petModel.owner,widget.petModel.ownerDetails),
                _albumView(context),
                _scheduleView(context),
                _callView(context),
              ],
            ),
      ),
    );
  }
}

 _networkImage(BuildContext context, String imageUrl){
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
          width: MediaQuery.of(context).size.width-40,
          child: Image.network(imageUrl,fit: BoxFit.contain,)),
    ),
  );
}
_petDetails(BuildContext context,PetModel petModel){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      width: MediaQuery.of(context).size.width/1.5,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text("Pet Name:",style: Theme.of(context).textTheme.bodyText1),
              Text(petModel.name,style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text("Pet DOB:",style: Theme.of(context).textTheme.bodyText1),
              Text(petModel.dob.split(" ")[0],style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Pet Location:",style: TextStyle(fontWeight: FontWeight.bold),),
              Text(petModel.location,style: const TextStyle(fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
            ],
          ),
          const SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Pet Breed:",style: Theme.of(context).textTheme.bodyText1),
              Text(petModel.breed,style: Theme.of(context).textTheme.bodyText1),
            ],
          ),
        ],
      ),
    ),
  );
}
_ownerDetails(BuildContext context,String owner, String ownerDetail){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      width: MediaQuery.of(context).size.width/1.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text("Owner Detail:",style: Theme.of(context).textTheme.bodyText1),
          const SizedBox(height: 10,),

          Container(
              height: MediaQuery.of(context).size.height/10,
              width: MediaQuery.of(context).size.width/1.5,
              color: Colors.grey,
              child: Text(owner.split("pr-")[1]+": "+ownerDetail,style: Theme.of(context).textTheme.bodyText1)),
        ],
      ),
    ),
  );
}
_albumView(BuildContext context){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      width: MediaQuery.of(context).size.width/1.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Album",style: TextStyle(fontWeight: FontWeight.bold,),
          overflow: TextOverflow.ellipsis,),
          InkWell(
              onTap: (){

              },
              child: const Icon(Icons.add_to_photos ))
        ],
      ),
    ),
  );
}
_scheduleView(BuildContext context){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      width: MediaQuery.of(context).size.width/1.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Text("Schedule",style:Theme.of(context).textTheme.bodyText1),
          TextButton(
            onPressed: () => {},
            child: Column(
              children: const <Widget>[
                Icon(Icons.calendar_today),
                Text("Create")
              ],
            ),
          ),
         TextButton(
        onPressed: () => {},
        child: Column(
          children: const <Widget>[
            Icon(Icons.assignment_turned_in_outlined),
            Text("View")
          ],
        )),
        ],
      ),
    ),
  );
}
_callView(BuildContext context){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      width: MediaQuery.of(context).size.width/1.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(onPressed: ()=> launch("tel://0123456789"), child: const Text("Call")),
          ElevatedButton(onPressed: (){}, child: const Text("Delete")),
        ],
      ),
    ),
  );
}

