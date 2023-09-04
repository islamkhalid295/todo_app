import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../componanet/component.dart';
import '../cubit/appCubit.dart';
import '../cubit/appStates.dart';

class ArchivedTaskScreen extends StatelessWidget {
  const ArchivedTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<appCubit,appStates>(
        listener: (context, state) {},
        builder: (context, state)
        {
          var list = appCubit.get(context).archiveTasks;
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
                        appCubit.get(context).updateDb(state: 'NewTask', id: model['id']);
                      },
                          icon: Icon(Icons.restore, color: Colors.green,)
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
