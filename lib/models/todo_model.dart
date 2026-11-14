import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';


part 'todo_model.g.dart';

@HiveType(typeId: 2)
class todo {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final DateTime time;

  @HiveField(4)
  final bool isDone;

  todo(
      {String? id,
      required this.title,
      required this.date,
      required this.time,
      required this.isDone
      }): id = id ?? const Uuid().v4();

  todo copyWith({
    String? id,
    String? title,
    DateTime? date,
    DateTime? time,
    bool? isDone,
  }) {
    return todo(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      time: time ?? this.time,
      isDone: isDone ?? this.isDone,
    );
  }
}
