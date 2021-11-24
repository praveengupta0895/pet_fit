
import 'package:firebase_database/firebase_database.dart';
import 'package:pet_fit/model/user_model.dart';
import 'package:pet_fit/utils/constants.dart';

class LoginHandler{
  Future<LoginResult> login(String userName, String password) async {
    bool _currentLoginStatus = false;
    String _userId='';
    try{
      await FirebaseDatabase.instance.reference().child(userDatabaseName).once().then((DataSnapshot _snapShot){
        for(var i in _snapShot.value.keys){
          DummyUser dummyUser =
          DummyUser(password: _snapShot.value[i]['password'], userName: _snapShot.value[i]['userName']);
          if(dummyUser.userName==userName&&dummyUser.password==password){
            _currentLoginStatus=true;
            _userId = _snapShot.value[i]['userName'];
            break;
          }
        }
      }).catchError((onError){

      });
      return LoginResult(id: _userId, loginResult: _currentLoginStatus);
    }catch (e){
      return LoginResult(id: _userId, loginResult: _currentLoginStatus);
    }

  }


}