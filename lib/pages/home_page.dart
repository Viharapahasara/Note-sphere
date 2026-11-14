import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_sphere/constants/app_colors.dart';
import 'package:notes_sphere/constants/app_constent.dart';
import 'package:notes_sphere/constants/text_style.dart';
import 'package:notes_sphere/models/notes_model.dart';
import 'package:notes_sphere/models/todo_model.dart';
import 'package:notes_sphere/services/notes_service.dart';
import 'package:notes_sphere/services/todo_service.dart';
import 'package:notes_sphere/utils/router.dart';
import 'package:notes_sphere/widgets/CategoryInputBottomsheet.dart';
import 'package:notes_sphere/widgets/note_card.dart';
import 'package:notes_sphere/widgets/progress_bar.dart';
import 'package:notes_sphere/widgets/todo_card.dart';
import 'package:notes_sphere/widgets/todo_input_bottomsheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Notes> _notes = [];
  List<todo> _todos = [];
  final NotesService _notesService = NotesService();
  final TodoService _todoService = TodoService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final bool isNewNotes = await _notesService.isNewUser();
    if (isNewNotes) {
      await _notesService.creatInitalNotes();
    }

    final bool isNewTodo = await _todoService.isNewUser();
    if (isNewTodo) {
      await _todoService.createTodoBox();
    }

    final notes = await _notesService.loadNotes();
    final todos = await _todoService.getDAta();

    if (!mounted) return;
    setState(() {
      _notes = notes;
      _todos = todos;
      _isLoading = false;
    });
  }

  List<todo> get _incompletedTodos =>
      _todos.where((item) => !item.isDone).toList();

  List<todo> get _completedTodos =>
      _todos.where((item) => item.isDone).toList();

  Future<void> _toggleTodo(todo item) async {
    await _todoService.toggleDone(item);
    await _loadData();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning ☀️';
    if (hour < 17) return 'Good Afternoon 🌤️';
    return 'Good Evening 🌙';
  }

  void _showQuickAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.kDefaultPadding,
            vertical: 24,
          ),
          decoration: const BoxDecoration(
            color: AppColors.kdeepBlue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Quick Action',
                  style: appTextStyle.headingMedium,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.kdarkNavy,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.note_add_outlined,
                    color: AppColors.kskyBlue,
                  ),
                ),
                title: const Text('Add a Note', style: appTextStyle.bodyLarge),
                subtitle: Text(
                  'Capture ideas, thoughts & memos',
                  style: TextStyle(
                    color: AppColors.kpeachCream.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right, color: AppColors.kpeachCream),
                onTap: () async {
                  Navigator.of(context).pop();
                  await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const CategoryInputBottomsheet(),
                  );
                  _loadData();
                },
              ),
              const Divider(color: AppColors.kdarkNavy, height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.kdarkNavy,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.add_task_outlined,
                    color: AppColors.kamberOrange,
                  ),
                ),
                title: const Text('Add a Task', style: appTextStyle.bodyLarge),
                subtitle: Text(
                  'Schedule a to-do with date and time',
                  style: TextStyle(
                    color: AppColors.kpeachCream.withValues(alpha: 0.6),
                    fontSize: 12,
                  ),
                ),
                trailing: const Icon(Icons.chevron_right, color: AppColors.kpeachCream),
                onTap: () {
                  Navigator.of(context).pop();
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
                          _loadData();
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final int completedCount = _completedTodos.length;
    final int totalCount = _todos.length;
    final incompletedList = _incompletedTodos;
    final String currentDate = DateFormat('EEEE, dd MMM').format(DateTime.now());

    return Scaffold(
     /* floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.kamberOrange,
        onPressed: _showQuickAddSheet,
        tooltip: 'Quick Add',
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),*/
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              color: AppColors.kamberOrange,
              backgroundColor: AppColors.kdeepBlue,
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top spacing + Header
                    SizedBox(
                      height: MediaQuery.of(context).padding.top + 12,
                    ),

                    // Greeting and App Header
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.kDefaultPadding,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getGreeting(),
                                style: TextStyle(
                                  color: AppColors.kskyBlue.withValues(alpha: 0.9),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                "NoteSphere",
                                style: appTextStyle.headingLarge,
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.kdeepBlue,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.kskyBlue.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 13,
                                  color: AppColors.kskyBlue,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  currentDate,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.kpeachCream,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Today's Progress Card
                    ProgressBar(
                      compleatedTask: completedCount,
                      totlaTask: totalCount,
                    ),
                    const SizedBox(height: 18),

                    // Quick Section Cards: Notes & To-Do List
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.kDefaultPadding,
                      ),
                      child: Row(
                        children: [
                          // Notes Card
                          Expanded(
                            child: NoteCard(
                              title: 'Notes',
                              subDetails: '${_notes.length} ${_notes.length == 1 ? 'Note' : 'Notes'}',
                              icon: Icons.bookmark_add_outlined,
                              accentColor: AppColors.kskyBlue,
                              onTap: () async {
                                await AppRouter.router.push("/notes");
                                _loadData();
                              },
                            ),
                          ),
                          const SizedBox(width: 14),

                          // TO-DO List Card
                          Expanded(
                            child: NoteCard(
                              title: 'TO-DO List',
                              subDetails: '${incompletedList.length} ${incompletedList.length == 1 ? 'Task' : 'Tasks'}',
                              icon: Icons.checklist_outlined,
                              accentColor: AppColors.kamberOrange,
                              onTap: () async {
                                await AppRouter.router.push("/todo");
                                _loadData();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Today's Tasks Section Header
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.kDefaultPadding,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Today's Tasks",
                                style: appTextStyle.headingMedium,
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.kdeepBlue,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: AppColors.kskyBlue.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  '${incompletedList.length} left',
                                  style: TextStyle(
                                    color: AppColors.kpeachCream.withValues(alpha: 0.8),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: () async {
                              await AppRouter.router.push("/todo");
                              _loadData();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 4,
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    "See All",
                                    style: TextStyle(
                                      color: AppColors.kskyBlue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(width: 2),
                                  Icon(
                                    Icons.chevron_right,
                                    size: 18,
                                    color: AppColors.kskyBlue,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Tasks preview list
                    if (incompletedList.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.kDefaultPadding,
                          vertical: 24,
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.kdeepBlue,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.kskyBlue.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                totalCount == 0
                                    ? Icons.post_add_rounded
                                    : Icons.celebration_outlined,
                                size: 44,
                                color: AppColors.kskyBlue.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                totalCount == 0
                                    ? "No tasks yet"
                                    : "All caught up!",
                                style: appTextStyle.headingMedium.copyWith(
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                totalCount == 0
                                    ? "Tap + to add your first task"
                                    : "You've finished all your tasks for today. Great job!",
                                textAlign: TextAlign.center,
                                style: appTextStyle.bodyMedium.copyWith(
                                  color: AppColors.kpeachCream.withValues(alpha: 0.65),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: incompletedList.length > 5 ? 5 : incompletedList.length,
                        itemBuilder: (context, index) {
                          final todo item = incompletedList[index];
                          return TodoCard(
                            title: item.title,
                            statee: item.isDone,
                            date: item.date,
                            time: item.time,
                            onClick: () => _toggleTodo(item),
                            onTap: () async {
                              await AppRouter.router.push("/todo");
                              _loadData();
                            },
                          );
                        },
                      ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
    );
  }
}
