import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_fit/repository/authentication_repository.dart';
import 'package:pet_fit/repository/user_repository.dart';
import 'package:pet_fit/view/screens/home_screen.dart';
import 'package:pet_fit/view/screens/login_screen.dart';
import 'package:pet_fit/view/screens/splash_screen.dart';
import 'package:pet_fit/view_models/auth_bloc/authentication_bloc.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.authenticationRepository,
    required this.userRepository,
  }) : super(key: key);

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  void initState() {
    // FirebaseCrashlytics.instance.crash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            primary: Colors.green
          )
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.black
          )
        ),
        appBarTheme:const AppBarTheme(
          color: Colors.black
        ),
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,overflow: TextOverflow.ellipsis),
          headline2: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,overflow: TextOverflow.ellipsis),
          headline3: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,overflow: TextOverflow.ellipsis),
          headline4: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white70,overflow: TextOverflow.ellipsis),
          bodyText1: TextStyle(fontSize: 15,fontWeight: FontWeight.w700,color:Colors.black,overflow: TextOverflow.ellipsis),
        ),


      ),
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushAndRemoveUntil<void>(
                  HomePage.route(),
                      (route) => false,
                );
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),// change to login
                      (route) => false,
                );
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
