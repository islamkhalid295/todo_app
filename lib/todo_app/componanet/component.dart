import 'package:flutter/material.dart';
import 'package:my_flutter_app/todo_app/cubit/appCubit.dart';
import 'package:my_flutter_app/todo_app/modules/home_screen.dart';

Widget buildTaskItem(Map model,context){
  return Dismissible(
    key: Key(model['id'].toString()),
    onDismissed: (direction) {
      appCubit.get(context).deleteFormDb(model['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(children: [
        CircleAvatar(child: Text("${model['time']}"),radius: 40.0,),
        SizedBox(width: 10),
        Expanded(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${model['titel']}"),
                Text("${model['date']}"),
              ]),
        ),
        SizedBox(width: 10),
        IconButton(onPressed: (){
          appCubit.get(context).updateDb(state: 'done', id: model['id']);
        },
            icon: Icon(Icons.check_circle_outline, color: Colors.green,)
        ),
        IconButton(onPressed: (){
          appCubit.get(context).updateDb(state: 'archive', id: model['id']);
        },
            icon: Icon(Icons.archive_outlined,color: Colors.grey,)
        ),
      ],
      ),
    ),
  );
}