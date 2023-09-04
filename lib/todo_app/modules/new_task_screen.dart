import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_app/todo_app/componanet/component.dart';
import 'package:my_flutter_app/todo_app/cubit/appCubit.dart';
import 'package:my_flutter_app/todo_app/cubit/appStates.dart';

class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit,appStates>(
      listener: (context, state) {},
      builder: (context, state)
      {
        var list = appCubit.get(context).newTasks;
        return ListView.separated(
          itemBuilder: (context, index) {
            var model = list[index];
            return Dismissible(
              key: UniqueKey(),
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
          },
          separatorBuilder: (context, index) => Container(width: double.infinity, height: 1.0, color: Colors.grey,),
          itemCount:list.length
        );
      }
    );
  }
}
