import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_task/providers/todo_provider.dart';

Widget defaultTextFormField(
        {required TextEditingController controller,
        required TextInputType type,
        onSubmitted,
        onChanged,
        onTab,
        required validate,
        required String label,
        required IconData icon}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      onFieldSubmitted: onSubmitted,
      onChanged: onChanged,
      validator: validate,
      onTap: onTab,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          prefixIcon: Icon(
            icon,
          ),
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.black,
          )),
    );

Widget noTasksWidget() => const Center(
      child: Text(
        "No Tasks yet, Please add some tasks",
        style: TextStyle(fontSize: 22, color: Colors.grey),
      ),
    );
Widget buildTaskItem(Map model, context, checkboxChanged, bool? done) =>
    Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Checkbox(value: model['status']=='done'?true:false, onChanged: checkboxChanged),
          Expanded(
            child: model['status']=='new' 
                ? Text(
                    '${model['title']}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  )
                : Text(
                    '${model['title']}',
                    style: const TextStyle(
                      fontSize: 18,
                      decoration: TextDecoration.lineThrough
                    ),
                  ),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
