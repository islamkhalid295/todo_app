import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/shared/shared.dart';
import 'package:my_flutter_app/todo_app/modules/home_screen.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            selectedItemColor: Colors.orange,
            selectedLabelStyle: TextStyle(color: Colors.orange),
            unselectedItemColor: Colors.grey,
            unselectedLabelStyle: TextStyle(color: Colors.grey),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,),
      ),
      home: const MyHomePage(),
    );
  }
}
