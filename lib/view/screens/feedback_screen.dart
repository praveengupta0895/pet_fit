import 'package:flutter/material.dart';
import 'package:pet_fit/utils/constants.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pet_fit/view/screens/home_screen.dart';

class FeedbackPage extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const FeedbackPage());
  }
  const FeedbackPage({Key? key}) : super(key: key);


  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {

  final double _initialRating = 2.0;
  final bool _isVertical = false;
  late double _rating;
  int _currentIndex=2;
  String _feedbackCategory="Compliments";
  final TextEditingController _comment = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Feedback")),
        leading: InkWell(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back)),),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Center(
              child: _buildAppLogo(),
            ),
            Text(feedbackWelcomeText.toString(),style:Theme.of(context).textTheme.headline1),
            const SizedBox(height: 10,),
            Text(feedbackText.toString(),style:Theme.of(context).textTheme.headline2),
            const SizedBox(height: 10,),
            Text(feedbackQuestion.toString(),style:Theme.of(context).textTheme.headline3),
            const SizedBox(height: 15,),
            _buildRatingbar(),
            const SizedBox(height: 15,),
            Text(feedbackCategory.toString(),style:Theme.of(context).textTheme.headline3),
            const SizedBox(height: 15,),
            _buildCategoryTab(),
            const SizedBox(height: 15,),
            _buildCommentSection(),
            const SizedBox(height: 15,),
            _buildSubmitFeedback()
            

          ],
        ),
      ),
    );
  }

  _showAlertDialog(String titleText,String contentText){
    AlertDialog alertDialog = AlertDialog(
      title: Text(titleText),
      content: Text(contentText),
      actions: [
      TextButton(
     child: const Text("Ok"),
        onPressed: () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const HomePage()), (route) => false);
        },
    ),
      ],
    );
     showDialog(context: context, builder: (BuildContext context){
      return alertDialog;
    });
  }

 Widget _buildCommentSection(){

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width/1.3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Please leave your feedback below: ",style: TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(height: 10,),
            Container(
              color: Colors.grey,
              width: MediaQuery.of(context).size.width/1.3,
              height: MediaQuery.of(context).size.height/6,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _comment,
                    decoration:  InputDecoration(
                      border: InputBorder.none,
                      hintText: "Provide Your "+_feedbackCategory,
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

 Widget _buildSubmitFeedback(){
   return ElevatedButton(
      child: const Text('Submit'),
      onPressed: (){
        if(_comment.text==''){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please provide comment..")));
        }else{
          _showAlertDialog("Feedback submitted", "Thanks for the feedback");
        }

      },
    );
  }


  _buildAppLogo(){
    return SizedBox(
        height: 200,
        width: 200,
        child: Image.asset('assets/images/petfitlogo.png'));
  }

  _buildRatingbar(){
    return Container(
      width: MediaQuery.of(context).size.width-50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey
      ),
      child: Center(
        child: RatingBar.builder(
          initialRating: _initialRating,
          direction: _isVertical ? Axis.vertical : Axis.horizontal,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return const Icon(
                  Icons.sentiment_very_dissatisfied,
                  color: Colors.red,
                );
              case 1:
                return const Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.redAccent,
                );
              case 2:
                return const Icon(
                  Icons.sentiment_neutral,
                  color: Colors.amber,
                );
              case 3:
                return const Icon(
                  Icons.sentiment_satisfied,
                  color: Colors.lightGreen,
                );
              case 4:
                return const Icon(
                  Icons.sentiment_very_satisfied,
                  color: Colors.green,
                );
              default:
                return Container();
            }
          },
          onRatingUpdate: (rating) {
            setState(() {
              _rating = rating;
            });
          },
          updateOnDrag: true,
        ),
      ),
    );
  }

  _buildCategoryTab(){
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: (){
              setState(() {
                _currentIndex=0;
                _feedbackCategory="Suggestions";
              });
            },
            child: _buildCategoryContainer("Suggestions",_currentIndex==0?Colors.blue:Colors.black),
          ),
          InkWell(
            onTap: (){
                setState(() {
                  _currentIndex=1;
                  _feedbackCategory="Complaints";
                });
            },
            child: _buildCategoryContainer("Complaints",_currentIndex==1?Colors.blue:Colors.black),
          ),
          InkWell(
            onTap: (){
              setState(() {
                _currentIndex=2;
                _feedbackCategory="Compliments";
              });
            },
            child: _buildCategoryContainer("Compliments",_currentIndex==2?Colors.blue:Colors.black),
          ),



        ],
      ),
    );

  }
  _buildCategoryContainer(String categoryName, Color color){
    return  Container(
      width: MediaQuery.of(context).size.width/3-15,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: color),
      child: Center(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(categoryName,style: Theme.of(context).textTheme.headline4,),
      )),
    );
  }

}
