import 'package:flutter/material.dart';
import 'package:notes_sphere/constants/app_colors.dart';
import 'package:notes_sphere/constants/app_constent.dart';
import 'package:notes_sphere/constants/text_style.dart';
import 'package:notes_sphere/models/notes_model.dart';
import 'package:notes_sphere/services/notes_service.dart';
import 'package:notes_sphere/utils/router.dart';
import 'package:notes_sphere/widgets/CategoryInputBottomsheet.dart';
import 'package:notes_sphere/widgets/notePage_card.dart';
import 'package:notes_sphere/widgets/note_category_cadr.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final NotesService notesService = NotesService();
  final TextEditingController _searchController = TextEditingController();

  List<Notes> allNotes = [];
  Map<String, List<Notes>> noteWithCategory = {};
  List<Notes> searchResults = [];
  bool isSearching = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAndCreateData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _checkAndCreateData() async {
    final bool isNewUser = await notesService.isNewUser();
    if (isNewUser) {
      await notesService.creatInitalNotes();
    }
    await _loadNotes();
  }

  Future<void> _loadNotes() async {
    final List<Notes> loadedNotes = await notesService.loadNotes();
    final Map<String, List<Notes>> noteByCategory =
        notesService.catagarizeNotes(loadedNotes);
    if (!mounted) return;
    setState(() {
      allNotes = loadedNotes;
      noteWithCategory = noteByCategory;
      isLoading = false;
    });

    if (isSearching) {
      _onSearchChanged(_searchController.text);
    }
  }

  void _onSearchChanged(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      setState(() {
        isSearching = false;
        searchResults = [];
      });
      return;
    }

    setState(() {
      isSearching = true;
      searchResults = allNotes.where((note) {
        return note.title.toLowerCase().contains(q) ||
            note.content.toLowerCase().contains(q) ||
            note.category.toLowerCase().contains(q);
      }).toList();
    });
  }

  Future<void> openBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const CategoryInputBottomsheet();
      },
    );
    await _loadNotes();
  }

  Future<void> _navigateToCategory(String categoryName) async {
    await AppRouter.router.push(
      '/categoryNote',
      extra: categoryName,
    );
    await _loadNotes();
  }

  Future<void> _navigateToEditNote(String noteId) async {
    await AppRouter.router.push(
      '/create-note',
      extra: {
        'isNewCategory': false,
        'isEditing': true,
        'id': noteId,
      },
    );
    await _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.kamberOrange,
        onPressed: openBottomSheet,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              color: AppColors.kamberOrange,
              backgroundColor: AppColors.kdeepBlue,
              onRefresh: _loadNotes,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.kDefaultPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.kdeepBlue,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.kskyBlue.withValues(alpha: 0.2),
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        style: appTextStyle.bodyLarge,
                        decoration: InputDecoration(
                          hintText: 'Search notes by title or content...',
                          hintStyle: TextStyle(
                            color: AppColors.kpeachCream.withValues(alpha: 0.5),
                            fontSize: 14,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.kskyBlue,
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: AppColors.kpeachCream,
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    _onSearchChanged('');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Search Results View
                    if (isSearching) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Search Results (${searchResults.length})',
                            style: appTextStyle.headingMedium.copyWith(fontSize: 18),
                          ),
                          TextButton(
                            onPressed: () {
                              _searchController.clear();
                              _onSearchChanged('');
                            },
                            child: const Text(
                              'Clear',
                              style: TextStyle(color: AppColors.kskyBlue),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (searchResults.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 48,
                                  color: AppColors.kskyBlue.withValues(alpha: 0.4),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'No notes match "${_searchController.text}"',
                                  style: appTextStyle.bodyMedium.copyWith(
                                    color: AppColors.kpeachCream.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.78,
                          ),
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) {
                            final note = searchResults[index];
                            return NoteCategoryCadr(
                              noteId: note.id,
                              noteTitle: note.title,
                              notes: note.content,
                              date: note.date,
                              onEdit: () => _navigateToEditNote(note.id),
                              removeNote: () async {
                                await notesService.deleteNote(note.id);
                                await _loadNotes();
                              },
                            );
                          },
                        ),
                      const SizedBox(height: 80),
                    ] else ...[
                      // Normal View: Categories Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Categories',
                            style: appTextStyle.headingMedium,
                          ),
                          Text(
                            '${allNotes.length} total ${allNotes.length == 1 ? 'note' : 'notes'}',
                            style: TextStyle(
                              color: AppColors.kpeachCream.withValues(alpha: 0.6),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      if (noteWithCategory.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 60),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.note_alt_outlined,
                                  size: 72,
                                  color: AppColors.kskyBlue.withValues(alpha: 0.4),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'No notes yet',
                                  style: appTextStyle.headingMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap the + button below to create your first note!',
                                  style: TextStyle(
                                    color: AppColors.kpeachCream
                                        .withValues(alpha: 0.7),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      else ...[
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 1.15,
                          ),
                          itemCount: noteWithCategory.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String categoryName =
                                noteWithCategory.keys.elementAt(index);
                            final List<Notes> categoryNotes =
                                noteWithCategory[categoryName] ?? [];
                            final int notesCount = categoryNotes.length;

                            return InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () => _navigateToCategory(categoryName),
                              child: NotepageCard(
                                title: categoryName,
                                numOfNotes: notesCount,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 28),

                        // Recent Notes Preview Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Recent Notes',
                              style: appTextStyle.headingMedium,
                            ),
                            Text(
                              'Showing recent',
                              style: TextStyle(
                                color: AppColors.kpeachCream.withValues(alpha: 0.5),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.78,
                          ),
                          itemCount: allNotes.length > 4 ? 4 : allNotes.length,
                          itemBuilder: (context, index) {
                            final note = allNotes[index];
                            return NoteCategoryCadr(
                              noteId: note.id,
                              noteTitle: note.title,
                              notes: note.content,
                              date: note.date,
                              onEdit: () => _navigateToEditNote(note.id),
                              removeNote: () async {
                                await notesService.deleteNote(note.id);
                                await _loadNotes();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Note deleted successfully!'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 80),
                      ],
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
