import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  String? Function(String?)? onSubmit,
  String? Function(String?)? onChange,
  Function()? onTap,
  bool isPassword = false,
  required String? Function(String?)? validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  Function()? suffixPressed,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(
                  suffix,
                ),
              )
            : null,
        border: OutlineInputBorder(),
      ),
    );

Widget buildTaskItem(Map model, context) => Slidable(
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onDismissed: (type) {
          final action = type == SlideActionType.primary
              ? AppCubit.get(context).DeleteData(id: model['Id'])
              : AppCubit.get(context).updateData(
                  status: 'done',
                  id: model['Id'],
                );
        },
      ),
      actionPane: SlidableDrawerActionPane(),
      key: Key(model['Id'].toString()),
      actions: [
        IconSlideAction(
          caption: "Delete",
          color: Colors.red,
          icon: Icons.archive_outlined,
          onTap: () {
            AppCubit.get(context).DeleteData(id: model['Id']);
          },
        ),
        IconSlideAction(
          caption: "Archive",
          color: Colors.grey[800],
          icon: Icons.archive_outlined,
          onTap: () {
            AppCubit.get(context).updateData(
              status: 'archived',
              id: model['Id'],
            );
          },
        ),
      ],
      secondaryActions: [
        IconSlideAction(
          caption: "Done",
          color: Colors.green,
          icon: Icons.check_box,
          onTap: () {
            AppCubit.get(context).updateData(
              status: 'done',
              id: model['Id'],
            );
          },
        )
      ],
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.deepOrange,
              radius: 40,
              child: Text(
                "${model['Time']}",
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${model['Title']}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${model['Date']}",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context).updateData(
                    status: 'done',
                    id: model['Id'],
                  );
                },
                icon: Icon(
                  Icons.check_box,
                  color: Colors.green,
                )),
            IconButton(
                onPressed: () {
                  AppCubit.get(context).updateData(
                    status: 'archived',
                    id: model['Id'],
                  );
                },
                icon: Icon(
                  Icons.archive_outlined,
                  color: Colors.black45,
                ))
          ],
        ),
      ),
    );

Widget TasksBuilder({required List<Map> tasks}) => ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) => ListView.separated(
        itemCount: tasks.length,
        itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
        separatorBuilder: (context, index) => Container(
          width: double.infinity,
          height: 1.0,
          color: Colors.grey[300],
        ),
      ),
      fallback: (BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 100.0,
              color: Colors.grey,
            ),
            Text(
              "No Tasks Yet, Please Sdd Some Tasks",
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            )
          ],
        ),
      ),
    );
