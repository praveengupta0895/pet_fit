
class DummyUser {
  DummyUser({
    required this.password,
    required this.userName,
  });

  String password;
  String userName;

}

class LoginResult{
  String id;
  bool loginResult;
  LoginResult({
    required this.id,
    required this.loginResult
});
}
