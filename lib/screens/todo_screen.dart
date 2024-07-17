import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_arcitech_assignment/screens/todo_form_screen.dart';

import '../bloc/todo_bloc.dart';

class TodoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TodoLoaded) {
            return ListView.builder(
              itemCount: state.todos.length,
              itemBuilder: (context, index) {
                final todo = state.todos[index];
                return ListTile(
                  title: Text(todo.title),
                  subtitle: Text(todo.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TodoFormScreen(todo: todo),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          context.read<TodoBloc>().add(DeleteTodo(todo.id));
                        },
                      ),
                      Checkbox(
                        value: todo.completed,
                        onChanged: (value) {
                          if (value != null) {
                            context.read<TodoBloc>().add(CompleteTodo(todo.id));
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is TodoError) {
            return Center(child: Text('Failed to fetch todos'));
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TodoFormScreen(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
