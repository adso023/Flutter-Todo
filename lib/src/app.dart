import 'package:flutter/material.dart';
import 'package:flutter_todo/src/screens/authScreen.dart';
import 'package:flutter_todo/src/screens/home.dart';
import 'package:provider/provider.dart';
import 'auth/auth.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Todo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Root(),
    );
  }
}

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (context) => Auth(),
        )
      ],
      child: Consumer<Auth>(
          builder: (context, auth, _) =>
              auth.authStatus == AuthLoading.Uninitialized
                  ? RootScreen()
                  : auth.authStatus == AuthLoading.Authenticated
                      ? Home()
                      : AuthScreen()),
    );
  }
}

class RootScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Flutter Todo'),
          SizedBox(
            height: 20,
          ),
          Text('Intializing'),
          Material(
            child: CircularProgressIndicator(),
          )
        ],
      ),
    ));
  }
}
