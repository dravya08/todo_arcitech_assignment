import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_arcitech_assignment/repository/todo_repository.dart';
import 'package:todo_arcitech_assignment/screens/todo_screen.dart';

import 'bloc/todo_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final todoRepository = TodoRepository();
  await todoRepository.init();

  runApp(MyApp(todoRepository: todoRepository));
}

class MyApp extends StatelessWidget {
  final TodoRepository todoRepository;

  MyApp({required this.todoRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodoBloc>(
          create: (context) =>
              TodoBloc(todoRepository: todoRepository)..add(FetchTodos()),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter ToDo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TodoScreen(),
      ),
    );
  }
}
