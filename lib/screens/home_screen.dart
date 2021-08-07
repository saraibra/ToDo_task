import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_task/components/components_widgets.dart';
import 'package:to_do_task/providers/todo_provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List tasks = Provider.of<ToDoProvider>(context).allTasks;
    bool? done = Provider.of<ToDoProvider>(context).completed;
    Provider.of<ToDoProvider>(context, listen: false).createDatabase();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('All Tasks'),
      ),
      body:
          Provider.of<ToDoProvider>(context, listen: false).allTasks.isNotEmpty
              ? ListView.separated(
                  itemBuilder: (context, index) =>
                   Dismissible(
      key: Key(tasks[index]['id'].toString()),
      onDismissed: (direction) {
            Provider.of<ToDoProvider>(context,listen: false).deleteData(id: tasks[index]['id']);
            tasks.removeAt(index);
      },
      child: buildTaskItem(tasks[index], context, (changed) {
if(changed){
       Provider.of<ToDoProvider>(context,listen: false)
       .updateData(id: tasks[index]['id'],status:'done');
}
else{
         Provider.of<ToDoProvider>(context,listen: false)
       .updateData(id: tasks[index]['id'],status:'new');
}
      }, done)),
                  separatorBuilder: (context, index) => Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.grey.shade300,
                      ),
                  itemCount: tasks.length)
              : const Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          scaffoldKey.currentState!.showBottomSheet(
              (context) => Container(
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.white,
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultTextFormField(
                            icon: Icons.title,
                            controller: titleController,
                            type: TextInputType.text,
                            validate: (value) {
                              if (value.isEmpty) {
                                return 'Title must not be empty ';
                              }
                              return null;
                            },
                            label: 'Task title',
                          ),
                          const SizedBox(width: 16),
                          TextButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  Provider.of<ToDoProvider>(context,
                                          listen: false)
                                      .insertToDatabase(
                                          title: titleController.text);
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Add Task'))
                        ],
                      ),
                    ),
                  ),
              elevation: 16);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
