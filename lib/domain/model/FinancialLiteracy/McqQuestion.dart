
import 'McqOption.dart';

class McqQuestion {
  final int id;
  final String question;
  final List<McqOption> options;

  const McqQuestion({
    required this.id,
    required this.question,
    required this.options,
  });

  int get correctIndex => options.indexWhere((o) => o.isCorrect);
}
