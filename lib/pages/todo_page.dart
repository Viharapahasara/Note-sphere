import 'package:flutter/material.dart';
import 'package:notes_sphere/constants/app_colors.dart';
import 'package:notes_sphere/constants/text_style.dart';
import 'package:notes_sphere/models/todo_model.dart';
import 'package:notes_sphere/services/todo_service.dart';
import 'package:notes_sphere/widgets/compleated_tab.dart';
import 'package:notes_sphere/widgets/progress_bar.dart';
import 'package:notes_sphere/widgets/todo_input_bottomsheet.dart';
import 'package:notes_sphere/widgets/todo_tab.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TodoService _todoService = TodoService();
  List<todo> allToDo = [];
  List<todo> inCompleatedToDo = [];
  List<todo> compleatedToDo = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    _initTodos();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initTodos() async {
    final bool isNew = await _todoService.isNewUser();
    if (isNew) {
      await _todoService.createTodoBox();
    }
    await _loadTodos();
  }

  Future<void> _loadTodos() async {
    final List<todo> loadedTodos = await _todoService.getDAta();
    if (!mounted) return;
    setState(() {
      allToDo = loadedTodos;
      inCompleatedToDo = loadedTodos.where((item) => !item.isDone).toList();
      compleatedToDo = loadedTodos.where((item) => item.isDone).toList();
      _isLoading = false;
    });
  }

  void _openAddTodoSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return TodoInputBottomSheet(
          onSave: (title, date, time) async {
            final newTodo = todo(
              title: title,
              date: date,
              time: time,
              isDone: false,
            );
            await _todoService.addTodo(newTodo);
            await _loadTodos();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Task added successfully!'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
        );
      },
    );
  }

  void _openEditTodoSheet(todo existingItem) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return TodoInputBottomSheet(
          existingTodo: existingItem,
          onSave: (title, date, time) async {
            final updated = existingItem.copyWith(
              title: title,
              date: date,
              time: time,
            );
            await _todoService.updateTodo(updated);
            await _loadTodos();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Task updated!'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
        );
      },
    );
  }

  Future<void> _toggleTodoStatus(todo item) async {
    final bool newStatus = !item.isDone;
    await _todoService.toggleDone(item);
    await _loadTodos();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus ? 'Task marked as done!' : 'Task marked as undone!',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _deleteTodo(todo item) async {
    await _todoService.deleteTodo(item.id);
    await _loadTodos();
    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deleted "${item.title}"'),
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Undo',
            textColor: AppColors.kamberOrange,
            onPressed: () async {
              await _todoService.addTodo(item);
              await _loadTodos();
            },
          ),
        ),
      );
    }
  }

  Future<void> _clearAllCompleted() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.kdeepBlue,
        title: const Text('Clear Completed Tasks'),
        content: const Text(
          'Are you sure you want to delete all completed tasks?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _todoService.clearCompleted();
      await _loadTodos();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Completed tasks cleared.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TO-DO List'),
        bottom: TabBar(
          dividerColor: Colors.transparent,
          controller: _tabController,
          indicatorColor: AppColors.kamberOrange,
          indicatorWeight: 3,
          labelColor: AppColors.kamberOrange,
          unselectedLabelColor: AppColors.kskyBlue,
          tabs: [
            Tab(
              child: Text(
                'To-Do (${inCompleatedToDo.length})',
                style: appTextStyle.subtitle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Tab(
              child: Text(
                'Completed (${compleatedToDo.length})',
                style: appTextStyle.subtitle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTodoSheet,
        backgroundColor: AppColors.kamberOrange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 12),
                

                // Tabs content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                  
                    children: [
                      TodoTab(
                        inCompleatedToDo: inCompleatedToDo,
                        compleatedToDo: compleatedToDo,
                        onToggleDone: _toggleTodoStatus,
                        onDelete: _deleteTodo,
                        onEdit: _openEditTodoSheet,
                      ),
                      CompletedTab(
                        inCompleatedToDo: inCompleatedToDo,
                        compleatedToDo: compleatedToDo,
                        onToggleDone: _toggleTodoStatus,
                        onDelete: _deleteTodo,
                        onEdit: _openEditTodoSheet,
                        onClearCompleted: _clearAllCompleted,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
