import 'dart:async';

import 'package:pet_fit/model/user_model.dart';
import 'package:pet_fit/repository/login_handler.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();

  Stream<AuthenticationStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<bool> logIn({
    required String username,
    required String password,
  }) async {

     LoginResult _loginResult=await LoginHandler().login(username, password);

    if(_loginResult.loginResult){
      _controller.add(AuthenticationStatus.authenticated);
      return true;
    }else{
      _controller.add(AuthenticationStatus.unauthenticated);
      return false;
    }

  }

  void logOut() {
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
