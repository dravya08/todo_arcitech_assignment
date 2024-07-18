import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../models/todo.dart';
import '../repository/todo_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository todoRepository;

  TodoBloc({required this.todoRepository}) : super(TodoLoading()) {
    on<FetchTodos>(_onFetchTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<CompleteTodo>(_onCompleteTodo);
  }

  void _onFetchTodos(FetchTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());

    final todos = await todoRepository.fetchTodos();
    emit(TodoLoaded(todos: todos));
  }

  void _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      final List<Todo> updatedTodos = List.from((state as TodoLoaded).todos)
        ..add(event.todo);
      emit(TodoLoaded(todos: updatedTodos));
      await todoRepository.addTodo(event.todo);
    }
  }

  void _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      final List<Todo> updatedTodos = (state as TodoLoaded).todos.map((todo) {
        return todo.id == event.todo.id ? event.todo : todo;
      }).toList();
      emit(TodoLoaded(todos: updatedTodos));
      await todoRepository.updateTodo(event.todo);
    }
  }

  void _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      final List<Todo> updatedTodos = (state as TodoLoaded)
          .todos
          .where((todo) => todo.id != event.id)
          .toList();
      emit(TodoLoaded(todos: updatedTodos));
      await todoRepository.deleteTodo(event.id);
    }
  }

  void _onCompleteTodo(CompleteTodo event, Emitter<TodoState> emit) async {
    if (state is TodoLoaded) {
      final List<Todo> updatedTodos = (state as TodoLoaded).todos.map((todo) {
        if (todo.id == event.id) {
          return todo.copyWith(completed: !todo.completed);
        }
        return todo;
      }).toList();
      emit(TodoLoaded(todos: updatedTodos));
      await todoRepository.updateTodo(
        updatedTodos.firstWhere((todo) => todo.id == event.id),
      );
    }
  }
}
