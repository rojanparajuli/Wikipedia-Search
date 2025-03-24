import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiki/bloc/splash/splash_screen_bloc.dart';
import 'package:wiki/bloc/wiki_bloc.dart';
import 'package:wiki/view/splash_screen.dart';
import '../bloc/splash/splash_screen_event.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SplashBloc()..add(CheckInternetEvent()),
        ),
        BlocProvider(
          create: (context) => WikipediaBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Wikipedia Search',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: SplashScreen(),
      ),
    );
  }
}

