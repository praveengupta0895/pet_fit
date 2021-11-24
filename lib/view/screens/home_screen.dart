import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:intl/intl.dart';
import 'package:pet_fit/model/pet_model.dart';
import 'package:pet_fit/utils/constants.dart';
import 'package:pet_fit/view/screens/add_new_pet_screen.dart';
import 'package:pet_fit/view/screens/pet_detail_screen.dart';
import 'package:pet_fit/view_models/auth_bloc/authentication_bloc.dart';

import 'feedback_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const HomePage());
  }
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Center(child: Text("PetFit")),
      ),
      drawer: Drawer(

        child: ListView(
          padding: EdgeInsets.zero,
          children: [
             DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.grey,
              ),
              child:Column(
                children: [
                  const Icon(Icons.person,size: 100,),
                  Text(CurrentUser.userName)
                ],
              ),
            ),
            ListTile(
              tileColor: Colors.grey,
              title: const Text('User Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 5,),
            ListTile(
              tileColor: Colors.grey,
              title: const Text('Add Pet'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddNewPetPage()));
              },
            ),
            const SizedBox(height: 5,),
            ListTile(
              tileColor: Colors.grey,
              title: const Text('Help'),
              onTap: () {
                Navigator.pop(context);

              },
            ),
            const SizedBox(height: 5,),
            ListTile(
              tileColor: Colors.grey,
              title: const Text('Support'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 5,),
            ListTile(
              tileColor: Colors.grey,
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 5,),
            ListTile(
              tileColor: Colors.grey,
              title: const Text('Feedback'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const FeedbackPage()));
              },
            ),
            const SizedBox(height: 5,),
            ListTile(
              tileColor: Colors.grey,
              title: const Text('Logout'),
              onTap: () {
                context
                    .read<AuthenticationBloc>()
                    .add(AuthenticationLogoutRequested());
              },
            ),

          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 10,),
            _buildPetDetails(context),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}

Widget _buildPetDetails(BuildContext context){
  return StreamBuilder<Event>(
      stream: FirebaseDatabase.instance.reference().child(petDataReference).onValue,
      builder: (context,AsyncSnapshot snapshot) {
        if (snapshot.hasData && !snapshot.hasError && snapshot.data.snapshot.value!=null){
          DataSnapshot dataSnapshot = snapshot.data.snapshot;
          List<PetModel> petDetailList=[];
          String _age="";
          for(var i in dataSnapshot.value.keys){
            _age = _calculateAge(dataSnapshot.value[i]['dob']);
            PetModel petModel =
            PetModel(
                breed: dataSnapshot.value[i]['breed'],
                dob: dataSnapshot.value[i]['dob'],
                location: dataSnapshot.value[i]['location'],
                age: _age.toString(),
                owner: i.toString(),
                name: dataSnapshot.value[i]['name'],
                image: dataSnapshot.value[i]['image'],
                ownerDetails: dataSnapshot.value[i]['ownerDetails']
            );
            petDetailList.add(petModel);

          }

          return
            Column(
              children: [
                GFCarousel(
                  autoPlay: true,
                  activeIndicator: Theme.of(context).indicatorColor,
                  pagerSize: 5.0,
                  pagination: true,
                  items: petDetailList.map(
                        (url) {
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                          child: Image.network(
                              url.image,
                              fit: BoxFit.cover,
                              width: 1000.0
                          ),
                        ),
                      );
                    },
                  ).toList()
                ),

                ListView.builder(
                     shrinkWrap: true,
                     scrollDirection: Axis.vertical,
                     physics: const NeverScrollableScrollPhysics(),
                     itemCount: petDetailList.length,
                     itemBuilder: (context, index) {
                      return petDetailList.isEmpty?Container():
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>PetDetailsPage(petModel: petDetailList[index])));
                              },
                              child: Container(
                                  decoration: const BoxDecoration(color: Colors.grey,
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10),)),
                                  child: _PetCard(petModel: petDetailList[index],)),
                            ),
                          );
        }
        ),

              ],
            );
        }else {

          return const Center(child: CircularProgressIndicator());
        }
      }
  );
}

String _calculateAge(String _strBirthDate){

  DateTime _birthDate = DateFormat("yyyy-MM-dd").parse(_strBirthDate);
  DateTime now = DateTime.now();
  String _age;
  int _year =now.year-_birthDate.year;
  int _month=now.month-_birthDate.month;
  int _day = now.day-_birthDate.day;
  if(_year==0){
    if(_month==0){
      if(_day==0){
        _age="Born Today!";
      }else{
        _age=_day.toString()+" days";
      }
    }else{
      _age=_month.toString()+" months";
    }
  }else{
    _age=_year.toString()+" years";
  }
  return _age;

}

class _PetCard extends StatefulWidget {
  const _PetCard({Key? key, required this.petModel}) : super(key: key);
  final PetModel petModel;

  @override
  _PetCardState createState() => _PetCardState();
}

class _PetCardState extends State<_PetCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height*1/6,
      width: MediaQuery.of(context).size.width-20,
      child: Row(
        children: [
          SizedBox(
              height:MediaQuery.of(context).size.height*1/6-10,
              width: MediaQuery.of(context).size.width/2-15,
              child: Image.network(widget.petModel.image,fit: BoxFit.fill,)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width/2-15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Pet Name: "+widget.petModel.name,style:Theme.of(context).textTheme.bodyText1),
                  Text("Pet Age: "+widget.petModel.age,style: Theme.of(context).textTheme.bodyText1),
                  Text("Pet Location: "+widget.petModel.location,style: Theme.of(context).textTheme.bodyText1),
                  Text("Pet Breed: "+widget.petModel.breed,style: Theme.of(context).textTheme.bodyText1),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}




