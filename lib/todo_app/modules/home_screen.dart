import 'package:conditional_builder_rec/conditional_builder_rec.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_flutter_app/todo_app/cubit/appCubit.dart';

import '../cubit/appStates.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var titelController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => appCubit()..createDb(),
      child: BlocConsumer<appCubit,appStates>(
        listener: (context, state) {
          if (state is insertDbState) Navigator.pop(context);
        } ,
        builder: (context, state)
        {
          appCubit cubit = appCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text("Todo App"),
              elevation: 0,
              backgroundColor: Colors.orange[100],
            ),
            body: ConditionalBuilderRec(
              builder: (context) => cubit.screens[cubit.currentIndex],
              condition: true,
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.sheetIsOpen) {
                  if (formKey.currentState!.validate())
                  {
                    cubit.insertIntoDb(titelController.text,
                        timeController.text, dateController.text);
                    cubit.changeBottomSheetState(false, Icons.edit);
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet((context) => Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              width: double.infinity,
                              child: Form(
                                key: formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                        controller: titelController,
                                        validator: (value) {
                                          if (value!.isEmpty)
                                            return 'titel must not be empty';
                                        },
                                        decoration: InputDecoration(
                                            label: Text("Titel"),
                                            icon: Icon(Icons.title_outlined),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))))),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                        controller: timeController,
                                        onTap: () {
                                          showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now())
                                              .then((value) {
                                            timeController.text =
                                                value!.format(context);
                                          });
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty)
                                            return 'time must not be empty';
                                        },
                                        decoration: InputDecoration(
                                            label: Text("Time"),
                                            icon:
                                                Icon(Icons.watch_later_outlined),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))))),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                        controller: dateController,
                                        validator: (value) {
                                          if (value!.isEmpty)
                                            return 'date must not be empty';
                                        },
                                        onTap: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime(2024))
                                              .then((value) {
                                            dateController.text =
                                                DateFormat.yMMMd().format(value!);
                                          });
                                        },
                                        decoration: InputDecoration(
                                            label: Text("Date"),
                                            icon: Icon(Icons.calendar_month),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))))),
                                  ],
                                ),
                              ),
                            ),
                          ))
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(false, Icons.edit);
                  });
                  cubit.changeBottomSheetState(true, Icons.add);
                  print("sheet opend");
                }
              },
              tooltip: 'Increment',
              child: Icon(cubit.fapIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: "New Task"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline),
                      label: "Done Task"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined),
                      label: "Archived Task"),
                ],
                onTap: (value) {
                  cubit.changeNavBarState(value);
                },
                currentIndex: cubit.currentIndex),
          );
        },
      ),
    );
  }


}
